# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and manifests for Ansible, AWS, Azure, Docker, GCP, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for Ansible, AWS, Azure, Docker, GCP, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for twelve tool families a DevOps engineer reaches for every day. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/` (CI/CD, Linux & system administration, networking fundamentals, and scripting & automation), a reusable S3 module for Terraform, and Jupyter notebooks for digging deeper into specific topics.

## Quick links

- [GCP primer](GCP/notes/0000-primer-gcp.md) — First-contact notes for the Google Cloud SDK (`gcloud`, `gsutil`, `bq`).
- [Install gcloud CLI and configure credentials](GCP/scripts/2026-07-16-install-gcloud-cli-and-configure-creds.sh) — Installs the Google Cloud SDK and sets up authenticated access.
- [List Compute and GCS with gcloud](GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh) — Lists Compute Engine instances and Cloud Storage buckets in a project.
- [Azure primer](Azure/notes/0000-primer-azure.md) — First-contact notes for the Azure CLI, resource groups, and regions.
- [Install Azure CLI and login](Azure/scripts/2026-07-13-install-azure-cli-and-login.sh) — Installs the Azure CLI and authenticates a session.

## Layout

- **Ansible/** — Primer notes, ad-hoc and playbook scripts, configs, snippets, docs, and a variable precedence notebook.
- **AWS/** — Primer notes, CLI install and configure scripts, and minimal config files with named profiles.
- **Azure/** — Primer notes, CLI install and login scripts, and resource group creation snippets.
- **docs/** — Kit-level operational notes and audit records.
- **docs/concepts/** — Foundational concept primers (CI/CD, Linux & system administration, networking fundamentals, scripting & automation).
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **GCP/** — Primer notes, gcloud CLI install and configure script, and a Compute/GCS listing snippet.
- **Git/** — Primer, install notes, CLI exploration, scripts for branching and merge conflicts, commit snippets, hook templates, and docs.
- **GitHub/** — Primer notes, CLI and web UI scripts, configs, docs, and Python API snippets.
- **GitHub Actions/** — Quickstart notes and CI workflow configs with environment variables and secrets.
- **GitLab CI/** — Primer notes, install and register runner scripts, pipeline configs, quickstart follow-ups, and local pipeline runner.
- **Kubernetes/** — Primer notes, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **OpenTofu/** — Primer notes, install and verify script, and a minimal local config.
- **Trivy/** — CLI exploration notes, container scanning scripts, and a Python wrapper snippet.
- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **CHANGELOG.md** — Kit-level change log.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates | Last verified |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|---------------|
| Ansible | 5 | 2 | 2 | 1 | — | 1 | 1 | — | — | — |
| AWS | 2 | 2 | 2 | — | — | — | — | — | — | 2026-07-13 |
| Azure | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-13 |
| Docker | 4 | 4 | 1 | — | 6 | 2 | 1 | 2 | — | — |
| GCP | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-16 |
| Git | 4 | 8 | — | 1 | — | 3 | — | — | 3 | — |
| GitHub | 10 | 6 | 6 | 2 | — | 1 | — | — | — | 2026-07-06 |
| GitHub Actions | 3 | 2 | 3 | — | — | — | — | — | — | 2026-07-13 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Kubernetes | 4 | 2 | — | — | — | — | — | 2 | — | — |
| Terraform | 4 | 2 | 7 | — | — | 2 | 1 | 1 | — | — |
| OpenTofu | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-19 |
| Trivy | 2 | 2 | — | 1 | — | — | — | — | — | 2026-07-12 |
| Concepts | 4 | — | — | — | — | 1 | — | — | — | 2026-07-12 |

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub. Terraform includes a reusable S3 module, workspaces docs, and a for_each vs count comparison notebook. OpenTofu joins the kit at first-contact level with a primer, install script, and minimal config. GitHub issue forms, label automation, and stale issue/PR automation configs are in place. Ansible has stabilised at L3 with playbook troubleshooting and ansible-lint integrated. GitHub Actions has a primer, quickstart notes, install script, and pipeline configs; GitLab CI has quickstart notes and pipeline configs. Trivy has a primer, container scanning scripts, and a Python wrapper snippet. The three major clouds are now represented at first-contact level — AWS, Azure, and GCP each have primer notes, CLI install scripts, and config or listing snippets. Foundational concept primers sit under `docs/concepts/` for CI/CD, Linux & system administration, networking fundamentals, and scripting & automation.

---
_Last updated: 2026-07-17_
