---
last_verified: 2026-09-03
tool_version: n/a
sources:
  - https://en.wikipedia.org/wiki/Infrastructure_as_code
  - https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac
---

# Version control and IaC: managing Terraform modules and environment promotion with Git branching

> How Git branching turns Terraform modules into a controlled, promotable asset across staging and production.

## What I set out to figure out

I already treat infrastructure as code, but I was missing a clean answer for how to version Terraform modules and move changes through environments without rebuilding or hand-editing state. Version control is listed as a key IaC practice, but the exact branching model for module promotion was not obvious from the docs alone. This note is the pattern I have settled on after a few iterations.

## The two concepts at play

This pattern combines **Version Control Concepts** (branches, tags, and merge flows) with **Infrastructure as Code Concepts** (modules, state, and plan/apply cycles). Version control supplies the isolation and audit trail; IaC supplies the reproducible artifacts. Without the version control layer, IaC changes are just commits on a flat line — any change to a module lands in every environment at once. Without the IaC layer, branches are just text files with no plan/apply verification.

## A branching model that has worked for me

I keep a `main` branch that holds the production-approved module versions. Each environment gets its own long-lived branch: `staging`, `production`. When I need to update a module:

1. I create a feature branch from `staging` (for example, `feat/update-vpc-cidr`).
2. I bump the module version or source reference inside that branch and run a plan against the staging workspace.
3. If the plan is clean, I merge the feature branch into `staging` and apply there.
4. After staging validation, I merge `staging` into `production` and apply against the production workspace.

The key invariant is that the same commit SHA moves through both environments. I never rebuild the module between staging and production; I promote the commit.

## Where the responsibilities split

| Concern | Git branch | Terraform module |
|---|---|---|
| Version isolation | yes | no |
| Change audit | yes | no |
| Resource definition | no | yes |
| State management | no | yes |
| Plan/apply validation | no | yes |
| Environment promotion | yes (merge) | no (apply) |

## Steps that have worked for me

1. Create the module in a dedicated directory with a semantic version tag.
2. Use branch protection on `main` so that merges require passing plans or CI checks.
3. Open a feature branch for every module change; merge only after a clean plan in the target environment's workspace.
4. Tag releases in `main` with the module version; downstream environments reference the tag, not a moving branch.
5. Roll back by reverting the merge commit or pinning the previous tag in the downstream branch.

## Verify

- `git log --oneline --graph --all` shows the feature branch merging cleanly into `staging`, then `staging` into `production` — no rebased history that would obscure the promotion path.
- State in each workspace references the same module source version after promotion.
- A plan run immediately after promotion reports no changes, confirming the module is pinned and the state is consistent.

## Where I have gotten it wrong

- Rebasing the feature branch after it was already merged into staging. The rebased SHA does not exist in `production`, so the merge became a conflict nightmare.
- Letting `main` drift from `staging` for weeks. When the merge finally happened, the plan diff was huge and hard to review.
- Using `latest` as the module source in production. A new module build invalidated the staging validation because the artifact had changed.

## What I'd try next

Wire this into a CI pipeline where the merge into `staging` runs a plan automatically and stores the plan artifact, then the merge into `production` re-applies that same artifact. The Git history becomes the promotion record; the IaC workflow becomes the enforcement layer.

## References

- Wikipedia, "Infrastructure as code."
- Red Hat, "What is infrastructure as code (IaC)?"
