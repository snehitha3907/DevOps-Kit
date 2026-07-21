# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and manifests for Ansible, AWS, Azure, Docker, GCP, Git, GitHub, GitHub Actions, GitLab CI, Kubernetes, OpenTofu, Terraform, and Trivy.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for thirteen tool families and four foundational concept areas. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for the tools a DevOps engineer reaches for every day. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/` (CI/CD, Linux & system administration, networking fundamentals, and scripting & automation), a reusable S3 module for Terraform, and Jupyter notebooks for deeper dives into specific topics.

## Quick links

- [Ansible inventory and ping playbook](Ansible/configs/2026-07-19-first-inventory-and-ping-playbook.yaml) — Initial Ansible inventory with a ping test playbook.
- [Ansible nginx/PHP-FPM/UFW playbook](Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml) — Hardened Ubuntu web-server playbook with nginx, PHP-FPM, and UFW.
- [Scan Ansible for antipatterns](Ansible/scripts/scan-ansible-antipatterns.py) — Lint-style script that flags common Ansible antipatterns.
- [First kubectl version and pod from manifest](Kubernetes/notes/2026-07-19-first-kubectl-version-and-pod-from-manifest.md) — First kubectl version check and a pod created from a manifest.
- [Following Kubernetes Basics tutorial notes](Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md) — Notes from the official Kubernetes Basics tutorial using Minikube.
- [ConfigMap, Secret, and mounted pod manifest](Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml) — A Pod manifest mounting a ConfigMap and Secret via envFrom and secretKeyRef.
- [Ansible readme-verified note](docs/2026-07-19-ansible-notebooks-readme-verified.md) — Kit note recording verification of the Ansible notebook.

## Layout

- **CHANGELOG.md** — Version history and release notes for the kit.
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, docs, and a variable precedence notebook.
- **AWS/** — Primer, CLI install and configure scripts, and minimal config files with named profiles.
- **Azure/** — Primer, CLI install and login scripts, and resource group creation snippets.
- **docs/** — Kit-level operational notes and audit records.
- **docs/concepts/** — Foundational concept primers (CI/CD, Linux & system administration, networking fundamentals, scripting & automation) with hands-on scripts.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **GCP/** — Primer, gcloud CLI install and configure script, and a Compute/GCS listing snippet.
- **Git/** — Primer, install notes, CLI exploration, branching and merge conflict scripts, commit snippets, hook templates, and docs.
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs, and Python API snippets.
- **GitHub Actions/** — Quickstart notes and CI workflow configs with environment variables and secrets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and local pipeline runner.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, and pod lifecycle scripts.
- **OpenTofu/** — Primer, install script, and minimal config for the open-source Terraform alternative.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **Trivy/** — CLI exploration notes, container scanning scripts, and a Python wrapper snippet.
- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates | Last verified |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|---------------|
| Ansible | 5 | 4 | 4 | 1 | — | 1 | 1 | — | 1 | 2026-07-19 |
| AWS | 2 | 2 | 2 | — | — | — | — | — | — | 2026-07-13 |
| Azure | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-13 |
| Docker | 4 | 4 | 1 | — | 4 | 2 | 1 | 2 | — | — |
| GCP | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-17 |
| Git | 4 | 8 | — | 1 | — | 3 | — | — | 3 | — |
| GitHub | 10 | 6 | 1 | 2 | — | 1 | — | — | — | 2026-07-06 |
| GitHub Actions | 3 | 2 | 3 | — | — | — | — | — | — | 2026-07-13 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Kubernetes | 5 | 2 | — | — | — | — | — | 3 | — | 2026-07-21 |
| OpenTofu | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-18 |
| Terraform | 4 | 2 | 2 | — | — | 2 | 1 | 1 | — | — |
| Trivy | 2 | 2 | — | 1 | — | — | — | — | — | 2026-07-12 |
| Concepts | 4 | 3 | — | — | — | — | — | — | — | 2026-07-18 |

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub. Terraform includes a reusable S3 module, workspaces docs, and a for_each vs count comparison notebook. GitHub issue forms, label automation, and stale issue/PR automation configs are in place. Ansible has stabilised with playbook troubleshooting, ansible-lint integration, a variable precedence notebook, and an nginx/PHP-FPM/UFW hardening playbook. GitHub Actions has a primer, quickstart notes, install script, and pipeline configs; GitLab CI has quickstart notes, runner registration scripts, and local pipeline execution. Trivy has a primer, container scanning scripts, and a Python wrapper snippet. The three major clouds are represented at first-contact level — AWS, Azure, and GCP each have primer notes, CLI install scripts, and config or listing snippets. OpenTofu joins the lineup with a primer, install script, and minimal config. Foundational concept primers sit under `docs/concepts/` for CI/CD, Linux & system administration, networking fundamentals, and scripting & automation.

---
_Last updated: 2026-07-21_
