# last_verified: 2026-08-23 · bash n/a

# Config file parsing, JSON querying with jq, and retry with exponential backoff
# L2 concept exercise for Scripting & Automation (Bash/Python)
# I wanted to practice reading structured config files and handling flaky commands.
# This script ties together the three patterns I keep seeing in real CI pipelines.

set -u

CONFIG_FILE="${1:-config.ini}"
API_ENDPOINT="${2:-http://localhost:8080/api/status}"

# --- Exercise 1: parse a simple INI-style config file ---
# I'm using a while-read loop with IFS to split key=value lines.
# The grep skip-comment pattern is the simplest way to ignore # lines
# without pulling in sed or awk.

parse_config() {
  local file="${1}"
  local section=""

  if [[ ! -f "${file}" ]]; then
    echo "Config file not found: ${file}" >&2
    return 1
  fi

  while IFS='=' read -r key value || [[ -n "${key}" ]]; do
    key=$(echo "${key}" | xargs)
    value=$(echo "${value}" | xargs)

    # skip comments and blank lines
    [[ -z "${key}" || "${key}" == \#* ]] && continue

    # sections in brackets
    if [[ "${key}" == \[*\] ]]; then
      section="${key//[\[\]]/}"
      continue
    fi

    echo "[${section}] ${key} = ${value}"
  done < "${file}"
}

# --- Exercise 2: query JSON output with jq ---
# I'm fetching a JSON endpoint and pulling out specific fields.
# The key thing I learned: jq -r gives raw strings, not quoted ones.

query_api_json() {
  local url="${1}"
  local response

  response=$(curl -sf --max-time 5 "${url}" 2>/dev/null) || {
    echo "API request failed for ${url}" >&2
    return 1
  }

  # extract status and service name from a typical health endpoint
  local status
  status=$(echo "${response}" | jq -r '.status // "unknown"')
  local service
  service=$(echo "${response}" | jq -r '.service // "unnamed"')

  echo "Service: ${service}, Status: ${status}"

  # pull out any warnings array if present
  local warnings
  warnings=$(echo "${response}" | jq -r '.warnings[]? // empty' 2>/dev/null)
  if [[ -n "${warnings}" ]]; then
    echo "Warnings:"
    echo "${warnings}" | while IFS= read -r w; do
      echo "  - ${w}"
    done
  fi

  return 0
}

# --- Exercise 3: retry with exponential backoff ---
# This is the same pattern I see everywhere — attempt, wait, double the wait,
# cap at 30 seconds. The caller passes max attempts, initial delay, and the command.

retry() {
  local max_attempts="${1:-3}"
  local delay="${2:-2}"
  local cmd=("${@:3}")
  local attempt=1

  while (( attempt <= max_attempts )); do
    echo "Attempt ${attempt}/${max_attempts}: ${cmd[*]}"
    if "${cmd[@]}"; then
      echo "Succeeded on attempt ${attempt}"
      return 0
    fi
    echo "Failed. Waiting ${delay}s..."
    sleep "${delay}"
    delay=$(( delay * 2 ))
    (( delay > 30 )) && delay=30
    (( attempt++ ))
  done

  echo "All ${max_attempts} attempts failed." >&2
  return 1
}

# --- Main ---
# I run each exercise and report the results. The || true on each call
# lets the script continue even if one exercise fails — I want to see
# all the output, not stop at the first problem.

main() {
  echo "=== Exercise 1: parse config ==="
  parse_config "${CONFIG_FILE}" || true

  echo ""
  echo "=== Exercise 2: query API JSON ==="
  retry 3 2 query_api_json "${API_ENDPOINT}" || true

  echo ""
  echo "=== Exercise 3: retry a flaky command ==="
  # simulate a command that fails twice then succeeds
  local attempt_count=0
  flaky_command() {
    (( attempt_count++ ))
    if (( attempt_count < 3 )); then
      echo "Flaky command failed (attempt ${attempt_count})"
      return 1
    fi
    echo "Flaky command succeeded"
    return 0
  }

  retry 5 1 flaky_command || true
}

main "${@}"
