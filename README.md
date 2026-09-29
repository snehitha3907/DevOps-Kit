# DevOps-Kit
> A working DevOps engineer's shelf for cloud CLIs, containers, orchestration, infrastructure as code, CI/CD, observability, and security scanning.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable scripts, and configs for the tools you reach for while building and operating systems. Use it as a shelf to grab a primer, verify a command, or borrow a concrete manifest that you can edit into your own. It is not a tutorial site and it does not try to replace each tool's official documentation.

## What's in here

The kit covers 21 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, secrets management, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Under `docs/concepts/`, eight foundational concept primers cover the ground the tool-specific material stands on — networking, Linux, scripting, version control, infrastructure as code, CI/CD, containerization, and observability.

## Quick links

- [Stand up a Cloud Run service from a generated Terraform config](GCP/scripts/build-cloud-run-service-terraform.py) — Writes a minimal `.tf` to a temp directory, then `init` / `plan` / `apply` it and prints the service URL.
- [Grafana quickstart trip-ups](graf/notes/2026-09-29-grafana-quickstart-trip-ups.md) — Running the official "Getting started" guide end to end: install, data source, dashboard, alerting, and what actually got in the way.
- [BuildKit vs classic vs Buildx](Docker/notebooks/comparing-docker-build-strategies.ipynb) — The three build engines side by side, with a feature matrix for choosing between them.
- [Multi-service Compose scaffold with health checks](Docker/templates/multi-service-compose-with-healthchecks/README.md) — App plus Postgres and Redis, every service health-checked, startup order gated on health.
- [Integrating Docker with Kubernetes for production workloads](Docker/docs/integrating-docker-with-kubernetes.md) — The handoff between the two: immutable image tags, pull secrets, probe translation, requests and limits, rollout and rollback.

## Layout

- **00_index/** — Topics map, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, an IAM least-privilege walkthrough, and a boto3-vs-CloudFormation-vs-CDK comparison notebook.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, installation, and sync checks.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, and a private AKS Bicep example.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, Go and Compose scaffolds, and a Docker-to-Kubernetes handoff guide.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, startup scripts, instance templates, and a scripted Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, gitattributes setup, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, runner setup, and dispatch examples.
- **GitLab CI** — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline config, multi-project pipeline templates, and an API trigger snippet.
- **graf/** — Grafana primer, Docker-based install script, UI exploration notes, and quickstart trip-ups.
- **Helm/** — Chart inspection, values files, values-management approaches, Redis chart manifests, release testing, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, production patterns with HPA and PDB, and Helm/Kustomize overlays.
- **OpenTelemetry** (folder `otel/`) — Traces primer, a collector install script, and a first-span snippet.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, and verification.
- **Prometheus/** — Scrape configuration, target health checks, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, and Python wrappers.
- **plm/** — Pulumi primer, CLI install and project init, and a minimal Python bucket snippet.
- **vlt/** — HashiCorp Vault primer, dev server setup, and KV engine examples.
- **docs/** — Foundational concept primers under `docs/concepts/`, plus notes about the kit itself.
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
| Docker | 6 | 7 | 2 | 5 | 1 | 6 | 3 | 9 | 12 | 2026-09-29 |
| FluxCD | 1 | 1 | — | 1 | — | — | — | — | — | 2026-09-22 |
| GCP | 2 | 1 | 2 | 5 | 3 | — | — | — | — | 2026-09-29 |
| Git | 8 | 15 | 1 | 11 | — | — | 1 | — | 22 | 2026-09-25 |
| GitHub | 11 | 6 | 3 | 6 | 7 | 1 | 1 | 1 | 8 | 2026-09-20 |
| GitHub Actions | 6 | 5 | 1 | 3 | 5 | — | — | — | — | 2026-09-11 |
| GitLab CI | 4 | — | 1 | 3 | 3 | — | — | — | — | 2026-09-19 |
| graf | 3 | 2 | — | 1 | — | — | — | — | — | 2026-09-29 |
| Helm | 3 | 4 | 1 | 3 | 4 | 4 | 1 | — | — | 2026-09-18 |
| Kubernetes | 9 | 4 | 2 | 3 | 1 | 5 | 2 | — | 10 | 2026-09-04 |
| otel | 1 | 1 | 1 | 1 | — | — | — | — | — | 2026-09-25 |
| OpenTofu | 2 | 3 | — | 2 | 2 | — | 1 | — | — | 2026-09-18 |
| Prometheus | 2 | — | 1 | 1 | 2 | — | — | — | — | 2026-09-05 |
| Terraform | 6 | 4 | 3 | 3 | 8 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | 1 | 2 | 4 | 2 | — | — | — | — | 2026-09-23 |
| HashiCorp Vault | 2 | 1 | — | 1 | — | — | — | — | — | 2026-09-19 |
| Pulumi | 1 | 1 | 1 | 1 | — | — | — | — | — | 2026-09-20 |

</details>

## Status

Recently added: a scripted Cloud Run deployment that drives Terraform end to end, Grafana quickstart trip-ups, a build-strategy comparison notebook, and a multi-service Compose scaffold that gates startup on health checks. Current work keeps strengthening production-ready patterns: private AKS, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD.

---
_Last updated: 2026-09-29_
