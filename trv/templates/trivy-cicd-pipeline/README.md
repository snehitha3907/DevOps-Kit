---
last_verified: 2026-10-15
tool_version: 0.58.1
sources:
  - https://aquasecurity.github.io/trivy/latest/docs/ci/github-actions/
  - https://aquasecurity.github.io/trivy/latest/docs/ci/gitlab/
---

# Trivy CI/CD Pipeline Template for Container Scanning

> A reusable scaffold for integrating Trivy vulnerability and misconfiguration scanning into GitHub Actions and GitLab CI pipelines, with fail-fast gates, SARIF upload, and SBOM generation.

## Purpose

This template provides production-ready CI/CD pipeline configurations that scan container images and source code with Trivy at multiple stages: fast filesystem scan on checkout, image scan on the built artifact, and SBOM generation for audit trails. Both GitHub Actions and GitLab CI variants are included.

## Layout

```
trivy-cicd-pipeline/
├── README.md
├── .github/
│   └── workflows/
│       └── trivy-scan.yml          # GitHub Actions workflow
├── .gitlab-ci.yml                  # GitLab CI pipeline
├── trivy-config.yaml               # Shared Trivy configuration
└── scripts/
    └── trivy-sbom-merge.py         # Helper: merge SBOM + scan results
```

## Prerequisites

- Container registry credentials configured in CI (GHCR, Docker Hub, GitLab Registry, etc.)
- For GitHub Actions: **Security** tab → **Code scanning alerts** enabled to surface SARIF results
- For GitLab CI: **Security & Compliance** → **Vulnerability Report** feature enabled
- Trivy vulnerability database downloads on first run; subsequent runs use cache (configure cache key per pipeline)

## GitHub Actions Usage

1. Copy `.github/workflows/trivy-scan.yml` to `.github/workflows/trivy-scan.yml` in the application repository.
2. Copy `trivy-config.yaml` to `.trivy.yaml` in the repository root (or adjust the `config-file` input in the workflow).
3. Ensure the repository has a `Dockerfile` at the root or update the `image-name` and `dockerfile-path` inputs.
4. Push to `main` or open a PR: the workflow runs `trivy fs` (fast), builds the image, runs `trivy image`, generates an SBOM, and uploads SARIF to GitHub Code Scanning.

### Workflow Stages

| Job | Purpose | Trivy Mode | Gate |
|-----|---------|------------|------|
| `trivy-fs` | Fail fast on source-level vulns/secrets/misconfigs | `fs` | Exit code 1 on CRITICAL/HIGH |
| `build` | Build and push container image | — | — |
| `trivy-image` | Binding verdict on shippable artifact | `image` | Exit code 1 on CRITICAL/HIGH; upload SARIF |
| `trivy-sbom` | Generate auditable component inventory | `image --format cyclonedx` | — |
| `trivy-config` | Scan IaC (Terraform, Dockerfile, K8s YAML) | `config` | Exit code 1 on CRITICAL/HIGH |

## GitLab CI Usage

1. Copy `.gitlab-ci.yml` to the repository root (or merge into existing `.gitlab-ci.yml`).
2. Copy `trivy-config.yaml` to `.trivy.yaml` in the repository root.
3. Define CI variables: `CI_REGISTRY_IMAGE`, `DOCKER_HUB_USER`/`DOCKER_HUB_PASSWORD` (or equivalent for your registry).
4. Push to `main` or open a merge request: the pipeline runs the same stages as the GitHub Actions variant and publishes vulnerability reports to GitLab's Security Dashboard.

### Pipeline Stages

| Stage | Job | Purpose | Trivy Mode | Gate |
|-------|-----|---------|------------|------|
| `scan` | `trivy_fs` | Fast source scan | `fs` | Exit code 1 on CRITICAL/HIGH |
| `build` | `build_image` | Build and push image | — | — |
| `scan` | `trivy_image` | Artifact scan | `image` | Exit code 1; upload SARIF as artifact |
| `scan` | `trivy_sbom` | SBOM generation | `image --format cyclonedx` | — |
| `scan` | `trivy_config` | IaC scan | `config` | Exit code 1 on CRITICAL/HIGH |

## Shared Configuration (`trivy-config.yaml`)

The included `trivy-config.yaml` sets sane defaults for CI:

```yaml
severity: CRITICAL,HIGH
ignore-unfixed: true
scanners: vuln,secret,misconfig
vulnerability:
  severity: CRITICAL,HIGH
  ignore-status:
    - unknown
misconfig:
  scan:
    skip-dirs:
      - ./vendor
      - ./node_modules
    skip-files:
      - go.sum
      - package-lock.json
```

Adjust `severity` to include `MEDIUM` when the team is ready to address that tier. Keep `ignore-unfixed: true` in CI to avoid blocking on vulnerabilities without published fixes.

## SBOM Merge Helper (`scripts/trivy-sbom-merge.py`)

The helper merges Trivy's CycloneDX SBOM with the vulnerability scan results, producing a single artifact that contains both the component inventory and the verdict. Use it in a post-scan step:

```bash
python3 scripts/trivy-sbom-merge.py \
  --sbom trivy-sbom.cyclonedx.json \
  --scan trivy-image.sarif \
  --output trivy-combined.json
```

## Verify

- Run the pipeline on a repository with a known-vulnerable base image (e.g., `FROM python:3.9-slim` with old OpenSSL). Confirm the `trivy_image` job fails and SARIF appears in the Security tab (GitHub) or Vulnerability Report (GitLab).
- Run on a clean image. Confirm all scan jobs pass and SBOM artifact is produced.
- Confirm `trivy_fs` / `trivy-fs` catches a test secret (`password = "secret123"`) in a staged file.

## Rollback

If a scan gate blocks a legitimate release, the fix is to address the underlying vulnerability (update base image, pin dependency) — not to weaken the gate. For emergency deployments, re-run the pipeline with a manual override variable (e.g., `TRIVY_SKIP_GATE=true`) that the workflow checks before enforcing exit codes.

## Common Errors

- **SARIF upload fails (GitHub).** The `github/codeql-action/upload-sarif@v3` step requires the repository to have Code Scanning enabled. Enable it in Settings → Security → Code scanning alerts.
- **GitLab vulnerability report empty.** The `trivy_image` job must output SARIF to `gl-sast-report.json` (the default artifact name GitLab expects) and the job must have `artifacts:reports:sast`.
- **Trivy DB download times out.** Configure a cache key in the CI config (both templates include cache directives). For air-gapped environments, pre-pull the DB and mount it at `/root/.cache/trivy`.
- **False positives from vendored code.** Add vendored directories to `misconfig.scan.skip-dirs` and `scan.skip-dirs` in `.trivy.yaml`.

## References

- Trivy GitHub Actions docs: https://aquasecurity.github.io/trivy/latest/docs/ci/github-actions/
- Trivy GitLab CI docs: https://aquasecurity.github.io/trivy/latest/docs/ci/gitlab/
- Trivy configuration reference: https://aquasecurity.github.io/trivy/latest/docs/configuration/cli/
- SARIF format specification: https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html
- CycloneDX SBOM spec: https://cyclonedx.org/specification/overview/