---
last_verified: 2026-11-24
tool_version: n/a
sources: []
---

# Rebuild the sample app pipeline in Jenkins

In the GitHub Actions lesson you built a CI pipeline that constructs the sample app image, scans it with Trivy, and only publishes it when the scan is clean. This lesson rebuilds that same build → test → scan flow in Jenkins, a self-hosted automation server, by writing a declarative `Jenkinsfile` that runs on an agent instead of in GitHub-hosted runners. The Jenkins primer covered what Jenkins is; here you write the actual pipeline and run it.

## What you'll learn

- Write a declarative Jenkinsfile with Build, Test, and Scan stages for the sample app
- Run `npm test` as a gate so a failing test stops the pipeline
- Run a Trivy image scan with `--exit-code 1` so a CRITICAL finding fails the build
- Create a Jenkins Pipeline job pointed at a Git repository and run it

## Before you start

- [Scan and publish the image from CI](../05-ci-cd/04-gha-scan-push.md) — the build → scan → publish pattern and the sample app with a Dockerfile and a passing `npm test`; you rebuild that same flow in Jenkins here
- Jenkins installed and reachable, with permission to create a Pipeline job; confirm you can open the Jenkins controller and create a new job
- The sample app repository cloned locally, with a `Dockerfile` and a passing `npm test`
- Docker available on the Jenkins agent so the Build and Scan stages can run containers; confirm with `docker --version` on the agent

## Walkthrough

1. Create a `Jenkinsfile` in the sample app repo root.

   A declarative pipeline is wrapped in `pipeline { ... }`, declares an `agent` that runs the work, and groups commands into `stage` blocks. Each `stage` holds `steps`, and `sh` runs a shell command on the agent.

   ```groovy
   pipeline {
       agent any
       stages {
           stage('Build') {
               steps {
                   sh 'docker build -t sample-app:latest .'
               }
           }
           stage('Test') {
               steps {
                   sh 'npm test'
               }
           }
           stage('Scan') {
               steps {
                   sh '''
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --severity CRITICAL --exit-code 1 \
  sample-app:latest
'''
               }
           }
       }
   }
   ```

   You should see: a `Jenkinsfile` that builds `sample-app:latest`, runs `npm test`, then scans the image with Trivy and fails on any CRITICAL finding.

   The Build stage produces the image. The Test stage runs the app's test suite. The Scan stage mounts the Docker socket into a Trivy container and scans `sample-app:latest`; `--exit-code 1` makes Trivy exit non-zero on CRITICAL findings, so the pipeline stops instead of continuing. Because Scan comes after Build and Test, a broken build or failing test never reaches the scanner.

2. Commit and push the `Jenkinsfile`.

   ```bash
   git add Jenkinsfile
   git commit -m "add Jenkins pipeline: build, test, scan"
   git push origin main
   ```

   You should see: the commit created on `main` and pushed to the remote.

3. Create a Pipeline job in Jenkins.

   Open the Jenkins controller, create a new "Pipeline" job, point it at the sample app repository, and select the `Jenkinsfile` from the repo root. Run the job.

   You should see: Jenkins checks out the repo, runs Build, Test, and Scan in order, and reports each stage's result.

## Exercise

In your own Jenkins:

1. Write a `Jenkinsfile` with Build (`docker build`), Test (`npm test`), and Scan (Trivy `--severity CRITICAL --exit-code 1`) stages, and commit it to your repository.
2. Create a Pipeline job in Jenkins pointing at your repository and run it.
3. Confirm Build and Test complete and Scan runs Trivy against the built image.
4. Introduce a CRITICAL-level finding into the app, rerun the job, and confirm the Scan stage fails and stops the pipeline.

Do not paste the run output inline — run the commands yourself and record the result.

## Check your work

- `git log --oneline -1` shows the `Jenkinsfile` commit on your branch.
- The Jenkins Pipeline job's most recent run shows Build, Test, and Scan stages, with Build and Test successful.
- After introducing a CRITICAL finding, the Scan stage exits non-zero and the pipeline does not proceed past Scan.

## Common mistakes

- Putting Scan before Build — the image does not exist yet, so Trivy has nothing to scan.
- Omitting `--exit-code 1` — Trivy exits 0 even when it finds CRITICAL vulnerabilities, so the scan gate never fails and a vulnerable build passes.
- Running `npm test` without installing dependencies first — the Test stage needs `node_modules` present, so run `npm install` (or include it in the image) before `npm test`.

## Next

[OpenTofu — quick primer](../../OpenTofu/notes/0000-primer-opentofu.md)
