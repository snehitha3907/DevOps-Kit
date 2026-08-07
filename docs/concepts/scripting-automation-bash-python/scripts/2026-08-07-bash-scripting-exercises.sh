# last_verified: 2026-08-07 · bash n/a

# Bash scripting exercises — functions, loops, and error handling
# L2 concept exercise for Scripting & Automation (Bash/Python)
# I'm using plain bash functions here because the task asks for exercises,
# not a polished framework. Each function is independent so I can run them
# separately while learning.


# I kept this as a function instead of a loop at the top level so I can
# reuse it for the other exercises. The backoff doubles each attempt,
# capped at 30 seconds, because exponential backoff is the standard
# pattern and I want to practice it before I see it in real CI scripts.

retry_with_backoff() {
  local max_attempts="${1:-3}"
  local delay="${2:-2}"
  local cmd=("${@:3}")
  local attempt=1

  while (( attempt <= max_attempts )); do
    echo "Attempt ${attempt}/${max_attempts}: ${cmd[*]}"
    if "${cmd[@]}"; then
      echo "Success on attempt ${attempt}"
      return 0
    fi
    echo "Failed. Waiting ${delay}s before retrying..."
    sleep "${delay}"
    delay=$(( delay * 2 ))
    (( delay > 30 )) && delay=30
    (( attempt++ ))
  done

  echo "All ${max_attempts} attempts failed."
  return 1
}

# --- Exercise 2: process a list of services ---
# I used a for-loop over an array because arrays preserve whitespace
# better than iterating over a string. The error handling prints which
# service failed but continues processing the rest — that's the behavior
# I want when checking multiple endpoints.

check_services() {
  local services=("http://localhost:9090/metrics" "http://localhost:3000" "http://localhost:8080/health")
  local failures=()

  for svc in "${services[@]}"; do
    echo "Checking ${svc}..."
    # curl -sf = silent + fail on HTTP error codes >= 400
    if curl -sf --max-time 2 "${svc}" > /dev/null; then
      echo "  OK"
    else
      echo "  FAILED"
      failures+=("${svc}")
    fi
  done

  if (( ${#failures[@]} > 0 )); then
    echo "Failed services: ${failures[*]}"
    return 1
  fi

  echo "All services healthy."
  return 0
}

# --- Exercise 3: parse log lines and filter ---
# I'm reading from stdin so I can pipe any log file into this function.
# The nested while-read loop was the trickiest part — I had to make sure
# I used `read -r` to avoid backslash interpretation, and I reset IFS
# only for the inner loop so the outer loop's field splitting stays intact.

filter_log_errors() {
  local pattern="${1:-ERROR}"
  local count=0

  while IFS= read -r line; do
    if [[ "${line}" == *"${pattern}"* ]]; then
      echo "${line}"
      (( count++ ))
    fi
  done

  echo "---"
  echo "Matched ${count} lines containing '${pattern}'"
  return 0
}

# --- Exercise 4: timed run with fallback ---
# I wanted to practice running a command with a timeout and then
# falling back to a simpler check if it hangs. `timeout` sends SIGTERM
# and then SIGKILL after the grace period, which is the standard way
# to prevent a stuck command from blocking the whole script.

timed_probe() {
  local url="${1:-http://localhost:8080/health}"
  local timeout_secs="${2:-3}"

  local response
  response=$(timeout "${timeout_secs}" curl -sf "${url}" 2>/dev/null) || {
    echo "Probe timed out or failed for ${url}"
    return 1
  }

  echo "Probe response: ${response}"
  return 0
}

# --- Main runner ---
# I'm calling each exercise in sequence and using the return code to
# decide whether to continue. The `|| true` on the last check prevents
# the whole script from exiting early if one probe fails — I want to
# see all results, not stop at the first error.

main() {
  echo "=== Exercise 1: retry ==="
  retry_with_backoff 3 2 curl -sf http://localhost:9090/metrics || true

  echo ""
  echo "=== Exercise 2: check services ==="
  check_services || true

  echo ""
  echo "=== Exercise 3: filter logs ==="
  # sample log data piped into the filter function
  cat <<'EOF' | filter_log_errors "ERROR"
2026-08-07 12:00:01 INFO Starting service
2026-08-07 12:00:02 ERROR Connection refused
2026-08-07 12:00:03 WARN High latency detected
2026-08-07 12:00:04 ERROR Timeout waiting for upstream
2026-08-07 12:00:05 INFO Health check passed
EOF

  echo ""
  echo "=== Exercise 4: timed probe ==="
  timed_probe "http://localhost:8080/health" 3 || true
}

main "${@}"
