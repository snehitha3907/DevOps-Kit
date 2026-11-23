---
last_verified: 2026-11-23
tool_version: 1.37.2
sources:
  - https://kubernetes.io/docs/tasks/debug/debug-application/
  - https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/
  - https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment
  - https://kubernetes.io/docs/reference/kubectl/generated/kubectl_rollout/
  - https://dl.k8s.io/release/stable.txt
  - https://github.com/kubernetes-sigs/kind/releases/tag/v0.33.0
  - https://github.com/kubernetes/minikube/releases/tag/v1.39.0
---
# Run an incident drill with a runbook

In [Define an SLO and alert on its burn rate](../09-observability/05-slo-and-burn-rate.md) you built SLOs and burn-rate alerts that fire when the error budget is consumed too fast. In [Remove static secrets from the cluster](../10-security/03-vault-secrets-in-kubernetes.md) you moved secrets out of Git and into Vault. Now you have observability that tells you *something* is wrong and a cluster where the app runs without static credentials. This lesson turns an alert into action: you follow a runbook to diagnose the failing deployment, roll back to a known-good revision, confirm recovery, and write a short post-incident note.

## What you'll learn

- Follow a runbook to diagnose a failing deployment from its alert
- Use `kubectl get events`, `kubectl describe pod/deployment`, `kubectl logs`, and `kubectl rollout status` to identify the root cause (ImagePullBackOff, CrashLoopBackOff, OOMKilled, resource limits, readiness/liveness probe failures)
- Roll back with `kubectl rollout undo deployment/<name> [--to-revision=N]`, confirm recovery with `kubectl rollout status` and `kubectl get pods`
- Write a short post-incident note recording timeline, root cause, action taken, and prevention

## Before you start

- [Define an SLO and alert on its burn rate](../09-observability/05-slo-and-burn-rate.md) — the app is scraped by Prometheus and has fast-burn and slow-burn alerts configured; this lesson simulates the alert firing.
- [Remove static secrets from the cluster](../10-security/03-vault-secrets-in-kubernetes.md) — the app reads its database password from Vault at runtime; the Deployment manifest contains no secret values.
- A local Kubernetes cluster (kind or minikube) with `kubectl` configured; confirm with `kubectl version --client` (v1.37.2 or compatible).
- The sample app Deployment from the previous lessons, deployed with a RollingUpdate strategy and `revisionHistoryLimit` left at the default (10).
- `curl` and `jq` available for querying Prometheus and the Kubernetes API.
- Reference runbook: [`Kubernetes/configs/incident-runbook.yaml`](../../Kubernetes/configs/incident-runbook.yaml) — a template you will use during the drill.
- Reference failure injector: [`Kubernetes/scripts/inject-failure.sh`](../../Kubernetes/scripts/inject-failure.sh) — a script that breaks the Deployment in a controlled way so you can practice diagnosis.

## Walkthrough

### 1. Review the runbook

Open the runbook template. It defines the steps you will follow when the alert fires.

```bash
cat ../../Kubernetes/configs/incident-runbook.yaml
```

You should see: a YAML document with sections for alert context, diagnosis commands, rollback procedure, verification, and post-incident note template.

### 2. Confirm the healthy baseline

Before injecting a failure, verify the Deployment is healthy and note its current revision.

```bash
# Name of the Deployment from previous lessons
DEPLOYMENT=web-app
NAMESPACE=default

# Current rollout status and revision
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE
kubectl rollout history deployment/$DEPLOYMENT -n $NAMESPACE
```

You should see: rollout status reports `successfully rolled out`; history shows at least one revision with a `CHANGE-CAUSE` annotation (if you used `--record` or set the annotation).

### 3. Inject a failure

The failure injector breaks the Deployment by updating the pod template to use a non-existent image tag, simulating an `ImagePullBackOff`. This creates a new revision (so rollback is possible).

```bash
../../Kubernetes/scripts/inject-failure.sh $DEPLOYMENT $NAMESPACE image-pull
```

You should see: the script patches the Deployment's container image to `nginx:this-tag-does-not-exist`, and `kubectl rollout status` begins waiting (and eventually times out).

Watch the rollout:

```bash
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=60s
```

You should see: the rollout hangs; after the timeout it reports an error. The pods are stuck in `ImagePullBackOff`.

### 4. Diagnose using the runbook steps

Follow the runbook's diagnosis section. Start with events and pod status.

