---
last_verified: 2026-08-10
tool_version: n/a
sources:
  - https://semaphore.io/blog/how-to-integrate-ci-cd-with-gitops-tools-like-argo-cd-or-flux
  - https://oneuptime.com/blog/post/2026-02-26-argocd-best-practices-cicd-integration/view
  - https://josenobile.co/guides/gitops-argocd/
  - https://oneuptime.com/blog/post/2026-02-09/deployment-gates-prometheus-cicd/view
  - https://developer.harness.io/docs/continuous-delivery/gitops/argo-rollouts/argo-rollouts-with-cv/
---

# Combining CI/CD with artifact promotion gates and environment-based rollbacks

> L2 concept exercise — exploring how CI/CD pipelines promote artifacts through environments with automated gates and rollback logic.

## What I'm practicing

The research on CI/CD Concepts (L3) highlighted several integration patterns that I want to understand at a hands-on level:
- Build-once, promote-everywhere: one artifact per commit, tagged with Git SHA, promoted through dev → staging → prod without rebuilding
- Deployment gates that query Prometheus metrics before allowing promotion (error rate, P99 latency, throughput comparisons)
- Automatic rollback when gates fail (e.g., `kubectl rollout undo` or Argo Rollouts abort)
- GitOps separation: CI only writes to Git (image tag updates), GitOps controller reconciles the cluster

This doc captures my notes as I work through these patterns conceptually.

## The artifact promotion model

Traditional CI/CD often rebuilds at each stage. The promotion model is different:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Build     │────▶│  Staging    │────▶│     Prod    │
│  (artifact) │     │  (promote)  │     │  (promote)  │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
  tag: sha-abc123    tag: sha-abc123      tag: sha-abc123
  (immutable)        (same artifact)      (same artifact)
```

The artifact (container image, binary, tarball) is built **once** at the first stage. Its digest (SHA256) becomes the immutable identifier. Every downstream stage pulls that exact artifact — no rebuild, no drift.

## Promotion gates with monitoring

Before promoting to the next environment, the pipeline queries real metrics. This is where CI/CD meets observability.

### Canary error rate gate

```promql
# Compare canary vs stable error rates over 5 minutes
sum(rate(http_requests_total{version="canary",status=~"5.."}[5m]))
/
sum(rate(http_requests_total{version="canary"}[5m]))

# vs

sum(rate(http_requests_total{version="stable",status=~"5.."}[5m]))
/
sum(rate(http_requests_total{version="stable"}[5m]))
```

If canary error rate > stable error rate + threshold (e.g., 0.05), **block promotion** and **trigger rollback**.

### P99 latency gate

```promql
# Canary P99 latency
histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket{version="canary"}[5m])) by (le))

# Stable P99 latency
histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket{version="stable"}[5m])) by (le))
```

If canary P99 > stable P99 * 1.5, **block promotion**.

### Throughput gate

```promql
# Requests per second comparison
sum(rate(http_requests_total{version="canary"}[5m]))
/
sum(rate(http_requests_total{version="stable"}[5m]))
```

If canary throughput drops > 20% below stable, **investigate before promoting**.

## Environment-based rollback patterns

When a gate fails, the pipeline needs a reliable rollback path. Three patterns I'm learning:

### 1. GitOps tag revert (cleanest for GitOps)

```bash
# CI pipeline detects gate failure
# Reverts the image tag update in the GitOps config repo
git revert <commit-that-updated-image-tag>
git push origin main

# GitOps controller (ArgoCD/Flux) sees the revert
# Reconciles cluster back to previous image
```

**Why this works:** The GitOps controller is always watching the config repo. A revert is just another commit — the controller applies it like any other change. Full audit trail in Git.

### 2. Kubernetes rollout undo (direct cluster action)

```bash
# Pipeline has cluster credentials (scoped to namespace)
kubectl rollout undo deployment/my-app -n staging

# Or for a specific revision
kubectl rollout undo deployment/my-app --to-revision=3 -n staging
```

**When to use:** Non-GitOps deployments, or emergency rollback when GitOps sync is too slow.

### 3. Argo Rollouts abort (progressive delivery)

```bash
# If using Argo Rollouts for canary
kubectl argo rollouts abort rollout/my-app -n prod

# The rollout controller:
# - Stops traffic shifting
# - Scales down canary pods
# - Scales up stable pods to 100%
```

**Advantage:** Handles the traffic shift automatically. No manual `kubectl` scaling needed.

## Putting it together: a mental model

```
Pipeline Run (commit sha-abc123)
│
├─▶ Build stage
│   ├─ Build container image: myapp:sha-abc123
│   ├─ Scan with Trivy (gate: no CRITICAL CVEs)
│   ├─ Sign with cosign (gate: signature verified)
│   └─ Push to registry
│
├─▶ Dev deploy (auto-promote)
│   └─ Update GitOps repo: dev/image-tag = sha-abc123
│
├─▶ Staging gate (Prometheus queries)
│   ├─ Wait for dev deployment healthy (5 min)
│   ├─ Query error rate, latency, throughput
│   ├─ If ALL pass: update GitOps repo: staging/image-tag = sha-abc123
│   └─ If ANY fail: alert, stop, NO promotion
│
└─▶ Prod gate (manual approval + Prometheus)
    ├─ Manual approval required (human gate)
    ├─ Query same metrics in staging
    ├─ If pass: update GitOps repo: prod/image-tag = sha-abc123
    └─ If fail: rollback staging (kubectl rollout undo or GitOps revert)
```

## Key insight: CI doesn't deploy

The biggest mental shift from traditional CI/CD: **CI never calls `kubectl apply` or `helm upgrade` directly.**

Instead:
1. CI builds and validates the artifact
2. CI updates a **GitOps configuration repository** (changes an image tag in a Kustomize overlay, Helm values file, or ArgoCD Application)
3. The **GitOps controller** (ArgoCD, Flux) detects the Git change
4. The controller **reconciles** the cluster to match the desired state in Git

This separation means:
- **Immutable audit trail**: Every deployment is a Git commit
- **No drift**: Cluster state always matches Git (eventually)
- **Rollback = git revert**: No special rollback logic needed
- **Least privilege**: CI only needs write access to config repo, not cluster admin

## What I'll explore next

- Writing a small script that simulates a promotion gate querying a mock Prometheus endpoint
- Practicing the GitOps revert pattern with a local Git repo and kustomize
- Looking at how Terraform plan/apply gates fit into this same model (separate plan artifact, approval gate, then apply)

---

*These notes are my L2 practice — working through the concepts by writing them out. The patterns come from the CI/CD Concepts L3 research cycle (2026-08-08).*