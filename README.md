# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and snippets for the tools you reach for daily.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Files](https://img.shields.io/badge/files-77-blue)
![Python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/shell-4EAA25?logo=gnu-bash&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white)

## What's in here

First-contact notes, setup scripts, configs, and manifests for six tool families a DevOps engineer reaches for every day: Ansible, Docker, Git, GitHub, Kubernetes, and Terraform. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit is meant to be cloned and used as a quick-touch reference, not a tutorial site.

## Coverage

| Tool | Notes | Scripts | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Configs |
|------|-------|---------|----------|-------------|------|-----------|-----------|---------|
| Ansible | 4 | 2 | 1 | — | 1 | 1 | — | 2 |
| Docker | 4 | 3 | — | 3 | 1 | — | 1 | 1 |
| General | — | — | — | — | 3 | — | — | — |
| Git | 4 | 3 | 1 | — | — | — | — | — |
| GitHub | 8 | 5 | 2 | — | — | — | — | 1 |
| Kubernetes | 4 | 2 | — | — | — | — | 2 | — |
| Terraform | 3 | 2 | — | — | — | — | 1 | 7 |

## Quick links

- [GitHub flow walkthrough](GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md) — Following the Hello World guide and GitHub flow from scratch.
- [ConfigMap + Secret mounted Pod](Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml) — Pod manifest with ConfigMap and Secret volume mounts.
- [Kubernetes Basics tutorial](Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md) — Notes from the official Kubernetes Basics interactive tutorial.
- [Ansible variable precedence notebook](Ansible/notebooks/ansible-variable-precedence.ipynb) — Jupyter notebook comparing variable precedence rules.
- [Wiring ansible-lint](Ansible/docs/2026-06-15-wiring-ansible-lint.md) — Integrating ansible-lint into the playbook workflow.

## Layout

- **Ansible/** — Primer notes, ad-hoc and playbook scripts, configs, snippets, and a variable precedence notebook.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, and scripts.
- **Git/** — Primer, install notes, CLI exploration, scripts for branching and merge conflicts, and a commit snippet.
- **GitHub/** — Primer notes, CLI and web UI scripts, configs, and Python API snippets.
- **General/** — Project-level cleanup and rework documentation.
- **Kubernetes/** — Primer notes, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, install and bootstrap scripts, configs, a reusable S3 module, and manifests.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

## Status

Currently working through L1 first-contact notes for the remaining tool families. Coverage is strongest on Docker, Git, and GitHub; Kubernetes and Terraform are filling in. Ansible has stabilised at L3 with playbook troubleshooting notes and an ansible-lint workflow integrated.

---
_Last updated: 2026-06-16_
