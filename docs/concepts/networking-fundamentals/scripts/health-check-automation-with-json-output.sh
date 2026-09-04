# last_verified: 2026-09-04 · bash n/a · curl n/a · openssl n/a · nc n/a

# Health-check automation with JSON output
# Concept L3 exercise for Networking Fundamentals
#
# This script combines networking fundamentals (DNS, TCP, TLS, HTTP probing)
# with scripting and automation patterns (config-file-driven checks, retry
# logic, structured JSON output). The idea is to read a list of targets from
# a JSON config file, probe each one with configurable retries, and emit a
# structured report that CI/CD pipelines or monitoring dashboards can consume.
#
# This is one way to automate multi-target health checks; alternatives include
# Prometheus blackbox_exporter or Kubernetes liveness probes. This script
# shows the underlying primitives in a format that plugs into existing tooling.

set -euo pipefail

readonly DEFAULT_TIMEOUT=5
readonly DEFAULT_RETRIES=2
readonly DEFAULT_RETRY_DELAY=1

# ---------------------------------------------------------------------------
# Probe functions — each returns 0 on success, 1 on failure.
# ---------------------------------------------------------------------------

probe_dns() {
  local host="$1"
  local ips=""
  if command -v getent >/dev/null 2>&1; then
    ips=$(getent hosts "$host" 2>/dev/null | awk '{print $1}' | head -n 3)
  fi
  if [[ -z "$ips" ]] && command -v dig >/dev/null 2>&1; then
    ips=$(dig +short "$host" 2>/dev/null | head -n 3)
  fi
  if [[ -z "$ips" ]]; then
    printf '[dns] %s: resolution FAILED\n' "$host" >&2
    return 1
  fi
  printf '[dns] %s -> %s\n' "$host" "$(echo "$ips" | tr '\n' ',')"
  return 0
}

probe_tcp() {
  local host="$1" port="$2" timeout_secs="${3:-$DEFAULT_TIMEOUT}"
  printf '[tcp] %s:%s ... ' "$host" "$port"
  if timeout "$timeout_secs" nc -z -v "$host" "$port" 2>&1; then
    printf 'OPEN\n'
    return 0
  fi
  local rc=$?
  if [[ $rc -eq 124 ]]; then
    printf 'TIMEOUT (%ss)\n' "$timeout_secs"
  else
    printf 'CLOSED (rc=%d)\n' "$rc"
  fi
  return 1
}

probe_tls() {
  local host="$1" port="${2:-443}" timeout_secs="${3:-$DEFAULT_TIMEOUT}"
  printf '[tls] %s:%s ... ' "$host" "$port"
  local raw_output=""
  if ! raw_output=$(timeout "$timeout_secs" openssl s_client -connect "${host}:${port}" -servername "$host" -quiet </dev/null 2>&1); then
    if ! echo "$raw_output" | grep -qi "Verify return code"; then
      printf 'HANDSHAKE FAILED\n'
      return 1
    fi
  fi
  local verify_line
  verify_line=$(echo "$raw_output" | grep "Verify return code" || true)
  if echo "$verify_line" | grep -q "Verify return code: 0"; then
    local expiry
    expiry=$(echo "$raw_output" | grep -i "notAfter" | head -n1 | sed 's/.*notAfter: //' || true)
    printf 'OK (expiry: %s)\n' "${expiry:-unknown}"
    return 0
  elif echo "$verify_line" | grep -qi "verify error"; then
    printf 'CERT VERIFICATION FAILED\n'
    return 1
  else
    printf 'OK (verification unclear)\n'
    return 0
  fi
}

probe_http() {
  local scheme="${1:-https}" host="$2" port="$3" path="${4:-/}" timeout_secs="${5:-$DEFAULT_TIMEOUT}"
  local url="${scheme}://${host}:${port}${path}"
  printf '[http] %s ... ' "$url"
  local code elapsed
  code=$(curl -skS -o /dev/null -w "%{http_code}" --max-time "$timeout_secs" "$url" 2>&1) || code="000"
  elapsed=$(curl -skS -o /dev/null -w "%{time_total}" --max-time "$timeout_secs" "$url" 2>&1) || elapsed="0.000"
  if [[ "$code" == "000" ]]; then
    printf 'FAILED (curl code 000, time %ss)\n' "$elapsed"
    return 1
  fi
  printf '%s (%ss)\n' "$code" "$elapsed"
  return 0
}

