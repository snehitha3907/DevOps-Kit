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
A devops engineer's collection of first-contact notes, runnable snippets, and configs for cloud CLIs, containers, orchestration, and infrastructure as code — Git, Docker, Kubernetes, Terraform, OpenTofu, Ansible, Pulumi, Helm, Prometheus, Trivy, Vault, Grafana, OpenTelemetry, ArgoCD, Flux CD, Jenkins, GitHub, GitHub Actions, GitLab CI, AWS, Azure, and GCP — plus foundational concepts in CI/CD, containerization, infrastructure as code, Linux, monitoring, networking, scripting, and version control. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, and templates.

## Quick links
- [Build and test on every pull request](learn/05-ci-cd/03-gha-build-test.md) — CI workflow that runs the sample app's tests on each PR and blocks merges until green
- [Docker Compose app with Postgres and health checks](Docker/manifests/app-postgres-healthchecks.compose.yaml) — Compose stack for the sample app and Postgres with startup health checks
- [Run the app and Postgres with Docker Compose](learn/04-containers/05-compose-app-db.md) — Compose file with healthchecks for both services
- [Scan the sample app image with Trivy](learn/04-containers/07-trivy-scan-image.md) — Trivy image-scan quickstart, failing fast on CRITICAL findings
- [Build the sample app as a multi-stage image](learn/04-containers/04-docker-multistage.md) — Multi-stage Dockerfile walkthrough for smaller, faster images

## Layout
- **00_index/** — Topics map, quick links, glossary, and learning path.
- **Ansible/** — Primer, playbooks, roles, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, sync and health scripts.
- **AWS/** — AWS CLI setup, IAM, VPC, and resource provisioning with boto3 snippets and stack builders.
- **Azure/** — Azure CLI setup, Bicep and Python SDK examples, VM scale sets, and a Container Apps baseline.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, build-strategy notebooks, and health checks.
- **Flux CD (FluxCD/)** — Flux CLI primer, bootstrap, GitRepository and Kustomization manifests, cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage, IAM, startup scripts, and Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, and repository scaffolds.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, and API examples.
- **GitHub Actions/** — Workflow primers, reusable workflows, multi-environment deploy, OIDC with AWS, and custom runner images.
- **GitLab CI/** — Pipeline primer, runner setup, variables and artifacts, multi-project and dynamic child pipelines.
- **Grafana (graf/)** — Grafana primer, Docker install script, UI notes, and provisioning config.
- **Grafana Cloud (grafc/)** — Hosted Grafana quickstart: agent scrape config, HTTP API dashboard, remote-write.
- **Helm/** — Chart inspection, values files, demo and microservice charts, chart testing with ct lint.
- **Jenkins (jnk/)** — Primer only: core concepts, pipeline syntax, agents, and common patterns.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress and Gateway API, production patterns, Kubebuilder scaffold.
- **k8s/** — Cluster template library: Cluster API fleet management, Flux GitOps bootstrap, cluster resource sets.
- **OpenTelemetry (otel/)** — Traces primer, collector install script, OTLP config, instrumented Go server, context propagation.
- **OpenTofu/** — OpenTofu primer, local config, S3 remote state, reusable AWS module, custom-provider guide.
- **Prometheus/** — Scrape config, target health checks, exporters, recording vs alerting rules, Alertmanager routing.
- **Pulumi (plm/)** — Primer, CLI install, bucket snippets, multi-stack structure, reusable Network component.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, 1.9 migration, testing guide, module registry scaffold.
- **Trivy/** — Image and filesystem scanning, scan modes, severity policies, Python wrappers, OPA/Rego policy-as-code.
- **HashiCorp Vault (vlt/)** — Primer, dev server setup, KV engine examples, secrets-engine scripts, least-privilege policy.
- **docs/** — Foundational concepts: CI/CD, containerization, IaC, Linux, monitoring, networking, scripting, version control.
- **learn/** — Guided first-contact lessons for Docker, CI/CD, and Trivy.

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
| Flux CD | 2 | 2 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-20 |
| GCP | 2 | 1 | 2 | 6 | 4 | 0 | 0 | 0 | 0 | 2026-09-28 |
| Git | 6 | 15 | 1 | 14 | 0 | 0 | 3 | 0 | 46 | 2026-10-27 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 2026-10-14 |
| GitHub Actions | 5 | 7 | 1 | 4 | 5 | 0 | 0 | 1 | 3 | 2026-10-27 |
| GitLab CI | 8 | 4 | 2 | 10 | 8 | 0 | 0 | 2 | 16 | 2026-10-22 |
| Grafana | 4 | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 2026-10-20 |
| Grafana Cloud | 2 | 0 | 1 | 1 | 2 | 0 | 0 | 0 | 0 | 2026-10-13 |
| Helm | 3 | 6 | 1 | 5 | 5 | 15 | 1 | 0 | 27 | 2026-10-21 |
| HashiCorp Vault | 3 | 2 | 0 | 4 | 2 | 0 | 0 | 0 | 0 | 2026-10-25 |
| Jenkins | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 2026-10-27 |
| Kubernetes | 10 | 6 | 2 | 4 | 1 | 7 | 2 | 0 | 70 | 2026-10-27 |
| OpenTelemetry | 2 | 2 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-14 |
| OpenTofu | 2 | 4 | 0 | 3 | 2 | 0 | 2 | 0 | 6 | 2026-10-10 |
| Prometheus | 2 | 4 | 1 | 6 | 5 | 3 | 1 | 0 | 18 | 2026-10-29 |
| Pulumi | 2 | 2 | 1 | 4 | 3 | 0 | 0 | 0 | 13 | 2026-10-29 |
| Terraform | 6 | 8 | 3 | 4 | 10 | 2 | 2 | 0 | 39 | 2026-10-27 |
| Trivy | 5 | 2 | 2 | 5 | 3 | 0 | 0 | 0 | 0 | 2026-10-19 |

</details>

## Status
Currently working through first-contact lessons for Docker, CI/CD, and Trivy, with primer coverage across the cloud CLIs and orchestration tools.

---
_Last updated: 2026-11-10_
