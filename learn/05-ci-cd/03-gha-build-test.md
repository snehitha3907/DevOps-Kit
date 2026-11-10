---
last_verified: 2026-11-10
tool_version: "actions/checkout v7.0.1 · actions/setup-node v7.1.0"
sources:
  - https://docs.github.com/en/actions/get-started/quickstart
  - https://docs.github.com/en/actions/tutorials/build-and-test-code/nodejs
  - https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#pull_request
  - https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository
  - https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks
---

# Build and test the sample app on every pull request

In [GitHub Actions — quick primer](../../GitHub Actions/notes/0000-primer-github-actions.md) you saw how a workflow is triggered and what jobs and steps are. Now you'll wire that into the sample app: every pull request runs the test suite, and GitHub blocks merging until the check passes. This is the gate that keeps a broken change out of `main`.

## What you'll learn

- Write a workflow that runs the app's tests on each pull request
- Require the workflow to pass before a PR can merge

## Before you start

- [GitHub Actions — quick primer](../../GitHub Actions/notes/0000-primer-github-actions.md) — workflows, jobs, steps, runners, and the `actions/checkout` action you'll reuse here.
- [CI/CD concepts](../../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md) — what a pipeline, job, trigger, and runner are; this lesson applies them in GitHub Actions.
- [Pull requests and branch protection on GitHub](../03-version-control/06-github-pr-flow.md) — how to open a PR and protect `main`, which you'll extend with a required status check.
- [Run the app and Postgres with Docker Compose](../04-containers/05-compose-app-db.md) — the sample app and its `npm test` command that this workflow will run.
- Node.js and npm installed. Confirm with `node --version` and `npm --version`.
- A GitHub repository for the sample app with `npm test` passing locally.

## Walkthrough

1. Create the workflow file. Save it as `.github/workflows/ci.yml` in your sample app repo:

   ```yaml
   name: CI
   on:
     pull_request:
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v7.0.1
         - uses: actions/setup-node@v7.1.0
           with:
             node-version: "20"
             cache: "npm"
         - run: npm ci
         - run: npm test
   ```

   You should see: a workflow named `CI` that triggers on `pull_request`, checks out the repo, sets up Node.js with npm dependency caching, installs exact lockfile versions, and runs the test suite.

   The `on: pull_request` trigger runs by default on `opened`, `synchronize`, and `reopened`, so the check fires whenever a PR is created or updated. `npm ci` installs from `package-lock.json`, so every run uses the exact same dependency versions.

2. Push the workflow file and open a pull request.

   ```bash
   git add .github/workflows/ci.yml
   git commit -m "add CI workflow that tests on pull requests"
   git checkout -b ci-build-test
   git push -u origin ci-build-test
   ```

   Then open a pull request against `main` on GitHub.

   You should see: GitHub starts a workflow run for the PR, and the Actions tab shows the `test` job running. The run creates a status check named after the job (`test`) on the PR.

3. Require the check before merging. On GitHub, go to Settings → Rulesets → New branch ruleset. Target `main`, then under Branch protections enable "Require status checks before merging" and add the `test` check. Create the ruleset.

   You should see: the ruleset is active. Direct pushes to `main` are blocked, and a PR cannot merge until the `test` check reports success on the latest commit.

   Required status checks only work when the workflow is triggered by an eligible event such as `pull_request` — which is why this workflow uses `pull_request`, not `workflow_dispatch`.

## Exercise

In your own repository:

1. Add the `CI` workflow from the walkthrough to `.github/workflows/ci.yml` (or adapt it for your app's test command).
2. Push it on a feature branch and open a pull request to `main`.
3. Confirm the `test` status check appears on the PR and passes.
4. Add a branch ruleset on `main` that requires the `test` status check before merging.
5. Try merging the PR while the check is failing — confirm GitHub blocks the merge.

## Check your work

On the pull request page in GitHub:

```text
test — required — successful
```

You should see: the `test` status check is listed as required, its state is green/successful on the latest commit, and the merge button is enabled only because the required check passed.

If the check is missing or pending, confirm the workflow file lives in `.github/workflows/` (not a nested folder) and that the PR triggered a `pull_request` run — `workflow_dispatch` runs do not satisfy branch protection.

## Common mistakes

- Putting the workflow outside `.github/workflows/` — GitHub will never discover or run it.
- Using `on: [push]` without `pull_request` — the check won't run on PRs, so it can't gate merges.
- Skipping `cache: "npm"` on `setup-node` — not incorrect, but each run reinstalls dependencies from scratch, making the check slower.
- Requiring a workflow that can be skipped by path or branch filters — a skipped check stays "Pending" and blocks merging, so keep the `pull_request` trigger unfiltered at this stage.

## Next

[Scan and publish the image from CI](../../00_index/learning-path.md)