---
last_verified: 2026-09-04
tool_version: n/a
sources:
  - https://scalr.com/learning-center/building-robust-terraform-opentofu-pipelines-the-ultimate-ci-cd-guide
  - https://reshamchaudhary.com/projects/iac-pipeline
  - https://nerdleveltech.com/infrastructure-as-code-iac-fundamentals-a-complete-2025-guide
  - https://about.gitlab.com/blog/gitlab-as-your-aws-control-plane/
---

# How I wired CI/CD gates into a multi-environment deployment workflow

## Purpose

A CI/CD pipeline without gates between environments is a firehose — code goes straight from a developer's laptop to production with no stops along the way. This document describes a practical approach to inserting automated and manual gates between dev, staging, and production, combining CI/CD pipeline design with infrastructure-as-code (IaC) and containerization to create a controlled promotion flow.

The pattern here is not theoretical. It draws from a real-world stack where Terraform provisions infrastructure, Ansible configures it, Docker packages the application, and GitHub Actions orchestrates the pipeline. The gates enforce linting, security scanning, policy compliance, and human approval before anything touches production.

## When to use

This pattern fits when:

- The team deploys across multiple environments (dev, staging, prod) and needs a controlled promotion path between them.
- Infrastructure changes and application deployments are both managed through code (IaC + CI/CD).
- Regulatory or organizational policy requires audit trails for every deployment decision.
- The team wants automated promotion for dev/staging but manual approval gates before production.

This is overkill for single-environment setups or teams that handle promotion manually through ad-hoc commands.

## The workflow I built

### 1. CI runs a tiered testing pipeline on every PR

Before anything gets merged, the pipeline executes a sequence of increasingly expensive checks:

```yaml
# Simplified GitHub Actions CI stages
stages:
  - lint        # terraform fmt, shellcheck, hadolint
  - security    # trivy filesystem scan, tfsec
  - policy      # conftest test against OPA policies
  - plan        # terraform plan, docker build local test
  - review      # post terraform plan diff as PR comment
```

Each stage is a gate. If lint fails, security never runs. If policy fails, the plan never posts. The developer sees a single pass/fail status on the PR, not a wall of raw output.

The plan step posts the terraform diff as a PR comment so humans can review what infrastructure will change before approving the merge.

### 2. Merge to main triggers dev deployment automatically

When the PR merges, the pipeline moves to the CD phase. Dev is the first target, and it deploys without human approval:

```
merge to main → terraform apply (dev) → ansible provisioning → docker deploy → health check → done
```

Dev is the playground. If something breaks here, it is cheap to fix and affects no one outside the team.

### 3. Staging gates on automated checks

After dev is healthy, the pipeline promotes the same artifact (same Docker SHA) to staging. Staging adds gates:

- **Smoke tests** — hit the staging endpoints and verify responses match expected values.
- **Load test gate** — a short burst load test checks that latency stays within baseline.
- **Policy compliance** — OPA/Conftest re-validates the staging state against security policies (no public S3 buckets, encryption enabled, tagging requirements).

If all pass, staging is marked as validated and the artifact is eligible for production promotion.

### 4. Production gates on human approval

Production is the one environment where automation pauses. The pipeline:

1. Creates a deployment request (a GitHub issue or a manual approval gate in the CI system).
2. Posts the terraform plan diff and staging validation results for reviewer context.
3. Waits for an explicit approval from a designated reviewer.
4. On approval, runs `terraform apply` with the saved plan, followed by Ansible post-provisioning.
5. Runs a canary health check — a subset of traffic hits the new version for a configurable window before full rollout.

The key insight: production promotion is a two-step process. The plan runs automatically and posts its diff; the apply waits for a human to click approve.

### 5. Drift detection closes the loop

After all environments are deployed, a nightly scheduled pipeline runs `terraform plan` against production and compares the output against the declared state. If drift is detected (someone manually changed a security group, for example), it triggers an alert. The decision tree is:

- **Intentional change** — import it into IaC so it is tracked.
- **Accidental change** — revert the manual modification.
- **Drift from another automation** — reconcile the conflicting systems.

## Putting it together

The full workflow looks like this in practice:

```
PR opened
  → lint → security → policy → plan → PR comment
PR merged to main
  → terraform apply dev → ansible configure dev → deploy dev → health check
  → promote to staging → smoke test → load test → policy recheck
  → create production deployment request → wait for approval
  → terraform apply prod → ansible configure prod → canary deploy → full rollout
nightly
  → terraform plan prod → drift alert if non-empty diff
```

Each arrow is a gate. Each gate has a clear pass/fail criterion. If any gate fails, the pipeline stops and the team investigates before retrying.

## Verify

After implementing this workflow, verify:

- A PR that introduces a non-compliant resource (e.g., unencrypted S3 bucket) is blocked at the policy gate before merge.
- Dev deploys automatically on merge without manual intervention.
- Staging requires all automated gates to pass before the artifact is promoted.
- Production deployment does not proceed without explicit human approval.
- The nightly drift detection fires an alert when a manual change is made to production resources.

What tripped me up the first time was skipping the plan diff review. Posting the terraform plan as a PR comment is cheap and catches most infrastructure mistakes before they reach any environment. I also learned the hard way that promoting different artifacts (rebuilding per environment) produces different binaries and invalidates all prior testing — always promote the same Docker image tag.

Another gotcha: asking someone to approve a production deployment without showing them what will change leads to rubber-stamping. I always include the plan diff and staging validation results in the approval request. And without drift detection, manual changes to production accumulate silently until the next deploy fails with a confusing conflict.
