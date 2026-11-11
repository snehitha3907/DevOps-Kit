---
last_verified: 2026-11-11
tool_version: "Trivy v0.76.2 · docker/login-action v4.8.0 · docker/build-push-action v7.4.0 · aquasecurity/trivy-action v0.36.0"
sources:
  - https://docs.github.com/en/actions/learn-github-actions/contexts
  - https://github.com/docker/login-action/releases/tag/v4.8.0
  - https://github.com/docker/build-push-action/releases/tag/v7.4.0
  - https://github.com/aquasecurity/trivy/releases/tag/v0.76.2
---

# Scan and publish the image from CI

In [Build and test the sample app on every pull request](03-gha-build-test.md) you added a `test` job that runs on pull requests and blocks merges until it passes. Now you extend that pipeline so every build also produces a container image, scans it with Trivy, and — only when the scan is clean — publishes the image to a registry tagged with the commit that triggered the run. This turns CI from "tests pass" into "a verified, publishable image exists."

## What you'll learn

- Build the image in CI, scan it with Trivy, and stop the build on CRITICAL findings.
- Push the image to a registry tagged with the commit SHA.

## Before you start

- [Build and test the sample app on every pull request](03-gha-build-test.md) — the `test` job and `.github/workflows/ci.yml` you extend here.
- [Scan the sample app image with Trivy](../04-containers/07-trivy-scan-image.md) — how `trivy image --severity CRITICAL --exit-code 1` fails a build on critical findings.
- Docker installed and running. Confirm with `docker --version`.
- A GitHub repository whose sample app builds as a container image.
- A container registry (Docker Hub or GHCR) with the registry username and a personal access token stored as repository secrets (`REGISTRY_USER`, `REGISTRY_PASSWORD`) and the registry host stored as a variable (`REGISTRY`).

## Walkthrough

1. Add a `build-scan-publish` job to `.github/workflows/ci.yml` that builds the image tagged with the commit SHA, scans it with Trivy, and pushes it only when the scan passes.

   ```yaml
   name: CI
   on:
     push:
       branches: [main]
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

     build-scan-publish:
       needs: test
       if: github.event_name == 'push'
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v7.0.1
         - name: Build and tag the image
           uses: docker/build-push-action@v7.4.0
           with:
             context: .
             load: true
             tags: sample-app:${{ github.sha }}
         - name: Scan the image with Trivy
           uses: aquasecurity/trivy-action@v0.36.0
           with:
             image-ref: sample-app:${{ github.sha }}
             severity: 'CRITICAL'
             exit-code: '1'
         - name: Log in to the registry
           uses: docker/login-action@v4.8.0
           with:
             registry: ${{ vars.REGISTRY }}
             username: ${{ secrets.REGISTRY_USER }}
             password: ${{ secrets.REGISTRY_PASSWORD }}
         - name: Push the image
           uses: docker/build-push-action@v7.4.0
           with:
             context: .
             push: true
             tags: ${{ vars.REGISTRY }}/sample-app:${{ github.sha }}
   ```

   You should see: the `build-scan-publish` job runs after `test` passes, builds `sample-app:<commit-sha>` into the runner's Docker daemon, runs `trivy image` filtered to CRITICAL findings and fails the step (`exit-code: 1`) if any exist, then logs in and pushes `${{ vars.REGISTRY }}/sample-app:<commit-sha>` to the registry. `github.sha` is the commit SHA that triggered the workflow.

   `load: true` loads the image into the runner's Docker daemon so Trivy can scan it locally. The final `push: true` build streams layers straight to the registry instead of building only into BuildKit's cache — without it, a later `docker push` reports "no such image".

2. Commit and push the workflow.

   ```bash
   git add .github/workflows/ci.yml
   git commit -m "build, trivy-scan, and publish the image on push"
   git push -u origin main
   ```

   You should see: GitHub starts a workflow run. On a pull request, only `test` runs; on a push to `main`, `build-scan-publish` runs after `test` and either publishes `sample-app:<sha>` or stops at the Trivy step when CRITICAL findings exist.

## Exercise

In your own repository:

1. Add the `build-scan-publish` job to `.github/workflows/ci.yml` (adapt the registry and image name to yours).
2. Store your registry credentials as repository secrets (`REGISTRY_USER`, `REGISTRY_PASSWORD`) and the registry host as a variable (`REGISTRY`).
3. Push to `main` and confirm the workflow builds the image tagged with the commit SHA, runs the Trivy scan, and publishes the image.
4. Temporarily change `severity` to include a finding that exists, push again, and confirm the job stops at the Trivy step with a non-zero exit code — then restore `severity: 'CRITICAL'`.

## Check your work

```bash
# on the latest push to main, inspect the workflow run
gh run list --limit 1
gh run view <run-id> --job build-scan-publish
```

You should see: the `build-scan-publish` job succeeded and its Trivy step reported exit code 0 with no CRITICAL findings, and the registry now holds `<registry>/sample-app:<commit-sha>` (confirm in the registry UI or with `docker manifest inspect <registry>/sample-app:<sha>`).

If the job never starts, confirm `if: github.event_name == 'push'` — pull requests skip it, which is why `test` carries the PR gate from the previous lesson.

## Common mistakes

- Scanning an image that was only built into BuildKit's cache — `docker push` later reports "no such image". Use `load: true` for the scan build, or `push: true` to stream straight to the registry.
- Passing `--skip-db-update` on Trivy's first run — Trivy refuses it ("--skip-db-update cannot be specified on the first run"). Let it download the vulnerability database once.
- Assuming Trivy fails by default — it exits 0 even when it finds vulnerabilities unless you set `exit-code: '1'` (or pass `--exit-code 1` to the CLI).
- Hard-coding registry credentials in the workflow — always read them from `${{ secrets.* }}`.

## Next

[Reuse pipeline steps across repositories](../../00_index/learning-path.md)
