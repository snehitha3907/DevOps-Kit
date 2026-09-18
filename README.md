# DevOps-Kit
> A working DevOps engineer's shelf for cloud CLIs, containers, orchestration, infrastructure as code, CI/CD, observability, and security.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable examples, and configs for the tools you reach for while building and operating systems. Use it as a shelf to grab a primer, verify a command, or borrow a concrete manifest. It is not a tutorial site and does not replace each tool's official documentation.

## What's in here

The kit covers 16 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Shared concept primers in `docs/concepts/` connect the foundations behind the tool-specific material.

## Quick links

- [OpenTofu S3 backend with workspace isolation](OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md) — Shared state per environment in S3 with locking so concurrent applies queue instead of clobbering each other.
- [OpenTofu S3 + DynamoDB remote-state bootstrap](OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh) — Provisions the state bucket, lock table, and scoped IAM user, then migrates local state into the backend.
- [Helm values management approaches](Helm/docs/values-management-approaches.md) — Compares `--set` flags, per-environment values files, and named templates with when to reach for each.
- [AWX job template and credential configuration](Ansible/configs/awx-job-template-and-credential-config.yaml) — A production GitOps job template with typed SSH, Vault, and AWS credentials.
- [Helm demo web service chart script](Helm/scripts/demo-web-service-chart.sh) — Scaffolds, lints, renders, installs, and verifies a small Helm release.

## Layout

- **00_index/** — Topics, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, and S3 website examples.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, installation, and sync checks.
- **Azure/** — Azure CLI setup, resource provisioning, VM scale sets, and a private AKS Bicep example.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, build patterns, health checks, and Go service scaffolds.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, and startup scripts.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, and regression examples.
- **GitHub/** — Repository operations, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, runner setup, and dispatch examples.
- **GitLab CI/** — Pipeline primer, runner setup, and a first local pipeline.
- **Helm/** — Chart inspection, values files, values-management approaches, Redis chart manifests, release testing, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, and Helm/Kustomize overlays.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, and verification.
- **Prometheus/** — Scrape configuration, target health checks, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, severity policies, and Python wrappers.
- **docs/** — Foundational concept primers and supporting kit notes.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|---------|---------|----------|-----------|-----------|-------------|-----------|---------------|
| Ansible | 10 | 4 | 4 | 8 | ✅ | 8 | ✅ | ✅ | 48 | 2026-09-16 |
| ArgoCD | 3 | — | ✅ | ✅ | ✅ | — | — | — | — | — |
| AWS | ✅ | — | 5 | ✅ | ✅ | — | — | — | — | — |
| Azure | 3 | — | 3 | — | 3 | ✅ | — | — | — | — |
| Docker | 6 | 6 | 5 | ✅ | ✅ | 5 | ✅ | 8 | 6 | 2026-09-09 |
| GCP | ✅ | — | 3 | ✅ | ✅ | — | — | — | — | — |
| Git | 8 | 13 | 9 | — | ✅ | — | ✅ | — | 22 | 2026-09-17 |
| GitHub | 10 | 5 | 6 | 7 | 3 | — | ✅ | — | — | 2026-08-23 |
| GitHub Actions | 6 | 5 | 3 | 5 | ✅ | — | — | — | — | 2026-09-11 |
| GitLab CI | 3 | — | ✅ | ✅ | — | — | — | — | — | — |
| Helm | 3 | 4 | 3 | 4 | ✅ | 4 | — | — | — | 2026-09-18 |
| Kubernetes | 9 | 4 | ✅ | ✅ | ✅ | 4 | ✅ | — | 10 | 2026-08-29 |
| OpenTofu | ✅ | 3 | ✅ | ✅ | — | — | — | — | — | 2026-09-18 |
| Prometheus | ✅ | — | ✅ | ✅ | ✅ | — | — | — | — | — |
| Terraform | 6 | 4 | 3 | 7 | 3 | ✅ | ✅ | — | 10 | 2026-09-17 |
| Trivy | 5 | — | ✅ | ✅ | ✅ | — | — | — | — | — |

</details>

## Status

Current work strengthens production-ready patterns: private AKS, AWX job templates, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD. Recent additions include OpenTofu S3 remote state with workspace isolation, a Helm values-management comparison, and an Ansible execution-pattern notebook.

---
_Last updated: 2026-09-18_