```bash
# Events in the namespace (filtered to the Deployment's pods)
kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp' | grep -E "$DEPLOYMENT|Warning"

# Describe a failing pod
POD=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD -n $NAMESPACE
```

You should see: events show `Failed to pull image` and `Back-off pulling image`; `describe pod` shows `ImagePullBackOff` under `State` and the image name `nginx:this-tag-does-not-exist` under `Containers`.

Check the rollout history again — the bad change created a new revision:

```bash
kubectl rollout history deployment/$DEPLOYMENT -n $NAMESPACE
```

You should see: two revisions now; the latest has no `CHANGE-CAUSE` (because the injector did not set one), and its pod template references the bad image.

### 5. Roll back to the previous revision

Use `kubectl rollout undo` to revert to the last known-good revision.

```bash
kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE
```

You should see: `deployment.apps/web-app rolled back`. The Deployment controller immediately starts a new rollout using the previous revision's pod template.

Watch the rollback complete:

```bash
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE
```

You should see: `deployment.apps/web-app successfully rolled out` within a minute. The pods are now running the good image again.

### 6. Confirm recovery

Verify the app is healthy and serving traffic.

```bash
# All pods Ready
kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT

# Port-forward and hit the health endpoint
kubectl port-forward -n $NAMESPACE svc/web-app-service 8080:80 &
PF_PID=$!
sleep 2
curl -s http://localhost:8080/healthz
curl -s http://localhost:8080/ready
kill $PF_PID
```

You should see: all pods show `Running` and `Ready`; both health endpoints return success (HTTP 200).

Check the rollout history again — a new revision was created for the rollback:

```bash
kubectl rollout history deployment/$DEPLOYMENT -n $NAMESPACE
```

You should see: three revisions now; revision 3 is the rollback, and its pod template matches revision 1 (the original good image).

### 7. Write a post-incident note

Use the template from the runbook. Fill in the timeline, root cause, action taken, and prevention. Save it as `incident-$(date +%Y%m%d-%H%M).md`.

```bash
cat > incident-$(date +%Y%m%d-%H%M).md <<'EOF'
# Incident: ImagePullBackOff on web-app Deployment

**Date:** $(date -u +"%Y-%m-%d %H:%M UTC")
**Duration:** ~5 minutes (simulated)
**Severity:** P2 (degraded service, no data loss)

## Timeline
- T+00:00 — Fast-burn alert `DemoAppFastBurn` fires (error rate > 1% over 5m)
- T+00:30 — On-call opens runbook, checks `kubectl get events`
- T+01:00 — Identifies `ImagePullBackOff` on web-app pods; bad image tag `nginx:this-tag-does-not-exist`
- T+01:30 — Executes `kubectl rollout undo deployment/web-app`
- T+02:30 — Rollout completes; all pods Ready; health checks pass
- T+03:00 — Alert resolves; post-incident note written

## Root Cause
A Deployment patch (simulated by the drill) set the container image to a non-existent tag. The image does not exist in any registry, so the kubelet cannot pull it. The Deployment created a new revision with the bad template, and the rolling update stalled at maxUnavailable.

## Action Taken
Rolled back to the previous revision (`kubectl rollout undo`). The Deployment controller recreated pods from the known-good pod template. No manual image tag correction was needed because the previous revision was intact.

## Prevention
- Pin exact image tags in Deployment manifests (never use `:latest` or untagged images).
- Set `revisionHistoryLimit` to a reasonable value (default 10 is fine; do not set to 0).
- Annotate every intentional change with `kubernetes.io/change-cause` so history is readable.
- Add a pre-deployment check in CI that verifies the image exists in the registry (`crane` or `skopeo`).
- Consider an admission webhook that rejects Deployments referencing images not present in the approved registry.
EOF
```

You should see: a markdown file with the incident details. In a real team, this would be committed to the runbook repo or attached to the incident ticket.

### 8. Try a different failure mode: CrashLoopBackOff

Reset the Deployment to healthy, then inject a crash.

```bash
# Ensure we're back at a good revision
kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE --to-revision=1
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE

# Inject a crash: override the container command to exit immediately
../../Kubernetes/scripts/inject-failure.sh $DEPLOYMENT $NAMESPACE crash
```

You should see: the script patches the Deployment's container command to `["sh", "-c", "exit 1"]`, creating a new revision. Pods enter `CrashLoopBackOff`.

