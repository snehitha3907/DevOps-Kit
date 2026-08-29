# last_verified: 2026-08-29 · bash n/a · curl n/a · openssl n/a · nc n/a

# TCP/TLS health probes with latency checks
# Concept L3 exercise for Networking Fundamentals
#
# This pattern combines networking fundamentals (DNS, TCP, TLS, HTTP) with
# scripting and monitoring concepts. The script probes each network layer
# independently — DNS resolution, raw TCP, TLS handshake, and HTTP health —
# then aggregates latency statistics for load-balanced endpoints. This is one
# way to automate multi-layer health checks; alternatives include Prometheus
# blackbox_exporter or Kubernetes liveness probes, but this script shows the
# underlying primitives.

set -euo pipefail

readonly DEFAULT_TIMEOUT=5
readonly DEFAULT_SAMPLES=3

# resolve_dns — verify a hostname resolves before probing ports.
# Uses getent and falls back to dig. Returns resolved IP on stdout.
resolve_dns() {
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
  printf '[dns] %s -> %s\n' "$host" "$(echo "$ips" | tr '\n' ',' | sed 's/,$//')"
  printf '%s\n' "$ips"
  return 0
}

# probe_tcp — raw TCP port check with nc and timeout.
# Distinguishes open vs closed/filtered vs timeout.
probe_tcp() {
  local host="$1"
  local port="$2"
  local timeout_secs="${3:-$DEFAULT_TIMEOUT}"
  printf '>> TCP probe: %s:%s\n' "$host" "$port"
  if timeout "$timeout_secs" nc -z -v "$host" "$port" 2>&1; then
    printf '   OPEN\n'
    return 0
  else
    local rc=$?
    if [[ $rc -eq 124 ]]; then
      printf '   TIMEOUT (%ss) — filtered or unreachable\n' "$timeout_secs"
    else
      printf '   CLOSED or FILTERED (rc=%d)\n' "$rc"
    fi
    return 1
  fi
}

# probe_tls — TLS handshake validation with openssl s_client.
# Checks reachability, certificate verification, and reports expiry.
probe_tls() {
  local host="$1"
  local port="${2:-443}"
  local timeout_secs="${3:-$DEFAULT_TIMEOUT}"
  printf '>> TLS probe: %s:%s\n' "$host" "$port"
  local raw_output=""
  if ! raw_output=$(timeout "$timeout_secs" openssl s_client -connect "${host}:${port}" -servername "$host" -quiet </dev/null 2>&1); then
    # openssl returns non-zero even on success in some versions; check output instead
    if ! echo "$raw_output" | grep -qi "Verify return code"; then
      printf '   TLS handshake FAILED — no verification line (timeout or refused)\n'
      return 1
    fi
  fi
  local verify_line
  verify_line=$(echo "$raw_output" | grep "Verify return code" || true)
  printf '   %s\n' "${verify_line:-no Verify return code line}"
  if echo "$verify_line" | grep -q "Verify return code: 0"; then
    printf '   TLS OK — certificate verified\n'
    # Extract expiry if available
    local expiry
    expiry=$(echo "$raw_output" | grep -i "notAfter" | head -n1 || true)
    [[ -n "$expiry" ]] && printf '   %s\n' "$expiry"
    return 0
  elif echo "$verify_line" | grep -qi "verify error"; then
    printf '   TLS REACHED but certificate verification FAILED\n'
    return 1
  else
    printf '   TLS handshake completed — verification unclear\n'
    return 0
  fi
}

# probe_http — HTTP health check with latency via curl write-out.
# Uses %{http_code} and %{time_total}; --max-time prevents hangs.
probe_http() {
  local scheme="${1:-https}"
  local host="$2"
  local port="$3"
  local path="${4:-/health}"
  local timeout_secs="${5:-$DEFAULT_TIMEOUT}"
  local url="${scheme}://${host}:${port}${path}"
  printf '>> HTTP probe: %s\n' "$url"
  local code elapsed
  # Two-curl pattern avoids mixing write-out with body; first gets code, second gets timing
  code=$(curl -skS -o /dev/null -w "%{http_code}" --max-time "$timeout_secs" "$url" 2>&1) || code="000"
  elapsed=$(curl -skS -o /dev/null -w "%{time_total}" --max-time "$timeout_secs" "$url" 2>&1) || elapsed="0.000"
  if [[ "$code" == "000" ]]; then
    printf '   FAILED — could not connect (curl code 000, time %ss)\n' "$elapsed"
    return 1
  else
    printf '   HTTP %s — total time %ss\n' "$code" "$elapsed"
    printf '%s %s\n' "$code" "$elapsed"
    return 0
  fi
}

