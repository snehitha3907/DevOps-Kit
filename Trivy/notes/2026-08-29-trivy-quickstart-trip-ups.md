---
last_verified: 2026-08-29
tool_version: n/a
sources: []
---

# Trivy quickstart — what tripped me up

> Following the official Trivy getting-started flow: install, scan a container image, scan a filesystem, read the output. Notes on where it worked and where it didn't.

## What I was trying to do

I wanted to follow the Trivy quickstart end-to-end: install Trivy, scan a small image (`alpine` because it pulls fast), then try the filesystem scan on a local checkout. The docs suggest starting with `trivy image` and then comparing `trivy fs` — so I ran both in sequence to see how the outputs differ.

```bash
# I installed via apt on Ubuntu — the docs list deb/rpm, brew, and binary options
sudo apt-get update && sudo apt-get install -y trivy
trivy --version

# First image scan — pulls DB on first run
trivy image alpine:3.18

# Then a filesystem scan on the current repo
trivy fs .
```

## What actually worked

- `trivy image alpine:3.18` worked after the database download. The table output is readable — it groups by Target (e.g. `alpine:3.18 (alpine 3.18.4)`) and shows Severity columns with counts.
- `trivy fs .` ran without needing a daemon. That surprised me — I assumed all Trivy modes needed Docker, but only `trivy image` does. The filesystem scan just walks local files and lockfiles.
- `trivy image --severity CRITICAL,HIGH alpine:3.18` filtered the noise nicely — I kept seeing LOW/MEDIUM in the default output and this flag made the table actually useful.
- `--format json` gave me structured output I could pipe to `jq`. The default table is for humans, but for scripting I needed JSON.

## Got stuck on

- **First-run DB download looks like a hang.** The first `trivy image` sat silent for ~6 seconds with no progress bar on my terminal, then printed `Downloading DB...`. I almost Ctrl+C'd — the second run was instant because the DB is cached under `~/.cache/trivy`.
- **Docker daemon must be running for `trivy image`.** I rebooted and forgot to start Docker — `trivy image alpine:3.18` failed with `Cannot connect to the Docker daemon`. `trivy fs` still worked, which confused me until I re-read the mode descriptions.
- **Exit code 0 even with vulnerabilities.** I expected the scan to fail when it found issues, but Trivy exits 0 by default. I had to add `--exit-code 1` (and `--severity CRITICAL` if I only want to gate on critical) to make it useful as a CI gate. I missed that on first read.
- **No lockfile means no findings.** I ran `trivy fs ./emptydir` and got no results. I thought the scanner was broken, but the directory simply had no package manifests — there's nothing for Trivy to resolve. The `trivy fs` output says the number of detected files, which I initially scrolled past.
- **Mixing `trivy image` and `trivy fs` on the same app.** I scanned an image and the repo checkout expecting identical results — they differed slightly because the image has base-layer OS packages (alpine apk) that don't appear in the repo's lockfile scan. That distinction wasn't obvious from the quickstart alone.
- **Cache invalidation.** After updating a Dockerfile base tag, I ran `trivy image` again and got the same CVE count. I needed `--skip-db-update` vs `--db-update` flags — the DB update is separate from image re-pull, and I was stale for one cycle.

## What I'd try next

I want to wire a small gate script that runs `trivy image --severity CRITICAL --exit-code 1` and `trivy fs --severity HIGH,CRITICAL` on a test repo, captures JSON, and prints a one-line summary of fixed vs unfixed findings. I'd also like to try `trivy repo` on a Git URL to see how it handles remote clones vs local `fs` scans, and compare `--format sarif` for CI consumption. The quickstart covers the happy path; the next step is scripting the severity/exit-code filters so the output is actually gate-ready.
