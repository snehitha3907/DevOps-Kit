# DevOps-Kit
> A working-engineer's devops reference for containers, orchestration, infrastructure as code, CI/CD, GitOps, and cloud CLIs.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for
A working devops engineer's quick-reference: first-contact notes, runnable snippets, and configs for containers, orchestration, infrastructure as code, CI/CD, GitOps, and cloud CLIs. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here
First-contact primers, notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, and templates for devops tools across cloud (AWS, Azure, GCP), containers (Docker, Kubernetes), GitOps (ArgoCD, FluxCD), configuration management (Ansible, Terraform, OpenTofu, Pulumi), CI/CD (GitHub, GitHub Actions, GitLab CI, Jenkins), and observability and security (Prometheus, Grafana, OpenTelemetry, Trivy). Most tool folders pair a primer with runnable material you can copy and adapt.

## Quick links
- [Terraform remote state with locking](learn/06-iac-and-cloud/06-terraform-remote-state.md) — Remote Terraform state setup from the learning path.
- [First Terraform apply](learn/06-iac-and-cloud/05-terraform-first-apply.md) — Provision and destroy your first infrastructure.
- [AWS IAM and VPC basics](learn/06-iac-and-cloud/03-aws-iam-vpc-basics.md) — Least-privilege IAM role and a VPC with public and private subnets.
- [Ansible webserver config](Ansible/configs/configure-webserver.yml) — Newly added Ansible playbook config for a webserver.
- [Ansible lab inventory](Ansible/configs/lab-inventory.ini) — Newly added Ansible lab inventory file.

## Layout
- **00_index/** — Topics map, quick links, glossary, and learning path.
- **Ansible/** — Playbooks, inventories, roles, templates, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, GitHub wiring, and health checks.
- **AWS/** — CLI setup, S3/EC2/VPC stacks, IAM, CloudFormation, and boto3 comparisons.
- **Azure/** — CLI setup, Bicep and Python SDK, AKS, Container Apps, and cleanup scripts.
- **Docker/** — Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, and Go/Compose scaffolds.
- **FluxCD/** — Flux CLI primer, bootstrap, GitRepository/Kustomization manifests, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage, IAM, startup scripts, and scripted Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, and gitattributes setup.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation.
- **GitHub Actions/** — Workflow primers, reusable workflows, multi-environment deploy template, OIDC with AWS, custom runner images, and secret management.
- **GitLab CI/** — Pipeline primer, runner setup, variables and artifacts, minimal and multi-project pipelines, and dynamic child pipelines.
- **Grafana (graf/)** — Primer, Docker install, UI notes, dashboards, and Prometheus/Alertmanager wiring.
- **Grafana Cloud (grafc/)** — First contact: agent scrape config, hosted dashboard, and HTTP-API dashboard creation.
- **HashiCorp Vault (vlt/)** — Primer, dev server, KV engine examples, secrets-engine mounting, and least-privilege policies.
- **Helm/** — Chart inspection, values files, demo and Redis charts, reusable microservice chart, and chart testing.
- **Jenkins (jnk/)** — Primer only: core concepts, pipeline syntax, agents, and common patterns.
- **Kubernetes/** — kubectl notes, workloads, probes, Gateway API, HPA/PDB, Helm/Kustomize overlays, and a Kubebuilder operator scaffold.
- **OpenTelemetry (otel/)** — Traces primer, collector install, OTLP export, context propagation, and an instrumented Go server.
- **OpenTofu/** — Primer, local config, S3 remote state with workspaces, reusable AWS VPC module, and a custom-provider guide.
- **Prometheus/** — Scrape configs, exporters, recording vs alerting rules, Alertmanager-to-PagerDuty routing, and a full Grafana stack template.
- **Pulumi (plm/)** — Primer, Python project scaffolds, multi-stack structure, and reusable components.
- **Terraform/** — Primer, modules, workspaces, remote state, 1.9 migration, testing guide, provider-schema validation, and module-registry publishing.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, Python wrappers, and OPA/Rego policy-as-code.

## Coverage
<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | 2 | 3 | 7 | 3 | 0 | 1 | 0 | 7 | 2026-10-07 |
| Ansible | 10 | 7 | 2 | 4 | 10 | 10 | 2 | 1 | 68 | 2026-10-28 |
| ArgoCD | 3 | 2 | 1 | 3 | 3 | 2 | 0 | 0 | 13 | 2026-10-20 |
| Azure | 4 | 2 | 3 | 5 | 2 | 2 | 0 | 0 | 10 | 2026-10-08 |
| Docker | 6 | 11 | 2 | 5 | 1 | 9 | 3 | 9 | 12 | 2026-10-29 |
| Flux CD | 2 | 2 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-20 |
| GCP | 2 | 1 | 2 | 6 | 4 | 0 | 0 | 0 | 0 | 2026-09-28 |
| Git | 6 | 15 | 1 | 14 | 0 | 0 | 3 | 0 | 46 | 2026-09-25 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 2026-10-10 |
| GitHub Actions | 5 | 7 | 1 | 4 | 5 | 0 | 0 | 1 | 3 | 2026-10-27 |
| GitLab CI | 8 | 4 | 2 | 10 | 8 | 0 | 0 | 2 | 16 | 2026-10-22 |
| Grafana | 4 | 3 | 0 | 2 | 1 | 0 | 0 | 0 | 0 | 2026-10-20 |
| Grafana Cloud | 2 | 0 | 1 | 1 | 2 | 0 | 0 | 0 | 0 |  |
| HashiCorp Vault | 3 | 2 | 0 | 4 | 2 | 0 | 0 | 0 | 0 | 2026-10-25 |
| Helm | 3 | 6 | 1 | 5 | 5 | 15 | 1 | 0 | 27 | 2026-10-21 |
| Jenkins | 2 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |  |
| Kubernetes | 10 | 6 | 2 | 4 | 1 | 7 | 2 | 0 | 70 | 2026-10-25 |
| OpenTelemetry | 2 | 2 | 2 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-14 |
| OpenTofu | 2 | 4 | 0 | 3 | 2 | 0 | 2 | 0 | 6 | 2026-10-10 |
| Prometheus | 2 | 4 | 1 | 6 | 5 | 3 | 1 | 0 | 18 | 2026-10-29 |
| Pulumi | 2 | 2 | 1 | 4 | 3 | 0 | 0 | 0 | 13 | 2026-10-14 |
| Terraform | 6 | 8 | 3 | 4 | 10 | 2 | 2 | 0 | 39 | 2026-10-27 |
| Trivy | 5 | 2 | 2 | 5 | 3 | 0 | 0 | 0 | 0 | 2026-10-19 |

</details>

## Status
Currently working through first-contact notes and templates across the tool set, with recent additions on Terraform remote state, AWS IAM and VPC basics, and Ansible configuration.

---
_Last updated: 2026-11-15_

