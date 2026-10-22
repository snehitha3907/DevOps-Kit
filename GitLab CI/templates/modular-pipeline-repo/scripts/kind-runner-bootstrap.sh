#!/bin/bash
# Kind runner bootstrap script for GitLab CI/CD
# last_verified: 2026-10-22 · GitLab CI (n/a) · Kind (n/a)
#
# This script creates a Kind cluster and registers a GitLab Runner
# configured to run CI jobs inside the cluster using the Kubernetes executor.
#
# Nothing here is pinned to a version. The node image tag, the GitLab URL,
# the chart repository and the two optional manifests are all supplied by the
# caller, because a tag that quietly stops resolving fails a long way from
# the thing that broke. Check that the node image tag matches the Kind
# release you have installed before you run this:
#
#   kind get images
#
# Usage:
#   ./kind-runner-bootstrap.sh [OPTIONS]
#
# Options:
#   -n, --name NAME          Cluster name (default: gitlab-runner)
#   -v, --version TAG        Kind node image tag, for example the tag that
#                            matches your Kind release (required)
#   -r, --runner-token TOKEN GitLab Runner registration token (required)
#   -u, --gitlab-url URL     GitLab instance URL (required)
#   -c, --chart-repo URL     Helm repository holding the GitLab Runner chart
#                            (required)
#   -t, --tags TAGS          Runner tags (default: kubernetes,docker,build,test,deploy)
#   -i, --ingress-manifest URL
#                            Ingress controller manifest to apply. The step is
#                            skipped when this is not set.
#   -m, --cert-manager-manifest URL
#                            Certificate manager manifest to apply. The step
#                            is skipped when this is not set.
#   -h, --help               Show this help message
#
# Environment variables (alternative to flags):
#   KIND_CLUSTER_NAME, K8S_VERSION, RUNNER_TOKEN, GITLAB_URL, CHART_REPO,
#   RUNNER_TAGS, INGRESS_MANIFEST_URL, CERT_MANAGER_MANIFEST_URL
#
# Prerequisites:
#   - Docker installed and running
#   - kind installed
#   - kubectl installed
#   - helm installed (for the runner installation)

set -euo pipefail

# Default values
CLUSTER_NAME="${KIND_CLUSTER_NAME:-gitlab-runner}"
K8S_VERSION="${K8S_VERSION:-}"
RUNNER_TOKEN="${RUNNER_TOKEN:-}"
GITLAB_URL="${GITLAB_URL:-}"
CHART_REPO="${CHART_REPO:-}"
RUNNER_TAGS="${RUNNER_TAGS:-kubernetes,docker,build,test,deploy}"
RUNNER_JOB_IMAGE="${RUNNER_JOB_IMAGE:-ubuntu}"
INGRESS_MANIFEST_URL="${INGRESS_MANIFEST_URL:-}"
CERT_MANAGER_MANIFEST_URL="${CERT_MANAGER_MANIFEST_URL:-}"
RUNNER_NAME="${RUNNER_NAME:-kind-runner-$(date +%s)}"
NAMESPACE="gitlab-runner"

# Colors
readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[1;34m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }

usage() {
  grep '^#' "$0" | cut -c4-
  exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--name) CLUSTER_NAME="$2"; shift 2 ;;
    -v|--version) K8S_VERSION="$2"; shift 2 ;;
    -r|--runner-token) RUNNER_TOKEN="$2"; shift 2 ;;
    -u|--gitlab-url) GITLAB_URL="$2"; shift 2 ;;
    -c|--chart-repo) CHART_REPO="$2"; shift 2 ;;
    -t|--tags) RUNNER_TAGS="$2"; shift 2 ;;
    -i|--ingress-manifest) INGRESS_MANIFEST_URL="$2"; shift 2 ;;
    -m|--cert-manager-manifest) CERT_MANAGER_MANIFEST_URL="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) log_error "Unknown option: $1"; usage ;;
  esac
done

# Validate required parameters
if [ -z "$K8S_VERSION" ]; then
  log_error "A node image tag is required. Use -v/--version or set K8S_VERSION."
  log_error "Pick the tag that matches the Kind release you have installed."
  exit 1
fi

