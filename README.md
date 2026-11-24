# DevOps-Kit
> A working-engineer's devops reference: first-contact notes, runnable snippets, and configs for cloud, containers, Kubernetes, infrastructure as code, CI/CD, GitOps, and observability.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for
A working devops engineer's quick-reference: first-contact notes, runnable snippets, and configs for cloud, containers, Kubernetes, infrastructure as code, CI/CD, GitOps, and observability. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs. Each tool folder pairs a short primer with material you can copy and adapt.

## What's in here
Primers, notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, and templates for devops tools. Cloud (AWS, Azure, GCP), containers (Docker, Kubernetes), GitOps (ArgoCD, FluxCD), configuration management and IaC (Ansible, Terraform, OpenTofu, Pulumi, Helm), CI/CD (GitHub, GitHub Actions, GitLab CI, Jenkins), security scanning (Trivy), secrets (Vault), and observability (Prometheus, Grafana, OpenTelemetry). Most tool folders pair a primer with runnable material you can copy and adapt.

## Quick links
- [Jenkinsfile](Jenkins/scripts/Jenkinsfile) — A Jenkins pipeline definition file.
- [05-jenkins-pipeline.md](learn/12-electives/05-jenkins-pipeline.md) — Jenkins pipeline lesson in the learning-path electives.
- [02-capstone.md](learn/11-operations/02-capstone.md) — Capstone lesson: ship the sample app end to end.
- [incident-runbook.yaml](Kubernetes/configs/incident-runbook.yaml) — Kubernetes incident runbook manifest.
- [inject-failure.sh](Kubernetes/scripts/inject-failure.sh) — Kubernetes failure-injection script.

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
- **docs/** — Foundational concept guides (CI/CD, containerization, IaC, Linux, monitoring, networking, scripting, version control) and kit notes.

## Coverage
<details><summary>Coverage table (23 tools × 9 categories)</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | 2 | 3 | 7 | 3 | 0 | 1 | 0 | 7 | 2026-10-07 |
| Ansible | 10 | 7 | 2 | 4 | 10 | 10 | 2 | 1 | 68 | 2026-10-28 |
| ArgoCD | 3 | 2 | 1 | 3 | 3 | 2 | 0 | 0 | 13 | 2026-10-20 |
| Azure | 4 | 2 | 3 | 5 | 2 | 2 | 0 | 0 | 10 | 2026-10-08 |
| Docker | 6 | 11 | 2 | 5 | 1 | 9 | 3 | 9 | 12 | 2026-10-29 |
| Flux CD | 2 | 2 | 0 | 2 | 2 | 0 | 0 | 0 | 0 | 2026-10-20 |
| GCP | 2 | 1 | 2 | 6 | 4 | 0 | 0 | 0 | 0 | 2026-09-28 |
| Git | 6 | 15 | 1 | 14 | 0 | 0 | 3 | 0 | 46 | 2026-10-27 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 2026-10-10 |
| GitHub Actions | 5 | 7 | 1 | 4 | 5 | 0 | 0 | 1 | 3 | 2026-10-27 |
| GitLab CI | 4 | 2 | 1 | 5 | 4 | 0 | 0 | 1 | 8 | 2026-10-22 |
| Grafana | 4 | 3 | 0 | 2 | 4 | 0 | 0 | 0 | 0 | 2026-10-20 |
| Grafana Cloud | 2 | 0 | 1 | 1 | 4 | 0 | 0 | 0 | 0 | — |
| HashiCorp Vault | 3 | 2 | 0 | 4 | 3 | 0 | 0 | 0 | 0 | 2026-10-25 |
| Helm | 3 | 6 | 1 | 5 | 5 | 15 | 1 | 0 | 27 | 2026-10-21 |
| Jenkins | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | — |
| Kubernetes | 10 | 6 | 2 | 5 | 2 | 7 | 2 | 0 | 70 | 2026-10-25 |
| OpenTelemetry | 2 | 2 | 2 | 3 | 3 | 0 | 0 | 0 | 0 | 2026-10-14 |
| OpenTofu | 2 | 4 | 0 | 3 | 2 | 0 | 2 | 0 | 6 | 2026-10-10 |
| Prometheus | 2 | 4 | 1 | 6 | 5 | 3 | 1 | 0 | 18 | 2026-10-29 |
| Pulumi | 2 | 2 | 1 | 4 | 3 | 0 | 0 | 0 | 13 | 2026-10-14 |
| Terraform | 6 | 8 | 3 | 4 | 10 | 2 | 2 | 0 | 39 | 2026-10-27 |
| Trivy | 5 | 2 | 2 | 5 | 3 | 0 | 0 | 0 | 0 | 2026-10-19 |

</details>

## Status
Currently working through first-contact notes and templates across the tool set, with recent work on Jenkins pipelines, Kubernetes incident runbooks, and the learning-path capstone.

---
_Last updated: 2026-11-24_
