# DevOps-Kit
> A working DevOps engineer's quick-reference for Docker, Kubernetes, Terraform, Ansible, Git, and the cloud-native toolchain.

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

- [Docker Get Started tutorial tripups](Docker/notes/2026-08-12-docker-tutorial-tripups.md) — Notes on what tripped me up during Docker's official Get Started tutorial.
- [Build, run, and cleanup Docker container script](Docker/snippets/2026-08-12-build-run-and-cleanup.py) — Python script that builds, runs, and tears down a Docker container to avoid stale images.
- [Trivy config with severity filtering](Trivy/configs/2026-08-12-trivy-config.yaml) — Trivy config focusing on CRITICAL/HIGH findings while skipping vendor directories.
- [Scraping endpoint three pillars notebook](docs/concepts/monitoring-observability-concepts/notebooks/2026-08-11-scraping-endpoint-three-pillars.ipynb) — Notebook demonstrating the three pillars of observability (metrics, logs, traces) via a scraping endpoint.
- [Kubernetes workload-type comparisons](Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb) — Interactive notebook comparing Pods, Deployments, StatefulSets, DaemonSets, and Jobs.

## Layout

- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **AWS/** — Primer, CLI install and configure scripts, and minimal config files with named profiles.
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, docs, and a variable precedence notebook.
- **ArgoCD/** — Primer and first application manifest for GitOps deployment on Kubernetes.
- **Azure/** — Primer, CLI install and login scripts, and resource group creation snippets.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, a networking drivers notebook, and a reusable Go microservice scaffold.
- **GCP/** — Primer, gcloud CLI install and configure script, and a Compute/GCS listing snippet.
- **Git/** — Primer, install notes, CLI exploration, branching and merge-conflict scripts, commit snippets, hook and repository-scaffold templates, docs, and a merge-strategies notebook.
- **git/** — Companion lowercase directory with git-bisect notes and a repo-scaffold template (10 files), detailed in [topics.md](00_index/topics.md).
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs, and Python API snippets.
- **GitHub Actions/** — Quickstart notes and CI workflow configs with environment variables and secrets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and local pipeline runner.
- **Helm/** — Primer, install and explore CLI script, chart inspection walkthrough, and docs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, pod lifecycle scripts, ingress docs, and a troubleshooting snippet.
- **OpenTofu/** — Primer, install script, and minimal config for the open-source Terraform alternative.
- **Prometheus/** — Primer, install and verify script, and a minimal scrape config for metrics collection.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **Trivy/** — CLI exploration notes, container scanning scripts, a config file, and a Python wrapper snippet.
- **docs/** — Kit-level operational notes and foundational concept primers.
- **CHANGELOG.md** — Chronological record of additions, reworks, and audit fixes.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates | Last verified |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|---------------|
| Ansible | 5 | 4 | 7 | 1 | 1 | 2 | 1 | — | 1 | 2026-07-27 |
| ArgoCD | 2 | 1 | 2 | — | — | — | — | — | — | 2026-08-11 |
| AWS | 2 | 2 | 2 | — | — | — | — | — | — | 2026-07-13 |
| Azure | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-13 |
| Docker | 5 | 5 | 1 | 2 | 7 | 3 | 1 | 5 | 6 | 2026-08-12 |
| GCP | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-17 |
| Git | 4 | 8 | — | 1 | — | 5 | 1 | — | 21 | 2026-08-03 |
| GitHub | 10 | 6 | 6 | 2 | — | 1 | 1 | — | — | 2026-08-05 |
| GitHub Actions | 3 | 2 | 4 | — | — | 1 | — | — | — | 2026-08-07 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Helm | 2 | 1 | 1 | 1 | — | 3 | — | — | — | 2026-08-11 |
| Kubernetes | 5 | 2 | — | 1 | — | 1 | 1 | 3 | — | 2026-07-22 |
| OpenTofu | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-18 |
| Prometheus | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| Terraform | 4 | 2 | 7 | — | — | 2 | 1 | 1 | — | — |
| Trivy | 2 | 2 | 1 | 1 | — | — | — | — | — | 2026-08-12 |

*Rows follow the on-disk tool directories. The lowercase `git/` directory mirrors a subset of `Git/` (bisect notes, a merge-strategies notebook, and a second repo-scaffold template); prefer `Git/` for the main toolkit.*

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub, with deeper config sets in Ansible and Terraform and first-contact notes across the three clouds, ArgoCD, Helm, OpenTofu, and Prometheus. The latest cycle added Docker tutorial tripups, a build-run-cleanup script, and a Trivy config with severity filtering.

---
_Last updated: 2026-08-12_
