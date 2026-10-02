#!/usr/bin/env bash
# last_verified: 2026-10-02 · ArgoCD CLI
# Build an ArgoCD Application from scratch and drive an automated sync to health.
#
# This is the end-to-end counterpart to the install + login + sync snippet already
# in this folder: it takes a bare cluster with ArgoCD running, drops a single
# Application manifest, and wires the sync policy so the app maintains itself.
#
# Usage:
#   ./build-argocd-application-from-scratch.sh \
#       --app guestbook --repo https://github.com/myorg/my-gitops.git \
#       --path manifests/guestbook --branch main \
#       --namespace guestbook --project default
#
# The script is idempotent: re-running it re-applies the same manifest and
# re-triggers the sync, so it is safe to use as the deploy step of a CI job.

set -euo pipefail

APP=""
REPO=""
APP_PATH=""
BRANCH="main"
NAMESPACE="default"
PROJECT="default"
SERVER="https://kubernetes.default.svc"
DRY_RUN=false

usage() {
  cat <<EOF
Usage: $0 --app <name> --repo <url> --path <git-path> [options]

Required:
  --app <name>       ArgoCD Application name
  --repo <url>       Git repo URL ArgoCD should read from
  --path <path>      Path inside the repo holding the manifests

Options:
  --branch <ref>     targetRevision (default: main)
  --namespace <ns>   destination namespace (default: default)
  --project <proj>   ArgoCD project (default: default)
  --server <url>     destination cluster API server (default: in-cluster)
  --dry-run          render the manifest and print it; do not apply
  -h                 show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --app) APP="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    --path) APP_PATH="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --namespace) NAMESPACE="$2"; shift 2 ;;
    --project) PROJECT="$2"; shift 2 ;;
    --server) SERVER="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

if [ -z "$APP" ] || [ -z "$REPO" ] || [ -z "$APP_PATH" ]; then
  echo "Missing required arguments:" >&2
  usage
  exit 2
fi

# Render the Application manifest to a temp file so the apply and the dry-run
# path share one code generation step.
TMP_MANIFEST="$(mktemp /tmp/argocd-app-XXXX.yaml)"
trap 'rm -f "$TMP_MANIFEST"' EXIT

cat > "$TMP_MANIFEST" <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${APP}
  namespace: argocd
  labels:
    app.kubernetes.io/name: ${APP}
spec:
  project: ${PROJECT}
  source:
    repoURL: ${REPO}
    targetRevision: ${BRANCH}
    path: ${APP_PATH}
  destination:
    server: ${SERVER}
    namespace: ${NAMESPACE}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

if [ "$DRY_RUN" = true ]; then
  echo "----- rendered Application manifest -----"
  cat "$TMP_MANIFEST"
  exit 0
fi

echo ">> Applying Application manifest for '${APP}'"
kubectl apply -f "$TMP_MANIFEST"

echo ">> Creating destination namespace '${NAMESPACE}' if absent"
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo ">> Triggering automated sync"
argocd app sync "$APP" --async

echo ">> Waiting for health (timeout 180s)"
argocd app wait "$APP" --health --timeout 180

echo ">> Final status"
argocd app get "$APP" -o wide