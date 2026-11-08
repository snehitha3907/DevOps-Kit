---
last_verified: 2026-11-08
tool_version: n/a
sources: []
---

# Scan the sample app image with Trivy

In [Package the sample app as an image](03-docker-first-image.md) you built a single-stage image, and in [Smaller, faster images with multi-stage builds](04-docker-multistage.md) you split it into build and runtime stages so the final image carries only what it needs to run. Now you point Trivy at that image to see which known vulnerabilities it contains, and you make the scan fail fast on the severities that matter — the same gate you will later wire into CI before an image can be pushed or deployed.

## What you'll learn

- Scan the image and read the findings table
- Make the scan fail on CRITICAL findings and explain the exit code

## Before you start

- [Trivy — quick primer](../../Trivy/notes/0000-primer-trivy.md) — what an image vulnerability scan reports (severity levels, the vulnerability DB, exit codes).
- [Smaller, faster images with multi-stage builds](04-docker-multistage.md) — the multi-stage sample app image you will scan here.
- Trivy installed. Confirm with `trivy --version`.
- Docker running — Trivy needs a container runtime to scan an image (`trivy image` fails with a connection error if Docker is not up).

## Walkthrough

1. Build the multi-stage sample app image if you have not already, and tag it so Trivy has a stable target to scan.

   ```bash
   docker build -f Dockerfile.multistage -t sample-app:scan .
   ```

   You should see: build output for both stages and `Successfully tagged sample-app:scan`. This is the same multi-stage image from the previous lesson, now with a tag you can pass to Trivy.

2. Scan the image with Trivy and read the findings table.

   ```bash
   trivy image sample-app:scan
   ```

   You should see: a severity-graded table (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN) listing each vulnerable package, its installed version, the fixed version when one exists, and a vulnerability ID such as `CVE-2024-XXXX`. The first run downloads Trivy's vulnerability database, so it takes a few seconds longer than later scans — do not interrupt it.

3. Scan only CRITICAL findings and make the scan fail with a non-zero exit code.

   ```bash
   trivy image sample-app:scan --severity CRITICAL --exit-code 1; echo "exit code: $?"
   ```

   You should see: a table of CRITICAL findings (or "No vulnerabilities found"), then `exit code: 1` when CRITICAL findings exist and `exit code: 0` when none do. `--severity CRITICAL` filters to just the highest severity, and `--exit-code 1` tells Trivy to return a non-zero exit code instead of 0 when findings at that severity are found — which is how a scan becomes a CI gate.

4. Inspect the full result as JSON so you can read individual fields (fixed version, title, package).

   ```bash
   trivy image sample-app:scan --severity CRITICAL,HIGH --format json --output trivy-scan.json
   cat trivy-scan.json | head -40
   ```

   You should see: JSON output whose top-level `Results` array holds one entry per scanned target, each with a `Vulnerabilities` list containing fields like `VulnerabilityID`, `PkgName`, `InstalledVersion`, `FixedVersion`, `Severity`, and `Title`.

## Exercise

Take the sample app image you built in the multi-stage lesson and scan it on your own:

1. Build the multi-stage image as `sample-app:exercise-trivy`.
2. Run `trivy image` on it with `--severity CRITICAL,HIGH` and `--exit-code 1`.
3. Confirm the scan exits non-zero when CRITICAL or HIGH findings exist, and zero after you relax the threshold to a severity with no findings.
4. Save the JSON report to `trivy-exercise.json` and read at least one finding's package, installed version, fixed version, and title from it.

Do not paste the scan output inline — run the commands yourself and record the result.

## Check your work

```bash
docker build -f Dockerfile.multistage -t sample-app:exercise-trivy .
trivy image sample-app:exercise-trivy --severity CRITICAL,HIGH --exit-code 1; echo "exit code: $?"
trivy image sample-app:exercise-trivy --severity CRITICAL,HIGH --format json --output trivy-exercise.json
python3 -c "import json; d=json.load(open('trivy-exercise.json')); print(len(d['Results']), 'target(s) scanned')"
```

You should see: the image builds, Trivy prints a CRITICAL/HIGH findings table, the exit code is non-zero when such findings exist and zero when none do, and the final Python line prints the number of scanned targets from `trivy-exercise.json`.

## Common mistakes

- Scanning a tag that was never built or pulled — `trivy image sample-app:exercise-trivy` errors out if that image does not exist locally. Build it first.
- Assuming Trivy fails by default — it exits 0 even when it finds vulnerabilities unless you pass `--exit-code 1`.
- Expecting every finding to have a fix — many CVEs list no `FixedVersion`; those are risk-acceptance decisions, not something a patch always resolves.
- Running `trivy image` without Docker running — the image scan needs a container runtime, so start Docker before you scan.

## Next

[CI/CD concepts](../../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)