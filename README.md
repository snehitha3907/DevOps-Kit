# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and snippets for the tools you reach for daily.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Files](https://img.shields.io/badge/files-93-blue)
![Python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/shell-4EAA25?logo=gnu-bash&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white)

## What's in here

First-contact notes, setup scripts, configs, and manifests for seven tool families a DevOps engineer reaches for every day: Ansible, Docker, Git, GitHub, GitLab CI, Kubernetes, and Terraform. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit is meant to be cloned and used as a quick-touch reference, not a tutorial site.

## Coverage

| Tool | Notes | Scripts | Snippets | Configs | Manifests | Docs | Dockerfiles | Notebooks | Templates |
|------|-------|---------|----------|---------|-----------|------|-------------|-----------|-----------|
| Ansible | 5 | 2 | 1 | 2 | — | 1 | — | 1 | — |
| Docker | 4 | 4 | — | 1 | 1 | 1 | 3 | 1 | — |
| Git | 4 | 8 | 1 | — | — | 3 | — | — | 3 |
| GitHub | 10 | 5 | 2 | 1 | — | — | — | — | — |
| GitLab CI | 1 | 1 | — | 1 | — | — | — | — | — |
| Kubernetes | 4 | 2 | — | — | 2 | — | — | — | — |
| Terraform | 3 | 2 | — | 7 | 1 | — | — | — | — |

## Quick links

- [Changelog from conventional commits](Git/scripts/changelog-from-conventional-commits.py) — Python script that parses conventional commit messages into a changelog.
- [Git hooks project scaffold](Git/templates/git-hooks/) — pre-commit, commit-msg, and post-checkout hook templates.
- [GitLab CI primer](GitLab%20CI/notes/0000-primer-gitlab-ci-cd.md) — Introduction to pipelines, runners, stages, jobs, and the `.gitlab-ci.yml` format.
- [GitLab CI first pipeline config](GitLab%20CI/configs/2026-06-22-first-pipeline.yaml) — Minimal `.gitlab-ci.yml` with a build and test stage.
- [GitLab CI runner setup script](GitLab%20CI/scripts/2026-06-22-install-runner-and-register.sh) — Script to install, configure, and register a GitLab Runner.

## Layout

- **Ansible/** — Primer notes, ad-hoc and playbook scripts, configs, snippets, docs, and a variable precedence notebook.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **Git/** — Primer, install notes, CLI exploration, scripts for branching and merge conflicts, commit snippets, hook templates, and docs.
- **GitHub/** — Primer notes, CLI and web UI scripts, configs, and Python API snippets.
- **GitLab CI/** — Primer notes, pipeline config, and runner setup script.
- **Kubernetes/** — Primer notes, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, install and bootstrap scripts, configs, a reusable S3 module, and manifests.
- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **CHANGELOG.md** — Kit-level change log.

## Status

Git and Ansible have the deepest coverage (L4 and L3 respectively). Docker, GitHub, and Kubernetes are filling in at L2. Terraform is at L1 with a reusable S3 module and EC2 manifest. GitLab CI was recently added with a primer, pipeline config, and runner setup script — more content to follow.

---
_Last updated: 2026-06-23_
