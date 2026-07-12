---
last_verified: 2026-07-12
tool_version: n/a
sources: []
---

# Trivy — quick primer

> First-day notes for someone who's never used Trivy. Personal voice, plain language.

## What is it?

Trivy is a security scanner that looks for vulnerabilities in your software. It's like running a virus scanner, but instead of scanning for malware, it scans your dependencies, container images, and infrastructure configs for known security issues (CVEs). If you've used `npm audit` or `snyk test`, the concept is familiar — Trivy just covers a lot more ground in one tool: OS packages, language libraries, IaC misconfigurations, and even secrets in source code.

## What does it do?

You point Trivy at something — a container image, a directory of source code, a Terraform plan, a Kubernetes cluster — and it downloads a vulnerability database, cross-references what you have against known CVEs, and prints a severity-graded report. It can output a human-readable table, JSON, SARIF, or HTML, and it exits with a non-zero code when it finds issues above a threshold you set.

## Why does it exist?

Before Trivy (and tools like it), you'd piece together vulnerability scanning: Docker Scout or Snyk for containers, `npm audit` / `pip-audit` for language deps, `tfsec` or `checkov` for IaC, and maybe `gitleaks` for secrets. Each tool has its own database, output format, and CI integration. Trivy bundles all of those scanning modes under one CLI with one shared vulnerability DB. For someone starting out in DevOps, it's one tool to learn instead of a half-dozen.

## Key terminology

- **Vulnerability DB** — The database Trivy downloads on first run. It aggregates data from NVD, Red Hat, Debian, Ubuntu, Alpine, GitHub Advisories, and others. Trivy keeps a local cache so subsequent scans are fast.
- **CVE** — Common Vulnerability and Exposure — a standardized identifier for a known security flaw. CVEs look like `CVE-2024-12345`.
- **Severity** — Rating from a scanner: CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN. Trivy uses the severity assigned by the upstream advisory source.
- **Image scan** (`trivy image`) — Scans a container image for vulnerable OS packages (apt, apk, rpm) and language libraries (pip, npm, go modules, etc.).
- **Filesystem scan** (`trivy fs`) — Scans a local directory for vulnerable dependencies and IaC misconfigurations. Good for scanning source code without building a container.
- **Config scan** (`trivy config`) — Scans Terraform, CloudFormation, Dockerfile, and Kubernetes YAML for security misconfigurations (e.g., privileged containers, open security groups).
- **SBOM** — Software Bill of Materials — a machine-readable inventory of all components in your software. Trivy can generate SBOMs in CycloneDX and SPDX formats.
- **Exit code** — Trivy returns exit code 0 when no issues are found above the threshold, non-zero when it finds something. This makes it a natural fit for CI/CD gating.
- **Ignore file** (`.trivyignore`) — A file where you list CVE IDs to suppress. Useful for accepted risk or false positives.

## A tiny example

After installing Trivy, scan a source code directory for vulnerabilities:

```bash
trivy fs ./my-project --severity CRITICAL,HIGH --exit-code 1
```

This downloads the vulnerability DB (first run only), scans `./my-project` for any critical or high-severity issues, and exits with code 1 if any are found. No output means clean.

## What I'll cover next

I want to try scanning a real container image and compare the results to a filesystem scan of the same app source. After that, I'll look at the Python wrapper to integrate Trivy into automated pipelines and explore the config scanner for Terraform and Dockerfile misconfigurations.