# ---------------------------------------------------------------------------
# measure_latency — collect N TCP connect samples and report min/avg/max.
# ---------------------------------------------------------------------------

measure_latency() {
  local host="$1" port="$2" samples="${3:-3}"
  printf '[latency] %s:%s (%d samples)\n' "$host" "$port" "$samples"
  local -a times=()
  local i=0
  while (( i < samples )); do
    local start end elapsed rc
    start=$(date +%s.%N)
    timeout 3 bash -c "exec 3<>/dev/tcp/${host}/${port}" 2>/dev/null
    rc=$?
    end=$(date +%s.%N)
    elapsed=$(awk "BEGIN{printf \"%.4f\", ${end} - ${start}}")
    if [[ $rc -eq 0 ]]; then
      times+=("$elapsed")
      printf '  sample %d: %ss (ok)\n' "$((i+1))" "$elapsed"
    else
      printf '  sample %d: FAILED (rc=%d) after %ss\n' "$((i+1))" "$rc" "$elapsed"
    fi
    ((i++))
    sleep 0.2
  done
  if [[ ${#times[@]} -eq 0 ]]; then
    printf '  no successful samples\n'
    return 1
  fi
  printf '  -- %d/%d successful --\n' "${#times[@]}" "$samples"
  printf '%s\n' "${times[@]}" | awk '
    { sum+=$1; n++; if(min==""||$1<min)min=$1; if(max==""||$1>max)max=$1 }
    END { printf "  min %.4fs  avg %.4fs  max %.4fs (n=%d)\n", min, sum/n, max, n }
  '
  return 0
}

# ---------------------------------------------------------------------------
# check_target — full probe suite for one target with retries.
# Returns 0 if the target passes all required layers.
# ---------------------------------------------------------------------------

check_target() {
  local host="$1" port="$2" scheme="${3:-https}" path="${4:-/}"
  local retries="${5:-$DEFAULT_RETRIES}" timeout_secs="${6:-$DEFAULT_TIMEOUT}"
  local attempt=0 passed=0 total_layers=0

  while (( attempt <= retries )); do
    passed=0
    total_layers=0

    ((total_layers++))
    if probe_dns "$host" >/dev/null 2>&1; then ((passed++)); fi

    ((total_layers++))
    if probe_tcp "$host" "$port" "$timeout_secs" >/dev/null 2>&1; then ((passed++)); fi

    if [[ "$scheme" == "https" || "$port" == "443" ]]; then
      ((total_layers++))
      if probe_tls "$host" "$port" "$timeout_secs" >/dev/null 2>&1; then ((passed++)); fi
    fi

    ((total_layers++))
    if probe_http "$scheme" "$host" "$port" "$path" "$timeout_secs" >/dev/null 2>&1; then ((passed++)); fi

    ((total_layers++))
    if measure_latency "$host" "$port" 3 >/dev/null 2>&1; then ((passed++)); fi

    if (( passed == total_layers )); then
      return 0
    fi

    ((attempt++))
    if (( attempt <= retries )); then
      sleep "$DEFAULT_RETRY_DELAY"
    fi
  done

  return 1
}

# ---------------------------------------------------------------------------
# JSON output helpers
# ---------------------------------------------------------------------------

json_array_append() {
  local ref="$1" value="$2"
  if [[ -z "${!ref:-}" ]]; then
    eval "$ref=\"${value}\""
  else
    eval "$ref=\"${!ref},${value}\""
  fi
}

# ---------------------------------------------------------------------------
# Main — read targets from a config file or CLI args, probe each, emit JSON.
# ---------------------------------------------------------------------------

usage() {
  cat <<'EOF'
Usage: health-check-automation-with-json-output.sh --config <targets.json>
       health-check-automation-with-json-output.sh --target <host> [--port <port>] [--scheme <https>] [--path </>]

Config file format (JSON array):
  [
    {"host": "example.com", "port": 443, "scheme": "https", "path": "/health"},
    {"host": "api.internal", "port": 8080, "scheme": "http", "path": "/ready"}
  ]

Output: JSON report to stdout with per-target layer results and summary.
EOF
}

emit_json_target() {
  local host="$1" port="$2" scheme="$3" path="$4"
  local start_time end_time elapsed_ms
  start_time=$(date +%s%N)

  local overall_ok=true

  # DNS
  local dns_ok="false"
  if probe_dns "$host" >/dev/null 2>&1; then dns_ok="true"; else overall_ok=false; fi

  # TCP
  local tcp_ok="false"
  if probe_tcp "$host" "$port" "$DEFAULT_TIMEOUT" >/dev/null 2>&1; then tcp_ok="true"; else overall_ok=false; fi

  # TLS
  local tls_ok="n/a"
  if [[ "$scheme" == "https" || "$port" == "443" ]]; then
    if probe_tls "$host" "$port" "$DEFAULT_TIMEOUT" >/dev/null 2>&1; then
      tls_ok="true"
    else
      tls_ok="false"
      overall_ok=false
    fi
  fi

  # HTTP
  local http_ok="false" http_code="000"
  local http_raw
  if http_raw=$(probe_http "$scheme" "$host" "$port" "$path" "$DEFAULT_TIMEOUT" 2>&1); then
    http_ok="true"
    http_code=$(echo "$http_raw" | grep -o '[0-9][0-9][0-9]' | head -1 || echo "000")
  else
    overall_ok=false
  fi

  # Latency
  local lat_ok="false"
  if measure_latency "$host" "$port" 3 >/dev/null 2>&1; then lat_ok="true"; else overall_ok=false; fi

  end_time=$(date +%s%N)
  elapsed_ms=$(( (end_time - start_time) / 1000000 ))

  local status_str="healthy"
  $overall_ok || status_str="unhealthy"

  printf '    {\n'
  printf '      "target": "%s:%s",\n' "$host" "$port"
  printf '      "scheme": "%s",\n' "$scheme"
  printf '      "path": "%s",\n' "$path"
  printf '      "dns": %s,\n' "$dns_ok"
  printf '      "tcp": %s,\n' "$tcp_ok"
  printf '      "tls": %s,\n' "$tls_ok"
  printf '      "http": %s,\n' "$http_ok"
  printf '      "http_code": %s,\n' "$http_code"
  printf '      "latency": %s,\n' "$lat_ok"
  printf '      "status": "%s",\n' "$status_str"
  printf '      "elapsed_ms": %d\n' "$elapsed_ms"
  printf '    }'

  $overall_ok && return 0 || return 1
}

main() {
  local config_file="" single_host="" single_port="443" single_scheme="https" single_path="/"
  local healthy=0 unhealthy=0 total=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --config) config_file="$2"; shift 2 ;;
      --target) single_host="$2"; shift 2 ;;
      --port) single_port="$2"; shift 2 ;;
      --scheme) single_scheme="$2"; shift 2 ;;
      --path) single_path="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 1 ;;
    esac
  done

  printf '{\n'
  printf '  "report": "health-check",\n'
  printf '  "timestamp": "%s",\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf '  "targets": [\n'

  local first_target=true

  if [[ -n "$config_file" ]]; then
    if [[ ! -f "$config_file" ]]; then
      printf 'Error: config file not found: %s\n' "$config_file" >&2
      exit 1
    fi
    while IFS= read -r line; do
      local t_host t_port t_scheme t_path
      t_host=$(echo "$line" | grep -o '"host"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"host"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
      t_port=$(echo "$line" | grep -o '"port"[[:space:]]*:[[:space:]]*[0-9]*' | head -1 | sed 's/.*"port"[[:space:]]*:[[:space:]]*\([0-9]*\)/\1/')
      t_scheme=$(echo "$line" | grep -o '"scheme"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"scheme"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
      t_path=$(echo "$line" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

      [[ -z "$t_host" ]] && continue
      t_port="${t_port:-443}"
      t_scheme="${t_scheme:-https}"
      t_path="${t_path:-/}"

      ((total++))
      if ! $first_target; then printf ',\n'; fi
      first_target=false

      if emit_json_target "$t_host" "$t_port" "$t_scheme" "$t_path"; then
        ((healthy++))
      else
        ((unhealthy++))
      fi
    done < <(grep -o '{[^}]*}' "$config_file")
  elif [[ -n "$single_host" ]]; then
    total=1
    if emit_json_target "$single_host" "$single_port" "$single_scheme" "$single_path"; then
      healthy=1
    else
      unhealthy=1
    fi
  else
    printf '\nError: provide --config <file> or --target <host>\n' >&2
    printf '}\n'
    exit 1
  fi

  printf '\n  ],\n'
  printf '  "summary": {\n'
  printf '    "total": %d,\n' "$total"
  printf '    "healthy": %d,\n' "$healthy"
  printf '    "unhealthy": %d\n' "$unhealthy"
  printf '  }\n'
  printf '}\n'

  (( unhealthy == 0 )) && return 0 || return 1
}

main "$@"
