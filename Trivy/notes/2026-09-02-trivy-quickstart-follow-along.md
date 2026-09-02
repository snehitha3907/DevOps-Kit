---
last_verified: 2026-09-02
tool_version: n/a
sources: []
---

# Trivy quickstart — what tripped me up

> Following the official Trivy getting-started guide: install Trivy, scan a container image, scan a local filesystem, and make sense of the output. Personal notes on what worked and where I stumbled.

## What I was trying to do

I wanted to run the Trivy quickstart from scratch on my laptop. Steps were: install Trivy, verify `trivy --version` and `trivy --help`, then scan a tiny public image and then scan the current repo with `trivy fs`. I picked `alpine:3.19` because it pulls quickly and the docs use alpine as the example image. For the filesystem scan I used the repo root so I could compare OS packages in the image vs language lockfiles on disk.

```bash
# I installed via apt — the docs also list brew and downloading the binary
sudo apt-get update && sudo apt-get install -y trivy
trivy --version
trivy --help | head -n 40

# first image scan — triggers DB download on first run
trivy image alpine:3.19

# then a filesystem scan on the checkout
trivy fs .
trivy fs . --severity HIGH,CRITICAL --format json | head -n 60
```

## What actually worked

- `trivy image alpine:3.19` rendered a readable table grouped by Target. Each row shows the artifact like `alpine:3.19 (alpine 3.19.1)` and a severity summary. Once the DB was cached, the second run was immediate.
- `trivy fs .` worked without Docker running, which surprised me. I thought all Trivy modes needed the daemon, but only `trivy image` talks to Docker; `trivy fs` just walks files and finds lockfiles.
- Filtering with `trivy image --severity HIGH,CRITICAL alpine:3.19` cut the noise. The default table includes LOW and MEDIUM and I kept scrolling past them.
- `--format json` plus `jq` gave me a parseable output for scripting. I also tried `--format table` explicitly to confirm the default.
- `--help` lists subcommands `image`, `fs`, `repo`, `sbom`, `k8s` — reading that clarified when to use each mode instead of guessing.

## Got stuck on

- **First DB download looks frozen.** The first `trivy image` paused for several seconds with no output before printing `Downloading DB...`. I almost hit Ctrl-C. The DB caches to `~/.cache/trivy/db` so the next run is fast.
- **Docker daemon must be up for image scans.** After a reboot I ran `trivy image` and got `Cannot connect to the Docker daemon`. I thought Trivy was broken, but `trivy fs .` still worked. The error message is accurate once you know the mode split.
- **Exit code stays 0 with findings.** I expected a non-zero exit when vulns were found, but Trivy exits 0 by default. I needed `--exit-code 1` combined with `--severity CRITICAL` to use it as a gate. I missed that flag the first time.
- **No lockfile, no findings.** I ran `trivy fs ./empty-dir` and got an empty report. I thought the scanner was broken, but the dir had no manifest to scan — the output header says how many files were detected and I had scrolled past it.
- **Image vs filesystem results differ.** Scanning `alpine:3.19` and scanning the repo checkout gave different CVE counts. The image includes apk packages from the base layer, while `trivy fs` sees only the repo's own dependencies. That split wasn't obvious from the quickstart alone.
- **Cache confusion.** I tweaked a Dockerfile base tag and re-ran `trivy image` without updating the image — I saw the old result. I needed to re-pull the image or clear the cache; the DB cache is separate from the image layer cache.

## What I'd try next

Next I want to write a tiny wrapper that runs `trivy image --severity HIGH,CRITICAL --exit-code 1` and `trivy fs --severity CRITICAL --exit-code 1`, saves both JSON outputs, and prints a one-line summary of total vs fixable findings. I also want to try `trivy repo <remote-git-url>` versus a local `trivy fs` clone to see how remote cloning differs, and test `--format sarif` so the result can plug into a code-scanning dashboard. The quickstart covers the happy path — the next step is making the exit-code and severity filters usable in a script.
