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
- [Pulumi first stack](learn/12-electives/07-pulumi-first-stack.md) — Recreate a VPC in Pulumi and compare it to Terraform.
- [GitLab CI sample app pipeline](GitLab CI/configs/gitlab-ci-sample-app-build-scan-push.yml) — Sample app build, scan, and push pipeline.
- [GitLab CI pipeline notes](learn/12-electives/04-gitlab-ci-pipeline.md) — Elective notes on GitLab CI pipelines.
- [Flux as a GitOps alternative](learn/12-electives/08-flux-gitops-alternative.md) — Elective notes comparing Flux to ArgoCD.
- [Grafana Cloud datasource config](Grafana Cloud/configs/grafana-cloud-datasource.yaml) — Datasource provisioning for Grafana Cloud.

## Layout
- **00_index/** — Topics map, quick links, glossary, and learning path.
- **Ansible/** — Playbooks, inventories, roles, templates, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, installation, and health checks.
- **AWS/** — CLI setup, S3/EC2/VPC stack builders, IAM least-privilege walkthrough, and boto3 vs CloudFormation vs CDK comparison.
- **Azure/** — CLI setup, Bicep and Python SDK, AKS cluster with modular addons, Container Apps, and cleanup scripts.
- **Docker/** — Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, and Go/Compose scaffolds.
- **FluxCD/** — Flux CLI primer, bootstrap, GitRepository/Kustomization manifests, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage, IAM, startup scripts, instance templates, and scripted Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, and gitattributes setup.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation.
- **GitHub Actions/** — Workflow primers, reusable workflows, multi-environment deploy template, OIDC with AWS, custom runner images, and secret management.
- **GitLab CI/** — Pipeline primer, runner setup, variables and artifacts, minimal and multi-project pipelines, and dynamic child pipelines.
- **Grafana/** — Primer, Docker install, UI notes, dashboards, and Prometheus/Alertmanager wiring.
- **Grafana Cloud/** — First contact: agent scrape config, hosted dashboard, and HTTP-API dashboard creation.
- **Helm/** — Chart inspection, values files, demo and Redis charts, reusable microservice chart, and chart testing.
- **Jenkins/** — Primer only: core concepts, pipeline syntax, agents, and common patterns.
- **Kubernetes/** — kubectl notes, workloads, probes, Gateway API, HPA/PDB, Helm/Kustomize overlays, and a Kubebuilder operator scaffold.
- **OpenTelemetry/** — Traces primer, collector install, OTLP export, context propagation, and instrumented Go server.
- **OpenTofu/** — Primer, local config, S3 remote state with workspaces, reusable AWS VPC module, and custom-provider guide.
- **Prometheus/** — Scrape configs, exporters, recording vs alerting rules, Alertmanager-to-PagerDuty routing, and a full Grafana stack template.
- **Pulumi/** — Primer, Python and TypeScript project scaffolds, multi-stack structure, and reusable components.
- **Terraform/** — Primer, modules, workspaces, remote state, 1.9 migration, testing guide, provider-schema validation, and module-registry publishing.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, Python wrappers, and OPA/Rego policy-as-code.
- **Vault/** — Primer, dev server, KV engine examples, secrets-engine mounting, and least-privilege policies.
- **docs/** — Foundational concept primers (CI/CD, containers, IaC, Linux, monitoring, networking, scripting, version control).
- **learn/** — Guided learning-path material oriented to the kit's tools and concepts.

## Coverage
<details>
<summary>Coverage table (23 tools × 9 categories)</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| Ansible | 10 | 7 | 2 | 4 | 10 | 10 | 2 | 1 | 68 | 2026-10-28 |
| ArgoCD | 3 | 2 | 1 | 3 | 3 | 2 | 0 | 0 | 13 | 2026-10-20 |
| AWS | 2 | 2 | 3 | 7 | 3 | 0 | 1 | 0 | 7 | 2026-10-07 |
| Azure | 4 | 2 | 3 | 5 | 2 | 2 | 0 | 0 | 10 | 2026-10-08 |
| Docker | 6 | 11 | 2 | 5 | 1 | 9 | 3 | 9 | 12 | 2026-10-29 |
| FluxCD | 2 | 2 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-20 |
| GCP | 2 | 1 | 2 | 6 | 4 | 0 | 0 | 0 | 0 | 2026-09-28 |
| Git | 6 | 15 | 1 | 14 | 0 | 0 | 3 | 0 | 46 | 2026-09-25 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 2026-10-10 |
| GitHub Actions | 5 | 7 | 1 | 4 | 5 | 0 | 0 | 1 | 3 | 2026-10-27 |
| GitLab CI | 4 | 2 | 1 | 5 | 5 | 0 | 0 | 1 | 8 | 2026-11-28 |
| Grafana | 4 | 3 | 0 | 2 | 4 | 0 | 0 | 0 | 0 | 2026-10-20 |
| Grafana Cloud | 2 | 0 | 1 | 1 | 4 | 0 | 0 | 0 | 0 | — |
| Helm | 3 | 6 | 1 | 5 | 5 | 15 | 1 | 0 | 27 | 2026-10-21 |
| Jenkins | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | — |
| Kubernetes | 10 | 6 | 2 | 5 | 2 | 7 | 2 | 0 | 70 | 2026-10-25 |
| OpenTelemetry | 2 | 2 | 2 | 3 | 3 | 0 | 0 | 0 | 0 | 2026-10-14 |
| OpenTofu | 2 | 4 | 0 | 3 | 2 | 0 | 2 | 0 | 6 | 2026-10-10 |
| Prometheus | 2 | 4 | 1 | 6 | 5 | 3 | 1 | 0 | 18 | 2026-10-29 |
| Pulumi | 2 | 2 | 1 | 4 | 3 | 0 | 0 | 0 | 13 | 2026-10-14 |
| Terraform | 6 | 8 | 3 | 4 | 10 | 2 | 2 | 0 | 39 | 2026-10-27 |
| Trivy | 5 | 2 | 2 | 5 | 3 | 0 | 0 | 0 | 0 | 2026-10-19 |
| Vault | 3 | 2 | 0 | 4 | 3 | 0 | 0 | 0 | 0 | 2026-10-25 |

</details>

## Status
Currently keeping the navigation and coverage tables in sync with the tool folders on disk.

---
_Last updated: 2026-11-28_
