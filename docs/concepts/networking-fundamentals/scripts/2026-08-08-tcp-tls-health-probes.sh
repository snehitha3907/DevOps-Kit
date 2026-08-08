#!/usr/bin/env bash
# last_verified: 2026-08-08 · bash n/a · curl n/a · openssl n/a · nc n/a
#
# Practice: scripted TCP/TLS health probes and latency checks.
# I wrote this to practice the three tools I reach for when a service
# won't connect: curl for HTTP, openssl for TLS, and nc for raw TCP.
# Each function probes one layer so I can call them in any order.

# --- TCP port probe with netcat ---
# I want to know if a port is even listening before debugging anything higher.
# `-z` means "just report open/closed, don't send data", `-v` gives me the
# connect result on stderr, and `timeout` keeps a filtered port from hanging.
probe_tcp() {
  local host="${1:-127.0.0.1}"
  local port="${2:-80}"
  local timeout_secs="${3:-5}"
  echo ">> TCP probe: ${host}:${port}"
  if timeout "${timeout_secs}" nc -z -v "${host}" "${port}" 2>&1; then
    echo "   OPEN"
  else
    echo "   CLOSED, FILTERED, or TIMED OUT"
  fi
}

# --- TLS handshake check with openssl ---
# A TLS service might listen but present a bad cert or fail the handshake.
# `openssl s_client` shows the full handshake. I feed it `</dev/null` so it
# doesn't wait for stdin, and `-quiet` trims the handshake chatter so the
# result is readable.
probe_tls() {
  local host="${1:-127.0.0.1}"
  local port="${2:-443}"
  local timeout_secs="${3:-5}"
  echo ">> TLS probe: ${host}:${port}"
  # I build the URL from a scheme variable so the literal never gets me
  # confused about which protocol I'm testing.
  if ! result=$(timeout "${timeout_secs}" openssl s_client -connect "${host}:${port}" -quiet </dev/null 2>&1); then
    echo "   TLS handshake FAILED — openssl exited non-zero"
    return 1
  fi
  if echo "${result}" | grep -q "Verify return code: 0"; then
    echo "   TLS OK — certificate verified"
  elif echo "${result}" | grep -qi "verify error"; then
    echo "   TLS REACHED but certificate verification failed"
  else
    echo "   TLS handshake OK but no verification line found"
  fi
  # Print the verification line so I can see the actual status myself.
  echo "${result}" | grep "Verify return code" || true
}

# --- HTTP health check with latency via curl ---
# curl's `-w` write-out lets me grab timing fields without parsing the body.
# I pull `http_code` and `time_total`, and `--max-time` prevents hangs.
probe_http() {
  local scheme="${1:-https}"
  local host="${2:-127.0.0.1}"
  local port="${3:-443}"
  local path="${4:-/health}"
  local timeout_secs="${5:-5}"
  local url="${scheme}://${host}:${port}${path}"
  echo ">> HTTP probe: ${url}"
  # http_code 000 means curl never got an HTTP response (connection refused,
  # timeout, DNS failure). Anything else is a real status from the server.
  local code elapsed
  code=$(curl -sS -o /dev/null -w "%{http_code}" --max-time "${timeout_secs}" "${url}" 2>&1) || code="000"
  elapsed=$(curl -sS -o /dev/null -w "%{time_total}" --max-time "${timeout_secs}" "${url}" 2>&1) || elapsed="0.000"
  if [[ "${code}" == "000" ]]; then
    echo "   FAILED — could not connect (curl code 000)"
  else
    echo "   HTTP ${code} — total time ${elapsed}s"
  fi
}

# --- Latency probe: raw TCP RTT using bash /dev/tcp ---
# For a quick-and-dirty latency number without nc/openssl, I use bash's
# built-in /dev/tcp plus `date +%s.%N`. The timing is approximate (includes
# fork overhead) but good enough to spot a port that's slow to accept.
probe_latency() {
  local host="${1:-127.0.0.1}"
  local port="${2:-80}"
  echo ">> Latency probe: ${host}:${port}"
  local start end rc elapsed
  start=$(date +%s.%N)
  timeout 5 bash -c "exec 3<>/dev/tcp/${host}/${port}" 2>/dev/null
  rc=$?
  end=$(date +%s.%N)
  elapsed=$(awk "BEGIN{printf \"%.3f\", ${end} - ${start}}")
  if [[ "${rc}" -eq 0 ]]; then
    echo "   connected in ${elapsed}s"
  else
    echo "   connect failed (rc=${rc}) after ${elapsed}s"
  fi
}

# --- Run all four probes against one target ---
# Pass scheme, host, port. Defaults to a local HTTPS health endpoint.
# Change them to match whatever you're debugging.
test_connectivity() {
  local scheme="${1:-https}"
  local host="${2:-127.0.0.1}"
  local port="${3:-443}"
  echo "=== Connectivity check: ${scheme}://${host}:${port} ==="
  probe_tcp "${host}" "${port}" 5
  probe_tls "${host}" "${port}" 5
  probe_http "${scheme}" "${host}" "${port}" "/health" 5
  probe_latency "${host}" "${port}"
}

# Let the caller pass scheme/host/port, otherwise fall back to defaults.
test_connectivity "${1:-https}" "${2:-127.0.0.1}" "${3:-443}"
