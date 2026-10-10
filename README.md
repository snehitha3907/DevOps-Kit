# DevOps-Kit
> A working DevOps engineer's shelf for cloud CLIs, containers, orchestration, infrastructure as code, CI/CD, observability, and security scanning.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before the coverage table below.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable scripts, and configs for the tools you reach for while building and operating systems. Use it as a shelf to grab a primer, verify a command, or borrow a concrete manifest that you can edit into your own. It is not a tutorial site and it does not try to replace each tool's official documentation.

## What's in here

The kit covers 22 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, secrets management, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Under `docs/concepts/`, eight foundational concept primers cover the ground the tool-specific material stands on — networking, Linux, scripting, version control, infrastructure as code, CI/CD, containerization, and observability.

## Quick links

- [GitHub Apps vs OAuth Apps: choosing the right integration](GitHub/docs/github-apps-vs-oauth-apps.md) — Actor-first comparison of which registration type fits unattended automation, event-driven workflows, and user-facing tooling.
- [Terraform module registry publishing workflow template](Terraform/templates/terraform-module-registry-publishing/README.md) — Complete module structure with CI/CD pipeline that validates, tests, and publishes modules on version tags.
- [Validate a Terraform provider schema against a contract](Terraform/scripts/validate-provider-schema.go) — A Go CLI that checks a `terraform providers schema -json` export against a hand-written contract of required arguments and attributes.
- [Migrate a codebase to Terraform 1.9](Terraform/docs/terraform-1-9-migration-guide.md) — Inventory and version-pin audit, state backup, one-environment-at-a-time plan comparison, plan-file apply promotion, lock refresh, verify and rollback runbook.
- [Azure Container Apps baseline for two microservices](Azure/configs/container-apps-microservices.yaml) — A public HTTP API and an internal worker sharing one managed environment, with per-service scaling rules and revision rollback.

## Layout

