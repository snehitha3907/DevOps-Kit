---
last_verified: 2026-10-27
tool_version: n/a
sources: ---
# Jenkins — install and run my first CLI command

## What is it?

I just started looking into Jenkins, an open-source automation server that helps you build, test, and deploy software. Think of it as a robot that runs commands for you on a schedule or when something changes in your code repository. It's been around since 2011 (originally Hudson) and is one of the most widely used CI/CD tools out there. If GitHub Actions is the modern cloud-native choice and GitLab CI is the integrated option, Jenkins is the self-hosted workhorse that runs on your own infrastructure — VMs, bare metal, Kubernetes, wherever.

## What does it do?

Jenkins runs jobs (also called pipelines). A job is a sequence of steps: check out code, run tests, build an artifact, push to a registry, deploy to a server. You define these steps in a Jenkinsfile (declarative pipeline syntax) or through the web UI (freestyle jobs). Jenkins connects to your Git repo (GitHub, GitLab, Bitbucket), watches for changes, and triggers builds automatically. It has a massive plugin ecosystem — over 1,800 plugins — so it can talk to basically anything: Docker, Kubernetes, AWS, Azure, Slack, Jira, you name it. I ran the Docker image locally and it started up on port 8080.

## Why does it exist?

Before Jenkins (and its predecessor Hudson), people ran build scripts manually or with cron jobs. That meant "works on my machine" problems, no central history, no visibility into what broke when. Jenkins gave teams a central place to see every build, every test result, every deploy — with logs, timestamps, and artifacts all in one UI. It became the default choice for on-prem CI/CD because it runs anywhere Java runs, and the plugin model let it adapt to whatever stack a team uses. I installed it locally just to see what the setup flow looks like.

## Key terminology

- **Controller** (formerly Master) — the main Jenkins process that schedules builds, serves the UI, and stores configuration. I logged into the web UI at `http://localhost:8080`.
- **Agent** (formerly Slave) — a machine or container that actually runs the build steps. The controller hands off work to agents. I spun up a Docker container as an agent on demand.
- **Pipeline** — the definition of your CI/CD workflow, written as code in a `Jenkinsfile`. I wrote a minimal pipeline with stages for Build and Test.
- **Stage** — a logical grouping of steps in a pipeline (e.g., "Build", "Test"). I grouped the checkout and build steps into a Build stage.
- **Step** — a single command or action inside a stage. I ran `sh 'echo hello'` as a step to verify the environment was working.
- **Plugin** — an extension that adds functionality (SCM integration, cloud providers, notifications). I installed the "GitHub Branch Source" plugin to auto-discover PRs and branches.
- **Executor** — a slot on an agent that can run one build at a time. The default agent has 2 executors.
- **Workspace** — the directory on an agent where the repository is checked out and the build runs. The default path is `/var/jenkins/workspace/my-job`.
- **Blue Ocean** — a modern, visual UI for pipelines (built-in since Jenkins 2.0). I preferred the visual pipeline view over the classic console log.

## A tiny example

```bash
# Pull the Jenkins LTS Docker image and start it locally
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts

# Wait for it to start, get the initial admin password
docker exec jenkins cat /var/jenkins/secrets/initialAdminPassword

# Open http://localhost:8080 in a browser and paste the password
# Then install suggested plugins, create an admin user, and start using Jenkins
```

This pulls the official Jenkins LTS image, maps ports 8080 (web UI) and 50000 (JNLP agent) to the host, and starts the container. After startup, the initial admin password is available in the container's filesystem, and the web UI guides you through the first-time setup.

## What I'll cover next

I want to try creating my first Jenkinsfile with a declarative pipeline, experiment with Docker agents so builds don't run on the controller, and explore credential management for connecting to Docker Hub or a Git provider. After that, I'll look at how to configure agents on Kubernetes for scalable build parallelism.