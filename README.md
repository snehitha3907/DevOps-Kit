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

- [VPC with private endpoints (CDK)](AWS/scripts/vpc-with-private-endpoints.py) — CDK Python stack with public/private/isolated subnets per environment, gateway endpoints plus interface endpoints behind a scoped TLS security group, and per-environment CIDR and NAT sizing.
- [Multi-account baseline with a CloudFormation StackSet](AWS/templates/cloudformation-multi-account-stack-set/README.md) — One shared template (encrypted CloudTrail-logs bucket, baseline IAM group, SNS topic) rolled out to many accounts and regions, with an example CLI sequence for creating the set and its instances.
- [StackSet template body](AWS/templates/cloudformation-multi-account-stack-set/template.yaml) — The account-agnostic CloudFormation template itself: S3 bucket with CloudTrail-write policy and DenyInsecureTransport, IAM group, parameterized SNS topic.
- [StackSet deploy example](AWS/templates/cloudformation-multi-account-stack-set/examples/deploy.sh) — Copy-pasteable `create-stack-set` / `create-stack-instances` commands for the baseline above.
- [Regression test probe for `git bisect run`](Git/scripts/regression-test.sh) — Deterministic exit codes (0 good, 1 bad, 125 skip) with TEST_CMD/PRE_CMD/timeout knobs; companion to the scripted-bisect guide.

## Layout

- **00_index/** — Topics map, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, a CDK VPC stack with private endpoints, a CloudFormation StackSet template for multi-account baselines, an IAM least-privilege walkthrough, and a boto3-vs-CloudFormation-vs-CDK comparison notebook.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests including a multi-cluster one, GitHub wiring, installation, scripted sync, and health checks.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, and a private AKS Bicep example.
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
- **Terraform/** — Terraform primer, modules, workspaces, remote state, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, and Python wrappers.
- **plm/** — Pulumi primer, CLI install and project init, and a minimal Python bucket snippet.
- **vlt/** — HashiCorp Vault primer, dev server setup, KV engine examples, and a script that mounts a first secrets engine at a custom path.
- **docs/** — Foundational concept primers under `docs/concepts/`, plus notes about the kit itself.
- **docs/audit/** — Coverage and readme audit notes about the kit's own documentation.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | 1 | 3 | 7 | 2 | — | 1 | — | 3 | 2026-10-07 |
| Ansible | 10 | 4 | 2 | 4 | 8 | 8 | 2 | 1 | 48 | 2026-09-18 |
| ArgoCD | 3 | 1 | 1 | 2 | 3 | — | — | — | — | 2026-10-02 |
| Azure | 4 | 1 | 3 | 3 | — | 1 | — | — | — | 2026-09-19 |
| Docker | 6 | 7 | 2 | 5 | 1 | 6 | 3 | 9 | 12 | 2026-09-29 |
| FluxCD | 2 | 1 | — | 1 | 1 | — | — | — | — | 2026-09-30 |
| GCP | 2 | 1 | 2 | 5 | 3 | — | — | — | — | 2026-09-29 |
| Git | 8 | 15 | 1 | 12 | — | — | 1 | — | 22 | 2026-10-06 |
| GitHub | 11 | 6 | 3 | 6 | 7 | 1 | 1 | 1 | 11 | 2026-10-01 |
| GitHub Actions | 6 | 6 | 1 | 4 | 5 | — | — | 1 | 3 | 2026-10-04 |
| GitLab CI | 4 | 1 | 1 | 4 | 4 | — | — | — | — | 2026-10-02 |
| Grafana (`graf/`) | 3 | 2 | — | 1 | — | — | — | — | — | 2026-09-29 |
| Grafana Cloud (`grafc/`) | 1 | — | 1 | — | 1 | — | — | — | — | 2026-09-30 |
| Helm | 3 | 5 | 1 | 4 | 5 | 14 | 1 | — | 22 | 2026-10-05 |
| Kubernetes | 9 | 4 | 2 | 3 | 1 | 5 | 2 | — | 10 | 2026-09-21 |
| OpenTelemetry (`otel/`) | 2 | 1 | 2 | 1 | 1 | — | — | — | — | 2026-09-30 |
| OpenTofu | 2 | 3 | — | 3 | 2 | — | 2 | — | 6 | 2026-10-06 |
| Prometheus | 2 | 1 | 1 | 2 | 3 | — | — | — | — | 2026-09-30 |
| Pulumi (`plm/`) | 2 | 1 | 1 | 2 | 1 | — | — | — | — | 2026-09-30 |
| Terraform | 6 | 4 | 3 | 3 | 8 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | 1 | 2 | 4 | 2 | — | — | — | — | 2026-09-23 |
| HashiCorp Vault (`vlt/`) | 2 | 1 | — | 2 | — | — | — | — | — | 2026-09-30 |

</details>

## Status

Current focus is the seam between CI and the cluster: a GitLab runner that can reach Kubernetes and roll a digest-pinned image, dynamic child pipelines for job sets that only exist at run time, and ArgoCD reading from a private GitHub repo with a multi-cluster ApplicationSet. On the GitHub Actions side the recent additions retire stored AWS keys in favour of OIDC workload identity, alongside the custom runner image, multi-environment promotion template, and bulk secret management. The newest arrival is a reusable Helm microservice chart — Deployment, Service, ConfigMap, optional Ingress/HPA/PDB, a migration Job hook, and a vendored PostgreSQL subchart — with a script that validates layered values files across environments before promotion. The newest additions on that same theme are a shared base values file for deploying one release to several clusters from a GitOps repo, and a chart-testing walkthrough that lints and installs only the charts a branch touched. Alongside that, OpenTofu grew a reusable AWS VPC module template with a plan/apply wrapper that runs policy checks before anything is applied, and the Helm values-management walkthrough gained a runnable `demo-chart` fixture so every lint, template, install, and upgrade command runs as written. The newest arrivals are on the AWS side: a CDK stack for a VPC with private endpoints (gateway plus interface endpoints, per-environment CIDR and NAT sizing) and a CloudFormation StackSet template that rolls one safe baseline out to many accounts, plus a deterministic regression-test probe that backs the scripted `git bisect` guide.

---
_Last updated: 2026-10-07_
