#!/bin/sh
# last_verified: 2026-10-20 · Flux CD 2.x (flux CLI)

# Purpose
#   Bootstrap a kind cluster with Flux CD, create a GitRepository and Kustomization
#   pointing at a demo Git repo. This script automates the manual steps from the
#   quickstart so they can be repeated reliably.
#
# When to use
#   - Setting up a local kind cluster for Flux CD experimentation
#   - CI pipelines that need a disposable Flux-enabled cluster
#   - Learning the Flux bootstrap flow without typing each command
#
# Prerequisites
#   - kind installed and in PATH
#   - kubectl installed and in PATH
#   - Docker running (kind uses Docker containers as nodes)
#   - A Git repository with a ./demo directory containing Kustomize manifests
#     (or use the placeholder and swap the URL later)
#
# Steps
#   1. Create a kind cluster (or use existing)
#   2. Install Flux CLI
#   3. Run pre-flight checks
#   4. Bootstrap Flux components into the cluster
#   5. Create GitRepository and Kustomization resources
#   6. Verify reconciliation

set -e

CLUSTER_NAME="${CLUSTER_NAME:-flux-demo}"
GIT_URL="${GIT_URL:-https://git.example.com/example-org/example-cluster-config}"
GIT_BRANCH="${GIT_BRANCH:-main}"
GIT_PATH="${GIT_PATH:-./demo}"
NAMESPACE="${NAMESPACE:-demo}"

echo "=== Creating kind cluster: $CLUSTER_NAME ==="
if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "Cluster $CLUSTER_NAME already exists"
else
  kind create cluster --name "$CLUSTER_NAME"
fi

echo "=== Installing Flux CLI ==="
curl -sSfL https://raw.githubusercontent.com/fluxcd/flux2/main/install.sh | sudo bash

echo "=== Running pre-flight checks ==="
flux check --pre

echo "=== Bootstrapping Flux components ==="
flux bootstrap github \
  --owner="${GITHUB_OWNER:-example-org}" \
  --repository="${GITHUB_REPO:-example-cluster-config}" \
  --branch="$GIT_BRANCH" \
  --path="./clusters/$CLUSTER_NAME" \
  --personal \
  --token-auth || {
    echo "Bootstrap requires a GitHub token. Set GITHUB_TOKEN or use a different bootstrap method."
    echo "Falling back to manual component install..."
    flux install
  }

echo "=== Creating namespace $NAMESPACE ==="
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo "=== Creating GitRepository ==="
cat <<EOF | kubectl apply -f -
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: demo
  namespace: flux-system
spec:
  interval: 1m
  url: $GIT_URL
  ref:
    branch: $GIT_BRANCH
EOF

echo "=== Creating Kustomization ==="
cat <<EOF | kubectl apply -f -
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: demo
  namespace: flux-system
spec:
  interval: 1m
  path: $GIT_PATH
  prune: true
  sourceRef:
    kind: GitRepository
    name: demo
  targetNamespace: $NAMESPACE
EOF

echo "=== Waiting for GitRepository to be ready ==="
flux reconcile source git demo --with-source --timeout=2m

echo "=== Waiting for Kustomization to reconcile ==="
flux reconcile kustomization demo --with-source --timeout=3m

echo "=== Verification ==="
flux get all
echo ""
echo "GitRepository status:"
kubectl get gitrepository demo -n flux-system -o wide
echo ""
echo "Kustomization status:"
kubectl get kustomization demo -n flux-system -o wide
echo ""
echo "Workloads in $NAMESPACE:"
kubectl get all -n "$NAMESPACE"

echo ""
echo "Bootstrap complete. Next steps:"
echo "  - Push manifests to $GIT_URL at path $GIT_PATH"
echo "  - Run 'flux reconcile kustomization demo --with-source' to force sync"
echo "  - Run 'flux suspend kustomization demo' to pause reconciliation"