# DevOps-Kit
> A working-engineer's devops reference for cloud CLIs, containers, orchestration, and infrastructure as code.

<!-- Badge row: dynamic shields.io only — no static counts -->
![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)
![Contributors](https://img.shields.io/github/contributors/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for
A working engineer's quick-reference: first-contact notes, runnable snippets, and configs for cloud CLIs, containers, orchestration, and infrastructure as code. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here
A DevOps engineer's collection of first-contact notes, runnable snippets, and configs for cloud CLIs, containers, orchestration, and infrastructure as code tools. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates.

## Quick links
- [Shell navigation orientation](learn/01-orientation/02-shell-navigation.md) — First steps around the lab shell
- [Pulumi Python project scaffold](Pulumi/templates/pulumi-python-project-scaffold/README.md) — Ready-to-copy Pulumi project scaffold
- [Production Docker deployment with HA](docker/manifests/production-docker-deployment-with-ha.yaml) — Compose manifest for a highly available Docker deployment
- [Docker production hardening runbook](docker/docs/docker-production-hardening-runbook.md) — Runbook for hardening Docker in production
- [GCP IAM config](gcp/configs/gcloud-iam-config.yaml) — gcloud IAM configuration example

## Layout
- **00_index/** — Topics map, quick links, glossary, and learning path.
- **Ansible/** (ans/) — Primers, playbooks, inventories, roles, templates, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, GitHub wiring, installation, scripted sync, and health checks.
- **AWS/** (aws/) — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, IAM least-privilege walkthrough, and boto3-vs-CloudFormation-vs-CDK comparison notebook.
- **Azure/** (az/) — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, a private AKS Bicep example with modular addons, a Container Apps microservices baseline, and cleanup scripts.
- **Docker/** (docker/) — Container primers, Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, Go and Compose scaffolds, and a Docker-to-Kubernetes handoff guide.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, GitRepository/Kustomization manifests, and pre-flight cluster checks.
- **GCP/** (gcp/) — gcloud setup, Compute and Cloud Storage examples, IAM, startup scripts, instance templates, and a scripted Cloud Run deployment.
- **Git/** (git/) — Branching, hooks, worktrees, merge strategies, repository scaffolds, gitattributes setup, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, release automation notes, and an org-wide Actions-usage audit notebook.
- **GitHub Actions/** — Workflow primers, reusable workflows, a multi-environment deploy template, an OIDC-with-AWS guide, custom runner images, bulk Actions-secret management, and dispatch examples.
- **GitLab CI/** (gl/, GitLab/) — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline configs, multi-project and dynamic child pipelines, a build-to-deploy-to-Kubernetes walkthrough, and an API trigger snippet.
- **Grafana/** (graf/) — Grafana primer, Docker-based install script, UI exploration notes, quickstart trip-ups, and provisioning config.
- **Grafana Cloud/** (grafc/) — Grafana Cloud first contact: agent scrape config, dashboard created over the HTTP API, notes from the hosted UI, and quickstart trip-ups.
- **Helm/** — Chart inspection, values files, a demo-chart fixture, shared base values for multi-cluster GitOps releases, Redis chart manifests, reusable microservice chart, chart testing with `ct lint`, and chart scaffolding.
- **Jenkins/** (jnk/) — Primer only: core concepts, pipeline syntax, agents, and common patterns.
- **Kubernetes/** (k8s/) — kubectl notes, workloads, probes, ingress plus Gateway API migration, monitoring, production patterns with HPA and PDB, Helm/Kustomize overlays, Kubebuilder operator scaffold, and reusable custom-resource reconciliation core.
- **OpenTelemetry/** (otel/, otl/) — Traces primer, collector install script, first-span snippet, OTLP export config, quickstart trip-ups, instrumented Go server, context-propagation guide, and custom span processor.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, plan/apply wrapper with policy checks, reusable AWS VPC module template, and custom-provider development guide.
- **Prometheus/** (pro/) — Scrape configuration, target health checks, hand-rolled exporter, recording vs alerting rules, Alertmanager-to-PagerDuty routing, and getting-started notes.
- **Pulumi/** (plm/) — Primer, CLI install and project init, minimal Python bucket snippet, multi-stack project structure guide, and reusable Network component.
- **Terraform/** (tf/) — Terraform primer, modules, workspaces, remote state, 1.9 migration guide, layered testing guide across tflint, native contracts, and Terratest, provider-schema validation tool, module registry publishing scaffold, notebooks, and environment scaffolds.
- **Trivy/** (trv/) — Image and filesystem scanning, scan-mode selection, severity policies, Python wrappers, and policy-as-code script with custom OPA/Rego checks.
- **HashiCorp Vault/** (vlt/) — Primer, dev server setup, KV engine examples, script for mounting first secrets engine at custom path, quickstart trip-ups, hvac script for round-tripping KV v2 secret through versions, and least-privilege read-only policy.
- **docs/concepts/** — Foundational concept primers and notes (Linux, networking, scripting, version control, containers, CI/CD, IaC, monitoring).
- **docs/** — Repo-level notes, audits, and coverage corrections.
- **learn/** — Orientation and guided learning entry point.

## Coverage
<details>
<summary>Coverage table (tools × 9 categories)</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | 2 | 3 | 7 | 3 | 0 | 1 | 0 | 7 | 2026-10-26 |
| Ansible | 10 | 7 | 2 | 4 | 8 | 10 | 2 | 1 | 68 | 2026-10-28 |
| ArgoCD | 3 | 2 | 1 | 3 | 3 | 2 | 0 | 0 | 13 | 2026-10-20 |
| Azure | 4 | 2 | 3 | 5 | 2 | 2 | 0 | 0 | 10 | 2026-10-08 |
| CI/CD Concepts | 0 | 5 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 2026-09-16 |
| Containerization Concepts | 0 | 3 | 2 | 2 | 0 | 0 | 1 | 0 | 0 | 2026-09-03 |
| Docker | 6 | 11 | 2 | 5 | 1 | 8 | 3 | 9 | 12 | 2026-10-29 |
| Flux CD | 2 | 2 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-20 |
| GCP | 2 | 1 | 2 | 6 | 4 | 0 | 0 | 0 | 0 | 2026-09-28 |
| Git | 6 | 13 | 1 | 20 | 0 | 0 | 3 | 0 | 42 | 2026-10-25 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 2026-10-14 |
| GitHub Actions | 5 | 7 | 1 | 4 | 5 | 0 | 0 | 1 | 3 | 2026-10-27 |
| GitLab CI | 4 | 2 | 1 | 6 | 4 | 0 | 0 | 1 | 7 | 2026-10-22 |
| Grafana | 4 | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 2026-10-20 |
| Grafana Cloud | 2 | 0 | 1 | 1 | 2 | 0 | 0 | 0 | 0 | 2026-10-13 |
| HashiCorp Vault | 3 | 2 | 0 | 4 | 2 | 0 | 0 | 0 | 0 | 2026-10-25 |
| Helm | 3 | 6 | 1 | 5 | 5 | 9 | 1 | 0 | 33 | 2026-10-21 |
| Infrastructure as Code Concepts | 0 | 3 | 1 | 1 | 0 | 0 | 2 | 0 | 0 | 2026-09-03 |
| Jenkins | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-10-20 |
| Kubernetes | 10 | 7 | 2 | 4 | 1 | 7 | 2 | 0 | 69 | 2026-10-27 |
| Linux & System Administration | 0 | 3 | 0 | 4 | 0 | 0 | 1 | 0 | 0 | 2026-08-07 |
| Monitoring & Observability Concepts | 0 | 3 | 0 | 3 | 0 | 0 | 2 | 0 | 0 | 2026-09-19 |
| Networking Fundamentals | 1 | 1 | 1 | 6 | 0 | 0 | 2 | 0 | 0 | 2026-08-07 |
| OpenTelemetry | 2 | 2 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-14 |
| OpenTofu | 2 | 4 | 0 | 3 | 2 | 0 | 2 | 0 | 6 | 2026-10-10 |
| Prometheus | 2 | 4 | 1 | 8 | 5 | 3 | 1 | 0 | 16 | 2026-10-29 |
| Pulumi | 2 | 2 | 1 | 4 | 3 | 0 | 0 | 0 | 13 | 2026-10-30 |
| Scripting & Automation (Bash/Python) | 0 | 3 | 2 | 4 | 0 | 0 | 1 | 0 | 0 | 2026-09-05 |
| Terraform | 6 | 8 | 3 | 8 | 10 | 2 | 2 | 0 | 35 | 2026-10-27 |
| Trivy | 5 | 2 | 2 | 5 | 3 | 0 | 0 | 0 | 0 | 2026-10-19 |
| Version Control Concepts | 0 | 4 | 2 | 4 | 0 | 0 | 0 | 0 | 0 | 2026-09-25 |
</details>

## Status
Currently working through L1 first-contact notes for Flux CD and expanding template scaffolds for Ansible, Helm, and Terraform. New this cycle: Jenkins primer, ArgoCD Vault integration, and a Kubernetes multi-cluster management template library (Cluster API + Flux GitOps + cluster resource sets).

---
_Last updated: 2026-11-01_
