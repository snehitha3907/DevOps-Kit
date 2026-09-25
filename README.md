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

The kit covers 22 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, secrets management, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. First contact with OpenTelemetry (a primer in `otel/`) sits alongside the Prometheus and Grafana material. Shared concept primers in `docs/concepts/` connect the foundations behind the tool-specific material.

## Quick links

- [OpenTelemetry primer](otel/notes/0000-primer-opentelemetry.md) — First-day notes on traces, spans, context propagation, exporters, and the collector — and where OTel sits relative to Prometheus and Grafana.
- [Automated git bisect runner](Git/scripts/bisect-automation-runner.sh) — Drives `git bisect run` end to end for a scripted regression test and reports the first bad commit.
- [Grafana primer](graf/notes/0000-primer-grafana.md) — First-day notes on data sources, panels, dashboards, variables, and alert rules — and why Grafana sits next to Prometheus.
- [Poking around the Grafana UI](graf/notes/2026-09-25-explore-grafana-ui.md) — Adding a Prometheus data source, building a first panel, and the localhost-in-Docker gotcha.
- [graf/ coverage note](graf/docs/2026-09-25-grafana-coverage-and-topics.md) — How the Grafana folder maps to the Coverage table and topic map.

## Layout

- **00_index/** — Topics, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, an IAM least-privilege walkthrough, and a boto3-vs-CloudFormation-vs-CDK comparison notebook.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, installation, and sync checks.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, and a private AKS Bicep example.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, Compose-vs-Swarm-vs-Kubernetes comparison, build patterns, health checks, and Go service scaffolds.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, startup scripts, and instance templates.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, gitattributes setup, bisect automation, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, runner setup, and dispatch examples.
- **GitLab CI/** — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline config, multi-project pipeline templates, and an API trigger snippet.
- **GitLab/** — Mirrors `GitLab CI/` (same pipeline primer, runner scripts, configs, and trigger snippet under a shorter path).
- **Helm/** — Chart inspection, values files, values-management approaches, Redis chart manifests, release testing, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, production patterns with HPA and PDB, and Helm/Kustomize overlays.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, and verification.
- **Prometheus/** — Scrape configuration, target health checks, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, and Python wrappers.
- **graf/** — Grafana primer, UI exploration notes, Docker-based install script, and a coverage note.
- **otel/** — First-contact OpenTelemetry primer (traces, spans, exporters, collector).
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
| FluxCD | 1 | 1 | — | 1 | — | — | — | — | — | 2026-09-22 |
| GCP | 2 | — | 2 | 4 | 3 | — | — | — | — | 2026-09-20 |
| Git | 8 | 13 | 1 | 11 | — | — | 1 | — | 22 | 2026-09-17 |
| GitHub | 11 | 6 | 3 | 6 | 7 | 1 | 1 | 1 | 8 | 2026-09-20 |
| GitHub Actions | 6 | 5 | 1 | 3 | 5 | — | — | — | — | 2026-09-11 |
| GitLab CI | 4 | — | 1 | 3 | 3 | — | — | — | — | 2026-09-19 |
| GitLab (mirrors GitLab CI) | 4 | — | 1 | 3 | 3 | — | — | — | — | 2026-09-19 |
| Helm | 3 | 4 | 1 | 3 | 4 | 4 | 1 | — | — | 2026-09-18 |
| Kubernetes | 9 | 4 | 2 | 3 | 1 | 5 | 2 | — | 10 | 2026-09-04 |
| OpenTofu | 2 | 3 | — | 2 | 2 | — | 1 | — | — | 2026-09-18 |
| Prometheus | 2 | — | 1 | 1 | 2 | — | — | — | — | 2026-09-05 |
| Terraform | 6 | 4 | 3 | 3 | 8 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | 1 | 2 | 4 | 2 | — | — | — | — | 2026-09-23 |
| graf (Grafana) | 2 | 1 | — | 1 | — | — | — | — | — | 2026-09-25 |
| otel (OpenTelemetry) | 1 | — | — | — | — | — | — | — | — | 2026-09-25 |
| vlt (HashiCorp Vault) | 2 | 1 | — | 1 | — | — | — | — | — | 2026-09-19 |
| plm (Pulumi) | 1 | 1 | 1 | 1 | — | — | — | — | — | 2026-09-20 |

</details>

## Status

Recent additions: a first-contact OpenTelemetry primer (traces, spans, exporters, collector), an automated `git bisect run` runner for scripted regression hunts, and first-contact Grafana notes (primer, Docker install, UI exploration against a Prometheus data source). Earlier work (trunk-based delivery notes, the TCP/DNS reachability practice script, the boto3/CloudFormation/CDK comparison notebook, the Trivy scan-modes guide, the IAM least-privilege walkthrough, the VPC + EC2 + RDS stack builder, the multi-project GitLab CI pipeline template) stays indexed below. Current work keeps strengthening production-ready patterns: private AKS, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD.

---
_Last updated: 2026-09-25_
