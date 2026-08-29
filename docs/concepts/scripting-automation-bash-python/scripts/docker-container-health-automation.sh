# last_verified: 2026-08-29 · bash n/a

# Container health automation with retry logic
# L3 concept exercise for Scripting & Automation (Bash/Python)
#
# This pattern combines bash scripting fundamentals with containerization
# concepts: instead of checking generic HTTP endpoints, the script probes
# Docker container health, restarts failed services with exponential backoff,
# and writes a YAML summary. The core ideas — retry loops, structured logging,
# error propagation — are the same; only the target changed.

readonly CONTAINERS=("nginx" "redis" "postgres")
readonly MAX_ATTEMPTS=3
readonly INITIAL_DELAY=2
readonly REPORT_FILE="container-health-report.yaml"

# retry_with_backoff — attempt a command up to max_attempts times,
# doubling the delay between tries (capped at 30s).
# The caller passes the command to retry as arguments.
retry_with_backoff() {
  local max_attempts="${1:-3}"
  local delay="${2:-2}"
  shift 2
  local cmd=("${@}")
  local attempt=1

  while (( attempt <= max_attempts )); do
    printf '[retry %d/%d] %s\n' "${attempt}" "${max_attempts}" "${cmd[*]}"
    if "${cmd[@]}"; then
      printf '[retry] succeeded on attempt %d\n' "${attempt}"
      return 0
    fi
    printf '[retry] failed — waiting %ds\n' "${delay}"
    sleep "${delay}"
    delay=$(( delay * 2 ))
    (( delay > 30 )) && delay=30
    (( attempt++ ))
  done

  printf '[retry] all %d attempts failed\n' "${max_attempts}" >&2
  return 1
}

# check_container_health — inspect a container's health status.
# Returns 0 for healthy / no-healthcheck, 1 for starting / unhealthy / missing.
check_container_health() {
  local name="${1}"

  if ! docker ps --format '{{.Names}}' | grep -qFx "${name}"; then
    printf '[health] %s: not running\n' "${name}"
    return 1
  fi

  local status
  status=$(docker inspect --format='{{.State.Health.Status}}' "${name}" 2>/dev/null || echo "none")

  if [[ "${status}" == "healthy" || "${status}" == "none" ]]; then
    printf '[health] %s: %s\n' "${name}" "${status:-no-healthcheck}"
    return 0
  else
    printf '[health] %s: %s\n' "${name}" "${status}"
    return 1
  fi
}

# restart_container — start a stopped container with retry.
restart_container() {
  local name="${1}"
  retry_with_backoff "${MAX_ATTEMPTS}" "${INITIAL_DELAY}" docker start "${name}"
}

# generate_yaml_report — emit a simple YAML summary to stdout.
# The caller redirects to a file. This is a deliberate "add a form"
# exercise: the same automation logic, but the output is structured YAML
# instead of plain text.
generate_yaml_report() {
  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  cat <<EOF
report_generated: ${timestamp}
containers_checked: ${#CONTAINERS[@]}
results:
EOF

  for name in "${CONTAINERS[@]}"; do
    local status="not_running"
    if docker ps --format '{{.Names}}' | grep -qFx "${name}"; then
      status=$(docker inspect --format='{{.State.Health.Status}}' "${name}" 2>/dev/null || echo "no-healthcheck")
    fi
    printf '  - name: %s\n    status: %s\n' "${name}" "${status}"
  done
}

# --- Main ---
# Walk each container, restart if unhealthy, then write the report.
main() {
  printf '=== Container health automation ===\n\n'

  for container in "${CONTAINERS[@]}"; do
    printf '--- checking %s ---\n' "${container}"

    if check_container_health "${container}"; then
      printf '[main] %s is healthy\n' "${container}"
    else
      printf '[main] %s unhealthy or down — attempting restart\n' "${container}"
      if restart_container "${container}"; then
        printf '[main] %s restarted, verifying...\n' "${container}"
        if check_container_health "${container}"; then
          printf '[main] %s recovered\n' "${container}"
        else
          printf '[main] %s still unhealthy after restart\n' "${container}" >&2
        fi
      else
        printf '[main] %s restart failed after %d attempts\n' "${container}" "${MAX_ATTEMPTS}" >&2
      fi
    fi

    printf '\n'
  done

  printf '=== generating report ===\n'
  generate_yaml_report > "${REPORT_FILE}"
  printf 'report written to %s\n' "${REPORT_FILE}"
}

main "${@}"
