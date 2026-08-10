---
last_verified: 2026-08-10
tool_version: n/a
sources:
  - https://semaphore.io/blog/how-to-integrate-ci-cd-with-gitops-tools-like-argo-cd-or-flux
  - https://oneuptime.com/blog/post/2026-02-26-argocd-best-practices-cicd-integration/view
  - https://josenobile.co/guides/gitops-argocd/
  - https://oneuptime.com/blog/post/2026-02-09/deployment-gates-prometheus-cicd/view
  - https://pkhamdee.blog/2026/05/19/devops-project-example-from-code-push-to-production-with-gitops-fluxcd-and-kubernetes/
  - https://zeonedge.com/blog/cicd-pipeline-design-patterns-2026-advanced-deployment-strategies
  - https://www.digitalapplied.com/blog/ci-cd-pipeline-design-2026-engineering-reference
  - https://scalr.com/learning-center/building-terraform-opentofu-pipelines-the-ultimate-ci-cd-guide
---

# Combining CI/CD concepts with artifact promotion and environment-based rollbacks

## Purpose

This document explains how CI/CD pipelines promote a single immutable artifact through multiple environments (development, staging, production) using metric-based gates, and how to implement environment-aware rollback when a gate fails. The goal is to replace naive rebuild-per-stage workflows with a promotion model that preserves artifact integrity and provides reliable recovery paths.

## When to use

Use this pattern when:
- A team needs to guarantee that the exact binary or container image tested in staging is the same one running in production.
- Deployment decisions should be driven by real metrics (error rate, latency, throughput) rather than time-based schedules.
- Rollback must be reproducible without manual debugging or ad-hoc fixes.
- The pipeline needs to satisfy audit requirements that every promotion is logged, reviewed, and reversible.

This is not appropriate for trivial single-environment deployments where rebuilds are cheap and rollback is handled manually by redeploying a previous commit.

## Prerequisites

- A container registry or artifact repository that supports immutable tags (e.g., SHA digests).
- A metrics backend such as Prometheus that exposes application health data.
- A GitOps controller (ArgoCD, Flux) or a Kubernetes cluster with `kubectl` access for reconciliation.
- Separate environment overlays or namespaces (dev, staging, prod) so promotion targets do not overlap.

## Steps

### 1. Build the artifact once

The pipeline builds a single artifact per commit and tags it with an immutable identifier such as the Git SHA.

```bash
# Example build step
docker build -t myapp:sha-abc123 .
docker push registry.example.com/myapp:sha-abc123
```

The same tag is reused through every subsequent stage. Rebuilding introduces drift, so promotion reuses the existing artifact.

### 2. Define promotion gates

Before an artifact moves from one environment to the next, the pipeline queries real metrics. Common gates include:

- **Error rate comparison** — compare canary 5xx error rate against the stable baseline.
- **P99 latency comparison** — ensure the canary P99 does not exceed the stable P99 by more than a defined factor.
- **Throughput comparison** — verify that request throughput does not drop significantly.

Each gate returns a boolean pass/fail. If any gate fails, promotion stops and rollback begins.

### 3. Update the deployment target

When all gates pass, the pipeline updates the target environment's configuration. In a GitOps workflow, this means committing a changed image tag to the configuration repository.

```bash
# Kustomize-based image update
kustomize edit set image myapp=registry.example.com/myapp:sha-abc123
git commit -am "promote sha-abc123 to staging"
git push origin main
```

The GitOps controller detects the commit and reconciles the cluster state. The pipeline does not call `kubectl apply` directly.

### 4. Handle rollback on gate failure

If a gate fails after promotion, the pipeline should revert the deployment to the last known good state.

- **GitOps revert** — revert the image-tag commit in the configuration repository. The controller reconciles back to the previous tag automatically.
- **Rollout undo** — for non-GitOps clusters, use `kubectl rollout undo` to restore the previous ReplicaSet.
- **Argo Rollouts abort** — for progressive delivery, `kubectl argo rollouts abort` stops traffic shifting and scales the stable variant back to full traffic.

## Verify

After promotion, verify the following:
- The target environment reports the correct artifact tag or digest.
- Health endpoints return 200 OK and readiness probes pass.
- Metric dashboards show stable error rates and latency within baseline thresholds.
- The Git history contains the promotion commit and, if applicable, the rollback revert.

After rollback, verify that the previous stable version is serving traffic and that the failed artifact is no longer receiving requests.

## Common errors

- **Rebuilding per environment** — rebuilding the artifact at each stage produces different binaries and invalidates test results. Always promote the same tagged artifact.
- **Mutable tags** — using `latest` or floating tags makes it impossible to reproduce a failed deployment. Pin to SHA digests or immutable semantic versions.
- **Skipping health waits** — a successful sync does not mean the deployment is healthy. Wait for readiness probes and stable metrics before declaring promotion complete.
- **Direct cluster credentials for CI** — giving CI full cluster access bypasses GitOps audit trails. Scope CI to write access on the configuration repository only.

## References

- Semaphore — How to integrate CI/CD with GitOps tools like Argo CD or Flux
- OneUptime — ArgoCD best practices for CI/CD integration
- JoseNobile — GitOps with ArgoCD: a complete guide
- OneUptime — Deployment gates with Prometheus in CI/CD
- pkhamdee — DevOps project example: code push to production with GitOps, FluxCD, and Kubernetes
- zeonedge — CI/CD pipeline design patterns 2026: advanced deployment strategies
- DigitalApplied — CI/CD pipeline design 2026: an engineering reference
- Scalr — Building Terraform/OpenTofu pipelines: the ultimate CI/CD guide
