# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and manifests for Ansible, Docker, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Files](https://img.shields.io/badge/files-111-blue)
![Python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/shell-4EAA25?logo=gnu-bash&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white)

## What's in here

First-contact notes, setup scripts, configs, and manifests for nine tool families a DevOps engineer reaches for every day: Ansible, Docker, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit also includes a foundational CI/CD concepts primer under `docs/concepts/`, a reusable S3 module for Terraform, and Jupyter notebooks for digging deeper into specific topics. It's meant to be cloned and used as a quick-touch reference, not a tutorial site.

## Coverage

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|
| Ansible | 5 | 2 | 2 | 1 | — | 1 | 1 | — | — |
| Docker | 4 | 4 | 1 | — | 4 | 2 | 1 | 2 | — |
| Git | 4 | 8 | — | 1 | — | 3 | — | — | 3 |
| GitHub | 10 | 6 | 1 | 2 | — | 1 | — | — | — |
| GitHub Actions | 1 | — | 1 | — | — | — | — | — | — |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — |
| Kubernetes | 4 | 2 | — | — | — | — | — | 2 | — |
| Terraform | 4 | 2 | 7 | — | — | 1 | 1 | 1 | — |
| Trivy | 1 | 1 | — | — | — | — | — | — | — |
| Concepts | 1 | — | — | — | — | — | — | — | — |

## Quick links

- [Terraform for_each vs count notebook](Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb) — Jupyter notebook comparing `for_each` and `count` for conditional resource creation.
- [Terraform workspaces and remote state locking](Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md) — Guide to Terraform workspaces and remote state with S3 and DynamoDB.
- [Go + Redis compose with health checks](Docker/manifests/2026-06-28-go-redis-compose-healthchecks.yaml) — Docker Compose manifest for a Go HTTP server with Redis and health checks.
- [Deploy keys vs fine-grained PATs for CI/CD](GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md) — Comparison of GitHub deploy keys and fine-grained PATs for CI/CD access.
- [Repo provisioning with GitHub API](GitHub/scripts/provision-repo-with-api.py) — Python script to create, protect, and add collaborators to a GitHub repository.

## Layout

- **Ansible/** — Primer notes, ad-hoc and playbook scripts, configs, snippets, docs, and a variable precedence notebook.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **docs/concepts/** — Foundational concept primers (CI/CD currently).
- **Git/** — Primer, install notes, CLI exploration, scripts for branching and merge conflicts, commit snippets, hook templates, and docs.
- **GitHub Actions/** — Quickstart notes and a first CI workflow config with environment variables and secrets.
- **GitHub/** — Primer notes, CLI and web UI scripts, configs, docs, and Python API snippets.
- **GitLab CI/** — Primer notes, install and register runner scripts, pipeline configs, quickstart follow-ups, and local pipeline runner.
- **Kubernetes/** — Primer notes, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **Trivy/** — CLI exploration notes and scripts for container image vulnerability scanning.
- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **CHANGELOG.md** — Kit-level change log.

## Status

Coverage is strongest on Docker, Git, and GitHub. Terraform now includes a reusable S3 module, workspaces docs, and a for_each vs count comparison notebook. Ansible has stabilised at L3 with playbook troubleshooting and ansible-lint integrated. GitHub Actions and GitLab CI coverage has begun with quickstart notes and pipeline configs. Trivy CLI exploration and container scanning scripts have been added. The CI/CD concepts primer has been added under `docs/concepts/`. Working through L1 first-contact notes for remaining tool families.

---
_Last updated: 2026-07-02_
