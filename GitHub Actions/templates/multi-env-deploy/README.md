---
last_verified: 2026-10-03
tool_version: n/a
---

# Multi-environment deploy template

> A caller + reusable-workflow pair that builds once and promotes the same artifact through dev, staging, and production.

## Purpose

Ship one build artifact to three environments without copy-pasting the deploy steps per environment. The caller (`deploy-caller.yml`) builds once and calls the reusable workflow (`reusable-deploy.yml`) once per environment, chained with `needs` so staging only runs after dev succeeds and production only runs after staging succeeds.

## When to use

Use this scaffold when every environment deploys the same way and only the target name, credentials, and approval gate differ. It is the minimal promotion-chain shape: build, artifact handoff, per-environment deploy, health check. When the deploy needs Terraform plan review, canary rollouts, or drift detection instead, use the heavier single-file variant in `../../configs/reusable-deployment-workflow-environment-gates-approval.yaml`.

## Prerequisites

- Three GitHub Environments named `dev`, `staging`, and `production` (repository Settings, Environments page).
- A required reviewer configured on `production` so the final call pauses for manual approval.
- One deploy secret per environment (`DEPLOY_TOKEN_DEV`, `DEPLOY_TOKEN_STAGING`, `DEPLOY_TOKEN_PROD`); environment-scoped secrets with the same name also work and keep the caller simpler.

## Steps

1. Copy `deploy-caller.yml` to `.github/workflows/deploy.yml` and `reusable-deploy.yml` to `.github/workflows/reusable-deploy.yml` in the application repository.
2. Replace the placeholder deploy and health-check commands in the reusable workflow with the real ones for the stack.
3. Set the per-environment secrets listed above.
4. Push to `main`: build runs once, then dev, staging, and production deploy in order with the same artifact name and image tag.
5. To deploy a single environment on demand, run the workflow manually and pass `dev`, `staging`, or `production` in the `environment` input; an empty input runs the full chain. The `always()` guards on the staging and production calls let a single-environment run proceed even though the earlier chain jobs were skipped — the result checks still enforce the promotion order on full runs.

## Verify

- The Actions run graph shows `Build` green, then `Deploy dev`, `Deploy staging`, `Deploy production` in sequence.
- The `production` job waits on the reviewer before starting; approving it lets the run finish.
- Each deploy job's step summary reports the environment name, tag, and artifact name, so a mismatch (e.g. staging deploying a different tag than dev) is visible without opening logs.

## Rollback

Re-run the caller from the previous good commit: the reusable workflow deploys whatever tag it is given, so promoting the last known-good SHA through the same chain restores all three environments without editing any file.

## Common errors

- **Reusable workflow not found.** The `uses: ./.github/workflows/reusable-deploy.yml` path is relative to the repository root; the call fails if the file was copied to a different directory.
- **Production deploys without approval.** The pause comes from the `production` Environment's required reviewers, not from the YAML; a missing reviewer rule means the job runs straight through.
- **Artifact expired.** The caller keeps the build artifact for 7 days; re-running an older run after expiry fails at the download step and needs a fresh build.

## References

- `../../configs/reusable-deployment-workflow-environment-gates-approval.yaml` — heavier called-workflow variant with Terraform plan, canary, and drift detection.
- `../../docs/composite-actions-vs-reusable-workflows.md` — when to use a reusable workflow versus a composite action.
