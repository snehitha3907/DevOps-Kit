#!/bin/bash
# last_verified: 2026-11-02 · bash 5.2.37 · curl 8.14.1 · ShellCheck 0.11.0

# service-health-check.sh — L1 companion script for "Write a safe Bash health-check script".
#
# Usage: ./service-health-check.sh <url>
#   Exits 0 when the service answers with a successful HTTP status,
#   non-zero when it is down or unreachable.

set -euo pipefail
IFS=$'\n\t'

# is_healthy — return 0 if the given URL answers with a successful HTTP status.
# curl --fail makes curl return non-zero on HTTP 4xx/5xx (and on connection
# failure), so a successful run means the service is healthy.
is_healthy() {
  local url="${1:?missing url}"
  curl --fail --silent --show-error --max-time 5 "$url" > /dev/null
}

# check_service — print a verdict and return non-zero when the service is down.
check_service() {
  local url="${1:?missing url}"
  if is_healthy "$url"; then
    printf 'healthy: %s\n' "$url"
    return 0
  else
    printf 'not healthy: %s\n' "$url" >&2
    return 1
  fi
}

# --- main ---
main() {
  local url="${1:?Usage: service-health-check.sh <url>}"
  check_service "$url"
}

main "$@"