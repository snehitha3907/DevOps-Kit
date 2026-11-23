#!/bin/bash
# last_verified: 2026-11-22 · Kubernetes kubectl
# Failure Injector for Incident Drill
#
# Usage:
#   ./inject-failure.sh <deployment-name> <namespace> <failure-mode>
#
# Failure modes:
#   image-pull  - Set container image to a non-existent tag (ImagePullBackOff)
#   crash       - Override container command to exit immediately (CrashLoopBackOff)
#   oom         - Set memory limit very low (OOMKilled)
#   probe       - Change readiness probe path to non-existent endpoint
#
# The script patches the Deployment's pod template, creating a new revision
# so that `kubectl rollout undo` can revert to the previous good revision.

set -euo pipefail

DEPLOYMENT="${1:-}"
NAMESPACE="${2:-default}"
MODE="${3:-}"

if [ -z "$DEPLOYMENT" ] || [ -z "$MODE" ]; then
  echo "usage: $0 <deployment-name> <namespace> <image-pull|crash|oom|probe>" >&2
  exit 2
fi

echo "==> Injecting failure mode '$MODE' into deployment/$DEPLOYMENT in namespace $NAMESPACE"

case "$MODE" in
  image-pull)
    # Patch the container image to a tag that does not exist
    kubectl patch deployment "$DEPLOYMENT" -n "$NAMESPACE" -p '{"spec":{"template":{"spec":{"containers":[{"name":"web-app","image":"nginx:this-tag-does-not-exist"}]}}}}'
    echo "Patched image to nginx:this-tag-does-not-exist"
    ;;

  crash)
    # Patch the container command to exit immediately
    kubectl patch deployment "$DEPLOYMENT" -n "$NAMESPACE" -p '{"spec":{"template":{"spec":{"containers":[{"name":"web-app","command":["sh","-c","exit 1"]}]}}}}'
    echo "Patched command to exit 1"
    ;;

  oom)
    # Patch the container memory limit to 4Mi (too low for nginx)
    kubectl patch deployment "$DEPLOYMENT" -n "$NAMESPACE" -p '{"spec":{"template":{"spec":{"containers":[{"name":"web-app","resources":{"limits":{"memory":"4Mi"}}}]}}}}'
    echo "Patched memory limit to 4Mi"
    ;;

  probe)
    # Patch the readiness probe path to a non-existent endpoint
    kubectl patch deployment "$DEPLOYMENT" -n "$NAMESPACE" -p '{"spec":{"template":{"spec":{"containers":[{"name":"web-app","readinessProbe":{"httpGet":{"path":"/nonexistent","port":8080},"initialDelaySeconds":5,"periodSeconds":10}}]}}}}'
    echo "Patched readiness probe path to /nonexistent"
    ;;

  *)
    echo "Unknown failure mode: $MODE" >&2
    echo "Valid modes: image-pull, crash, oom, probe" >&2
    exit 1
    ;;
esac

echo "==> Failure injected. Watching rollout status (press Ctrl+C to stop watching)..."
kubectl rollout status deployment/"$DEPLOYMENT" -n "$NAMESPACE" --timeout=120s || true

echo "==> Current pod status:"
kubectl get pods -n "$NAMESPACE" -l app="$DEPLOYMENT" -o wide