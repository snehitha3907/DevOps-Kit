#!/usr/bin/env bash
# bootstrap-kind.sh — Create a kind cluster and install Argo CD
# last_verified: 2026-10-20 · Argo CD 2.14+ (chart 10.10.3)

set -euo pipefail

CLUSTER_NAME="argocd-multi-cluster"
ARGOCD_NAMESPACE="argocd"
ARGOCD_CHART_VERSION="10.10.3"
ARGOCD_VERSION="v2.14.3"
KIND_NODE_IMAGE="kindest/node:v1.30.0"

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*"; }

check_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "Required command '$1' not found"; exit 1; }
}

wait_for_deployment() {
  local ns="$1" deploy="$2" timeout="${3:-180}"
  info "Waiting for deployment/$deploy in namespace $ns..."
  kubectl -n "$ns" rollout status "deployment/$deploy" --timeout="${timeout}s" || {
    err "Deployment $deploy did not become ready in time"
    kubectl -n "$ns" get pods -l "app.kubernetes.io/name=$deploy" -o wide
    exit 1
  }
}

main() {
  info "Checking prerequisites..."
  check_cmd kind
  check_cmd kubectl
  check_cmd helm
  check_cmd docker

  info "Creating kind cluster '$CLUSTER_NAME'..."
  if kind get clusters | grep -qx "$CLUSTER_NAME"; then
    warn "Cluster '$CLUSTER_NAME' already exists. Skipping creation."
  else
    cat <<EOF | kind create cluster --name "$CLUSTER_NAME" --image "$KIND_NODE_IMAGE" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP
      - containerPort: 443
        hostPort: 443
        protocol: TCP
EOF
  fi

  info "Setting kubectl context..."
  kubectl config use-context "kind-$CLUSTER_NAME"

  info "Installing Argo CD Helm chart version $ARGOCD_CHART_VERSION..."
  helm repo add argo https://argoproj.github.io/argo-helm --force-update
  helm repo update argo

  kubectl create namespace "$ARGOCD_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

  helm upgrade --install argocd argo/argo-cd \
    --namespace "$ARGOCD_NAMESPACE" \
    --version "$ARGOCD_CHART_VERSION" \
    --set server.service.type=LoadBalancer \
    --set server.extraArgs[0]="--insecure" \
    --set controller.extraArgs[0]="--enable-k8s-cluster-secrets" \
    --set repoServer.extraArgs[0]="--parallelismlimit=10" \
    --wait --timeout 5m

  info "Waiting for Argo CD components to be ready..."
  wait_for_deployment "$ARGOCD_NAMESPACE" "argocd-server"
  wait_for_deployment "$ARGOCD_NAMESPACE" "argocd-repo-server"
  wait_for_deployment "$ARGOCD_NAMESPACE" "argocd-dex-server"
  wait_for_deployment "$ARGOCD_NAMESPACE" "argocd-redis"
  wait_for_deployment "$ARGOCD_NAMESPACE" "argocd-application-controller"

  info "Retrieving initial admin password..."
  local password
  password=$(kubectl -n "$ARGOCD_NAMESPACE" get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' 2>/dev/null | base64 -d || echo "Unable to retrieve (secret may not exist yet)")

  info "Argo CD is ready!"
  printf "\n"
  printf "Cluster:         %s\n" "$CLUSTER_NAME"
  printf "Argo CD Version: %s\n" "$ARGOCD_VERSION"
  printf "Chart Version:   %s\n" "$ARGOCD_CHART_VERSION"
  printf "Namespace:       %s\n" "$ARGOCD_NAMESPACE"
  printf "Admin User:      admin\n"
  printf "Admin Password:  %s\n" "$password"
  printf "\n"
  printf "Access Argo CD UI:\n"
  printf "  kubectl -n %s port-forward svc/argocd-server 8080:80\n" "$ARGOCD_NAMESPACE"
  printf "  Then open http://localhost:8080\n"
  printf "\n"
  printf "Next steps:\n"
  printf "  1. Apply the base Kustomize: kubectl apply -k overlays/dev/\n"
  printf "  2. Deploy applications: kubectl apply -f applicationset/matrix-generator.yaml\n"
}

main "$@"