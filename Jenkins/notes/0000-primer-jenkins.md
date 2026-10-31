---
last_verified: 2026-10-20
tool_version: "n/a"
sources:
  - https://www.jenkins.io/doc/
---

# Jenkins — quick primer

> First-day notes for someone who's never used Jenkins. Personal voice, plain language.

## What is it?

Jenkins is an open-source automation server that helps you build, test, and deploy software. Think of it as a robot that runs commands for you on a schedule or when something changes in your code repository. It's been around since 2011 (originally Hudson) and is one of the most widely used CI/CD tools out there. If GitHub Actions is the modern cloud-native choice and GitLab CI is the integrated option, Jenkins is the self-hosted workhorse that runs on your own infrastructure — VMs, bare metal, Kubernetes, wherever.

## What does it do?

At its core, Jenkins runs **jobs** (also called **pipelines**). A job is a sequence of steps: check out code, run tests, build an artifact, push to a registry, deploy to a server. You define these steps in a `Jenkinsfile` (declarative pipeline syntax) or through the web UI (freestyle jobs). Jenkins connects to your Git repo (GitHub, GitLab, Bitbucket), watches for changes, and triggers builds automatically. It has a massive plugin ecosystem — over 1,800 plugins — so it can talk to basically anything: Docker, Kubernetes, AWS, Azure, Slack, Jira, you name it.

## Why does it exist?

Before Jenkins (and its predecessor Hudson), people ran build scripts manually or with cron jobs. That meant "works on my machine" problems, no central history, no visibility into what broke when. Jenkins gave teams a central place to see every build, every test result, every deploy — with logs, timestamps, and artifacts all in one UI. It became the default choice for on-prem CI/CD because it runs anywhere Java runs, and the plugin model let it adapt to whatever stack a team used. Today it's still the go-to when you need full control over your build infrastructure, complex pipeline logic, or integration with legacy systems that cloud CI services don't support.

## Key terminology

- **Controller** (formerly Master) — the main Jenkins process that schedules builds, serves the UI, and stores configuration. Example: the server you log into at `http://jenkins:8080`.
- **Agent** (formerly Slave) — a machine or container that actually runs the build steps. The controller hands off work to agents. Example: a Docker container spun up on-demand to run `mvn test`.
- **Pipeline** — the definition of your CI/CD workflow, written as code in a `Jenkinsfile`. Example: a declarative pipeline with `stages` for Build, Test, Deploy.
- **Stage** — a logical grouping of steps in a pipeline (e.g., "Build", "Test"). Example: `stage('Test') { steps { sh 'pytest' } }`.
- **Step** — a single command or action inside a stage. Example: `sh 'docker build -t myapp .'`.
- **Plugin** — an extension that adds functionality (SCM integration, cloud providers, notifications). Example: "GitHub Branch Source" plugin auto-discovers PRs and branches.
- **Executor** — a slot on an agent that can run one build at a time. An agent with 4 executors runs 4 builds in parallel.
- **Workspace** — the directory on an agent where the repository is checked out and the build runs. Example: `/var/jenkins/workspace/my-job`.
- **Blue Ocean** — a modern, visual UI for pipelines (built-in since Jenkins 2.0). Example: instead of the classic console log, you see a flowchart of stages with green/red status.
- **Credential** — secrets stored securely in Jenkins (API tokens, SSH keys, passwords) and injected into builds. Example: a Docker Hub token used in `withCredentials` block.

## A tiny example

```groovy
// Jenkinsfile — declarative pipeline
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'echo "Building..."'
                sh 'make build'
            }
        }
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
    }
}
```

This pipeline runs on any available agent, checks out the repo (implicit), runs `make build` then `make test`. Save as `Jenkinsfile` in your repo root, create a "Pipeline" job in Jenkins pointing at the repo, and it builds on every push.

## What I'll cover next

I want to try running Jenkins locally with Docker, create my first declarative pipeline, and explore the Blue Ocean UI. Then I'll look at how to use agents (Docker, Kubernetes) so builds don't run on the controller itself. After that, credential management and plugin configuration for real-world integrations.