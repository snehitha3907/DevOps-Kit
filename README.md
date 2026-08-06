# DevOps-Kit
> A working engineer's DevOps reference for Docker, Kubernetes, Terraform, Ansible, Git, and 12 more tools.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![License](https://img.shields.io/github/license/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for sixteen tool families and eight foundational concept areas. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for the tools a DevOps engineer reaches for every day. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/` (CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, and version control), a reusable S3 module for Terraform, and Jupyter notebooks for deeper dives into specific topics.

## Quick links

- [Go + Redis + Prometheus Compose stack](Docker/manifests/go-redis-prometheus-compose.yaml) — Compose manifest for a multi-service stack with health checks, resource limits, and Prometheus scraping.
- [Multi-service Dockerfile for Go + Redis + Prometheus](Docker/manifests/Dockerfile) — Production-oriented Dockerfile for the Go HTTP server, Redis, and Prometheus stack.
- [Prometheus scrape config for Docker Compose stack](Docker/manifests/prometheus.yml) — Minimal Prometheus configuration targeting the Docker Compose services.
- [Production-ready Go HTTP server Dockerfile](Docker/dockerfiles/production-ready-go-http-server.Dockerfile) — Non-root user, HEALTHCHECK, and layer caching for a Go HTTP server.
- [Go microservice project scaffold README](Docker/templates/go-microservice/README.md) — Starter template with multi-stage Dockerfile, Makefile, go.mod, and main.go.

## Layout

- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, docs, and a variable precedence notebook.
- **ArgoCD/** — Primer and first application manifest for GitOps deployment on Kubernetes.
- **AWS/** — Primer, CLI install and configure scripts, and minimal config files with named profiles.
- **Azure/** — Primer, CLI install and login scripts, and resource group creation snippets.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **GCP/** — Primer, gcloud CLI install and configure script, and a Compute/GCS listing snippet.
- **Git/** — Primer, install notes, CLI exploration, branching and merge-conflict scripts, commit snippets, hook and repository-scaffold templates, docs, and a merge-strategies notebook.
- **git/** — Companion lowercase directory with git-bisect notes and a second repo-scaffold template (10 files), detailed in [topics.md](00_index/topics.md).
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs, and Python API snippets.
- **GitHub Actions/** — Quickstart notes and CI workflow configs with environment variables and secrets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and local pipeline runner.
- **Helm/** — Primer, install and explore CLI script, chart inspection walkthrough, and docs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, pod lifecycle scripts, ingress docs, and a troubleshooting snippet.
- **OpenTofu/** — Primer, install script, and minimal config for the open-source Terraform alternative.
- **Prometheus/** — Primer, install and verify script, and a minimal scrape config for metrics collection and alerting.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **Trivy/** — CLI exploration notes, container scanning scripts, and a Python wrapper snippet.
- **docs/** — Kit-level operational notes and foundational concept primers (CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, and version control).

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates | Last verified |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|---------------|
| Ansible | 5 | 4 | 7 | 1 | 1 | 2 | 1 | — | 1 | 2026-07-27 |
| ArgoCD | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| AWS | 2 | 2 | 2 | — | — | — | — | — | — | 2026-07-13 |
| Azure | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-13 |
| Docker | 4 | 5 | 1 | 1 | 7 | 2 | 1 | 5 | 6 | 2026-08-05 |
| GCP | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-17 |
| Git | 4 | 8 | — | 1 | — | 5 | 1 | — | 21 | 2026-08-03 |
| GitHub | 10 | 6 | 6 | 2 | — | 1 | 1 | — | — | 2026-07-06 |
| GitHub Actions | 3 | 2 | 3 | — | — | — | — | — | — | 2026-07-13 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Helm | 1 | 1 | 1 | — | — | 3 | — | — | — | 2026-07-25 |
| Kubernetes | 5 | 2 | — | 1 | — | 1 | — | 3 | — | 2026-07-22 |
| OpenTofu | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-18 |
| Prometheus | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| Terraform | 4 | 2 | 7 | — | — | 2 | 1 | 1 | — | — |
| Trivy | 2 | 2 | — | 1 | — | — | — | — | — | 2026-07-12 |

*The `Git` row covers the `Git/` directory. A companion lowercase `git/` directory with git-bisect notes and a second repo-scaffold template (10 files) is detailed in [topics.md](00_index/topics.md).*

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub, with deeper config sets in Ansible and Terraform. ArgoCD, OpenTofu, and Prometheus are at first-contact level. Helm has a primer, install script, and three docs. The three major clouds sit at introduction level. Ansible adds an over-Terraform local-exec pattern for post-provisioning configuration. Git now ships client-side hook templates alongside two repository-scaffold starters (conventional commits, pinned hooks, release-please), a worktrees gotchas guide, and an automated git-bisect walkthrough for CI. Foundational concept primers under `docs/concepts/` cover the full breadcrumb from Linux basics to monitoring. Docker gained a production-ready Go HTTP server image, a multi-service Compose stack with Prometheus, and a Go microservice scaffold template in the latest cycle.

---
_Last updated: 2026-08-06_
