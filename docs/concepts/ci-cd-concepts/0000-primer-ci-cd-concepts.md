# CI/CD Concepts — quick primer

> First-day notes on CI/CD. What it is, why it matters, and the key ideas to know.

## What is it?

CI/CD stands for Continuous Integration and Continuous Delivery (or Deployment). It's a set of practices that automate the steps between writing code and getting it running somewhere useful.

Continuous Integration means merging code changes frequently — multiple times a day — and automatically running tests and checks against every merge. The idea is to catch integration problems early instead of discovering them after weeks of isolated work.

Continuous Delivery means every change that passes those automated checks is potentially releasable. You can push a button and deploy to production at any time. Continuous Deployment takes that one step further — every passing change is automatically deployed without human approval.

Think of it like an assembly line for software. Instead of hand-crafting each release, you set up a pipeline that does it consistently, repeatably, and automatically.

## Why does it matter for DevOps?

As a DevOps practitioner, CI/CD is one of the core workflows I'll use every day. It connects the "develop" and "operate" sides of the job — developers push code, and the pipeline automatically builds, tests, and deploys it.

Without CI/CD, deploying software means manual steps: building binaries, copying files, running commands on servers, hoping nothing breaks. With CI/CD, those steps are codified and automated. I can focus on fixing things when they go wrong rather than repeating the same manual process.

CI/CD also gives me confidence. When a pipeline passes all its checks — linting, unit tests, integration tests, security scans — I know the change is safe to deploy. When it fails, I know exactly where and why.

## Key terminology

- **Pipeline** — The automated workflow that takes code from commit to deployment. It's made up of stages and jobs running in sequence or parallel. Example: a pipeline might run tests, then build a container image, then deploy to staging.
- **Stage** — A logical grouping of related jobs in a pipeline. Stages usually run sequentially. Example: `test` stage runs before `build` stage.
- **Job** — A single unit of work within a stage. Jobs within the same stage can run in parallel. Example: running unit tests for two different modules at the same time.
- **Artifact** — A file produced by one job that can be passed to a later job. Example: a compiled binary or a test report that gets uploaded and used in a deployment step.
- **Trigger** — An event that starts a pipeline run. Common triggers are pushing to a branch, opening a PR, or scheduling a time. Example: `on: [push]` in a GitHub Actions workflow triggers on every push.
- **Runner / Agent** — The machine that executes pipeline jobs. It can be hosted (GitHub-hosted runners, GitLab SaaS runners) or self-hosted (my own servers). Example: `ubuntu-latest` is a hosted runner.
- **Environment** — A named deployment target like `staging` or `production`. Pipelines often promote artifacts through environments with approval gates. Example: deploy to staging after tests pass, then manually approve promotion to production.
- **Secret** — A sensitive value like an API key or password that the pipeline needs but shouldn't appear in logs. Example: stored as `MY_AUTH_TOKEN` in the CI/CD platform's secrets manager.
- **Matrix build** — Running the same job with multiple configurations (OS versions, language versions) in parallel. Example: test a Python library against Python 3.10, 3.11, and 3.12 simultaneously.
- **Idempotency** — Running a pipeline step multiple times produces the same result. This is important for reliability — re-running a failed pipeline shouldn't cause side effects.

## A concrete example

Here's a minimal CI pipeline (YAML for GitHub Actions) that runs tests on every push:

```yaml
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install -r requirements.txt
      - run: pytest
```

Every time I push code, this pipeline checks out the repo, sets up Python, installs dependencies, and runs tests. If any step fails, I get a notification immediately instead of finding out later.

## How this connects to what's next

CI/CD concepts are the foundation for tools like GitHub Actions, GitLab CI/CD, and Jenkins. Once I understand what a pipeline, stage, and job are, I can configure any of those platforms. The concepts are the same — only the YAML syntax differs.
