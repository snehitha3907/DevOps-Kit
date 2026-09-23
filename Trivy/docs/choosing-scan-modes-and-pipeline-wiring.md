---
last_verified: 2026-09-23
tool_version: n/a
---

# Trivy scan modes — image vs fs vs repo vs sbom, with a pipeline example

## Purpose

This doc explains when to reach for each of the four Trivy scan modes I kept
mixing up — `image`, `fs`, `repo`, and `sbom` — and shows one way to wire the
right mode into a build pipeline so a scan failure blocks a bad artifact.

## When to use which

| Mode | What it scans | Reach for it when… |
|---|---|---|
| `image` | A container image already present locally or in a registry | The pipeline just built (or pulled) an image and you want a verdict before pushing or deploying it |
| `fs` | A local directory (a checkout, an unpacked rootfs, a build context) | You want fast feedback on the working tree or on files before they are baked into an image |
| `repo` | A remote repository, cloned by Trivy itself | You want to scan a repo you have not checked out, e.g. a one-off audit of another team's service |
| `sbom` | A pre-generated SBOM file (CycloneDX or SPDX) listing components | The SBOM is produced once (by the build) and scanned separately, possibly later or by a different stage |

The mental model I settled on: `fs` looks at files I already have, `repo`
fetches files I don't, `image` looks at a finished artifact, and `sbom` skips
detection entirely and audits a component list someone else produced.

## Prerequisites

- Trivy installed on the machine or image running the scan step.
- For `image`: the image must be built or pulled first — scanning a tag that
  was never pulled just errors out.
- For `sbom`: an SBOM file generated from the same artifact you intend to ship;
  scanning a stale SBOM from last week's build gives a stale verdict.

## Steps

### 1. Scan the built image

```sh
trivy image --severity HIGH,CRITICAL --exit-code 1 my-service:ci-123
```

This is the gate I put closest to the push/deploy step: exit code 1 means
"findings at these severities fail the build". Keeping the severity list
explicit avoids the default surfacing a long tail of low-severity noise that
nobody acts on.

### 2. Scan the working tree during development

```sh
trivy fs --severity HIGH,CRITICAL --exit-code 1 .
```

One gotcha I actually hit here: pointing `fs` at an empty or freshly
initialized directory returns a clean result that means nothing — there is
simply nothing to find. I now run it from the repo root after dependencies
are installed so lockfiles and vendored components exist.

### 3. Audit a repo without checking it out

```sh
trivy repo --severity HIGH,CRITICAL <repo-url>
```

Trivy clones to a temp dir and scans. This is one way to do a quick audit;
the docs also show checking out first and using `fs`, which I prefer when I
need reproducible flags because the clone step hides fetch options from me.

### 4. Scan a pre-generated SBOM

```sh
trivy sbom --severity HIGH,CRITICAL --exit-code 1 ./sbom.cyclonedx.json
```

Useful when SBOM generation and vulnerability verdicts belong to different
stages or teams: the build stage attests "this is what's inside", and the
security stage answers "is any of it currently known-bad".

### 5. Worked pipeline example

A minimal three-stage shape that combines the modes without rescanning
everything twice:

```sh
# stage: build
docker build -t my-service:ci-123 .
trivy fs --severity HIGH,CRITICAL --exit-code 1 .          # fast: fail before baking further

# stage: attest
generate-sbom my-service:ci-123 -o ./sbom.cyclonedx.json  # whatever generator the team uses

# stage: gate
trivy image --severity HIGH,CRITICAL --exit-code 1 my-service:ci-123
trivy sbom  --severity HIGH,CRITICAL --exit-code 1 ./sbom.cyclonedx.json
```

The `fs` scan fails fast on the checkout; the `image` scan is the binding
verdict on the shippable artifact; the `sbom` scan keeps an auditable
component list next to the verdict. If the `image` and `sbom` verdicts ever
disagree, I trust the `image` one for the go/no-go decision and treat the
drift as a sign the SBOM generator is out of sync with the Dockerfile.

## Verify

- Re-run the gate command locally with `--exit-code 1` and confirm it exits
  non-zero on a deliberately vulnerable fixture, and zero after the fixture
  is fixed.
- Confirm each stage scans what you think it does: `fs` from the repo root,
  `image` against the exact tag the deploy step will use, `sbom` against an
  SBOM generated from that same tag in the same run.
- Check the pipeline log shows which mode produced the verdict — "image scan
  failed" and "sbom scan failed" point at different fixes.

## What I'd try next

I want to compare severity-filtered gates against fix-available filtering on
a real service, so the pipeline only blocks on issues with a published fix.
That is a separate experiment; this doc stays with the mode choice.
