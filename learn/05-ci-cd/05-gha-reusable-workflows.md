---
last_verified: 2026-11-12
tool_version: n/a
sources: []
---

# Reuse pipeline steps across repositories

In [Scan and publish the image from CI](04-gha-scan-push.md) you built a `publish.yml` workflow whose `build-scan-publish` job builds an image, scans it with Trivy, and publishes it to a registry. That job solves the problem for one repository, but every other team ends up copying the same steps into their own `.github/workflows/*.yml`. This lesson extracts that job into a reusable workflow owned by a central platform repository, then calls it from another repository with inputs and secrets — so every team runs the same build-scan-publish pipeline instead of copy-pasting it.

## What you'll learn

- Extract the build-scan-push job into a reusable workflow
- Call it with inputs and secrets from another workflow

## Before you start

- [Scan and publish the image from CI](04-gha-scan-push.md) — the `build-scan-publish` job in `publish.yml` that you extract here; your sample app repo with a Dockerfile and a passing `npm test`.
- Docker installed (`docker --version`) and a GitHub repository for the sample app.
- Registry credentials stored as GitHub secrets (`REGISTRY_USER`, `REGISTRY_PASSWORD`) in both the platform repo and the app repo.

## Walkthrough

1. Extract `build-scan-publish` into a reusable workflow in the platform repository.

   Create `.github/workflows/build-scan-publish.yml` in the repo the platform team owns. It declares `on: workflow_call`, takes the registry and image name as inputs, requires the registry credentials as secrets, and runs the build-scan-publish job:

   ```yaml
   name: Build, scan, publish

   on:
     workflow_call:
       inputs:
         registry:
           description: 'Container registry host (e.g. ghcr.io or index.docker.io)'
           required: true
           type: string
         image_name:
           description: 'Image name to build and publish'
           required: true
           type: string
       secrets:
         REGISTRY_USER:
           description: 'Registry username'
           required: true
         REGISTRY_PASSWORD:
           description: 'Registry password or personal access token'
           required: true

   permissions:
     contents: read

   jobs:
     build-scan-publish:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4

         - name: Build the image tagged with the commit SHA
           run: |
             docker build -t ${{ inputs.registry }}/${{ inputs.image_name }}:${{ github.sha }} .

         - name: Scan the image with Trivy
           run: |
             docker run --rm \
               -v /var/run/docker.sock:/var/run/docker.sock \
               aquasec/trivy image --severity CRITICAL --exit-code 1 \
               ${{ inputs.registry }}/${{ inputs.image_name }}:${{ github.sha }}

         - name: Publish the image to the registry
           run: |
             echo "${{ secrets.REGISTRY_PASSWORD }}" | docker login ${{ inputs.registry }} \
               -u ${{ secrets.REGISTRY_USER }} --password-stdin
             docker push ${{ inputs.registry }}/${{ inputs.image_name }}:${{ github.sha }}
   ```

   You should see: a reusable workflow that can only be triggered by another workflow (`workflow_call`), accepts `registry` and `image_name` inputs, requires `REGISTRY_USER` and `REGISTRY_PASSWORD` secrets, and runs the same build → Trivy scan → publish sequence the previous lesson taught.

   Because this is a reusable workflow, its `on:` contains only `workflow_call` (not `push` or `pull_request`), and its logic lives entirely under `jobs:` — the caller supplies the trigger and the environment.

2. Call the reusable workflow from the app repository's `publish.yml`.

   In the app repo, replace the inline `build-scan-publish` job with a call to the platform repo's reusable workflow, passing inputs and secrets:

   ```yaml
   name: Build, scan, publish

   on:
     push:
       branches: [main]

   jobs:
     build-scan-publish:
       uses: platform-team/ci/.github/workflows/build-scan-publish.yml@main
       with:
         registry: ${{ env.REGISTRY }}
         image_name: sample-app
       secrets:
         REGISTRY_USER: ${{ secrets.REGISTRY_USER }}
         REGISTRY_PASSWORD: ${{ secrets.REGISTRY_PASSWORD }}
   ```

   You should see: pushing to `main` starts the reusable workflow in the platform repo, which builds `sample-app:${{ github.sha }}`, scans it with Trivy, and publishes it — all without the app repo containing any build or scan steps.

   Reusable workflows are jobs, not steps, so `uses:` goes under a `job.uses:` key (never inside `steps:`). Inputs and secrets that flow across repos must be declared in `workflow_call.inputs` and `workflow_call.secrets` in the reusable file, or the call fails at dispatch time.

## Exercise

In your own repositories:

1. In a central platform repository, create `.github/workflows/build-scan-publish.yml` with `on: workflow_call`, `registry` and `image_name` inputs, `REGISTRY_USER` and `REGISTRY_PASSWORD` secrets, and the `build-scan-publish` job from the walkthrough.
2. In your app repository, rewrite `.github/workflows/publish.yml` to call it with `uses: <platform-org>/ci/.github/workflows/build-scan-publish.yml@main`, passing your registry, image name, and secrets.
3. Store `REGISTRY_USER` and `REGISTRY_PASSWORD` as repository secrets in both repos.
4. Push a commit to `main` in the app repo and watch the run in the Actions tab.
5. Confirm the image appears in your registry tagged with the commit SHA.

Do not paste the run output inline — run the commands yourself and record the result.

## Check your work

```bash
git log --oneline -1                                                    # latest commit on main
gh run list --limit 1 --json status,conclusion                          # latest workflow run
docker run --rm aquasec/trivy image --severity CRITICAL --exit-code 1 \
  REGISTRY/sample-app:SHA                                               # scan the published image
```
Replace `REGISTRY/sample-app:SHA` with the image you published.

You should see: the latest commit is on `main`, the latest workflow run concluded successfully, and the reusable workflow ran the build-scan-publish job in the platform repo.

## Common mistakes

- Putting `uses:` inside a `steps:` block — reusable workflows are jobs, so `uses:` belongs under `job.uses:`, never `steps.uses:`.
- Forgetting to declare `REGISTRY_USER` and `REGISTRY_PASSWORD` in `workflow_call.secrets:` — the call fails at dispatch time with a secret-not-declared error.
- Passing an input the reusable workflow does not declare — the value is silently dropped, so the build or publish step fails with a confusing missing-value error.
- Hard-coding registry credentials in the reusable workflow — store them as encrypted GitHub secrets and reference them with `${{ secrets.NAME }}`.

## Next

[Infrastructure as code concepts](../../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
