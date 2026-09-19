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

The kit covers 17 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Shared concept primers in `docs/concepts/` connect the foundations behind the tool-specific material.

## Quick links

- [Exploring the Flux CLI command surface](FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md) — Bootstrap, reconcile, tree, and get commands for the Flux GitOps operator, with the gotchas that tripped me up on first run.
- [Install Flux CLI and run flux check --pre](FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh) — Smallest path to a Flux-ready cluster: install the CLI and verify prerequisites.
- [GitHub CLI quickstart trip-ups](GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md) — What tripped me up while following the official `gh` CLI quickstart: auth, default repo scope, and output formatting.
- [OpenTofu S3 backend with workspace isolation](OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md) — Shared state per environment in S3 with locking so concurrent applies queue instead of clobbering each other.
- [Helm values management approaches](Helm/docs/values-management-approaches.md) — Compares `--set` flags, per-environment values files, and named templates with when to reach for each.

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
- **vlt/** — HashiCorp Vault primer, dev server setup, and KV engine examples (added per changelog vlt-001, vlt-002).
- **docs/** — Foundational concept primers and supporting kit notes.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Scripts | Configs | Snippets | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|---------|---------|----------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | — | 5 | 2 | 2 | — | — | — | — | — |
| Ansible | 10 | 4 | 4 | 8 | 2 | 8 | 2 | 1 | 48 | 2026-07-27 |
| ArgoCD | 3 | — | 1 | 2 | 1 | — | — | — | — | — |
| Azure | 4 | — | 3 | — | 3 | 1 | — | — | — | — |
| Docker | 6 | 6 | 5 | 1 | 2 | 5 | 1 | 8 | 6 | 2026-09-09 |
| Flux CD | 1 | — | 1 | — | — | — | — | — | — | 2026-09-19 |
| GCP | 1 | — | 3 | 2 | 2 | — | — | — | — | — |
| Git | 8 | 13 | 9 | — | 1 | — | 1 | — | 22 | 2026-08-04 |
| GitHub | 11 | 5 | 6 | 7 | 3 | — | 1 | — | — | 2026-08-22 |
| GitHub Actions | 6 | 5 | 3 | 5 | 1 | — | — | — | — | — |
| GitLab CI | 3 | — | 2 | 1 | — | — | — | — | — | — |
| Helm | 3 | 4 | 3 | 4 | 1 | 4 | 1 | — | — | 2026-07-25 |
| Kubernetes | 9 | 4 | 2 | 1 | 2 | 5 | 2 | — | 10 | 2026-07-22 |
| OpenTofu | 2 | 3 | 2 | 2 | — | — | 1 | — | — | 2026-08-25 |
| Prometheus | 2 | — | 1 | 2 | 1 | — | — | — | — | — |
| Terraform | 6 | 4 | 3 | 7 | 3 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | — | 2 | 2 | 2 | — | — | — | — | — |
| HashiCorp Vault | 2 | — | 1 | — | — | — | — | — | — | 2026-09-19 |

</details>

## Status
Current work strengthens production-ready patterns: private AKS, AWX job templates, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD. Recent additions include Flux CLI primer and pre-flight checks, GitHub CLI quickstart trip-ups, and monitoring + containerization observability notebooks.

## Backlog

- **B-01** — HashiCorp Vault (`vlt/`) Coverage row verified against disk: Notes=2 (primer + exploration note), Scripts=1, Last verified 2026-09-19; topics.md now has a Vault section (vlt-004).
- **B-02** — `docs/audit/OpenTofu/notes/0000-primer-opentofu.md` and `docs/audit/OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh` are duplicates of `OpenTofu/notes/0000-primer-opentofu.md` and `OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh`. Decide whether to keep both, merge, or remove the audit-path copies.
- **B-03** — `docs/audit/README.md` and `docs/audit/00_index/topics.md` are stubs with no inbound markdown links. Either complete them with real content or remove.
- **B-04** — CHANGELOG historical references contain stale paths: `tf/manifests/reusable-vpc-module.hcl` (should be `Terraform/manifests/reusable-vpc-module.hcl`), `General/docs/*.md` (never existed, noted as removed), `Docker/notes/docker-compose.yml` (removed per 2026-09-17 audit fix).
- **B-05** — Orphan files with no inbound links require review: `Git/docs/github.sh`, `Git/notes/file.py`, `Git/notes/readme.md`, `Git/docs/regression-test.sh` (duplicate of `docs/audit/regression-test.sh`), `docs/concepts/version-control-concepts/config_final_v2_REALLY_FINAL.sh`, `docs/audit/regression-test.sh`.

---

_Last updated: 2026-09-19_