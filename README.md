# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and snippets for the tools you reach for daily.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Files](https://img.shields.io/badge/files-89-blue)
![Python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/shell-4EAA25?logo=gnu-bash&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white)

## What's in here

First-contact notes, setup scripts, configs, and manifests for eight tool families a DevOps engineer reaches for every day: Ansible, Docker, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, and Terraform. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/`. It's meant to be cloned and used as a quick-touch reference, not a tutorial site.

## Coverage

| Tool | Notes | Scripts | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Configs | Templates |
|------|-------|---------|----------|-------------|------|-----------|-----------|---------|-----------|
| Ansible | 4 | 2 | 1 | — | 1 | 1 | — | 2 | — |
| Concepts | 1 | — | — | — | — | — | — | — | — |
| Docker | 4 | 4 | — | 3 | 1 | 1 | 1 | 1 | — |
| General | — | — | — | — | 5 | — | — | — | — |
| Git | 4 | 7 | 1 | — | 2 | — | — | — | 3 |
| GitHub | 9 | 5 | 2 | — | — | — | — | 1 | — |
| GitHub Actions | 1 | — | — | — | — | — | — | — | — |
| GitLab CI | 1 | 1 | — | — | — | — | — | 1 | — |
| Kubernetes | 4 | 2 | — | — | — | — | 2 | — | — |
| Terraform | 3 | 2 | — | — | — | — | 1 | 7 | — |

## Quick links

- [Changelog from conventional commits](Git/scripts/changelog-from-conventional-commits.py) — Python script that parses conventional commit messages into a changelog.
- [Git hooks project scaffold](Git/templates/git-hooks/) — pre-commit, commit-msg, and post-checkout hook templates.
- [Batch git operations](Git/scripts/batch-git-ops.sh) — Script for running git commands across multiple repos.
- [Ansible variable precedence notebook](Ansible/notebooks/ansible-variable-precedence.ipynb) — Jupyter notebook comparing variable precedence rules.
- [Wiring ansible-lint](Ansible/docs/2026-06-15-wiring-ansible-lint.md) — Integrating ansible-lint into the playbook workflow.

## Layout

- **Ansible/** — Primer notes, ad-hoc and playbook scripts, configs, snippets, docs, and a variable precedence notebook.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **docs/concepts/** — Foundational concept primers (CI/CD, version control, IaC, etc.).
- **Git/** — Primer, install notes, CLI exploration, scripts for branching and merge conflicts, commit snippets, hook templates, and docs.
- **GitHub Actions/** — Primer and quickstart notes for GitHub Actions workflows.
- **GitLab CI/** — Primer notes, install and register runner scripts, and pipeline configs.
- **GitHub/** — Primer notes, CLI and web UI scripts, configs, and Python API snippets.
- **General/** — Project-level cleanup and rework documentation.
- **Kubernetes/** — Primer notes, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, install and bootstrap scripts, configs, a reusable S3 module, and manifests.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

## Status

Currently working through L1 first-contact notes for the remaining tool families. Coverage is strongest on Docker, Git, and GitHub; Kubernetes and Terraform are filling in. Ansible has stabilised at L3 with playbook troubleshooting notes and an ansible-lint workflow integrated. Git templates and changelog automation have been added. Foundational concept primers under `docs/concepts/` have started with CI/CD. GitHub Actions coverage has begun with quickstart notes.

---
_Last updated: 2026-06-23_