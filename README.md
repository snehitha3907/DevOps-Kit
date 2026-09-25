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

- [Comparing deployment approaches: boto3 vs CloudFormation vs CDK](AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb) — The same small versioned S3 bucket stack built three ways, so the imperative-vs-declarative trade-offs are concrete.
- [Choosing Trivy scan modes and wiring them into a pipeline](Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md) — When to reach for `image`, `fs`, `repo`, or `sbom` scans, and how to make a failure block a bad artifact.
- [Parallel tasks with structured logging](docs/concepts/scripting-automation-bash-python/scripts/2026-09-23-parallel-tasks-with-logging.sh) — A small pattern for running a few shell tasks at once with one log line per event and a clear signal when one fails.
- [Branch divergence check with git rev-list](docs/concepts/version-control-concepts/snippets/2026-09-23-branch-divergence-rev-list.py) — Ahead/behind counts for two branches plus the unique commits on each side.
- [IAM least-privilege walkthrough](AWS/docs/iam-policy-least-privilege-walkthrough.md) — Scoping policies for a Lambda + S3 + DynamoDB stack and verifying them with the policy simulator.

## Layout

- **00_index/** — Topics, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, an IAM least-privilege walkthrough, and a boto3-vs-CloudFormation-vs-CDK comparison notebook.
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
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, and Python wrappers.
- **graf/** — Grafana primer, UI exploration notes, and Docker-based install script.
- **vlt/** — HashiCorp Vault primer, dev server setup, and KV engine examples.
- **plm/** — Pulumi primer, CLI install + project init, and minimal Python bucket snippet.
- **docs/** — Foundational concept primers and supporting kit notes.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | 1 | 3 | 6 | 2 | — | 1 | — | — | 2026-09-23 |
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
| Trivy | 5 | 1 | 2 | 4 | 2 | — | — | — | — | 2026-09-23 |
| HashiCorp Vault | 2 | 1 | — | 1 | — | — | — | — | — | 2026-09-19 |
| Pulumi | 1 | 1 | 1 | 1 | — | — | — | — | — | 2026-09-20 |
| graf | 2 | 1 | — | 1 | — | — | — | — | — | 2026-09-25 |

</details>

## Status

Recent additions: a notebook comparing boto3, CloudFormation, and CDK on the same small stack, a Trivy scan-modes guide (image vs fs vs repo vs sbom) with pipeline wiring, an IAM least-privilege walkthrough for a Lambda/S3/DynamoDB stack, a VPC + EC2 + RDS stack builder in boto3, and concept exercises in parallel shell logging and git branch-divergence checks. Earlier work (the multi-project GitLab CI pipeline template, the reusable gitattributes setup, the local pipeline validator, the Trivy repo scan workflow, Pulumi coverage, GitHub release automation) stays indexed below. Current work keeps strengthening production-ready patterns: private AKS, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD.

---
_Last updated: 2026-09-23_
