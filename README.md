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

The kit covers 19 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, secrets management, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Shared concept primers in `docs/concepts/` connect the foundations behind the tool-specific material.

## Quick links

- [Reusable gitattributes setup with filters and merge drivers](Git/scripts/setup-gitattributes-filters-and-merge.sh) — Line-ending rules, clean/smudge filters, custom diff drivers for notebooks and binaries, and merge drivers for lockfiles and whitespace-sensitive files.
- [Multi-project pipeline template with downstream trigger](GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml) — Cross-project pipeline using shared includes, workflow rules, and a bridge job that triggers a downstream pipeline in another project.
- [Local GitLab CI pipeline validator](GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh) — Lints `.gitlab-ci.yml` syntax and runs a local execution with `gitlab-runner exec` before pushing.
- [Trivy repo scan workflow](Trivy/scripts/trivy-fs-repo-scan-workflow.sh) — Scans a Git repository's dependencies for known vulnerabilities using `trivy repo` with SARIF output and severity filtering.
- [Create S3 bucket and upload object](AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py) — Minimal boto3 script to create an S3 bucket with versioning and upload a test object.

## Layout

- **00_index/** — Topics, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, and boto3 snippets.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, installation, and sync checks.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, and a private AKS Bicep example.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, Compose-vs-Swarm-vs-Kubernetes comparison, build patterns, health checks, and Go service scaffolds.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, startup scripts, and instance templates.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, gitattributes setup, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, runner setup, and dispatch examples.
- **GitLab CI/** — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline config, multi-project pipeline templates, and an API trigger snippet.
- **Helm/** — Chart inspection, values files, values-management approaches, Redis chart manifests, release testing, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, production patterns with HPA and PDB, and Helm/Kustomize overlays.
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

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | — | 3 | 5 | 2 | — | — | — | — | 2026-09-22 |
| Ansible | 10 | 4 | 2 | 4 | 8 | 8 | 2 | 1 | 48 | 2026-09-16 |
| ArgoCD | 3 | — | 1 | 1 | 2 | — | — | — | — | 2026-08-11 |
| Azure | 4 | 1 | 3 | 3 | — | 1 | — | — | — | 2026-09-19 |
| Docker | 6 | 6 | 2 | 5 | 1 | 6 | 2 | 9 | 6 | 2026-09-09 |
| FluxCD | 1 | 1 | — | 1 | — | — | — | — | — | 2026-09-20 |
| GCP | 2 | — | 2 | 4 | 3 | — | — | — | — | 2026-09-20 |
| Git | 8 | 13 | 1 | 10 | — | — | 1 | — | 22 | 2026-09-22 |
| GitHub | 11 | 6 | 3 | 6 | 7 | 1 | 1 | 1 | 8 | 2026-09-20 |
| GitHub Actions | 6 | 5 | 1 | 3 | 5 | — | — | — | — | 2026-09-11 |
| GitLab CI | 4 | — | 1 | 3 | 3 | — | — | — | — | 2026-09-22 |
| Helm | 3 | 4 | 1 | 3 | 4 | 4 | 1 | — | — | 2026-09-18 |
| Kubernetes | 9 | 4 | 2 | 3 | 1 | 5 | 2 | — | 10 | 2026-09-04 |
| OpenTofu | 2 | 3 | — | 2 | 2 | — | 1 | — | — | 2026-09-18 |
| Prometheus | 2 | — | 1 | 1 | 2 | — | — | — | — | 2026-09-05 |
| Terraform | 6 | 4 | 3 | 3 | 8 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | — | 2 | 4 | 2 | — | — | — | — | 2026-09-02 |
| HashiCorp Vault | 2 | 1 | — | 1 | — | — | — | — | — | 2026-09-19 |
| Pulumi | 1 | 1 | 1 | 1 | — | — | — | — | — | 2026-09-20 |

</details>

## Status

Recent additions: a multi-project GitLab CI pipeline template with downstream triggers, a reusable gitattributes setup script with filters and merge drivers, a local GitLab CI pipeline validator, a Trivy repo scan workflow with SARIF output, and an AWS S3 bucket creation snippet with boto3. Earlier work (Pulumi coverage, GitHub release automation, the Compose-versus-Swarm-versus-Kubernetes notebook, GitLab pipeline plus trigger examples) stays indexed below. Current work keeps strengthening production-ready patterns: private AKS, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD.

---
_Last updated: 2026-09-22_
