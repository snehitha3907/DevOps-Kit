#!/bin/bash
# GitLab CI Helper Functions
# last_verified: 2026-10-21 · GitLab CI/CD 17.4
# Sourced in before_script via: source .gitlab/ci/helpers.sh

set -euo pipefail

# Colors for output
readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[1;34m'
readonly NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }

# Check if a command exists
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Retry a command with exponential backoff
# Usage: retry <max_attempts> <initial_delay_seconds> <command> [args...]
retry() {
  local max_attempts="$1"
  local delay="$2"
  shift 2
  local attempt=1
  until "$@"; do
    if [ $attempt -ge $max_attempts ]; then
      log_error "Command failed after $max_attempts attempts: $*"
      return 1
    fi
    log_warn "Attempt $attempt failed. Retrying in ${delay}s..."
    sleep $delay
    delay=$((delay * 2))
    attempt=$((attempt + 1))
  done
}

# Wait for a Kubernetes resource to be ready
# Usage: wait_for_rollout <resource> [namespace] [timeout]
wait_for_rollout() {
  local resource="$1"
  local namespace="${2:-default}"
  local timeout="${3:-300s}"
  log_info "Waiting for rollout of $resource in namespace $namespace..."
  kubectl rollout status "$resource" -n "$namespace" --timeout="$timeout"
}

# Generate a semantic version from Git tags
# Usage: version=$(generate_version)
generate_version() {
  local version
  version=$(git describe --tags --always --dirty 2>/dev/null || echo "0.0.0-${CI_COMMIT_SHORT_SHA}")
  echo "$version"
}

# Extract Docker image digest
# Usage: digest=$(get_image_digest <image>)
get_image_digest() {
  local image="$1"
  docker inspect --format='{{index .RepoDigests 0}}' "$image" 2>/dev/null | cut -d'@' -f2
}

# Login to container registry
# Usage: registry_login
registry_login() {
  if [ -n "${CI_REGISTRY_USER:-}" ] && [ -n "${CI_REGISTRY_PASSWORD:-}" ]; then
    log_info "Logging into registry ${CI_REGISTRY}..."
    echo "$CI_REGISTRY_PASSWORD" | docker login -u "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY"
  else
    log_warn "Registry credentials not set, skipping login"
  fi
}

# Setup kubectl with KUBE_CONFIG
# Usage: setup_kubectl
setup_kubectl() {
  if [ -n "${KUBE_CONFIG:-}" ]; then
    log_info "Configuring kubectl..."
    mkdir -p ~/.kube
    echo "$KUBE_CONFIG" | base64 -d > ~/.kube/config
    chmod 600 ~/.kube/config
  else
    log_warn "KUBE_CONFIG not set, skipping kubectl setup"
  fi
}

# Setup Helm with registry auth
# Usage: setup_helm
setup_helm() {
  if [ -n "${CI_REGISTRY_USER:-}" ] && [ -n "${CI_REGISTRY_PASSWORD:-}" ]; then
    log_info "Configuring Helm registry auth..."
    helm registry login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" "$CI_REGISTRY"
  fi
}

# Export common variables for child jobs
# Usage: export_pipeline_vars
export_pipeline_vars() {
  cat > build.env <<EOF
CI_COMMIT_SHA=${CI_COMMIT_SHA}
CI_COMMIT_SHORT_SHA=${CI_COMMIT_SHORT_SHA}
CI_COMMIT_TAG=${CI_COMMIT_TAG:-}
CI_COMMIT_BRANCH=${CI_COMMIT_BRANCH}
CI_PROJECT_NAME=${CI_PROJECT_NAME}
REGISTRY_IMAGE=${REGISTRY_IMAGE}
BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
VERSION=${CI_COMMIT_TAG:-${CI_COMMIT_SHORT_SHA}}
EOF
  log_info "Exported pipeline variables to build.env"
}

# Check if running in a merge request
is_merge_request() {
  [ "${CI_PIPELINE_SOURCE:-}" = "merge_request_event" ]
}

# Check if running on default branch
is_default_branch() {
  [ "${CI_COMMIT_BRANCH:-}" = "${CI_DEFAULT_BRANCH:-}" ]
}

# Check if running on a tag
is_tag() {
  [ -n "${CI_COMMIT_TAG:-}" ]
}

# Get the target environment for deployment
# Usage: env=$(get_deploy_environment)
get_deploy_environment() {
  if is_tag; then
    echo "production"
  elif is_default_branch; then
    echo "staging"
  elif is_merge_request; then
    echo "review-${CI_MERGE_REQUEST_IID}"
  else
    echo "development"
  fi
}

# Validate required environment variables
# Usage: validate_env VAR1 VAR2 ...
validate_env() {
  local missing=()
  for var in "$@"; do
    if [ -z "${!var:-}" ]; then
      missing+=("$var")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    log_error "Missing required environment variables: ${missing[*]}"
    return 1
  fi
}

# Print section header
section() {
  echo
  echo "=========================================="
  echo "  $*"
  echo "=========================================="
}