Diagnose:

```bash
POD=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD -n $NAMESPACE
kubectl logs $POD -n $NAMESPACE --previous
```

You should see: `describe` shows `CrashLoopBackOff` and `Restart Count` incrementing; `logs --previous` shows the container exited with code 1 (no application logs because it crashed before starting).

Roll back and confirm:

```bash
kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE
kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT
```

You should see: rollback completes, pods become Ready again.

### 9. Try a third failure mode: OOMKilled (memory limit)

```bash
# Inject OOM: set memory limit very low
../../Kubernetes/scripts/inject-failure.sh $DEPLOYMENT $NAMESPACE oom
```

You should see: the script sets `memory: 4Mi` limit on the container. The app (nginx) exceeds this immediately and is OOMKilled.

Diagnose:

```bash
POD=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[0].metadata.name}')
kubectl describe pod $POD -n $NAMESPACE | grep -A5 "State:"
```

You should see: `State: Terminated` with `Reason: OOMKilled` and `Exit Code: 137` (SIGKILL).

Roll back:

```bash
kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE
```

### 10. Try a fourth failure mode: readiness probe failure

```bash
# Inject readiness probe failure: change the probe path to one that returns 404
../../Kubernetes/scripts/inject-failure.sh $DEPLOYMENT $NAMESPACE probe
```

You should see: the script changes the readiness probe path from `/ready` to `/nonexistent`. Pods start but never become Ready; the Service does not route traffic to them. The Deployment rolls out but stalls (new ReplicaSet never becomes Available).

Diagnose:

```bash
kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o wide
kubectl describe pod $(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[0].metadata.name}') -n $NAMESPACE | grep -A10 "Readiness"
```

You should see: pods show `Running` but `READY 0/1`; `describe` shows `Readiness probe failed: HTTP probe failed with statuscode: 404`.

Roll back:

```bash
kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE
```

## Exercise

Do the full drill on your own against a fresh cluster:

1. Deploy the sample app (from the production manifest) with a RollingUpdate strategy and `revisionHistoryLimit: 10`.
2. Confirm the Deployment is healthy and note the current revision.
3. Use `inject-failure.sh` to break the Deployment with **one** of: `image-pull`, `crash`, `oom`, or `probe`.
4. Follow the runbook: check events, describe pods, check logs, identify the failure mode.
5. Roll back with `kubectl rollout undo`.
6. Confirm recovery: rollout status, all pods Ready, health endpoints respond.
7. Write a post-incident note with timeline, root cause, action taken, and prevention.
8. Repeat for a different failure mode.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
# Rollback works and reaches success
kubectl rollout undo deployment/web-app -n default
kubectl rollout status deployment/web-app -n default

# All pods Ready after rollback
kubectl get pods -n default -l app=web-app

# Health endpoints respond
kubectl port-forward -n default svc/web-app-service 8080:80 &
PF_PID=$!
sleep 2
curl -sf http://localhost:8080/healthz && curl -sf http://localhost:8080/ready
kill $PF_PID

# Post-incident note exists and has required sections
ls -la incident-*.md
grep -E "Timeline|Root Cause|Action Taken|Prevention" incident-*.md
```

You should see: `rollout undo` + `rollout status` succeed; all pods show `Running` and `Ready`; both health endpoints return 200; at least one incident note file exists with all four required section headers.

## Common mistakes

- `kubectl rollout undo` says "no rollback revision found" → `revisionHistoryLimit` may be 0 or all history cleaned; check `kubectl rollout history` first.
- Rollback completes but app still broken → rolled back to a revision that was also broken; check revision `CHANGE-CAUSE` and test before relying on it.
- `kubectl debug` fails with "forbidden: pods/ephemeralcontainers" → RBAC missing; grant `patch`/`update` on `pods/ephemeralcontainers` via aggregated ClusterRole or dedicated ClusterRoleBinding.
- `ImagePullBackOff` after rollback → image tag was `:latest` or missing; pin exact tags in Deployment and use `imagePullPolicy: IfNotPresent`.
- Forgetting `kubectl logs --previous` for CrashLoopBackOff → the current container is restarting; `--previous` shows the logs from the crashed instance.
- Readiness probe failure looks like a healthy pod (`Running`) but `READY 0/1` → the Service won't send traffic; always check `READY` column, not just `STATUS`.

## Next

[Capstone: ship the sample app end to end](02-capstone.md)