if [ -z "$RUNNER_TOKEN" ]; then
  log_error "Runner token is required. Use -r/--runner-token or set RUNNER_TOKEN env var."
  exit 1
fi

if [ -z "$GITLAB_URL" ]; then
  log_error "GitLab URL is required. Use -u/--gitlab-url or set GITLAB_URL env var."
  exit 1
fi

if [ -z "$CHART_REPO" ]; then
  log_error "Chart repository is required. Use -c/--chart-repo or set CHART_REPO env var."
  log_error "It has to be the Helm repository that holds the GitLab Runner chart."
  exit 1
fi

# Check prerequisites
check_prereqs() {
  log_info "Checking prerequisites..."
  local missing=()
  for cmd in docker kind kubectl helm; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$cmd")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    log_error "Missing required commands: ${missing[*]}"
    log_error "Install them and try again."
    exit 1
  fi
  if ! docker info >/dev/null 2>&1; then
    log_error "Docker daemon is not running"
    exit 1
  fi
  log_success "All prerequisites satisfied"
}

# Create Kind cluster with custom configuration
create_cluster() {
  log_info "Creating Kind cluster '$CLUSTER_NAME' with the node image $K8S_VERSION..."

  # Check if cluster already exists
  if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    log_warn "Cluster '$CLUSTER_NAME' already exists. Deleting..."
    kind delete cluster --name "$CLUSTER_NAME"
  fi

  cat <<EOF | kind create cluster --name "$CLUSTER_NAME" --image "kindest/node:${K8S_VERSION}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: ${CLUSTER_NAME}
networking:
  apiServerAddress: "127.0.0.1"
  apiServerPort: 6443
  disableDefaultCNI: false
  kubeProxyMode: "ipvs"
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "gitlab-runner=true,role=control-plane"
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP
      - containerPort: 443
        hostPort: 443
        protocol: TCP
  - role: worker
    kubeadmConfigPatches:
      - |
        kind: JoinConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "gitlab-runner=true,role=worker"
  - role: worker
    kubeadmConfigPatches:
      - |
        kind: JoinConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "gitlab-runner=true,role=worker"
EOF

  log_success "Kind cluster '$CLUSTER_NAME' created"
}

# Configure kubectl context
configure_kubectl() {
  log_info "Configuring kubectl context..."
  kind get kubeconfig --name "$CLUSTER_NAME" > "$HOME/.kube/kind-${CLUSTER_NAME}"
  export KUBECONFIG="$HOME/.kube/kind-${CLUSTER_NAME}"
  kubectl cluster-info --context "kind-${CLUSTER_NAME}"
  log_success "kubectl configured for cluster '$CLUSTER_NAME'"
}

# Install an ingress controller. The manifest is supplied by the caller,
# because the controller publishes a new manifest per release and the one
# that matches the cluster is the caller's choice.
install_ingress() {
  if [ -z "$INGRESS_MANIFEST_URL" ]; then
    log_warn "No ingress manifest given, skipping the ingress controller."
    return 0
  fi
  log_info "Installing the ingress controller..."
  kubectl apply -f "$INGRESS_MANIFEST_URL"
  log_info "Waiting for the ingress controller to be ready..."
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s
  log_success "Ingress controller installed"
}

# Install the certificate manager. The manifest is supplied by the caller for
# the same reason as the ingress manifest.
install_cert_manager() {
  if [ -z "$CERT_MANAGER_MANIFEST_URL" ]; then
    log_warn "No certificate manager manifest given, skipping it."
    return 0
  fi
  log_info "Installing the certificate manager..."
  kubectl apply -f "$CERT_MANAGER_MANIFEST_URL"
  log_info "Waiting for the certificate manager to be ready..."
  kubectl wait --namespace cert-manager \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=cert-manager \
    --timeout=120s
  log_success "Certificate manager installed"
}

# Create namespace for GitLab Runner
create_namespace() {
  log_info "Creating namespace '$NAMESPACE'..."
  kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
  log_success "Namespace '$NAMESPACE' created"
}

# Create runner registration secret
create_runner_secret() {
  log_info "Creating runner registration secret..."
  kubectl create secret generic gitlab-runner-secret \
    --namespace "$NAMESPACE" \
    --from-literal=runner-registration-token="$RUNNER_TOKEN" \
    --dry-run=client -o yaml | kubectl apply -f -
  log_success "Runner registration secret created"
}

