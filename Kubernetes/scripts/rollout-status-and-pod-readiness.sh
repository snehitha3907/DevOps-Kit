#!/bin/bash
# last_verified: 2026-09-21 · Kubernetes kubectl
# Reusable kubectl helper: rollout status and pod readiness health checks.
#
# Usage:
#   ./rollout-status-and-pod-readiness.sh <deployment-name> [namespace]
#
# Prints the rollout status, then checks that every pod backing the
# deployment is Ready. Exits non-zero if the rollout is still in progress
# or any pod is not Ready, so the script can gate a CI step on it.

set -u

DEPLOYMENT="${1:-}"
NAMESPACE="${2:-default}"

if [ -z "$DEPLOYMENT" ]; then
  echo "usage: $0 <deployment-name> [namespace]" >&2
  exit 2
fi

echo "==> rollout status for '$DEPLOYMENT' in namespace '$NAMESPACE'"
kubectl rollout status deployment/"$DEPLOYMENT" -n "$NAMESPACE"

echo "==> pod readiness for '$DEPLOYMENT' in namespace '$NAMESPACE'"
NOT_READY=0
while read -r pod status; do
  if [ "$status" != "Ready" ]; then
    echo "  NOT READY: $pod (status=$status)"
    NOT_READY=1
  fi
done < <(kubectl get pods -n "$NAMESPACE" \
  -l "app.kubernetes.io/name=$DEPLOYMENT" \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}')

if [ "$NOT_READY" -eq 1 ]; then
  echo "one or more pods are not Ready" >&2
  exit 1
fi

echo "all pods Ready"