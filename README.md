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

The kit covers 27 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, secrets management, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Under `docs/concepts/`, eight foundational concept primers cover the ground the tool-specific material stands on — networking, Linux, scripting, version control, infrastructure as code, CI/CD, containerization, and observability.

## Quick links

- [ArgoCD docs: Vault/External Secrets integration](ArgoCD/docs/argocd-vault-external-secrets.md) — Complete guide to wiring ArgoCD with HashiCorp Vault and External Secrets Operator for GitOps secret management.
- [ArgoCD scripts: application helper](ArgoCD/scripts/argocd-application-helper.py) — Python helper to create, sync, and verify ArgoCD Applications from scripts or CI pipelines.
- [ArgoCD manifests: multi-cluster fleet ApplicationSet](ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml) — ApplicationSet manifest that fans out Applications across a fleet of clusters using a list generator.
- [ArgoCD templates: multi-cluster GitOps repo scaffold](ArgoCD/templates/multi-cluster-gitops-repo/README.md) — Scaffold for a multi-cluster GitOps repository structure with base apps, overlays, and bootstrap script.
- [ArgoCD samples: guestbook Application manifest](ArgoCD/templates/multi-cluster-gitops-repo/applications/sample-app.yaml) — Minimal Guestbook Application manifest for the multi-cluster GitOps scaffold.

## Layout

- **00_index/** — Topics map, quick links, glossary, and learning path.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests including a multi-cluster one, GitHub wiring, installation, scripted sync, health checks, and Vault/External Secrets integration.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, an IAM least-privilege walkthrough, and a boto3-vs-CloudFormation-vs-CDK comparison notebook.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, a private AKS Bicep example with modular addons, a Container Apps microservices baseline, an Azure DevOps pipeline pattern for Bicep, and two prefix-selected resource-group cleanup scripts.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, Go and Compose scaffolds, and a Docker-to-Kubernetes handoff guide.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, GitRepository/Kustomization manifests, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, startup scripts, instance templates, and a scripted Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, gitattributes setup, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, release automation notes, an org-wide Actions-usage audit notebook, and a Dependabot merge script.
- **GitHub Actions/** — Workflow primers, reusable workflows, a multi-environment deploy template, an OIDC-with-AWS guide, custom runner images, bulk Actions-secret management, and dispatch examples.
- **GitLab CI** — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline configs, multi-project and dynamic child pipelines, a build-to-deploy-to-Kubernetes walkthrough, and an API trigger snippet. (A root-level `GitLab` symlink aliases this folder.)
- **graf/** — Grafana primer, Docker-based install script, UI exploration notes, quickstart trip-ups from two passes, and a provisioning config declaring a Prometheus datasource and first dashboard as files.
- **grafc/** — Grafana Cloud first contact: an agent scrape config, a dashboard created over the HTTP API, notes from the hosted UI, and quickstart trip-ups covering the agent wiring and the remote-write path.
- **Helm/** — Chart inspection, values files, values-management approaches with a runnable `demo-chart` fixture, a shared base values file for multi-cluster GitOps releases, Redis chart manifests, a reusable microservice chart with a vendored PostgreSQL subchart, a cross-environment values validator, chart testing with `ct lint`, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress plus a Gateway API migration, monitoring, production patterns with HPA and PDB, Helm/Kustomize overlays, a Kubebuilder operator scaffold, and a reusable custom-resource reconciliation core.
- **OpenTelemetry** (folder `otel/`) — Traces primer, collector install script, first-span snippet, a minimal OTLP export config, quickstart trip-ups, an instrumented Go server, a context-propagation guide, and a custom span processor.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, a plan/apply wrapper with policy checks, a reusable AWS VPC module template, and a custom-provider development guide.
- **Prometheus/** — Scrape configuration, target health checks, a hand-rolled exporter, recording versus alerting rules, Alertmanager-to-PagerDuty routing, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, a 1.9 migration guide, a layered testing guide across tflint, native contracts, and Terratest, a provider-schema validation tool with a Go CLI and contract, a module registry publishing scaffold, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, Python wrappers, and a policy-as-code script that bundles custom OPA/Rego checks.
- **plm/** — Pulumi primer, CLI install and project init, a minimal Python bucket snippet, a multi-stack project structure guide, and a reusable Network component.
- **vlt/** — HashiCorp Vault primer, dev server setup, KV engine examples, a script that mounts a first secrets engine at a custom path, quickstart trip-ups, an hvac script that round-trips a KV v2 secret through its versions, and a least-privilege read-only policy bound to a group.
- **docs/** — Foundational concept primers under `docs/concepts/`, plus notes about the kit itself.
- **docs/audit/** — Coverage and readme audit notes about the kit's own documentation.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| Ansible | 10 | 5 | 2 | 4 | 8 | 8 | 2 | 1 | 48 | 2026-10-12 |
| ArgoCD | 3 | 2 | 1 | 3 | 3 | 2 | — | — | 13 | 2026-10-20 |
| AWS | 2 | 2 | 3 | 7 | 3 | — | 1 | — | 3 | 2026-10-08 |
| Azure | 4 | 2 | 3 | 5 | 1 | 1 | — | — | 10 | 2026-10-09 |
| Docker | 6 | 8 | 2 | 5 | 1 | 6 | 3 | 9 | 12 | 2026-10-12 |
| FluxCD | 2 | 2 | — | 2 | 2 | — | — | — | — | 2026-10-20 |
| GCP | 2 | 1 | 2 | 5 | 3 | — | — | — | — | 2026-09-29 |
| Git | 6 | 14 | 1 | 12 | — | — | 1 | — | 22 | 2026-10-11 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 2026-10-14 |
| GitHub Actions | 5 | 6 | 1 | 4 | 5 | — | — | 1 | 3 | 2026-10-11 |
| GitLab CI | 4 | 1 | 1 | 4 | 4 | — | — | — | — | 2026-10-02 |
| Grafana (`graf/`) | 4 | 2 | — | 1 | 1 | — | — | — | — | 2026-10-14 |
| Grafana Cloud (`grafc/`) | 2 | — | 1 | 1 | 2 | — | — | — | — | 2026-10-19 |
| Helm | 3 | 5 | 1 | 4 | 5 | 14 | 1 | — | 22 | 2026-10-06 |
| Kubernetes | 9 | 5 | 2 | 4 | 1 | 6 | 2 | — | 32 | 2026-10-14 |
| OpenTelemetry (`otel/`) | 2 | 2 | 2 | 2 | 2 | — | — | — | — | 2026-10-14 |
| OpenTofu | 2 | 4 | — | 3 | 2 | — | 2 | — | 6 | 2026-10-11 |
| Prometheus | 2 | 2 | 1 | 4 | 4 | — | — | — | 11 | 2026-10-19 |
| Pulumi (`plm/`) | 2 | 2 | 1 | 3 | 2 | — | — | — | — | 2026-10-15 |
| Terraform | 6 | 6 | 3 | 4 | 9 | 2 | 2 | — | 24 | 2026-10-14 |
| Trivy | 5 | 2 | 2 | 5 | 3 | — | — | — | — | 2026-10-19 |
| HashiCorp Vault (`vlt/`) | 3 | 1 | — | 3 | 1 | — | — | — | — | 2026-10-08 |

</details>

## Status

Currently working through L1 first-contact notes for Flux CD and Grafana Cloud, and expanding template scaffolds for Ansible, Helm, and Terraform. Recently added ArgoCD Vault/External Secrets integration docs and multi-cluster GitOps scaffold.

---
_Last updated: 2026-10-20_