- **00_index/** — Topics map, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, an IAM least-privilege walkthrough, and a boto3-vs-CloudFormation-vs-CDK comparison notebook.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests including a multi-cluster one, GitHub wiring, installation, scripted sync, and health checks.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, a private AKS Bicep example with modular addons, a Container Apps microservices baseline, an Azure DevOps pipeline pattern for Bicep, and two prefix-selected resource-group cleanup scripts.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, Go and Compose scaffolds, and a Docker-to-Kubernetes handoff guide.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, GitRepository/Kustomization manifests, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, startup scripts, instance templates, and a scripted Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, gitattributes setup, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, a multi-environment deploy template, an OIDC-with-AWS guide, custom runner images, bulk Actions-secret management, and dispatch examples.
- **GitLab CI** — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline configs, multi-project and dynamic child pipelines, a build-to-deploy-to-Kubernetes walkthrough, and an API trigger snippet.
- **graf/** — Grafana primer, Docker-based install script, UI exploration notes, and quickstart trip-ups.
- **grafc/** — Grafana Cloud first contact: an agent scrape config, a dashboard created over the HTTP API, and notes from the hosted UI.
- **Helm/** — Chart inspection, values files, values-management approaches with a runnable `demo-chart` fixture, a shared base values file for multi-cluster GitOps releases, Redis chart manifests, a reusable microservice chart with a vendored PostgreSQL subchart, a cross-environment values validator, chart testing with `ct lint`, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, production patterns with HPA and PDB, and Helm/Kustomize overlays.
- **OpenTelemetry** (folder `otel/`) — Traces primer, collector install script, first-span snippet, a minimal OTLP export config, quickstart trip-ups, and an instrumented Go server.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, a plan/apply wrapper with policy checks, and a reusable AWS VPC module template.
- **Prometheus/** — Scrape configuration, target health checks, a hand-rolled exporter, recording versus alerting rules, Alertmanager-to-PagerDuty routing, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, a 1.9 migration guide, a provider-schema validation tool with a Go CLI and contract, a module registry publishing scaffold, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, and Python wrappers.
- **plm/** — Pulumi primer, CLI install and project init, and a minimal Python bucket snippet.
- **vlt/** — HashiCorp Vault primer, dev server setup, KV engine examples, a script that mounts a first secrets engine at a custom path, quickstart trip-ups, an hvac script that round-trips a KV v2 secret through its versions, and a least-privilege read-only policy bound to a group.
- **docs/** — Foundational concept primers under `docs/concepts/`, plus notes about the kit itself.
- **docs/audit/** — Coverage and readme audit notes about the kit's own documentation.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-------------|---------------|
| AWS | 2 | 2 | 3 | 7 | 3 | — | 1 | — | 3 | 2026-10-07 |
| Ansible | 10 | 4 | 2 | 4 | 8 | 8 | 2 | 1 | 48 | 2026-09-16 |
| ArgoCD | 3 | 1 | 1 | 2 | 3 | — | — | — | — | 2026-10-02 |
| Azure | 4 | 2 | 3 | 5 | 1 | 1 | — | — | 10 | 2026-10-08 |
| Docker | 6 | 7 | 2 | 5 | 1 | 6 | 3 | 9 | 12 | 2026-09-29 |
| FluxCD | 2 | 1 | — | 1 | 1 | — | — | — | — | 2026-09-30 |
| GCP | 2 | 1 | 2 | 5 | 3 | — | — | — | — | 2026-09-28 |
| Git | 8 | 15 | 1 | 12 | — | — | 1 | — | 22 | 2026-09-25 |
| GitHub | 11 | 7 | 3 | 6 | 7 | 1 | 1 | 1 | 11 | 2026-10-10 |
| GitHub Actions | 6 | 6 | 1 | 4 | 5 | — | — | 1 | 3 | 2026-10-04 |
| GitLab CI | 4 | 1 | 1 | 4 | 4 | — | — | — | — | 2026-10-02 |
| Grafana (`graf/`) | 3 | 2 | — | 1 | — | — | — | — | — | 2026-09-29 |
| Grafana Cloud (`grafc/`) | 1 | — | 1 | — | 1 | — | — | — | — | 2026-09-30 |
| Helm | 3 | 5 | 1 | 4 | 5 | 14 | 1 | — | 22 | 2026-10-05 |
| Kubernetes | 9 | 4 | 2 | 3 | 1 | 5 | 2 | — | 10 | 2026-09-04 |
| OpenTelemetry (`otel/`) | 2 | 1 | 2 | 1 | 1 | — | — | — | — | 2026-09-30 |
| OpenTofu | 2 | 3 | — | 3 | 2 | — | 2 | — | 6 | 2026-09-20 |
| Prometheus | 2 | 1 | 1 | 2 | 3 | — | — | — | — | 2026-09-30 |
| Pulumi (`plm/`) | 2 | 1 | 1 | 2 | 1 | — | — | — | — | 2026-09-30 |
| Terraform | 6 | 5 | 3 | 4 | 9 | 2 | 2 | — | 25 | 2026-10-09 |
| Trivy | 5 | 1 | 2 | 4 | 2 | — | — | — | — | 2026-09-23 |
| HashiCorp Vault (`vlt/`) | 3 | 1 | — | 3 | 1 | — | — | — | — | 2026-10-07 |

</details>

## Status

Current focus is the seam between CI and the cluster: a GitLab runner that can reach Kubernetes and roll a digest-pinned image, dynamic child pipelines for job sets that only exist at run time, and ArgoCD reading from a private GitHub repo with a multi-cluster ApplicationSet. On the GitHub Actions side the recent additions retire stored AWS keys in favour of OIDC workload identity, alongside the custom runner image, multi-environment promotion template, and bulk secret management. The newest arrival is a reusable Helm microservice chart — Deployment, Service, ConfigMap, optional Ingress/HPA/PDB, a migration Job hook, and a vendored PostgreSQL subchart — with a script that validates layered values files across environments before promotion. The newest additions on that same theme are a shared base values file for deploying one release to several clusters from a GitOps repo, and a chart-testing walkthrough that lints and installs only the charts a branch touched. Alongside that, OpenTofu grew a reusable AWS VPC module template with a plan/apply wrapper that runs policy checks before anything is applied, and the Helm values-management walkthrough gained a runnable `demo-chart` fixture so every lint, template, install, and upgrade command runs as written. Most recently, Azure gained a Bicep module template for an AKS cluster with modular addons (GitOps, HTTP routing, Key Vault, monitoring, network policy, and policy). Since then the Vault shelf filled out its second layer: quickstart trip-ups from a dev server, an hvac script that writes, reads, and lists versions of a KV v2 secret, and a minimal read-only policy bound to a group for least-privilege token issuance. On the Azure side there are now two cleanup scripts that delete prefix-matched resource groups while sparing locked ones — one gated on an explicit confirmation flag, one built for scheduled runs with dry-run by default. Newest since then: a Container Apps baseline for a small API-plus-worker pair, an Azure DevOps pipeline pattern that takes Bicep through build, what-if, and deploy, a Terraform 1.9 migration walkthrough that treats the plan diff as the changelog, a GitHub Apps vs OAuth Apps integration guide for choosing the right registration type, a Terraform module registry publishing workflow template, and a Go CLI that validates a provider's schema against a hand-written contract.

---
_Last updated: 2026-10-10_
