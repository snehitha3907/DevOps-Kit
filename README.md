# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and manifests for Ansible, Docker, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Files](https://img.shields.io/badge/files-103-blue)
![Python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/shell-4EAA25?logo=gnu-bash&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white)

## What's in here

First-contact notes, setup scripts, configs, and manifests for nine tool families a DevOps engineer reaches for every day: Ansible, Docker, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit also includes a foundational CI/CD concepts primer under `docs/concepts/` and a reusable S3 module for Terraform. It's meant to be cloned and used as a quick-touch reference, not a tutorial site.

## Coverage

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|
| Ansible | 5 | 2 | 2 | 1 | — | 1 | 1 | — | — |
| Concepts | 1 | — | — | — | — | — | — | — | — |
| Docker | 4 | 4 | 1 | — | 4 | 1 | 1 | 1 | — |
| Git | 4 | 8 | — | 1 | — | 3 | — | — | 3 |
| GitHub | 10 | 5 | 1 | 2 | — | — | — | — | — |
| GitHub Actions | 1 | — | 1 | — | — | — | — | — | — |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — |
| Kubernetes | 4 | 2 | — | — | — | — | — | 2 | — |
| Terraform | 4 | 2 | 7 | — | — | — | — | 1 | — |
| Trivy | 1 | — | — | — | — | — | — | — | — |

## Quick links

- [Multi-stage Go HTTP server Dockerfile](Docker/dockerfiles/multi-stage-go-http-server.Dockerfile) — Multi-stage build for a Go HTTP server with an optimised production image.
- [GitLab CI quickstart notes](GitLab%20CI/notes/2026-06-24-following-gitlab-ci-quickstart.md) — Notes following the GitLab CI quickstart guide with pipeline stages.
- [Run first local pipeline script](GitLab%20CI/scripts/2026-06-24-run-first-local-pipeline.sh) — Script to run a GitLab pipeline locally using the CLI.
- [Changelog from conventional commits](Git/scripts/changelog-from-conventional-commits.py) — Python script that parses conventional commit messages into a changelog.
- [Git hooks project scaffold](Git/templates/git-hooks/) — pre-commit, commit-msg, and post-checkout hook templates.

## Layout

- **Ansible/** — Primer notes, ad-hoc and playbook scripts, configs, snippets, docs, and a variable precedence notebook.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **docs/concepts/** — Foundational concept primers (CI/CD currently).
- **Git/** — Primer, install notes, CLI exploration, scripts for branching and merge conflicts, commit snippets, hook templates, and docs.
- **GitHub Actions/** — Quickstart notes and a first CI workflow config with environment variables and secrets.
- **GitHub/** — Primer notes, CLI and web UI scripts, configs, and Python API snippets.
- **GitLab CI/** — Primer notes, install and register runner scripts, and pipeline configs.
- **Kubernetes/** — Primer notes, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, install and bootstrap scripts, configs, a reusable S3 module, and manifests.
- **Trivy/** — CLI exploration notes for vulnerability scanning.
- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **CHANGELOG.md** — Kit-level change log.

## Status

Coverage is strongest on Docker, Git, and GitHub. Ansible has stabilised at L3 with playbook troubleshooting and ansible-lint integrated. Terraform now has a reusable S3 module. GitHub Actions and GitLab CI coverage has begun with quickstart notes and pipeline configs. Trivy CLI exploration notes have been added. The CI/CD concepts primer has been added under `docs/concepts/`. Working through L1 first-contact notes for remaining tool families.

---
_Last updated: 2026-06-26_
