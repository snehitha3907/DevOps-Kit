---
last_verified: 2026-08-14
tool_version: n/a
sources: []
---

# Trivy quickstart — what tripped me up

> Following the official Trivy getting-started flow: install, scan a container image, read the output. Notes on where it worked and where it didn't.

## The flow I followed

The quickstart has you install Trivy, then scan a container image with `trivy image nginx:latest` (I used the `alpine` image instead since it's small and pulls fast). On the first scan Trivy downloads its vulnerability database, which took a few seconds and made me think the command had hung — it hadn't.

```bash
trivy image alpine
```

That worked and printed a severity table. Then the quickstart suggested scanning a Git repo with `trivy repo` and a local directory with `trivy fs`, both of which ran fine on my machine.

## Got stuck on

- **First-scan database download.** `trivy image alpine` sat silent for ~5 seconds before showing a progress bar. I almost Ctrl+C'd. The DB is cached after that, so later scans are fast.
- **Container runtime requirement.** Scanning an image needs a working container runtime (Docker in my case). `trivy image` failed with a connection error when I'd forgotten to start the Docker daemon. The quickstart assumed it was running and didn't call it out.
- **No vulnerable packages found ≠ broken.** `trivy fs ./my-project` returned "No vulnerable packages found" on a directory with no lockfiles. I thought the scanner was misconfigured; actually there was simply nothing to resolve.
- **Output format default.** The default table is fine for eyeballing, but I wanted JSON for scripting and had to remember `--format json`. Easy to miss if you skim the docs.
- **Exit codes for CI.** Trivy exits 0 by default even when it finds vulnerabilities; you have to pass `--exit-code 1` to make a scan fail when issues are found. I assumed it would fail by default.

## What I'd try next

I want to scan a real image from a project I'm building and wire `--severity CRITICAL,HIGH` with `--exit-code 1` into a script as a gate. I'd also like to compare `trivy image` vs `trivy fs` on the same app to see which surfaces more useful findings.
