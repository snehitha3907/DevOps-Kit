# GitLab CI/CD — quick primer

> First-day notes for someone who's never used GitLab CI/CD. Personal voice, plain language.

## What is it?

GitLab CI/CD is a built-in CI/CD system inside GitLab — it's what GitHub Actions is to GitHub, but it comes with every GitLab repo by default (no separate tab or marketplace). You define pipelines in a `.gitlab-ci.yml` file at the root of your repo, and GitLab runs them on every push.

## What does it do?

It runs jobs (build, test, deploy) inside isolated environments called runners. You describe the pipeline stages, what commands to run, and what conditions trigger them — all in one YAML file. It shows you the output in the GitLab web UI, marks passed/failed jobs, and can deploy to servers or cloud platforms.

## Why does it exist?

Before GitLab CI/CD, teams used external tools like Jenkins (which needs its own server) or Travis CI (separate subscription). GitLab baked it in so you don't leave the platform. The repo is the source of truth for both code and pipeline config. People use it day-to-day for running tests automatically, linting code, building artifacts, and deploying to staging environments.

## Key terminology

- **Pipeline** — A collection of jobs split into stages (e.g., build → test → deploy). GitLab runs each stage in order unless you say otherwise.
- **Job** — A single unit of work in a pipeline. "Run tests" or "Build Docker image." Has a script, an image, and optional rules.
- **Stage** — A group of jobs that run in parallel within the same stage. Jobs in `test` stage all run at the same time.
- **Runner** — A process that executes jobs. GitLab provides shared runners for free (on gitlab.com), or you install your own on a server or local machine.
- **`.gitlab-ci.yml`** — The pipeline definition file. Lives in the root of the repo. GitLab reads it on every push.
- **Artifact** — Files produced by a job (e.g., compiled binary, test report) that get passed to later stages or downloaded from the UI.
- **CI/CD variable** — A key-value pair (like an env var) you set in the GitLab UI or the file. Used for secrets, API tokens, config.

## A tiny example

```yaml
# .gitlab-ci.yml — minimal pipeline that prints "Hello" and the commit message
stages:
  - greet

hello-job:
  stage: greet
  script:
    - echo "Hello from GitLab CI/CD!"
    - echo "Commit: $CI_COMMIT_MESSAGE"
```

Push this to a GitLab repo and a pipeline runs automatically. The `$CI_COMMIT_MESSAGE` variable is one of many predefined vars GitLab injects.

## What I'll cover next

Install a local runner so I don't rely on shared runners, then write a real pipeline with build and test stages. I also want to understand how `rules:` and `only/except` control job execution.
