---
last_verified: 2026-11-25
tool_version: n/a
sources: []
---

# Rebuild the sample app pipeline in GitLab CI

In [Scan and publish the image from CI](../05-ci-cd/04-gha-scan-push.md) you built a GitHub Actions workflow that builds the sample app image, scans it with Trivy, and publishes it only when the scan is clean. This lesson rebuilds that same build → scan → push flow in GitLab CI, writing a `.gitlab-ci.yml` that runs on GitLab runners instead of GitHub-hosted ones. You tag the image with the commit SHA so every published image traces back to exactly one commit.

## What you'll learn

- Write a `.gitlab-ci.yml` with build and scan stages for the sample app
- Build the image and push it to the GitLab container registry tagged with the commit SHA
- Scan the image with Trivy using `--severity CRITICAL --exit-code 1` so a CRITICAL finding fails the pipeline

## Before you start

- [GitLab CI — quick primer](../../GitLab CI/notes/0000-primer-gitlab-ci-cd.md) — what a pipeline, job, stage, and runner are, and that `.gitlab-ci.yml` lives at the repo root
- [Scan and publish the image from CI](../05-ci-cd/04-gha-scan-push.md) — the build → scan → publish pattern and the sample app with a Dockerfile and a passing `npm test`
- Docker available so the build job can run containers; confirm with `docker --version`
- A GitLab repository for the sample app; GitLab provides `CI_REGISTRY_IMAGE`, `CI_REGISTRY_USER`, and `CI_REGISTRY_PASSWORD`, with the user and password set as CI/CD variables in the project settings

## Walkthrough

1. Create `.gitlab-ci.yml` in the sample app repo root.

   GitLab runs each stage in order and stops the pipeline when a job fails, so the scan stage sits after build and blocks everything that follows when Trivy finds CRITICAL findings.

   ```yaml
   stages:
     - build
     - scan

   variables:
     REGISTRY_IMAGE: "$CI_REGISTRY_IMAGE"
     IMAGE_TAG: "$REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA"

   build:docker:
     stage: build
     image: docker:cli
     services:
       - docker:dind
     before_script:
       - |
         if [ -n "$CI_REGISTRY_PASSWORD" ]; then
           echo "$CI_REGISTRY_PASSWORD" \
             | docker login --username "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY"
         fi
     script:
       - docker build --tag "$IMAGE_TAG" .
       - docker push "$IMAGE_TAG"

   scan:image:
     stage: scan
     image: aquasec/trivy
     needs:
       - build:docker
     script:
       - trivy image --severity CRITICAL --exit-code 1 "$IMAGE_TAG"
   ```

   You should see: a `.gitlab-ci.yml` with a build stage that builds and pushes `sample-app:<sha>` to the GitLab registry, and a scan stage that pulls that image and runs Trivy, failing the pipeline on any CRITICAL finding.

   The build job uses the `docker:cli` image with a `docker:dind` service so it can run `docker build` and `docker push`. It logs in to the GitLab registry using the predefined `CI_REGISTRY_USER` / `CI_REGISTRY_PASSWORD` variables, then builds and pushes the image tagged with `$CI_COMMIT_SHORT_SHA`. The scan job uses the `aquasec/trivy` image, needs the build job so it runs after the image is pushed, and scans `IMAGE_TAG`; `--exit-code 1` makes Trivy exit non-zero on CRITICAL findings, which fails the job and stops the pipeline.

   A companion copy of this file lives at [`GitLab CI/configs/gitlab-ci-sample-app-build-scan-push.yml`](../../GitLab CI/configs/gitlab-ci-sample-app-build-scan-push.yml).

2. Commit and push the file.

   ```bash
   git add .gitlab-ci.yml
   git commit -m "add GitLab CI pipeline: build and scan"
   git push origin main
   ```

   You should see: the commit created on `main` and GitLab starts a pipeline with the build and scan jobs.

3. Watch the pipeline in GitLab.

   Open the repository in GitLab, go to Build > Pipelines, and open the latest run. Confirm the build job pushes the image and the scan job runs Trivy against it.

   You should see: the build job completes and the scan job either passes (no CRITICAL findings) or fails on a CRITICAL finding, and no stage runs after a failed scan.

## Exercise

In your own sample app repository:

1. Add the `.gitlab-ci.yml` from the walkthrough, with `CI_REGISTRY_USER` and `CI_REGISTRY_PASSWORD` set as CI/CD variables in your GitLab project settings.
2. Push a commit to the default branch and watch the pipeline in GitLab.
3. Confirm the build job pushes the image tagged with the commit SHA and the scan job runs Trivy against it.
4. Introduce a CRITICAL-level finding, push again, and confirm the scan job fails and the pipeline does not proceed past scan.

Do not paste the run output inline — run the commands yourself and record the result.

## Check your work

```bash
git log --oneline -1                                    # the .gitlab-ci.yml commit on the default branch
```
Open GitLab > Build > Pipelines for the latest run and confirm:
- the `build:docker` job completed and pushed `REGISTRY_IMAGE:<sha>`
- the `scan:image` job ran `trivy image --severity CRITICAL --exit-code 1` and passed (or failed on a CRITICAL finding after you introduced one)

## Common mistakes

- Putting scan before build — the image does not exist in the registry yet, so Trivy has nothing to scan.
- Omitting `--exit-code 1` — Trivy exits 0 even when it finds CRITICAL vulnerabilities, so the scan gate never fails and a vulnerable build passes.
- Forgetting the `docker:dind` service — the build job cannot run `docker build` without a Docker daemon, so the job fails at the first `docker` command.

## Next

[Rebuild the sample app pipeline in Jenkins](05-jenkins-pipeline.md)
