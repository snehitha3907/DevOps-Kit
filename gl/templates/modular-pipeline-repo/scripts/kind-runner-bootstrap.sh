#!/bin/bash
# Kind Runner Bootstrap Script for GitLab CI/CD
# last_verified: 2026-10-21 · GitLab CI/CD 17.4 · Kind 0.26.0
#
# This script creates a Kind cluster and registers a GitLab Runner
# configured to run CI jobs inside the cluster using the Kubernetes executor.
#
# Usage:
#   ./kind-runner-bootstrap.sh [OPTIONS]
#
# Options:
#   -n, --name NAME          Cluster name (default: gitlab-runner)
#   -v, --version VERSION    Kind/Kubernetes version (default: v1.29.2)
#   -r, --runner-token TOKEN GitLab Runner registration token (required)
#   -u, --gitlab-url URL     GitLab instance URL (default: https://gitlab.com)
#   -t, --tags TAGS          Runner tags (default: kubernetes,docker,build,test,deploy)
#   -h, --help               Show this help message
#
# Environment variables (alternative to flags):
#   KIND_CLUSTER_NAME, K8S_VERSION, RUNNER_TOKEN, GITLAB_URL, RUNNER_TAGS
#
# Prerequisites:
#   - Docker installed and running
#   - kind installed (https://kind.sigs.k8s.io/)
#   - kubectl installed
#   - helm installed (for runner installation)
#   - GitLab Runner registration token from Admin Area > Runners

set -euo pipefail

# Default values
CLUSTER_NAME="${KIND_CLUSTER_NAME:-gitlab-runner}"
K8S_VERSION="${K8S_VERSION:-v1.29.2}"
RUNNER_TOKEN="${RUNNER_TOKEN:-}"
GITLAB_URL="${GITLAB_URL:-https://gitlab.com}"
RUNNER_TAGS="${RUNNER_TAGS:-kubernetes,docker,build,test,deploy}"
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
    -t|--tags) RUNNER_TAGS="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) log_error "Unknown option: $1"; usage ;;
  esac
done

# Validate required parameters
if [ -z "$RUNNER_TOKEN" ]; then
  log_error "Runner token is required. Use -r/--runner-token or set RUNNER_TOKEN env var."
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
  log_info "Creating Kind cluster '$CLUSTER_NAME' with Kubernetes $K8S_VERSION..."

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
containerdConfigPatches:
  - |
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
      endpoint = ["https://registry-1.docker.io"]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
      endpoint = ["https://gcr.io"]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."ghcr.io"]
      endpoint = ["https://ghcr.io"]
EOF

  log_success "Kind cluster '$CLUSTER_NAME' created"
}

# Configure kubectl context
configure_kubectl() {
  log_info "Configuring kubectl context..."
  kind get kubeconfig --name "$CLUSTER_NAME" > ~/.kube/kind-${CLUSTER_NAME}
  export KUBECONFIG=~/.kube/kind-${CLUSTER_NAME}
  kubectl cluster-info --context "kind-${CLUSTER_NAME}"
  log_success "kubectl configured for cluster '$CLUSTER_NAME'"
}

# Install ingress controller (NGINX)
install_ingress() {
  log_info "Installing NGINX Ingress Controller..."
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
  log_info "Waiting for ingress controller to be ready..."
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s
  log_success "NGINX Ingress Controller installed"
}

# Install Cert-Manager for TLS
install_cert_manager() {
  log_info "Installing Cert-Manager..."
  kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.yaml
  log_info "Waiting for Cert-Manager to be ready..."
  kubectl wait --namespace cert-manager \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=cert-manager \
    --timeout=120s
  log_success "Cert-Manager installed"
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

  # Add GitLab Helm repository
  helm repo add gitlab https://charts.gitlab.io --force-update
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
        image = "ubuntu:24.04"
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
      [runners.cache]
        Type = "s3"
        Path = "gitlab-runner/cache"
        Shared = true
        [runners.cache.s3]
          ServerAddress = "minio:9000"
          BucketName = "gitlab-runner"
          BucketLocation = "us-east-1"
          Insecure = true
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
  echo "  Kubernetes version: $K8S_VERSION"
  echo "  Runner name: $RUNNER_NAME"
  echo "  Runner tags: $RUNNER_TAGS"
  echo "  Namespace: $NAMESPACE"
  echo "  GitLab URL: $GITLAB_URL"
  echo
  log_info "To use this cluster for local development:"
  echo "  export KUBECONFIG=~/.kube/kind-${CLUSTER_NAME}"
  echo "  kubectl config use-context kind-${CLUSTER_NAME}"
  echo
  log_info "To delete the cluster:"
  echo "  kind delete cluster --name $CLUSTER_NAME"
  echo
  log_info "Runner registration token is stored in secret 'gitlab-runner-secret' in namespace '$NAMESPACE'"
}

# Main execution
main() {
  log_info "Starting Kind runner bootstrap for GitLab CI/CD"
  log_info "Cluster: $CLUSTER_NAME, K8s: $K8S_VERSION, GitLab: $GITLAB_URL"

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