# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and manifests for Ansible, ArgoCD, AWS, Azure, Docker, GCP, Git, GitHub, GitHub Actions, GitLab CI, Helm, Kubernetes, OpenTofu, Prometheus, Terraform, and Trivy.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for sixteen tool families and seven foundational concept areas. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests for the tools a DevOps engineer reaches for every day. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and manifests or snippets picked up along the way. The kit also includes foundational concept primers under `docs/concepts/` (CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, and version control), a reusable S3 module for Terraform, and Jupyter notebooks for deeper dives into specific topics.

## Quick links

- [Ansible collection requirements and Docker lifecycle playbook](Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml) — Declares community.docker, community.general, and ansible.posix collections, plus a playbook scaffold for a Docker container lifecycle.
- [Helm chart inspection walkthrough](Helm/configs/2026-07-23-first-helm-chart-inspection.yaml) — Inspecting a published Helm chart's values, templates, and structure.
- [Prometheus primer](Prometheus/notes/0000-primer-prometheus.md) — First-contact notes for the metrics collection and alerting system.
- [Prometheus install and verify metrics script](Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh) — Install Prometheus, start the server, and verify metrics are being collected.
- [ArgoCD first application manifest](ArgoCD/configs/2026-07-23-first-application-manifest.yaml) — First ArgoCD Application manifest for deploying a project from Git.

## Layout

- **CHANGELOG.md** — Version history and release notes for the kit.
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, docs, and a variable precedence notebook.
- **ArgoCD/** — Primer and first application manifest for GitOps deployment on Kubernetes.
- **AWS/** — Primer, CLI install and configure scripts, and minimal config files with named profiles.
- **Azure/** — Primer, CLI install and login scripts, and resource group creation snippets.
- **docs/** — Kit-level operational notes and audit records.
- **docs/concepts/** — Foundational concept primers (CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, version control) with hands-on scripts.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, and a networking drivers notebook.
- **GCP/** — Primer, gcloud CLI install and configure script, and a Compute/GCS listing snippet.
- **Git/** — Primer, install notes, CLI exploration, branching and merge conflict scripts, commit snippets, hook templates, and docs.
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs, and Python API snippets.
- **GitHub Actions/** — Quickstart notes and CI workflow configs with environment variables and secrets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and local pipeline runner.
- **Helm/** — Primer, install and explore CLI script, chart inspection walkthrough, and docs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, pod lifecycle scripts, ingress docs, and a troubleshooting snippet.
- **OpenTofu/** — Primer, install script, and minimal config for the open-source Terraform alternative.
-  **Prometheus/** — Prometheus primer with first-contact notes for metrics collection and alerting; install and verify script; minimal scrape config.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, docs, notebooks, and manifests.
- **Trivy/** — CLI exploration notes, container scanning scripts, and a Python wrapper snippet.
- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Dockerfiles | Docs | Notebooks | Manifests | Templates | Last verified |
|------|-------|---------|---------|----------|-------------|------|-----------|-----------|-----------|---------------|
| Ansible | 5 | 4 | 7 | 1 | — | 1 | 1 | — | 1 | 2026-07-25 |
| ArgoCD | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| AWS | 2 | 2 | 2 | — | — | — | — | — | — | 2026-07-13 |
| Azure | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-13 |
| Docker | 4 | 4 | 1 | — | 6 | 2 | 1 | 2 | — | — |
| GCP | 1 | 1 | — | 1 | — | — | — | — | — | 2026-07-17 |
| Git | 4 | 8 | — | 1 | — | 3 | — | — | 3 | — |
| GitHub | 10 | 6 | 6 | 2 | — | 1 | — | — | — | 2026-07-08 |
| GitHub Actions | 3 | 2 | 3 | — | — | — | — | — | — | — |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Helm | 1 | 1 | 1 | — | — | 3 | — | — | — | 2026-07-25 |
| Kubernetes | 5 | 2 | — | 1 | — | 1 | — | 3 | — | 2026-07-22 |
| OpenTofu | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-18 |
| Prometheus | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| Terraform | 4 | 2 | 7 | — | — | 2 | 1 | 1 | — | — |
| Trivy | 2 | 2 | — | 1 | — | — | — | — | — | 2026-07-12 |

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub. Terraform includes a reusable S3 module, workspaces docs, and a for_each vs count comparison notebook. GitHub issue forms, label automation, and stale issue/PR automation configs are in place. Ansible has stabilised with playbook troubleshooting, ansible-lint integration, a variable precedence notebook, collection requirements, and a Docker lifecycle playbook. ArgoCD and Prometheus have joined with first-contact primers, install scripts, and initial manifests or scrape configs. Helm has a primer, install script, three docs, and a chart inspection config. Kubernetes added ingress docs and a pod troubleshooting snippet. GitHub Actions and GitLab CI each have quickstart notes and pipeline configs. Trivy has a primer, container scanning scripts, and a Python wrapper snippet. The three major clouds are represented at first-contact level — AWS, Azure, and GCP each have primer notes, CLI install scripts, and config or listing snippets. OpenTofu has a primer, install script, and minimal config. Foundational concept primers sit under `docs/concepts/` for CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, and version control.

---

_Last updated: 2026-07-27_
