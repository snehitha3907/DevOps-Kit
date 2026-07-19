# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and manifests for 13 tool families: Ansible, AWS, Azure, Docker, GCP, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, OpenTofu, Terraform, and Trivy.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for Ansible, AWS, Azure, Docker, GCP, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, OpenTofu, Terraform, and Trivy. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for thirteen tool families a DevOps engineer reaches for every day. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/` (CI/CD, Linux & system administration, networking fundamentals, and scripting & automation), a reusable S3 module for Terraform, and Jupyter notebooks for digging deeper into specific topics.

## Quick links

- [Audit check — repo health verification](docs/2026-07-19-audit-004-check.md) — Records the outcome of the cycle's structural and coverage review.
- [OpenTofu primer](OpenTofu/notes/0000-primer-opentofu.md) — First-contact notes for OpenTofu, the open-source Terraform fork.
- [Install OpenTofu and verify](OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh) — Installs the OpenTofu CLI and confirms it's working.
- [Minimal local OpenTofu config](OpenTofu/configs/2026-07-18-minimal-local-config.tf) — Minimal configuration for local state testing with OpenTofu.
- [Linux filesystem permissions and process management](docs/concepts/linux-system-administration/2026-07-18-filesystem-permissions-and-process-management.sh) — Hands-on script practicing permission and process patterns.

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
- **OpenTofu/** — Primer notes, install script, and minimal config for the open-source Terraform alternative.
- **Terraform/** — Primer notes, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
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
| GCP | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-17 |
| Git | 4 | 8 | — | 1 | — | 3 | — | — | 3 | — |
| GitHub | 10 | 6 | 6 | 2 | — | 1 | — | — | — | 2026-07-06 |
| GitHub Actions | 3 | 2 | 3 | — | — | — | — | — | — | 2026-07-13 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Kubernetes | 4 | 2 | — | — | — | — | — | 2 | — | — |
| OpenTofu | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-18 |
| Terraform | 4 | 2 | 7 | — | — | 2 | 1 | 1 | — | — |
| Trivy | 2 | 2 | — | 1 | — | — | — | — | — | 2026-07-12 |
| Concepts | 4 | 2 | — | — | — | 1 | — | — | — | 2026-07-18 |

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub. Terraform includes a reusable S3 module, workspaces docs, and a for_each vs count comparison notebook. GitHub issue forms, label automation, and stale issue/PR automation configs are in place. Ansible has stabilised at L3 with playbook troubleshooting and ansible-lint integrated. GitHub Actions has a primer, quickstart notes, install script, and pipeline configs; GitLab CI has quickstart notes and pipeline configs. Trivy has a primer, container scanning scripts, and a Python wrapper snippet. The three major clouds are now represented at first-contact level — AWS, Azure, and GCP each have primer notes, CLI install scripts, and config or listing snippets. OpenTofu joins the lineup with a primer, install script, and minimal config. Foundational concept primers sit under `docs/concepts/` for CI/CD, Linux & system administration, networking fundamentals, and scripting & automation.

---
_Last updated: 2026-07-19_
