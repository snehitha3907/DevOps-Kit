#!/usr/bin/env bash
# last_verified: 2026-09-09 · GitHub Actions n/a

set -euo pipefail

# Self-hosted runner registration and cleanup wrapper for ephemeral runners
# Usage: ./self-hosted-runner-registration-cleanup.sh [register|run|cleanup] [options]
#   register  - Register a new ephemeral runner and output the runner token
#   run       - Start the runner with the provided token (blocks until job completes)
#   cleanup   - Remove the runner after job completion

REPO="${GITHUB_REPOSITORY:-}"
TOKEN="${GITHUB_TOKEN:-}"
RUNNER_NAME="${RUNNER_NAME:-ephemeral-runner-$(date +%s)}"
LABELS="${RUNNER_LABELS:-self-hosted,ephemeral,linux,x64}"
WORK_DIR="${RUNNER_WORK_DIR:-/tmp/runner-${RUNNER_NAME}}"
RUNNER_VERSION="${RUNNER_VERSION:-2.319.1}"

log() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*"
}

die() {
  log "ERROR: $*" >&2
  exit 1
}

check_deps() {
  command -v curl >/dev/null || die "curl not found"
  command -v jq >/dev/null || die "jq not found"
  command -v tar >/dev/null || die "tar not found"
}

download_runner() {
  local arch="x64"
  case "$(uname -m)" in
    aarch64|arm64) arch="arm64" ;;
    x86_64) arch="x64" ;;
    *) die "Unsupported architecture: $(uname -m)" ;;
  esac

  local url="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${arch}-${RUNNER_VERSION}.tar.gz"
  local dest="${WORK_DIR}/actions-runner.tar.gz"

  log "Downloading runner v${RUNNER_VERSION} for ${arch}..."
  mkdir -p "${WORK_DIR}"
  curl -fsSL -o "${dest}" "${url}" || die "Failed to download runner"
  tar -xzf "${dest}" -C "${WORK_DIR}" || die "Failed to extract runner"
  rm -f "${dest}"
}

register_runner() {
  check_deps
  [[ -n "${REPO}" ]] || die "GITHUB_REPOSITORY not set"
  [[ -n "${TOKEN}" ]] || die "GITHUB_TOKEN not set"

  download_runner

  log "Registering runner '${RUNNER_NAME}' for ${REPO}..."
  local reg_token
  reg_token=$(curl -fsSL -X POST \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${REPO}/actions/runners/registration-token" \
    | jq -r .token) || die "Failed to get registration token"

  "${WORK_DIR}/config.sh" \
    --url "https://github.com/${REPO}" \
    --token "${reg_token}" \
    --name "${RUNNER_NAME}" \
    --labels "${LABELS}" \
    --work "${WORK_DIR}/_work" \
    --unattended \
    --replace \
    --ephemeral || die "Runner registration failed"

  log "Runner registered successfully"
  log "Runner name: ${RUNNER_NAME}"
  log "Work directory: ${WORK_DIR}"
}

run_runner() {
  [[ -d "${WORK_DIR}" ]] || die "Runner not found at ${WORK_DIR}. Run 'register' first."
  [[ -f "${WORK_DIR}/.runner" ]] || die "Runner not configured. Run 'register' first."

  log "Starting runner '${RUNNER_NAME}'..."
  cd "${WORK_DIR}"
  ./run.sh --once || die "Runner execution failed"
  log "Runner job completed"
}

cleanup_runner() {
  [[ -d "${WORK_DIR}" ]] || { log "Work directory ${WORK_DIR} not found, nothing to clean"; return 0; }
  [[ -f "${WORK_DIR}/.runner" ]] || { log "Runner not configured, removing work dir"; rm -rf "${WORK_DIR}"; return 0; }

  log "Cleaning up runner '${RUNNER_NAME}'..."
  cd "${WORK_DIR}"

  if [[ -n "${TOKEN}" && -n "${REPO}" ]]; then
    local removal_token
    removal_token=$(curl -fsSL -X POST \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/repos/${REPO}/actions/runners/remove-token" \
      | jq -r .token 2>/dev/null) || removal_token=""

    if [[ -n "${removal_token}" ]]; then
      ./config.sh remove --token "${removal_token}" --unattended || log "Warning: runner removal via API failed"
    else
      log "Warning: could not get removal token, removing locally only"
    fi
  else
    log "No GitHub credentials provided, removing locally only"
  fi

  rm -rf "${WORK_DIR}"
  log "Cleanup complete"
}

usage() {
  cat <<EOF
Self-hosted runner registration and cleanup wrapper for ephemeral runners

Usage: $0 <command> [options]

Commands:
  register    Register a new ephemeral runner
  run         Start the runner (blocks until job completes)
  cleanup     Remove the runner after job completion
  all         Register, run, and cleanup in sequence (for CI use)

Environment variables:
  GITHUB_REPOSITORY   Required. Format: owner/repo
  GITHUB_TOKEN        Required. GitHub token with actions:write permission
  RUNNER_NAME         Optional. Runner name (default: ephemeral-runner-<timestamp>)
  RUNNER_LABELS       Optional. Comma-separated labels (default: self-hosted,ephemeral,linux,x64)
  RUNNER_WORK_DIR     Optional. Work directory (default: /tmp/runner-<name>)
  RUNNER_VERSION      Optional. Runner version (default: 2.319.1)

Examples:
  # In CI, run the full lifecycle:
  GITHUB_REPOSITORY=myorg/myrepo GITHUB_TOKEN=\$TOKEN $0 all

  # Manual step-by-step:
  GITHUB_REPOSITORY=myorg/myrepo GITHUB_TOKEN=\$TOKEN $0 register
  GITHUB_REPOSITORY=myorg/myrepo GITHUB_TOKEN=\$TOKEN $0 run
  GITHUB_REPOSITORY=myorg/myrepo GITHUB_TOKEN=\$TOKEN $0 cleanup
EOF
}

main() {
  local cmd="${1:-}"
  case "${cmd}" in
    register) register_runner ;;
    run) run_runner ;;
    cleanup) cleanup_runner ;;
    all)
      register_runner
      run_runner
      cleanup_runner
      ;;
    *) usage; exit 1 ;;
  esac
}

main "$@"