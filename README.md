# DevOps-Kit
> A working DevOps engineer's shelf for cloud CLIs, containers, orchestration, infrastructure as code, CI/CD, observability, and security scanning.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable examples, and configs for the tools you reach for while building and operating systems. Use it as a shelf to grab a primer, verify a command, or borrow a concrete manifest. It is not a tutorial site and does not replace each tool's official documentation.

## What's in here

The kit covers 18 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, observability, secrets management, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Shared concept primers in `docs/concepts/` connect the foundations behind the tool-specific material.

## Quick links

- [HashiCorp Vault quick primer](vlt/notes/0000-primer-vlt.md) — First-day notes on keeping secrets out of env files: seal/unseal, dev server, the KV secrets engine, and policies.
- [Install the Vault CLI and start a dev server](vlt/scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh) — Smallest path to a running Vault: install the CLI, start an in-memory dev server, stash and read back a first secret.
- [Scripted health gate with correlated logs](docs/concepts/monitoring-observability-concepts/scripts/scripted-health-gate-with-correlated-logs.py) — Probe DNS/TCP/HTTP targets and emit one structured log per stage under a shared correlation id, ending in a proceed-or-hold gate verdict.
- [Two-provider local_file + random_pet config](Terraform/configs/2026-09-19-local-file-random-provider.hcl) — First try at composing the local and random providers: generate a unique suffix and write it to disk.
- [Pipeline health telemetry, DORA metrics, and deployment markers](docs/concepts/monitoring-observability-concepts/docs/cicd-pipeline-health-telemetry-dora-deployment-markers.md) — Treat the delivery pipeline as a system worth monitoring: flaky-test tracking, stage-duration telemetry, and deploy markers tied to signals.

## Layout

- **00_index/** — Topics, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, and S3 website examples.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests, installation, and sync checks.
- **Azure/** — Azure CLI setup, resource provisioning, VM scale sets, and a private AKS Bicep example.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, build patterns, health checks, and Go service scaffolds.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, and startup scripts.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, and regression examples.
- **GitHub/** — Repository operations, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, runner setup, and dispatch examples.
- **GitLab CI/** — Pipeline primer, runner setup, and a first local pipeline.
- **Helm/** — Chart inspection, values files, values-management approaches, Redis chart manifests, release testing, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, and Helm/Kustomize overlays.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, and verification.
- **Prometheus/** — Scrape configuration, target health checks, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, severity policies, and Python wrappers.
- **vlt/** — HashiCorp Vault primer, CLI install, and an in-memory dev server for first secrets.
- **docs/** — Foundational concept primers and supporting kit notes.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|---------|---------|----------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | — | 5 | 2 | 2 | — | — | — | — | 2026-07-13 |
| Ansible | 10 | 4 | 4 | 8 | 2 | 8 | 2 | 1 | 48 | 2026-09-16 |
| ArgoCD | 3 | — | 1 | 2 | 1 | — | — | — | — | 2026-08-11 |
| Azure | 4 | — | 3 | — | 3 | 1 | — | — | — | 2026-09-18 |
| Docker | 6 | 6 | 5 | 1 | 2 | 5 | 1 | 8 | 6 | 2026-09-09 |
| Flux CD | 1 | — | 1 | — | — | — | — | — | — | 2026-09-19 |
| GCP | 1 | — | 3 | 2 | 2 | — | — | — | — | 2026-07-17 |
| Git | 8 | 13 | 9 | — | 1 | — | 1 | — | 22 | 2026-09-17 |
| GitHub | 11 | 5 | 6 | 7 | 3 | — | 1 | — | — | 2026-09-19 |
| GitHub Actions | 6 | 5 | 3 | 5 | 1 | — | — | — | — | 2026-09-11 |
| GitLab CI | 3 | — | 2 | 1 | — | — | — | — | — | — |
| Helm | 3 | 4 | 3 | 4 | 1 | 4 | 1 | — | — | 2026-09-18 |
| Kubernetes | 9 | 4 | 2 | 1 | 2 | 5 | 2 | — | 10 | 2026-09-04 |
| OpenTofu | 2 | 3 | 2 | 2 | — | — | 1 | — | — | 2026-09-18 |
| Prometheus | 2 | — | 1 | 2 | 1 | — | — | — | — | 2026-09-05 |
| Terraform | 6 | 4 | 3 | 8 | 3 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | — | 2 | 2 | 2 | — | — | — | — | 2026-09-02 |
| Vault (`vlt/`) | 1 | — | 1 | — | — | — | — | — | — | 2026-09-19 |

</details>

## Status

Current work strengthens production-ready patterns: private AKS, AWX job templates, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD. Recent additions include the first HashiCorp Vault primer and dev-server script, pipeline health telemetry with DORA metrics, and a two-provider Terraform example.

---
_Last updated: 2026-09-19_