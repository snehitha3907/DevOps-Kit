#!/bin/sh
# shellcheck shell=sh
# Helper functions for the pipeline jobs.
# last_verified: 2026-10-22 · GitLab CI (n/a)
#
# The file is sourced from before_script, so it has to parse under whatever
# shell the runner picked for the image. The images this pipeline uses are
# Alpine-based and the runner runs those with sh rather than bash, so the
# file stays POSIX: `source` is a bash builtin, and `pipefail` is not
# portable to every sh.
#
# Sourced with: . .gitlab/ci/helpers.sh

set -eu

# Colours for the log helpers.
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

log_info() { printf '%b\n' "${BLUE}[INFO]${NC} $*"; }
log_warn() { printf '%b\n' "${YELLOW}[WARN]${NC} $*"; }
log_error() { printf '%b\n' "${RED}[ERROR]${NC} $*"; }
log_success() { printf '%b\n' "${GREEN}[SUCCESS]${NC} $*"; }

# Check if a command exists.
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Retry a command with exponential backoff.
# Usage: retry <max_attempts> <initial_delay_seconds> <command> [args...]
retry() {
  max_attempts="$1"
  delay="$2"
  shift 2
  attempt=1
  until "$@"; do
    if [ "$attempt" -ge "$max_attempts" ]; then
      log_error "command failed after $max_attempts attempts: $*"
      return 1
    fi
    log_warn "attempt $attempt failed, retrying in ${delay}s"
    sleep "$delay"
    delay=$((delay * 2))
    attempt=$((attempt + 1))
  done
}

# Wait for a Kubernetes resource to be ready.
# Usage: wait_for_rollout <resource> [namespace] [timeout]
wait_for_rollout() {
  resource="$1"
  namespace="${2:-default}"
  timeout="${3:-300s}"
  log_info "waiting for the rollout of $resource in namespace $namespace"
  kubectl rollout status "$resource" -n "$namespace" --timeout="$timeout"
}

# Generate a version from the git tags.
# Usage: version=$(generate_version)
generate_version() {
  version=$(git describe --tags --always --dirty 2>/dev/null || echo "dev-${CI_COMMIT_SHORT_SHA}")
  echo "$version"
}

# Extract the digest of an image.
# Usage: digest=$(get_image_digest <image>)
get_image_digest() {
  docker inspect --format='{{index .RepoDigests 0}}' "$1" 2>/dev/null | cut -d'@' -f2
}

# Log the registry into the docker client.
# Usage: registry_login
registry_login() {
  if [ -n "${CI_REGISTRY_USER:-}" ] && [ -n "${CI_REGISTRY_PASSWORD:-}" ]; then
    log_info "logging into the registry $CI_REGISTRY"
    # The password goes over stdin rather than through -p, which would put it
    # in the process list for anything else on the runner to read.
    printf '%s' "$CI_REGISTRY_PASSWORD" \
      | docker login --username "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY"
  else
    log_warn "registry credentials are not set, skipping the login"
  fi
}

# Write the kubeconfig from the KUBE_CONFIG variable.
# Usage: setup_kubectl
setup_kubectl() {
  kubeconfig="${KUBECONFIG_FILE:-$HOME/.kube/config}"
  if [ -n "${KUBE_CONFIG:-}" ]; then
    log_info "writing the kubeconfig to $kubeconfig"
    mkdir -p "$(dirname "$kubeconfig")"
    printf '%s' "$KUBE_CONFIG" | base64 -d > "$kubeconfig"
    chmod 600 "$kubeconfig"
  else
    log_warn "KUBE_CONFIG is not set, skipping the kubeconfig"
  fi
}

# Log the registry into helm.
# Usage: setup_helm
setup_helm() {
  if [ -n "${CI_REGISTRY_USER:-}" ] && [ -n "${CI_REGISTRY_PASSWORD:-}" ]; then
    log_info "logging the registry into helm"
    helm registry login \
      --username "$CI_REGISTRY_USER" \
      --password "$CI_REGISTRY_PASSWORD" \
      "$CI_REGISTRY"
  else
    log_warn "registry credentials are not set, skipping the helm login"
  fi
}

# Write the variables the rest of the pipeline needs into the dotenv file.
# Usage: export_pipeline_vars
export_pipeline_vars() {
  # Only the image tag travels. A dotenv variable cannot override a
  # predefined CI_ variable, so writing those back would be ignored at best.
  cat > build.env <<EOF
IMAGE_TAG=${IMAGE_TAG:-$REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA}
VERSION=${CI_COMMIT_TAG:-$CI_COMMIT_SHORT_SHA}
EOF
  log_info "wrote build.env"
}

# Check if the pipeline is a merge request pipeline.
is_merge_request() { [ "${CI_PIPELINE_SOURCE:-}" = "merge_request_event" ]; }

# Check if the pipeline runs on the default branch.
is_default_branch() { [ "${CI_COMMIT_BRANCH:-}" = "${CI_DEFAULT_BRANCH:-}" ]; }

# Check if the pipeline runs on a tag.
is_tag() { [ -n "${CI_COMMIT_TAG:-}" ]; }

# The environment the pipeline deploys to.
# Usage: env=$(get_deploy_environment)
get_deploy_environment() {
  if is_tag; then
    echo "production"
  elif is_default_branch; then
    echo "staging"
  elif is_merge_request; then
    echo "review-${CI_MERGE_REQUEST_IID:-}"
  else
    echo "development"
  fi
}

# Check that the named variables are set.
# Usage: validate_env VAR1 VAR2 ...
validate_env() {
  missing=""
  value=""
  for var in "$@"; do
    # There is no portable way to read a variable by name in POSIX sh, so the
    # lookup goes through eval.
    eval "value=\${$var:-}"
    if [ -z "$value" ]; then
      missing="$missing $var"
    fi
  done
  if [ -n "$missing" ]; then
    log_error "missing required environment variables:$missing"
    return 1
  fi
}

# Print a section header.
section() {
  echo
  echo "=========================================="
  echo "  $*"
  echo "=========================================="
}
