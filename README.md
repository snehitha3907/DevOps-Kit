# DevOps-Kit
> A working engineer's reference for Docker, Git, GitHub, Kubernetes, Terraform, and Ansible — notes, scripts, configs, and snippets.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Files](https://img.shields.io/badge/files-64-blue)
![Python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/shell-4EAA25?logo=gnu-bash&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white)

## What's in here

A collection of first-contact notes, setup scripts, and reference snippets for tools a DevOps engineer reaches for daily. Each tool directory follows a consistent layout — a primer, CLI exploration notes, and executable scripts to get from zero to running. Currently tracks six tools across 64 files.

## Coverage

| Tool       | Notes | Scripts | Snippets | Dockerfiles | Docs | Manifests | Configs |
|------------|-------|---------|----------|-------------|------|-----------|---------|
| Ansible    | 4     | 2       | 1        | —           | —    | —         | 1       |
| Docker     | 4     | 3       | —        | 2           | 1    | 1         | 1       |
| Git        | 4     | 3       | 1        | —           | —    | —         | —       |
| GitHub     | 5     | 4       | 2        | —           | —    | —         | 1       |
| Kubernetes | 3     | 2       | —        | —           | —    | 1         | —       |
| Terraform  | 3     | 2       | —        | —           | —    | 1         | 7       |

## Quick links

- [Ansible Docker + Python setup](Ansible/configs/docker-python-setup.yaml) — Playbook for configuring Docker and Python on managed nodes.
- [Ansible playbook troubleshooting](Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md) — Debugging SSH, pipx, and permission issues in playbooks.
- [Docker web + database manifest](Docker/manifests/2026-06-13-web-db-compose.yaml) — Compose manifest for nginx web service with PostgreSQL.
- [Terraform local config with vars](Terraform/configs/2026-06-12-tried-local-with-vars.tf) — Local provider configuration with variables and outputs.
- [Terraform bootstrap script](Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh) — Script to bootstrap a structured Terraform project.

## Layout

- **Ansible/** — Primer notes, getting-started notes, ad-hoc and playbook scripts, and snippets.
- **Docker/** — Primer, CLI notes, configs, dockerfiles, docs, scripts, and compose multi-service script.
- **Git/** — Primer, install notes, CLI exploration, install script, commit snippet, branching workflow, and merge conflict practice.
- **GitHub/** — Primer notes, configs, scripts for CLI and web UI, and Python snippets.
- **Kubernetes/** — Primer notes, kubectl exploration, tutorial notes, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, getting-started notes, install and bootstrap scripts, configs, reusable module, and manifests.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

## Status

Active coverage of six tools at various stages — Git, Docker, and Terraform at ongoing L3 depth; Kubernetes at L2; Ansible and GitHub building out L3. New material added daily as tool exploration continues.

---
_Last updated: 2026-06-13_
