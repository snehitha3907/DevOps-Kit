# DevOps-Kit
> A working DevOps engineer's quick-reference for Docker, Kubernetes, Terraform, Ansible, Git, and the cloud-native toolchain.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for sixteen tool families and eight foundational concept areas. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for the tools a DevOps engineer reaches for every day. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/` (CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, and version control), a reusable S3 module for Terraform, and Jupyter notebooks for deeper dives into specific topics.

## Quick links

- [Deploy a static website to S3](AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh) — Publish a local folder as a public static site on S3 with the AWS CLI.
- [Trigger a workflow dispatch and poll status](GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py) — Kick off a GitHub Actions `workflow_dispatch` and poll the API until the run finishes.
- [Minimal gcloud config + startup script](GCP/configs/2026-08-14-minimal-gcloud-config-and-startup-script.yaml) — gcloud config export plus a Compute Engine `startup-script` metadata block and a simple nginx boot.
- [Trivy quickstart trip-ups](Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md) — What tripped me up on the Trivy getting-started flow: first-scan DB pull, container runtime, exit codes for CI.
- [AWS CLI quickstart walkthrough](AWS/scripts/2026-08-14-aws-cli-quickstart-walkthrough.sh) — First-contact walkthrough of the AWS CLI install and configure flow.

## Layout

- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **AWS/** — Primer, CLI install and configure scripts, minimal config files with named profiles, and an S3 static-site deployment script.
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, docs, and a variable precedence notebook.
- **ArgoCD/** — Primer and first application manifest for GitOps deployment on Kubernetes.
- **Azure/** — Primer, CLI install and login scripts, and resource group creation snippets.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, a networking drivers notebook, and a reusable Go microservice scaffold.
- **GCP/** — Primer, gcloud CLI install and configure script, a Compute/GCS listing snippet, and a minimal config.
- **Git/** — Primer, install notes, CLI exploration, branching and merge-conflict scripts, commit snippets, hook and repository-scaffold templates, docs, and a merge-strategies notebook.
- **git/** — Companion lowercase directory with git-bisect notes and a repo-scaffold template, detailed in [topics.md](00_index/topics.md).
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs, and Python API snippets.
- **GitHub Actions/** — Quickstart notes, CI workflow configs, and REST API snippets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and local pipeline runner.
- **Helm/** — Primer, install and explore CLI script, chart inspection walkthrough, and docs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, pod lifecycle scripts, ingress docs, and a troubleshooting snippet.
- **OpenTofu/** — Primer, install script, and minimal config for the open-source Terraform alternative.
- **Prometheus/** — Primer, install and verify script, and a minimal scrape config for metrics collection.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **Trivy/** — Primer, CLI exploration notes, container scanning scripts, a config file, and a Python wrapper snippet.
- **docs/** — Kit-level operational notes and foundational concept primers.
- **CHANGELOG.md** — Chronological record of additions, reworks, and audit fixes.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates | Last verified |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|---------------|
| Ansible | 6 | 4 | 7 | 2 | 1 | 2 | 1 | — | 1 | 2026-08-12 |
| ArgoCD | 2 | 1 | 2 | — | — | — | — | — | — | 2026-08-11 |
| AWS | 2 | 5 | 2 | 1 | — | — | — | — | — | 2026-08-15 |
| Azure | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-13 |
| Docker | 5 | 5 | 1 | 2 | 7 | 3 | 1 | 5 | 6 | 2026-08-12 |
| GCP | 1 | 1 | 1 | 1 | — | — | — | — | — | 2026-08-14 |
| Git | 4 | 8 | — | 1 | — | 5 | 1 | — | 21 | 2026-08-03 |
| GitHub | 10 | 6 | 6 | 2 | — | 1 | 1 | — | — | 2026-08-05 |
| GitHub Actions | 3 | 2 | 4 | 1 | — | 1 | — | — | — | 2026-08-15 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Helm | 2 | 1 | 1 | 1 | — | 3 | — | — | — | 2026-08-11 |
| Kubernetes | 6 | 2 | 1 | 1 | — | 1 | 1 | 3 | — | 2026-08-12 |
| OpenTofu | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-18 |
| Prometheus | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| Terraform | 5 | 2 | 7 | — | — | 2 | 1 | 1 | — | 2026-08-12 |
| Trivy | 3 | 2 | 1 | 1 | — | — | — | — | — | 2026-08-14 |

*Rows follow the on-disk tool directories. `Last verified` is the most recent `last_verified` stamp found in that tool's docs, configs, and scripts. The lowercase `git/` directory mirrors a subset of `Git/` (bisect notes, a merge-strategies notebook, and a second repo-scaffold template); prefer `Git/` for the main toolkit.*

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub, with deeper config sets in Ansible and Terraform and first-contact notes across the three clouds, ArgoCD, Helm, OpenTofu, and Prometheus. The latest additions are an AWS S3 static-site deployment script, a GitHub Actions `workflow_dispatch` trigger-and-poll snippet, a minimal gcloud config, and Trivy quickstart trip-up notes.

---
_Last updated: 2026-08-15_