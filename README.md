# DevOps-Kit
> A working DevOps engineer's quick-reference for Docker, Kubernetes, Terraform, Ansible, Git, and the cloud-native toolchain.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for sixteen tool families across infrastructure provisioning, configuration management, containers, orchestration, CI/CD, and security scanning. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and manifests or snippets picked up along the way. Foundational concept primers under `docs/concepts/` (CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, and version control) ground the tool-specific material, and Jupyter notebooks go deeper on specific topics. The lowercase `git/` directory mirrors a subset of `Git/` (bisect notes, a merge-strategies notebook, and a second repo-scaffold template); prefer `Git/` for the main toolkit. Recent work has centred on Ansible role scaffold templates, multi-server deployment manifests, Bash scripting patterns for config parsing with jq, GitHub repository documentation, and a PR-checker workflow.

## Quick links

- [Multi-server deployment manifest](Ansible/manifests/multi-server-deployment.yaml) — Ansible manifest for a multi-server deployment with load balancer and database roles.
- [Ansible role scaffold template](Ansible/templates/ansible-role/roles/myrole/README.md) — Reusable Ansible role scaffold with Molecule testing setup and standard role directory layout.
- [Group vars and inventory](Ansible/manifests/group_vars/all.yaml) — Shared Ansible variables and production inventory for the multi-server deployment.
- [Config parsing with jq and retry patterns](docs/concepts/scripting-automation-bash-python/scripts/2026-08-23-config-parsing-jq-retry.sh) — A Bash script that ties together config parsing, jq filtering, and retry-with-backoff patterns.
- [Document GitHub docs in README](GitHub/docs/2026-08-22-document-github-docs-in-readme.md) — Notes on documenting the GitHub docs folder in the kit README.

## Layout

- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **AWS/** — Primer, CLI install and configure scripts, EC2 tagging and S3 static-site snippets, and minimal config files with named profiles.
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, docs, and a variable precedence notebook.
- **ArgoCD/** — Primer, quickstart notes, and first application and ApplicationSet manifests for GitOps deployment on Kubernetes.
- **Azure/** — Primer, CLI install and login scripts, quickstart trip-up notes, and resource group and storage account provisioning snippets.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, a networking drivers notebook, and a reusable Go microservice scaffold.
- **GCP/** — Primer, gcloud CLI install and configure script, Compute/GCS listing snippet, and a minimal config with a startup script.
- **Git/** — Primer, install notes, CLI exploration, branching and merge-conflict scripts, commit snippets, hook and repository-scaffold templates, docs, and a merge-strategies notebook.
- **git/** — Companion lowercase directory mirroring a subset of `Git/` (bisect notes, a merge-strategies notebook, and a second repo-scaffold template); prefer `Git/` for the main toolkit.
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs (deploy-keys vs fine-grained PATs guide, branch protection and required reviews), and Python API snippets.
- **GitHub Actions/** — Quickstart notes, CI workflow configs, and REST API snippets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and a local pipeline runner.
- **Helm/** — Primer, install and explore CLI script, chart inspection walkthrough, custom-values snippet, and docs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, pod lifecycle scripts, ingress docs, and troubleshooting snippets.
- **OpenTofu/** — Primer, install script using the official get.opentofu.org installer, and minimal local config with variables and outputs for the open-source Terraform alternative.
- **Prometheus/** — Primer, install and verify script, and a minimal scrape config for metrics collection.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **Trivy/** — Primer, CLI exploration notes, container scanning scripts, a config file, and Python wrappers.
- **docs/** — Foundational concept primers, kit-level operational notes, and internal audit records.
- **CHANGELOG.md** — Chronological record of additions, reworks, and audit fixes.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Docs | Notebooks | Manifests | Templates | Dockerfiles | Last verified |
|------|-------|---------|---------|----------|------|-----------|-----------|-----------|-------------|---------------|
| Ansible | 7 | 4 | 7 | 2 | 2 | 1 | 8 | 14 | 1 | 2026-08-24 |
| ArgoCD | 2 | 1 | 2 | — | — | — | — | — | — | 2026-08-11 |
| AWS | 2 | 5 | 2 | 2 | — | — | — | — | — | 2026-08-16 |
| Azure | 3 | 2 | — | 2 | — | — | — | — | — | 2026-08-23 |
| Docker | 5 | 5 | 1 | 2 | 3 | 1 | 5 | 6 | 7 | 2026-08-12 |
| GCP | 1 | 2 | 1 | 2 | — | — | — | — | — | 2026-08-23 |
| Git | 4 | 8 | — | 1 | 5 | 1 | — | 21 | — | 2026-08-03 |
| GitHub | 10 | 6 | 7 | 3 | 4 | 1 | — | — | — | 2026-08-23 |
| GitHub Actions | 3 | 2 | 4 | 1 | 1 | — | — | — | — | 2026-08-15 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Helm | 2 | 1 | 1 | 1 | 3 | — | — | — | — | 2026-08-11 |
| Kubernetes | 6 | 2 | 1 | 1 | 1 | 1 | 3 | — | — | 2026-08-12 |
| OpenTofu | 2 | 1 | 1 | — | — | — | — | — | — | 2026-08-21 |
| Prometheus | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| Terraform | 5 | 3 | 7 | 2 | 3 | 1 | 1 | — | — | 2026-08-22 |
| Trivy | 3 | 2 | 1 | 2 | — | — | — | — | — | 2026-08-16 |

*Rows follow the on-disk tool directories. `Last verified` is the most recent `last_verified` stamp found in that tool's docs, configs, and scripts. The lowercase `git/` directory mirrors a subset of `Git/` (bisect notes, a merge-strategies notebook, and a second repo-scaffold template); prefer `Git/` for the main toolkit.*

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub, with deeper config sets in Ansible and Terraform and first-contact notes across the three clouds, ArgoCD, Helm, OpenTofu, and Prometheus. Recent work has centred on Ansible role scaffold templates and multi-server deployment manifests, Bash scripting patterns for config parsing with jq, GitHub repository documentation, and a PR-checker workflow. The Trivy wrapper that fails a build when a scan surfaces a critical CVE remains the security entry point.

---
_Last updated: 2026-08-24_
