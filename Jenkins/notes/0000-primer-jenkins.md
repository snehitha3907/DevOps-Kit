---
last_verified: 2026-10-20
tool_version: "13.x"
sources:
  - https://josenobile.co/guides/prometheus-grafana/
---

# Jenkins — quick primer

> First-day notes for someone who's never used Jenkins. Personal voice, plain language.

## What is it?

Jenkins is an open-source automation server for building, testing, and deploying software. I think of it as the thing that watches my repository and runs a pipeline whenever I push — compile, test, package, deploy — without me clicking anything. It's been around a long time and most CI/CD conversations still reference it.

## What does it do?

It lets me define a pipeline in a `Jenkinsfile` (declarative or scripted Groovy) and runs it on agents. It schedules jobs, tracks build history, stores artifacts, and integrates with almost every SCM and tool through plugins.

## Why does it exist?

Before Jenkins, teams ran builds by hand or with cron jobs. Jenkins made "continuous integration" practical: every commit triggers a build, failures surface immediately, and the whole team sees the green/red status. It exists because someone had to automate the boring part of shipping.

## Key terminology

- **Controller (master)** — The Jenkins server that schedules jobs and serves the UI. Example: the box running on port 8080.
- **Agent (node)** — A worker machine that actually runs builds. Example: a Docker container or a VM with the build tools installed.
- **Pipeline** — The scripted workflow, usually in a `Jenkinsfile`. Example: `pipeline { agent any; stages { stage('Build') { steps { sh 'make' } } } }`.
- **Job** — A configured task Jenkins can run. Example: a freestyle job that runs `npm test`.
- **Plugin** — An extension that adds integrations. Example: the Git plugin clones repos, the Docker plugin builds images.
- **Blue Ocean** — A modern UI for pipelines. Example: visual stage view instead of the classic console log.
- **Build artifact** — A file produced by a build. Example: a `.jar` or container image saved for later stages.

## A tiny example

```bash
# Run Jenkins in Docker
docker run -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

Then open http://localhost:8080, grab the initial admin password from the container logs, and install the suggested plugins.

## What I'll cover next

I'll install Jenkins via Docker and run my first declarative pipeline, then explore the UI — dashboard, job config, Blue Ocean, and the plugin manager.
