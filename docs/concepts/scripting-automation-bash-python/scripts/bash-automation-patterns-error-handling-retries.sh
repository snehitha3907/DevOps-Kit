#!/usr/bin/env bash
# last_verified: 2026-08-29 · bash n/a

# Bash automation patterns — error handling, retries, and structured logging
# L3 concept script for Scripting & Automation (Bash/Python)
# This script demonstrates common patterns for unattended automation:
# structured logging, retry with exponential backoff and jitter, argument
# validation, cleanup traps, and idempotent setup.

set -euo pipefail

# --- Structured logging ---
# Messages are prefixed with an ISO timestamp and severity tag so logs
# are machine-parseable. DEBUG messages are suppressed unless LOG_LEVEL
# is explicitly set.

LOG_LEVEL="${LOG_LEVEL:-INFO}"
log() {
  local level="${1}"
  shift
  local ts
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "[${ts}] [${level}] ${*}"
}
info() {
  if [[ "${LOG_LEVEL}" == "DEBUG" ]]; then
    log "INFO" "${@}"
  fi
}
warn()  { log "WARN" "${@}" >&2; }
error() { log "ERROR" "${@}" >&2; }

# --- Retry with exponential backoff and jitter ---
# Exponential backoff alone causes thundering herds. Jitter in the 50–150%
# range lets concurrent runners desynchronize naturally. The caller
# supplies max attempts, base delay, and the command array.

retry() {
  local max_attempts="${1:-3}"
  local base_delay="${2:-2}"
  shift 2
  local cmd=("${@}")
  local attempt=1
  local delay="${base_delay}"

  while (( attempt <= max_attempts )); do
    if "${cmd[@]}"; then
      info "Succeeded on attempt ${attempt}"
      return 0
    fi
    warn "Attempt ${attempt}/${max_attempts} failed."
    if (( attempt < max_attempts )); then
      local jitter
      jitter=$(awk "BEGIN {srand(); printf \"%.1f\", ${delay} * (0.5 + rand())}")
      info "Waiting ${jitter}s before retry..."
      sleep "${jitter}"
      delay=$(( delay * 2 ))
      (( delay > 60 )) && delay=60
    fi
    (( attempt++ ))
  done
  error "All ${max_attempts} attempts failed."
  return 1
}

# --- Cleanup trap ---
# EXIT traps fire on normal exit, unhandled errors, and interrupts.
# Registering one here removes temporary artifacts so the script is
# safe to re-run.

TMPDIR_WORK=""
cleanup() {
  if [[ -n "${TMPDIR_WORK}" && -d "${TMPDIR_WORK}" ]]; then
    info "Removing temp dir: ${TMPDIR_WORK}"
    rm -rf "${TMPDIR_WORK}"
  fi
}
trap cleanup EXIT

# --- Argument parsing and validation ---
# Failing fast with a clear message beats producing cryptic errors halfway
# through a long automation run.

usage() {
  cat <<EOF
Usage: ${0} <file_to_check> <expected_owner> [max_attempts] [base_delay]
  file_to_check   Path to the file to verify
  expected_owner  Username that should own the file
  max_attempts    Retry limit (default: 3)
  base_delay      Seconds between retries (default: 2)
EOF
  exit 1
}

if [[ $# -lt 2 ]]; then
  error "Missing required arguments."
  usage
fi

FILE_PATH="${1}"
EXPECTED_OWNER="${2}"
MAX_ATTEMPTS="${3:-3}"
BASE_DELAY="${4:-2}"

if ! [[ "${MAX_ATTEMPTS}" =~ ^[0-9]+$ ]] || (( MAX_ATTEMPTS < 1 )); then
  error "max_attempts must be a positive integer."
  exit 1
fi
if ! [[ "${BASE_DELAY}" =~ ^[0-9]+(\.[0-9]+)?$ ]] || awk "BEGIN {exit (!(${BASE_DELAY} > 0))}"; then
  error "base_delay must be a positive number."
  exit 1
fi

# --- Idempotent setup ---
# A random temp-directory name makes the script safe to run concurrently.

TMPDIR_WORK=$(mktemp -d)
: > "${TMPDIR_WORK}/state.log"

# --- Sample automation: verify file ownership with retry ---
# The verify function represents a real automation task. Wrapping it in
# retry demonstrates how the patterns compose when a downstream check is
# flaky (e.g., NFS latency, eventual consistency after a deployment).

verify_owner() {
  local file="${1}"
  local expected_owner="${2}"
  if [[ ! -f "${file}" ]]; then
    error "File not found: ${file}"
    return 1
  fi
  local actual_owner
  actual_owner=$(stat -c "%U" "${file}")
  if [[ "${actual_owner}" != "${expected_owner}" ]]; then
    error "Owner mismatch: expected ${expected_owner}, got ${actual_owner}"
    return 1
  fi
  echo "OK: ${file} owned by ${actual_owner}"
  return 0
}

info "Starting ownership verification for ${FILE_PATH} (max ${MAX_ATTEMPTS} attempts)"

if output=$(retry "${MAX_ATTEMPTS}" "${BASE_DELAY}" verify_owner "${FILE_PATH}" "${EXPECTED_OWNER}"); then
  while IFS= read -r line; do
    echo "${line}" >> "${TMPDIR_WORK}/state.log"
    info "Result: ${line}"
  done <<< "${output}"
  info "Verification complete. Log saved to ${TMPDIR_WORK}/state.log"
else
  error "Verification failed after ${MAX_ATTEMPTS} attempts."
  exit 1
fi
