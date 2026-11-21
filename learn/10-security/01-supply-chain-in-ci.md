---
last_verified: 2026-11-21
tool_version: 0.76.2
sources:
  - https://trivy.dev/docs/latest/supply-chain/sbom/
  - https://trivy.dev/docs/latest/references/configuration/cli/trivy_image/
  - https://trivy.dev/docs/latest/target/sbom/
  - https://github.com/aquasecurity/trivy/releases/tag/v0.76.2
---

# SBOMs and image policy in the pipeline

In [Scan and publish the image from CI](../05-ci-cd/04-gha-scan-push.md) you built an image, scanned it with Trivy, and published it to a registry only when the scan was clean — but you scanned a mutable tag, and a tag can be retagged or overwritten between the moment you scan it and the moment it runs. [Deploy from Git with ArgoCD and roll back](../08-gitops/02-argocd-deploy-and-rollback.md) then deploys whatever image tag sits in Git, so there is a gap: the image you scanned may not be the image that lands in the cluster. This lesson closes that gap. You will generate an SBOM so there is a machine-readable inventory of exactly what is in the image, and you will block deployment of any image that fails policy — scanning by immutable digest (`name@sha256:...`) so the artifact you scan is the artifact you deploy.

## What you'll learn

- Generate an SBOM for the image in CI (CycloneDX), embedding vulnerabilities with `--scanners vuln` because `--format cyclonedx` alone emits an SBOM but disables security scanning.
- Block deployment of an image that fails policy with `--scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1`, scanning by immutable digest so the scanned artifact is exactly the deployed artifact.

## Before you start

- [Scan and publish the image from CI](../05-ci-cd/04-gha-scan-push.md) — the build→scan→publish workflow; Trivy gate on CRITICAL before publish; image tagged with the commit SHA.
- [Deploy from Git with ArgoCD and roll back](../08-gitops/02-argocd-deploy-and-rollback.md) — the GitOps loop where an image-tag change in Git flows to the cluster, and rollback happens by reverting the commit.
- Trivy installed; confirm with `trivy version` (this lesson was written against 0.76.2).
- Docker installed; confirm with `docker --version`.
- A sample app image pushed to a registry (from the previous lesson) and the ArgoCD Application manifest that deploys it.

## Walkthrough

### 1. Generate a CycloneDX SBOM for the image

Scan the published image and write a CycloneDX SBOM. Add `--scanners vuln` so the SBOM also carries vulnerability entries — `--format cyclonedx` by itself emits an SBOM and disables security scanning, which is easy to miss.

```bash
trivy image --format cyclonedx --output sbom.cdx.json --scanners vuln REGISTRY/sample-app:SHA
```

You should see: `sbom.cdx.json` is written. Open it and it lists each package (name, version, type) as a CycloneDX component, with vulnerability entries referencing those packages by fix status. The SBOM is now an auditable inventory of the image you are about to deploy.

Replace `REGISTRY/sample-app:SHA` with your own registry and the commit-SHA tag from the previous lesson.

### 2. Scan the image by immutable digest, not a mutable tag

A tag can move between scan and deploy, so capture the image's digest and scan `name@sha256:...`. In CI the digest comes from the build/push step output; locally you can read it from the image's repo digests:

```bash
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' REGISTRY/sample-app:SHA | cut -d@ -f2)
trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 \
  "REGISTRY/sample-app@sha256:$DIGEST"
```

You should see: Trivy exits `0` when no HIGH or CRITICAL unfixed findings exist, and exits non-zero (failing the step) when one does. `--ignore-unfixed` keeps only findings that have a fix, so you are not blocked by unfixable noise; `--exit-code 1` turns any matching finding into a failed CI step.

Never mask the result with `|| true` — that swallows the exit code and lets a vulnerable image through the gate.

### 3. Wire the gate into CI before the deploy

Add the digest scan as a gate between the build and the step that bumps the image tag in Git (which is what ArgoCD picks up). If the scan fails, the tag is never bumped and ArgoCD never syncs a vulnerable image:

```yaml
- name: Scan image by digest and enforce policy
  run: |
    trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 \
      "REGISTRY/sample-app@sha256:${{ steps.build.outputs.digest }}"
```

Only after this step passes do you generate the SBOM, commit the new image tag, and push — at which point ArgoCD converges the cluster to the vetted image. A bad scan stops the pipeline before anything is deployed, and the rollback lesson's `git revert` is your escape hatch if a bad image still slips through.

## Exercise

In your own repository:

1. Generate an SBOM for your image in CycloneDX and again in SPDX; confirm both files are valid JSON and non-empty.
2. Scan your image by digest with `--scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1`; confirm exit `0` on a clean image, then introduce a CRITICAL finding and confirm the scan exits non-zero.
3. Add the digest-scan gate to your CI workflow ahead of the image-tag bump/deploy step; confirm a failing scan stops the pipeline — and do not use `|| true`.

Do not paste the run output inline — run the commands yourself and record the result.

## Check your work

```bash
trivy image --format cyclonedx --output sbom.cdx.json --scanners vuln REGISTRY/sample-app:SHA
test -s sbom.cdx.json && python3 -m json.tool sbom.cdx.json >/dev/null && echo "valid CycloneDX JSON"
```

```bash
trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 \
  "REGISTRY/sample-app@sha256:<digest>"
echo $?
```

You should see: the SBOM file exists and parses as JSON; the digest scan exits `0` on a clean image and a non-zero code when a HIGH/CRITICAL unfixed finding is present — proving the gate blocks a vulnerable deployment.

## Common mistakes

- `--format cyclonedx` alone disables security scanning — always add `--scanners vuln` when the SBOM must carry vulnerabilities.
- Scanning by tag (`:latest` or `:SHA`) instead of digest — the image can change between scan and deploy; scan `name@sha256:...`.
- Masking `--exit-code 1` with `|| true` — the gate never fails and a vulnerable image reaches the cluster.
- `failed to download DB` — no network to the vulnerability DB; pre-warm with `trivy image --download-db-only` or set `TRIVY_DB_REPOSITORY` to an internal mirror.

## Next

[Store and read secrets with Vault](02-vault-kv-basics.md)
