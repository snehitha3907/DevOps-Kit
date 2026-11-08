# DevOps-Kit
> A working DevOps reference for cloud CLIs, containers, orchestration, infrastructure as code, GitOps, and observability.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)
![Contributors](https://img.shields.io/github/contributors/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first contact to confident in a sensible order — read that before this table.

## Who this is for
A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, configs, manifests, and templates for cloud platforms, containers, CI/CD, orchestration, infrastructure as code, GitOps, and observability. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here
First-contact primers, notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, and reusable templates across the major DevOps tool families present on disk. Most tool folders pair a primer with hands-on material you can adapt, plus a `learn/` track for guided, beginner-to-advanced lessons.

## Quick links
- [Scan the sample app image with Trivy](learn/04-containers/07-trivy-scan-image.md) — Point Trivy at the sample app image, read the findings, and fail fast on severities that matter.
- [Smaller, faster images with multi-stage builds](learn/04-containers/04-docker-multistage.md) — Split a Docker image into build and runtime stages to reduce size and attack surface.
- [Package the sample app as an image](learn/04-containers/03-docker-first-image.md) — Write a Dockerfile, build the image, run a container, and reach `/health`.
- [GitHub PR flow](learn/03-version-control/06-github-pr-flow.md) — Practice the branch, pull request, review, and merge workflow.
- [Recover work with reflog](learn/03-version-control/05-git-recover-reflog.md) — Use `git reflog` to find and restore commits after a reset or rebase.

## Layout
- **00_index/** — Topics map, quick links, glossary, and learning path.
- **learn/** — Guided lessons in reading order (orientation, networking, version control, containers, and more).
- **docs/concepts/** — Foundational concept primers (Linux, networking, scripting, version control, CI/CD, containers, IaC, observability).
- **AWS/, Azure/, GCP/** — Cloud CLI setup, identity/IAM patterns, provisioning scripts, configs, and templates.
- **Ansible/** — Playbooks, inventories, roles, execution patterns, linting, and project scaffolds.
- **Docker/** — Dockerfiles, Compose stacks, build strategies, networking, health checks, and service scaffolds.
- **Kubernetes/** and **k8s/** — Workloads, manifests, probes, ingress/Gateway API, operators, and a multi-cluster Cluster API + Flux template library.
- **Helm/** — Charts, values management, release lifecycle, chart testing, and reusable microservice templates.
- **Terraform/**, **tf/**, **OpenTofu/**, **Pulumi/**, **plm/** — Infrastructure as code primers, modules, state/backends, testing, migration notes, and project scaffolds.
- **Git/**, **GitHub/**, **GitHub Actions/**, **GitLab CI/** — Version control workflows, repository/release automation, CI pipelines, runners, and deployment examples.
- **ArgoCD/**, **FluxCD/** — GitOps primers, bootstrap/install scripts, application manifests, and reconciliation configs.
- **Prometheus/**, **pro/**, **Grafana/** (`graf/`), **Grafana Cloud/** (`grafc/`), **OpenTelemetry/** (`otel/`) — Metrics, dashboards, alerting, scrape/remote-write configs, and tracing instrumentation.
- **Trivy/** — Image and filesystem scanning, severity policies, SBOM/reporting, and CI wiring.
- **HashiCorp Vault/** (`Vault/`, `vlt/`) — Secrets engines, policies, auth patterns, and KV/agent examples.
- **Jenkins/** (`jnk/`) — Jenkins primer and first-contact material.

## Coverage
<details>
<summary>Coverage table (23 tool families, by on-disk category)</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Total | Last verified |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| AWS | 2 | 2 | 3 | 7 | 3 |  | 1 |  | 7 | 25 | 2026-10-26 |
| Ansible | 10 | 7 | 2 | 4 | 8 | 10 | 2 | 1 | 68 | 112 | 2026-10-28 |
| ArgoCD | 3 | 2 | 1 | 3 | 3 | 2 |  |  | 13 | 27 | 2026-10-20 |
| Azure | 4 | 2 | 3 | 5 | 2 | 2 |  |  | 10 | 28 | 2026-10-08 |
| Docker | 6 | 11 | 2 | 5 | 1 | 8 | 3 | 9 | 12 | 57 | 2026-10-30 |
| Flux CD | 2 | 2 |  | 2 | 2 |  |  |  |  | 8 | 2026-10-20 |
| GCP | 2 | 1 | 2 | 6 | 4 |  |  |  |  | 15 | 2026-09-28 |
| Git | 6 | 15 | 1 | 14 |  |  | 3 |  | 46 | 85 | 2026-10-27 |
| GitHub | 11 | 7 | 3 | 7 | 7 | 1 | 2 | 1 | 17 | 56 | 2026-10-14 |
| GitHub Actions | 5 | 7 | 1 | 4 | 5 |  |  | 1 | 3 | 26 | 2026-10-27 |
| GitLab CI | 4 | 2 | 1 | 5 | 4 |  |  | 1 | 8 | 25 | 2026-10-22 |
| Grafana | 4 | 3 |  | 2 | 1 |  |  |  |  | 10 | 2026-10-20 |
| Grafana Cloud | 2 |  | 1 | 1 | 2 |  |  |  |  | 6 | 2026-10-13 |
| Helm | 3 | 6 | 1 | 5 | 5 | 15 | 1 |  | 27 | 63 | 2026-10-21 |
| Jenkins | 2 |  |  | 1 |  |  |  |  |  | 3 | 2026-10-27 |
| Kubernetes | 10 | 6 | 2 | 4 | 1 | 7 | 2 |  | 70 | 102 | 2026-10-27 |
| OpenTelemetry | 2 | 2 | 2 | 2 | 2 |  |  |  |  | 10 | 2026-10-14 |
| OpenTofu | 2 | 4 |  | 3 | 2 |  | 2 |  | 6 | 19 | 2026-10-10 |
| Prometheus | 2 | 4 | 1 | 6 | 5 | 3 | 1 |  | 18 | 40 | 2026-10-29 |
| Pulumi | 2 | 2 | 1 | 4 | 3 |  |  |  | 13 | 25 | 2026-10-30 |
| Terraform | 6 | 8 | 3 | 4 | 10 | 2 | 2 |  | 39 | 74 | 2026-10-27 |
| Trivy | 5 | 2 | 2 | 5 | 3 |  |  |  |  | 17 | 2026-10-19 |
| HashiCorp Vault | 3 | 2 |  | 4 | 2 |  |  |  |  | 11 | 2026-10-25 |

</details>

## Status
The learning track is expanding through container and version-control lessons. Tool coverage continues to grow across cloud, IaC, GitOps, and observability folders; see the coverage table and [topics map](00_index/topics.md) for what is currently on disk.

---
_Last updated: 2026-11-08_
