# Trivy CLI exploration — what can I scan and how do I read the output

> I installed Trivy and started poking around the CLI to understand what it can scan and how to make sense of the results.

## Getting oriented

First thing I did was run `trivy --help`. The output lists several subcommands, each for a different scan target:

| Command | Scans | Example |
|---------|-------|---------|
| `image` | Container images | `trivy image nginx:latest` |
| `filesystem` (or `fs`) | Local directories | `trivy fs ./my-project` |
| `repository` (or `repo`) | Remote git repos | `trivy repo https://github.com/org/repo` |
| `config` | IaC config files (Terraform, Docker, K8s) | `trivy config ./infra` |
| `sbom` | Software BOM files | `trivy sbom sbom.spdx.json` |
| `rootfs` | Root filesystem (container or VM) | `trivy rootfs --server http://...` |
| `kubernetes` (or `k8s`) | K8s cluster resources | `trivy k8s cluster` |

For each one, the output looks similar — a table of vulnerabilities grouped by severity.

## Trying my first scan

I scanned a local filesystem with a known old Go binary I'd built:

```bash
trivy fs ./test-project
```

The output showed something like:

```
2026-06-25T12:00:00Z    INFO    Need to update DB
2026-06-25T12:00:05Z    INFO    Downloading vulnerability DB...
42.71 MiB / 42.71 MiB   100.00%  6.72 MiB/s 5s
2026-06-25T12:00:12Z    INFO    Vulnerability scanning is enabled

./go.mod (gomod)
=================
Total: 3 (UNKNOWN: 0, LOW: 1, MEDIUM: 1, HIGH: 1, CRITICAL: 0)
```

It downloads a vulnerability database first (only on first run or when it's stale), then scans. The results are per-file/per-module, with a table listing the library, installed version, fixed version, severity, and a CVE ID.

## Reading the output

Each result table has columns:

- **Library** — the package or module name
- **Vulnerability** — the CVE identifier
- **Severity** — CRITICAL / HIGH / MEDIUM / LOW / UNKNOWN
- **Installed Version** — what I have
- **Fixed Version** — the version that patches it
- **Title** — short description

I found the severity summary line at the top of each section the quickest way to get a health check: `Total: 3 (UNKNOWN: 0, LOW: 1, MEDIUM: 1, HIGH: 1, CRITICAL: 0)`. If there's a CRITICAL or HIGH, that's what I'd investigate first.

## Getting machine-readable output

The table view is nice for eyeballing, but I wanted JSON for scripting:

```bash
trivy fs ./test-project --format json
```

That outputs a structured JSON blob with `Results[].Vulnerabilities[]` — each vulnerability has `PkgName`, `VulnerabilityID`, `Severity`, `InstalledVersion`, `FixedVersion`, `Title`, `Description`, and more. Perfect for automated analysis.

There's also `--format sarif` for SIEM integration and `--format template` for custom templates.

## Filtering results

A few flags I tried:

| Flag | What it does |
|------|-------------|
| `--severity CRITICAL,HIGH` | Only show CRITICAL and HIGH |
| `--ignore-unfixed` | Skip vulnerabilities with no fix available |
| `--exit-code 1` | Exit with code 1 if vulns found (useful for CI) |
| `--scanners vuln,secret,config` | Choose what to scan for |

Combining `--severity` with `--exit-code` makes a nice CI gate:

```bash
trivy fs . --severity CRITICAL,HIGH --exit-code 1 --ignore-unfixed
```

## What tripped me up

- The first scan always downloads the vulnerability DB, which takes a few seconds. Not a problem, just unexpected when running in a script.
- `trivy fs` on a directory with no lock/sbom files returns "No vulnerable packages found" — I was worried it wasn't working at first, but it just means there's nothing to scan.
- Severity levels are case-sensitive in filters (`--severity critical` fails, needs `--severity CRITICAL`).

## What I'd try next

Next I want to scan a real container image and compare the results to `trivy fs` on the same app's source. I also want to try `trivy repo` on a public repo to see how it handles the clone + scan flow.
