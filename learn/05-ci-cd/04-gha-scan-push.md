---
last_verified: 2026-11-11
tool_version: n/a
sources: []
---

# Scan and publish the image from CI

In [Build and test the sample app on every pull request](03-gha-build-test.md) you added a CI workflow that runs the test suite on every pull request and blocks merges until it passes. In [Scan the sample app image with Trivy](../04-containers/07-trivy-scan-image.md) you learned how to point Trivy at an image and make the scan fail on CRITICAL findings. Now you combine the two: every push to `main` builds the image, scans it with Trivy, and only publishes it to a registry when the scan is clean — so an image with CRITICAL findings never leaves CI.

## What you'll learn

- Build the image in CI, scan it with Trivy, and stop on CRITICAL findings
- Push the image to a registry tagged with the commit SHA

## Before you start

- [Build and test the sample app on every pull request](03-gha-build-test.md) — the CI workflow and branch protection you extend here; your sample app repo with a Dockerfile and a passing `npm test`.
- [Scan the sample app image with Trivy](../04-containers/07-trivy-scan-image.md) — how `trivy image --severity CRITICAL --exit-code 1` becomes a non-zero gate, and that Trivy downloads its vulnerability database on the first run.
- Docker installed (`docker --version`) and a GitHub repository for the sample app.
- Registry credentials stored as GitHub secrets (`REGISTRY_USER`, `REGISTRY_PASSWORD`) with `REGISTRY` set as an environment variable or secret, so the workflow can authenticate.

## Walkthrough

1. Create a new workflow file `.github/workflows/publish.yml` that builds the image, scans it, and publishes it.

   ```yaml
   name: Build, scan, publish
   on:
     push:
       branches: [main]
   jobs:
     build-scan-publish:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Build the image tagged with the commit SHA
           run: |
             docker build -t ${{ env.REGISTRY }}/sample-app:${{ github.sha }} .
         - name: Scan the image with Trivy
           run: |
             docker run --rm \
               -v /var/run/docker.sock:/var/run/docker.sock \
               aquasec/trivy image --severity CRITICAL --exit-code 1 \
               ${{ env.REGISTRY }}/sample-app:${{ github.sha }}
         - name: Publish the image to the registry
           run: |
             echo "${{ secrets.REGISTRY_PASSWORD }}" | docker login ${{ env.REGISTRY }} \
               -u ${{ env.REGISTRY_USER }} --password-stdin
             docker push ${{ env.REGISTRY }}/sample-app:${{ github.sha }}
   ```

   You should see: a workflow triggered on pushes to `main` that builds `sample-app:${{ github.sha }}`, runs Trivy against it and fails the run on any CRITICAL finding, then logs in and pushes the image tagged with the commit SHA.

   The build step tags the image with `${{ github.sha }}`, the commit SHA that triggered the run, so every published image is traceable to exactly one commit. The Trivy step runs before the publish step, so a scan that finds CRITICAL vulnerabilities exits non-zero and stops the job before anything is pushed. Trivy downloads its vulnerability database on the first run, so the initial scan takes longer — do not interrupt it.

2. Commit and push the workflow, then push a commit to `main`.

   ```bash
   git add .github/workflows/publish.yml
   git commit -m "add build-scan-publish workflow"
   git push origin main
   ```

   You should see: GitHub starts the `build-scan-publish` job, and the Actions tab shows the build, Trivy scan, and publish steps running in order.

## Exercise

In your own repository:

1. Add the `publish.yml` workflow from the walkthrough, setting `REGISTRY` to your registry and storing `REGISTRY_USER` and `REGISTRY_PASSWORD` as repository secrets.
2. Push a commit to `main` and watch the run in the Actions tab.
3. Confirm the build and publish steps complete and the image appears in your registry tagged with the commit SHA.
4. Introduce a CRITICAL-level finding and confirm the Trivy step fails the run before the publish step runs.

Do not paste the run output inline — run the commands yourself and record the result.

## Check your work

```bash
git log --oneline -1                                                    # latest commit on main
gh run list --limit 1 --json status,conclusion                          # latest workflow run
docker run --rm aquasec/trivy image --severity CRITICAL --exit-code 1 \
  REGISTRY/sample-app:SHA                                               # scan the published image
```
Replace `REGISTRY/sample-app:SHA` with the image you published.

You should see: the latest commit is on `main`, the latest workflow run concluded successfully, and the Trivy scan of the published image exits zero when no CRITICAL findings exist.

## Common mistakes

- Publishing before scanning — if the publish step runs before the Trivy step, an image with CRITICAL findings reaches the registry; keep Trivy ahead of publish in the step order.
- Forgetting `--exit-code 1` — Trivy exits 0 even when it finds vulnerabilities unless you pass `--exit-code 1`, so the gate would never fail.
- Tagging with a fixed tag such as `latest` instead of `${{ github.sha }}` — then you cannot tell which commit an image came from, and old images get overwritten on every push.
- Hard-coding registry credentials in the workflow — store them as encrypted GitHub secrets and reference them with `${{ secrets.NAME }}`.

## Next

[Reuse pipeline steps across repositories](../../00_index/learning-path.md)
