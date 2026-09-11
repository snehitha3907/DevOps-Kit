---
last_verified: 2026-09-11
tool_version: n/a
sources:
  - https://docs.github.com/en/actions/using-workflows/reusing-workflows
  - https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
---

# Composite actions vs reusable workflows: choosing the right pattern

## Purpose

GitHub Actions gives you two ways to share CI/CD logic across repositories: composite actions and reusable workflows. Both let you stop copy-pasting the same steps into every `.github/workflows/*.yml`, but they solve different problems. This document explains when to reach for each and how to wire them up.

## When to use

Use a **composite action** when you want to package a set of steps that you can call from any workflow in any repo, but you still want the caller to control the surrounding job structure — environment variables, triggers, run-name, and what happens after the steps finish. Composite actions are the right granularity when the shared logic is a single job's worth of work and you want the owning repo to stay in charge of orchestration.

Use a **reusable workflow** when you want to hand off an entire job (or an entire pipeline) to another repository and let that repository own the triggers, the environment, and the matrix strategy. The caller just dispatches the workflow with `uses: owner/repo/.github/workflows/file.yml@ref` and optionally passes inputs and secrets. Reusable workflows are the right granularity when you want a fully self-contained, centrally governed pipeline that every team consumes the same way.

In practice, most teams start with composite actions for small shared steps (lint, build, deploy-to-staging) and graduate to reusable workflows when they need a whole environment pipeline (deploy-to-production with approvals, region matrices, and rollback) governed by a platform team.

## Prerequisites

- A GitHub repository with a workflow file you want to refactor.
- For reusable workflows: the calling repo must be in the same GitHub Enterprise Cloud instance (or GitHub.com), and the workflow file must live in `.github/workflows/` of the repository that owns it.
- `actions/checkout@v4` for any workflow that needs the repository contents.

## Steps

### 1. Extract a composite action

Create `./actions/lint-and-test/action.yml`:

```yaml
name: Lint and test
description: Run the linter and the test suite for the current repo.
inputs:
  python-version:
    description: Python version to use
    required: false
    default: '3.12'
runs:
  using: composite
  steps:
    - uses: actions/checkout@v4
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: ${{ inputs.python-version }}
    - name: Install
      run: python -m pip install -e .[test]
    - name: Lint
      run: ruff check .
    - name: Test
      run: pytest -q
```

Call it from any workflow:

```yaml
name: CI
on:
  push:
    branches: [main]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/lint-and-test@v1
        with:
          python-version: '3.11'
```

### 2. Extract a reusable workflow

Create `.github/workflows/deploy-staging.yml` in a repository the platform team owns:

```yaml
name: Deploy to staging
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      deploy-token:
        required: true
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: ./scripts/deploy.sh
        env:
          DEPLOY_TOKEN: ${{ secrets.deploy-token }}
```

Call it from a team repo:

```yaml
name: Release
on:
  pull_request:
    branches: [main]
jobs:
  deploy:
    uses: platform-team/ci-cd/.github/workflows/deploy-staging.yml@main
    with:
      environment: staging
    secrets:
      deploy-token: ${{ secrets.DEPLOY_TOKEN }}
```

### 3. Decide which to use

Ask three questions:

1. Does the caller need to add steps before or after the shared logic? If yes, use composite — the caller keeps the job and can interleave steps.
2. Does the shared logic need its own triggers, environment, or matrix? If yes, use reusable — only a reusable workflow can declare its own `on:` and `environment:`.
3. Is the shared logic a single job, or a multi-job pipeline? A single job points at composite; a pipeline points at reusable.

## Verify

- A composite action's `action.yml` is valid: `using: composite` is present, `runs.steps` is a list, and every `uses:` references an action that resolves.
- A reusable workflow's `on:` contains only `workflow_call` (and optionally `workflow_dispatch`), and the caller's `uses:` points at `owner/repo/.github/workflows/<file>.yml@<ref>`.
- Inputs and secrets flow through: add `echo` logging at the top of the shared file and confirm the values appear in the run log.
- The shared file is exercised by at least one real workflow run before you rely on it.

## Common errors

- Calling a reusable workflow with `uses:` inside a `steps:` block — reusable workflows are jobs, not steps. Put them under a `job.uses:` instead.
- Forgetting `using: composite` in `action.yml` — without it, GitHub treats the file as a JavaScript action and the YAML steps are ignored.
- Passing an input that the reusable workflow does not declare — the value is silently dropped, which makes the failure hard to spot. Check the `workflow_call.inputs` table.
- Referencing a secret in a reusable workflow without declaring it in `workflow_call.secrets:` — the call fails at dispatch time.

## References

- [Reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)