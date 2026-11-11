# DevOps-Kit
> A working-engineer's devops reference for cloud CLIs, containers, orchestration, and infrastructure as code.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for
A working devops engineer's quick-reference: first-contact notes, runnable snippets, and configs for cloud CLIs, containers, orchestration, and infrastructure as code. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here
First-contact primers, notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, and templates for devops tools across cloud (AWS, Azure, GCP), containers (Docker, Kubernetes), GitOps (ArgoCD, FluxCD), configuration management (Ansible, Terraform, OpenTofu, Pulumi), CI/CD (GitHub, GitHub Actions, GitLab CI, Jenkins), and observability (Prometheus, Grafana, OpenTelemetry, Trivy). Most tool folders pair a primer with runnable material you can copy and adapt.

## Quick links
- [Build, scan, and publish an image from CI](learn/05-ci-cd/04-gha-scan-push.md) — GitHub Actions workflow that builds an image, scans it with Trivy, and publishes only when the scan is clean.
- [Run tests on every pull request with GitHub Actions](learn/05-ci-cd/03-gha-build-test.md) — CI workflow plus a branch ruleset that blocks merges until the test check passes.
- [Sample app and Postgres with Docker Compose healthchecks](Docker/manifests/app-postgres-healthchecks.compose.yaml) — Compose stack where the app waits for a healthy database before starting.
- [Run the app and Postgres with Docker Compose](learn/04-containers/05-compose-app-db.md) — Compose file with healthchecks, and how to confirm both services report healthy.
- [Scan a Docker image with Trivy](learn/04-containers/07-trivy-scan-image.md) — image vulnerability scan, severity filtering, and making the scan fail on CRITICAL findings.

## Layout
- **00_index/** — Topics map, quick links, glossary, and learning path.
- **Ansible/** — Playbooks, inventories, roles, templates, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, GitHub wiring, installation, and health checks.
- **AWS/** — CLI setup, S3/EC2/VPC stack builders, IAM least-privilege walkthrough, and boto3 vs CloudFormation vs CDK comparison.
- **Azure/** — CLI setup, Bicep and Python SDK, AKS cluster with modular addons, Container Apps, and cleanup scripts.
- **Docker/** — Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, and Go/Compose scaffolds.
- **FluxCD/** — Flux CLI primer, bootstrap, GitRepository/Kustomization manifests, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage, IAM, startup scripts, instance templates, and scripted Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, and gitattributes setup.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation.
- **GitHub Actions/** — Workflow primers, reusable workflows, multi-environment deploy template, OIDC with AWS, custom runner images, and secret management.
- **GitLab CI** — Pipeline primer, runner setup, variables and artifacts, minimal and multi-project pipelines, and dynamic child pipelines.
- **Grafana (graf/)** — Primer, Docker install, UI notes, dashboards, and Prometheus/Alertmanager wiring.
- **Grafana Cloud (grafc/)** — First contact: agent scrape config, hosted dashboard, and HTTP-API dashboard creation.
- **HashiCorp Vault (vlt/)** — Primer, dev server, KV engine examples, secrets-engine mounting, and least-privilege policies.
- **Helm/** — Chart inspection, values files, demo and Redis charts, reusable microservice chart, and chart testing.
- **Jenkins (jnk/)** — Primer only: core concepts, pipeline syntax, agents, and common patterns.
- **Kubernetes/** — kubectl notes, workloads, probes, Gateway API, HPA/PDB, Helm/Kustomize overlays, and a Kubebuilder operator scaffold.
- **OpenTelemetry (otel/)** — Traces primer, collector install, OTLP export, context propagation, and instrumented Go server.
- **OpenTofu/** — Primer, local config, S3 remote state with workspaces, reusable AWS VPC module, and custom-provider guide.
- **Prometheus/** — Scrape configs, exporters, recording vs alerting rules, Alertmanager-to-PagerDuty routing, and a full Grafana stack template.
- **Pulumi (plm/)** — Primer, Python and TypeScript project scaffolds, multi-stack structure, and reusable components.
- **Terraform/** — Primer, modules, workspaces, remote state, 1.9 migration, testing guide, provider-schema validation, and module-registry publishing.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, Python wrappers, and OPA/Rego policy-as-code.

## Coverage
<details>
<summary>Coverage table (22 tools × 9 categories)</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| Ansible | 10 | 7 | 2 | 4 | 8 | 10 | 2 | 1 | 68 | 2026-10-28 |
| ArgoCD | 3 | 2 | 1 | 3 | 3 | 2 | 0 | 0 | 13 | 2026-10-20 |
| AWS | 2 | 2 | 3 | 7 | 3 | 0 | 1 | 0 | 7 | 2026-10-26 |
| Azure | 4 | 2 | 3 | 5 | 2 | 2 | 0 | 0 | 10 | 2026-10-08 |
| Docker | 6 | 11 | 2 | 5 | 1 | 9 | 3 | 9 | 12 | 2026-10-29 |
| FluxCD | 2 | 2 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-20 |
| GCP | 2 | 1 | 2 | 6 | 4 | 0 | 0 | 0 | 0 | 2026-09-28 |
| Git | 6 | 15 | 1 | 14 | 0 | 0 | 3 | 0 | 46 | 2026-10-27 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 2026-10-14 |
| GitHub Actions | 5 | 7 | 1 | 4 | 5 | 0 | 0 | 1 | 3 | 2026-10-27 |
| GitLab CI | 4 | 2 | 1 | 5 | 4 | 0 | 0 | 1 | 8 | 2026-10-22 |
| Grafana | 4 | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 2026-10-20 |
| Grafana Cloud | 2 | 0 | 1 | 1 | 2 | 0 | 0 | 0 | 0 | 2026-10-13 |
| HashiCorp Vault | 3 | 2 | 0 | 4 | 2 | 0 | 0 | 0 | 0 | 2026-10-25 |
| Helm | 3 | 6 | 1 | 5 | 5 | 15 | 1 | 0 | 27 | 2026-10-21 |
| Jenkins | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-10-27 |
| Kubernetes | 10 | 6 | 2 | 4 | 1 | 7 | 2 | 0 | 70 | 2026-10-27 |
| OpenTelemetry | 2 | 2 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-14 |
| OpenTofu | 2 | 4 | 0 | 3 | 2 | 0 | 2 | 0 | 6 | 2026-10-10 |
| Prometheus | 2 | 4 | 1 | 6 | 5 | 3 | 1 | 0 | 18 | 2026-10-29 |
| Pulumi | 2 | 2 | 1 | 4 | 3 | 0 | 0 | 0 | 13 | 2026-10-30 |
| Terraform | 6 | 8 | 3 | 4 | 10 | 2 | 2 | 0 | 39 | 2026-10-27 |
| Trivy | 5 | 2 | 2 | 5 | 3 | 0 | 0 | 0 | 0 | 2026-10-19 |

</details>

## Status
Currently adding first-contact notes and templates across the tool set, with recent work on GitHub Actions CI gating, Docker Compose healthchecks, and Trivy image scanning.

---
_Last updated: 2026-11-11_