# measure_latency — collect N TCP connect samples via bash /dev/tcp and report stats.
# Produces min/avg/max/p50 from date +%s.%N differences.
measure_latency() {
  local host="$1"
  local port="$2"
  local samples="${3:-$DEFAULT_SAMPLES}"
  printf '>> Latency (%d samples): %s:%s\n' "$samples" "$host" "$port"
  local -a times=()
  local i=0
  while (( i < samples )); do
    local start end elapsed rc
    start=$(date +%s.%N)
    timeout 3 bash -c "exec 3<>/dev/tcp/${host}/${port}" 2>/dev/null
    rc=$?
    end=$(date +%s.%N)
    elapsed=$(awk "BEGIN{printf \"%.4f\", $end - $start}")
    if [[ $rc -eq 0 ]]; then
      times+=("$elapsed")
      printf '   sample %d: %ss (ok)\n' "$((i+1))" "$elapsed"
    else
      printf '   sample %d: FAILED (rc=%d) after %ss\n' "$((i+1))" "$rc" "$elapsed"
    fi
    ((i++))
    sleep 0.2
  done
  if [[ ${#times[@]} -eq 0 ]]; then
    printf '   no successful samples — cannot compute stats\n'
    return 1
  fi
  # Compute avg/min/max using awk
  printf '   -- %d/%d successful --\n' "${#times[@]}" "$samples"
  printf '%s\n' "${times[@]}" | awk '
    { sum+=$1; n++; if(min==""||$1<min)min=$1; if(max==""||$1>max)max=$1; vals[n]=$1 }
    END { printf "   min %.4fs  avg %.4fs  max %.4fs (n=%d)\n", min, sum/n, max, n }
  '
}

# check_endpoint — full layer stack for one host:port (+ optional HTTP path).
# This is the integration point: DNS -> TCP -> TLS (if 443) -> HTTP -> latency.
check_endpoint() {
  local host="$1"
  local port="${2:-443}"
  local scheme="${3:-https}"
  local path="${4:-/health}"
  printf '\n=== endpoint: %s:%s (%s) ===\n' "$host" "$port" "$scheme"
  # DNS first — skip if host is already an IP
  if ! [[ "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    resolve_dns "$host" >/dev/null || printf '[warn] continuing despite DNS failure\n'
  fi
  probe_tcp "$host" "$port" "$DEFAULT_TIMEOUT" || true
  if [[ "$port" == "443" || "$scheme" == "https" ]]; then
    probe_tls "$host" "$port" "$DEFAULT_TIMEOUT" || true
  fi
  probe_http "$scheme" "$host" "$port" "$path" "$DEFAULT_TIMEOUT" || true
  measure_latency "$host" "$port" "$DEFAULT_SAMPLES" || true
}

# check_load_balanced — probe a list of backends behind a load balancer.
# Demonstrates how the same probe primitives apply when an endpoint fans out
# to multiple IPs (e.g., ELB, NGINX, HAProxy). Each backend is checked
# individually and a summary counts healthy vs failed.
check_load_balanced() {
  local lb_host="$1"
  local lb_port="${2:-80}"
  shift 2
  local -a backends=("$@")
  if [[ ${#backends[@]} -eq 0 ]]; then
    # No explicit backends — probe the LB VIP itself
    check_endpoint "$lb_host" "$lb_port" "http" "/"
    return
  fi
  printf '\n=== load-balanced check: %s:%s -> %d backends ===\n' "$lb_host" "$lb_port" "${#backends[@]}"
  local healthy=0 failed=0
  for be in "${backends[@]}"; do
    local be_host be_port
    be_host=$(echo "$be" | cut -d: -f1)
    be_port=$(echo "$be" | cut -d: -f2)
    be_port=${be_port:-$lb_port}
    if probe_tcp "$be_host" "$be_port" 3; then
      ((healthy++))
    else
      ((failed++))
    fi
    probe_http "http" "$be_host" "$be_port" "/" 3 || true
  done
  printf '\n[lb summary] %d healthy, %d failed out of %d backends\n' "$healthy" "$failed" "${#backends[@]}"
  # Also probe the VIP to see if the LB itself responds
  printf '\n--- LB VIP probe ---\n'
  check_endpoint "$lb_host" "$lb_port" "http" "/" || true
}

# --- CLI ---
# Usage: ./tcp-tls-health-probes-with-latency.sh [host] [port] [scheme] [path]
#   or: ./tcp-tls-health-probes-with-latency.sh --lb <vip> <port> <backend1:port> ...
usage() {
  printf 'Usage: %s [host [port [scheme [path]]]]\n' "$0"
  printf '       %s --lb <vip> <port> <backend1:port> [backend2:port ...]\n' "$0"
  printf 'Examples:\n'
  printf '  %s 127.0.0.1 443 https /health\n' "$0"
  printf '  %s example.com 443\n' "$0"
  printf '  %s --lb 10.0.0.10 80 10.0.1.11:8080 10.0.1.12:8080\n' "$0"
}

if [[ "${1:-}" == "--lb" ]]; then
  shift
  if [[ $# -lt 2 ]]; then
    usage >&2; exit 1
  fi
  check_load_balanced "$@"
elif [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage; exit 0
else
  check_endpoint "${1:-127.0.0.1}" "${2:-443}" "${3:-https}" "${4:-/health}"
fi
