# DevOps-Kit
> A working DevOps engineer's shelf for cloud CLIs, containers, orchestration, infrastructure as code, CI/CD, observability, and security scanning.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable examples, and configs for the tools you reach for while building and operating systems. Use it as a shelf to grab a primer, verify a command, or borrow a concrete manifest. It is not a tutorial site and does not replace each tool's official documentation.

## What's in here

The kit covers 19 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Shared concept primers in `docs/concepts/` connect the foundations behind the tool-specific material.

## Quick links

- [Comparing Docker Compose, Swarm, and Kubernetes for local orchestration](Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb) — Scaffolds the same demo app in all three formats and compares them structurally, so the trade-offs are visible side by side.
- [Minimal GitLab pipeline with stages, cache, and artifacts](GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml) — Three stages with a pip cache and test artifacts wired together in one scratch-project config.
- [Trigger a GitLab pipeline and poll its jobs](GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh) — Kicks off a pipeline via the API and watches it from the terminal instead of keeping the browser open.
- [GitHub repository scaffold](GitHub/templates/github-repo-scaffold/README.md) — Production-ready repo template: branch protection, CODEOWNERS, issue and PR templates, and Dependabot.
- [GitLab runner setup, variables, and artifacts trip-ups](GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md) — The layer after the quickstart: self-hosted runner registration, CI/CD variables, caching, and stage artifacts.

## Layout

- **00_index/** — Topics, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, and S3 website examples.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, installation, and sync checks.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, and a private AKS Bicep example.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, Compose-vs-Swarm-vs-Kubernetes comparison, build patterns, health checks, and Go service scaffolds.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, and startup scripts.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, runner setup, and dispatch examples.
- **GitLab CI/** — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline config, and an API trigger snippet.
- **Helm/** — Chart inspection, values files, values-management approaches, Redis chart manifests, release testing, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, and Helm/Kustomize overlays.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, and verification.
- **Prometheus/** — Scrape configuration, target health checks, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, severity policies, and Python wrappers.
- **vlt/** — HashiCorp Vault primer, dev server setup, and KV engine examples.
- **plm/** — Pulumi primer, CLI install + project init, and minimal Python bucket snippet.
- **docs/** — Foundational concept primers and supporting kit notes.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|---------|---------|----------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | — | 5 | 2 | 2 | — | — | — | — | 2026-07-13 |
| Ansible | 10 | 4 | 4 | 8 | 2 | 8 | 2 | 1 | 48 | 2026-09-16 |
| ArgoCD | 3 | — | 1 | 2 | 1 | — | — | — | — | 2026-08-11 |
| Azure | 4 | 1 | 3 | — | 3 | 1 | — | — | — | 2026-09-19 |
| Docker | 6 | 6 | 5 | 1 | 2 | 5 | 2 | 8 | 6 | 2026-09-09 |
| Flux CD | 1 | — | 1 | — | — | — | — | — | — | 2026-09-19 |
| GCP | 1 | — | 3 | 2 | 2 | — | — | — | — | 2026-07-17 |
| Git | 8 | 13 | 9 | — | 1 | — | 1 | — | 22 | 2026-09-17 |
| GitHub | 11 | 5 | 6 | 7 | 3 | — | 1 | — | 8 | 2026-09-19 |
| GitHub Actions | 6 | 5 | 3 | 5 | 1 | — | — | — | — | 2026-09-11 |
| GitLab CI | 4 | — | 2 | 2 | 1 | — | — | — | — | 2026-09-19 |
| Helm | 3 | 4 | 3 | 4 | 1 | 4 | 1 | — | — | 2026-09-18 |
| Kubernetes | 9 | 4 | 2 | 1 | 2 | 5 | 2 | — | 10 | 2026-09-04 |
| OpenTofu | 2 | 3 | 2 | 2 | — | — | 1 | — | — | 2026-09-18 |
| Prometheus | 2 | — | 1 | 2 | 1 | — | — | — | — | 2026-09-05 |
| Terraform | 6 | 4 | 3 | 8 | 3 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | — | 2 | 2 | 2 | — | — | — | — | 2026-09-02 |
| HashiCorp Vault | 2 | 1 | 1 | — | — | — | — | — | — | 2026-09-19 |
| Pulumi | 1 | — | 1 | — | 1 | — | — | — | — | 2026-09-19 |

</details>

## Status
Recent additions include a GitHub repository scaffold (branch protection, CODEOWNERS, issue templates), a GitLab CI follow-up on runners, variables, and artifacts with a minimal stages-cache-artifacts pipeline and an API trigger snippet, a Docker Compose-vs-Swarm-vs-Kubernetes orchestration notebook, and an Azure CLI-vs-Bicep-vs-Python-SDK comparison. Vault and Pulumi first-contact notes are indexed alongside the longer-standing tool families.

---
_Last updated: 2026-09-20_