# Install GitLab Runner using Helm
install_runner() {
  log_info "Installing GitLab Runner via Helm..."

  # Add the chart repository the caller named
  helm repo add gitlab "$CHART_REPO" --force-update
  helm repo update

  # Create runner configuration
  cat <<EOF > /tmp/runner-values.yaml
gitlabUrl: ${GITLAB_URL}
runnerRegistrationToken: "${RUNNER_TOKEN}"
certsSecretName: ""
rbac:
  create: true
  clusterWideAccess: true
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "${NAMESPACE}"
        image = "${RUNNER_JOB_IMAGE}"
        privileged = true
        cpu_limit = "2000m"
        memory_limit = "2Gi"
        cpu_request = "500m"
        memory_request = "512Mi"
        service_account = "gitlab-runner"
        [runners.kubernetes.pod_labels]
          gitlab-runner = "true"
        [runners.kubernetes.volumes]
          [[runners.kubernetes.volumes.host_path]]
            name = "docker-sock"
            mount_path = "/var/run/docker.sock"
            host_path = "/var/run/docker.sock"
          [[runners.kubernetes.volumes.empty_dir]]
            name = "build-dir"
            mount_path = "/builds"
          [[runners.kubernetes.volumes.empty_dir]]
            name = "cache-dir"
            mount_path = "/cache"
      [runners.kubernetes.pod_annotations]
        "prometheus.io/scrape" = "true"
        "prometheus.io/port" = "9100"
  tags: "${RUNNER_TAGS}"
  runUntagged: false
  locked: false
  accessLevel: "not_protected"
  maximumTimeout: 3600
  pollInterval: 10
  pollTimeout: 180
  outputLimit: 4096
EOF

  helm upgrade --install gitlab-runner gitlab/gitlab-runner \
    --namespace "$NAMESPACE" \
    --values /tmp/runner-values.yaml \
    --wait --timeout 300s

  log_success "GitLab Runner installed"
}

# Verify runner registration
verify_runner() {
  log_info "Verifying runner registration..."
  sleep 10
  local pods
  pods=$(kubectl get pods -n "$NAMESPACE" -l app=gitlab-runner --no-headers 2>/dev/null | grep -c Running || echo "0")
  if [ "$pods" -gt 0 ]; then
    log_success "GitLab Runner is running ($pods pod(s))"
    kubectl get pods -n "$NAMESPACE" -l app=gitlab-runner
  else
    log_warn "Runner pods not yet running. Checking status..."
    kubectl get pods -n "$NAMESPACE" -l app=gitlab-runner
    kubectl logs -n "$NAMESPACE" -l app=gitlab-runner --tail=50
  fi
}

# Print connection information
print_info() {
  log_info "Cluster information:"
  echo "  Cluster name: $CLUSTER_NAME"
  echo "  Node image tag: $K8S_VERSION"
  echo "  Runner name: $RUNNER_NAME"
  echo "  Runner tags: $RUNNER_TAGS"
  echo "  Namespace: $NAMESPACE"
  echo "  GitLab URL: $GITLAB_URL"
  echo
  log_info "To use this cluster for local development:"
  echo "  export KUBECONFIG=~/.kube/kind-$CLUSTER_NAME"
  echo "  kubectl config use-context kind-$CLUSTER_NAME"
  echo
  log_info "To delete the cluster:"
  echo "  kind delete cluster --name $CLUSTER_NAME"
  echo
  log_info "Runner registration token is stored in secret 'gitlab-runner-secret' in namespace '$NAMESPACE'"
}

# Main execution
main() {
  log_info "Starting Kind runner bootstrap for GitLab CI/CD"
  log_info "Cluster: $CLUSTER_NAME, node image: $K8S_VERSION, GitLab: $GITLAB_URL"

  check_prereqs
  create_cluster
  configure_kubectl
  install_ingress
  install_cert_manager
  create_namespace
  create_runner_secret
  install_runner
  verify_runner
  print_info

  log_success "Kind runner bootstrap completed successfully!"
}

main "$@"
