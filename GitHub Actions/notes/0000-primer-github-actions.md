---
last_verified: 2026-07-11
tool_version: n/a
sources:
  - https://dev.to/_d7eb1c1703182e3ce1782/github-actions-complete-guide-build-your-first-cicd-pipeline-in-2026-6m6
  - https://joincloudpros.com/blog/cicd-pipeline-tutorial-beginner
  - https://nexsonitacademy.com/blog/cicd-pipeline-tutorial-beginners
---

# GitHub Actions — quick primer

> First-day notes for someone who's never used GitHub Actions. Personal voice, plain language.

## What is it?

GitHub Actions is GitHub's built-in CI/CD platform. It's like having a runner that listens to events in your repo — pushes, PRs, issue comments — and executes workflows you define in YAML. If you've used Jenkins or GitLab CI/CD, the mental model is similar: event triggers → pipeline steps → output. But Actions lives right inside GitHub, so there's no separate server to run.

## What does it do?

It lets me define automated workflows that run on GitHub's infrastructure. Push code, and it can run tests, build containers, deploy to cloud, or just print "Hello from Actions." Every workflow runs in a fresh VM called a runner, and GitHub hosts the runners for free on public repos.

## Why does it exist?

Before Actions, CI/CD for a GitHub repo meant wiring up a third-party service like Jenkins or Travis CI. You'd configure webhooks, manage tokens, and maintain your own build servers. Actions bakes that into the repo itself — the workflow file lives next to your source code, and the runner infrastructure is managed by GitHub. It lowers the barrier to getting automated tests and deployments running.

## Key terminology

- **Workflow** — The top-level automation. A YAML file in `.github/workflows/`. Has a name, trigger event, and one or more jobs.
- **Job** — A unit of work inside a workflow. Jobs run in parallel by default. Chain them with `needs:` to enforce ordering. Example: `deploy` job waits for `build` to finish.
- **Step** — A single command or action in a job. Steps run sequentially. Example: `run: npm test`.
- **Action** — A reusable packaged automation, published on the Marketplace. Example: `actions/checkout@v4` clones your repo into the runner.
- **Runner** — The VM that executes jobs. GitHub-hosted runners come with Ubuntu, Windows, and macOS images with common tools pre-installed.
- **Event** — What triggers the workflow. Common ones: `push`, `pull_request`, `schedule` (cron), `workflow_dispatch` (manual button).
- **Matrix** — Run a job across multiple OS or version combos. Example: test against Node 18, 20, and 22 on both Ubuntu and Windows.
- **Artifact** — Files produced by a job you can pass to another job or download from the UI. Example: `actions/upload-artifact@v4`.
- **Secret** — Encrypted env var stored at repo or org level. Referenced as `${{ secrets.MY_SECRET }}`. Never put secrets in the YAML directly.
- **Context** — Runtime variables GitHub provides. Example: `${{ github.ref }}` is the branch or tag that triggered the run.

## A tiny example

Create `.github/workflows/ci.yml` in any repo:

```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Say hello
        run: echo "Hello from Actions"
```

Push the file — GitHub detects the workflow, starts a runner, and shows the live logs in the Actions tab. The whole cycle takes about 30 seconds the first time.

## What I'll cover next

I want to set up a real workflow for a Python project with test running and dependency caching, then understand how to scope workflows to specific branches and add manual approval gates. The matrix strategy across Python versions is also on my list to try.
