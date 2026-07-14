# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and manifests for Ansible, AWS, Azure, Docker, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for Ansible, AWS, Azure, Docker, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, Terraform, and Trivy. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for eleven tool families a DevOps engineer reaches for every day. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and any manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/` (CI/CD, Linux & system administration, networking fundamentals, and scripting & automation), a reusable S3 module for Terraform, and Jupyter notebooks for digging deeper into specific topics.

## Quick links

- [Azure primer](Azure/notes/0000-primer-azure.md) — First-contact notes for Azure CLI.
- [Azure CLI install script](Azure/scripts/2026-07-13-install-azure-cli-and-login.sh) — Install Azure CLI and authenticate.
- [Azure resource group snippet](Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh) — Create resource groups and list regions.
- [AWS config profile](AWS/configs/2026-07-13-minimal-aws-config.ini) — Minimal AWS CLI config with named profiles.
- [AWS primer flag note](AWS/notes/2026-07-13-primer-already-exists.md) — Noting the AWS primer already exists.

## Layout

- **Ansible/** — Primer notes, ad-hoc and playbook scripts, configs, an nginx snippet, linting docs, and a variable precedence notebook.
- **AWS/** — CLI primer, install and configure scripts, and config profiles.
- **Azure/** — CLI primer, install and login script, and a resource group snippet.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **docs/concepts/** — Foundational concept primers (CI/CD, Linux & system administration, networking fundamentals, scripting & automation).
- **Git/** — Primer, install notes, CLI exploration, branching and merge scripts, commit snippets, hook templates, and docs.
- **GitHub/** — Primer notes, CLI and web UI scripts, repo configs, docs, and Python API snippets.
- **GitHub Actions/** — Primer, quickstart notes, install scripts, and CI workflow configs.
- **GitLab CI/** — Primer, quickstart notes, runner install script, and pipeline configs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
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
| Git | 4 | 8 | — | 1 | — | 3 | — | — | 3 | — |
| GitHub | 10 | 6 | 6 | 2 | — | 1 | — | — | — | 2026-07-06 |
| GitHub Actions | 3 | 2 | 3 | — | — | — | — | — | — | 2026-07-13 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Kubernetes | 4 | 2 | — | — | — | — | — | 2 | — | — |
| Terraform | 4 | 2 | 7 | — | — | 2 | 1 | 1 | — | — |
| Trivy | 2 | 2 | — | 1 | — | — | — | — | — | 2026-07-12 |
| Concepts | 4 | — | — | — | — | — | — | — | — | 2026-07-12 |

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub. Terraform includes a reusable S3 module, workspaces docs, and a for_each vs count comparison notebook. Ansible has stabilised at L3 with playbook troubleshooting and ansible-lint integrated. GitHub Actions now has a primer, quickstart notes, install scripts, and pipeline configs. GitLab CI coverage has begun with quickstart notes and pipeline configs. Trivy has a primer, container scanning scripts, and a Python wrapper snippet. AWS has been added with CLI primer, install script, and config profiles. Azure has been added with CLI primer, install script, and resource group snippet. Foundational concept primers have been added under `docs/concepts/` for CI/CD, Linux & system administration, networking fundamentals, and scripting & automation.

---
_Last updated: 2026-07-14_
