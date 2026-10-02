# DevOps-Kit
> A working DevOps engineer's shelf for cloud CLIs, containers, orchestration, infrastructure as code, CI/CD, observability, and security scanning.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable scripts, and configs for the tools you reach for while building and operating systems. Use it as a shelf to grab a primer, verify a command, or borrow a concrete manifest that you can edit into your own. It is not a tutorial site and it does not try to replace each tool's official documentation.

## What's in here

The kit covers 22 tool families across cloud CLIs, configuration management, containers, orchestration, Git hosting, CI/CD, infrastructure as code, secrets management, observability, and security scanning. Most tool folders pair a primer with notes, scripts, configs, manifests, snippets, notebooks, Dockerfiles, or templates. Under `docs/concepts/`, eight foundational concept primers cover the ground the tool-specific material stands on — networking, Linux, scripting, version control, infrastructure as code, CI/CD, containerization, and observability.

## Quick links

- [GitLab CI/CD with Kubernetes, end to end](GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md) — The path from a push to a running Deployment: a runner that can reach the cluster, a credential the job is allowed to hold, and the gate that keeps a merge request from touching it.
- [Dynamic child pipeline scaffold](GitLab CI/scripts/dynamic-child-pipeline.sh) — For when the set of jobs is only knowable at run time, and the child config has to be written by a job before anything can trigger it.
- [Wiring ArgoCD with GitHub for GitOps deployment](ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md) — The control plane reading manifests from a private repo, and where the two-sided integration broke.
- [Multi-cluster ApplicationSet](ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml) — One generator fanning out a guestbook Deployment per cluster, and the install flags that large CRD needs.
- [Build an Application from scratch and sync it](ArgoCD/scripts/build-argocd-application-from-scratch.sh) — Idempotent end-to-end counterpart to install, login, and sync; safe as a CI deploy step.

## Layout

- **00_index/** — Topics map, quick links, glossary, and learning path.
- **AWS/** — AWS CLI setup, profiles, resource listings, tagging, S3 website examples, boto3 snippets and stack builders, an IAM least-privilege walkthrough, and a boto3-vs-CloudFormation-vs-CDK comparison notebook.
- **Ansible/** — Primers, playbooks, inventories, roles, templates, Docker integration, and execution-pattern notebooks.
- **ArgoCD/** — GitOps primer, Application and ApplicationSet manifests including a multi-cluster one, GitHub wiring, installation, scripted sync, and health checks.
- **Azure/** — Azure CLI setup, CLI-vs-Bicep-vs-Python-SDK comparison, resource provisioning, VM scale sets, and a private AKS Bicep example.
- **Docker/** — Container primers, Dockerfiles, Compose stacks, build-strategy and networking notebooks, health checks, Go and Compose scaffolds, and a Docker-to-Kubernetes handoff guide.
- **FluxCD/** — Flux CLI primer, bootstrap, reconcile, GitRepository/Kustomization manifests, and pre-flight cluster checks.
- **GCP/** — gcloud setup, Compute and Cloud Storage examples, IAM, startup scripts, instance templates, and a scripted Cloud Run deployment.
- **Git/** — Branching, hooks, worktrees, merge strategies, repository scaffolds, gitattributes setup, and regression examples.
- **GitHub/** — Repository operations, repo scaffold template, issue forms, branch protection, API examples, and release automation notes.
- **GitHub Actions/** — Workflow primers, reusable workflows, runner setup, and dispatch examples.
- **GitLab CI** — Pipeline primer, runner setup, variables and artifacts notes, minimal pipeline configs, multi-project and dynamic child pipelines, a build-to-deploy-to-Kubernetes walkthrough, and an API trigger snippet.
- **graf/** — Grafana primer, Docker-based install script, UI exploration notes, and quickstart trip-ups.
- **grafc/** — Grafana Cloud first contact: an agent scrape config, a dashboard created over the HTTP API, and notes from the hosted UI.
- **Helm/** — Chart inspection, values files, values-management approaches, Redis chart manifests, release testing, and chart scaffolding.
- **Kubernetes/** — kubectl notes, workloads, probes, ingress, monitoring, production patterns with HPA and PDB, and Helm/Kustomize overlays.
- **OpenTelemetry** (folder `otel/`) — Traces primer, collector install script, first-span snippet, a minimal OTLP export config, quickstart trip-ups, and an instrumented Go server.
- **OpenTofu/** — OpenTofu primer, local configuration, S3 remote state with workspace isolation, state management, and verification.
- **Prometheus/** — Scrape configuration, target health checks, a hand-rolled exporter, recording versus alerting rules, Alertmanager-to-PagerDuty routing, and getting-started notes.
- **Terraform/** — Terraform primer, modules, workspaces, remote state, notebooks, and environment scaffolds.
- **Trivy/** — Image and filesystem scanning, scan-mode selection, severity policies, and Python wrappers.
- **plm/** — Pulumi primer, CLI install and project init, and a minimal Python bucket snippet.
- **vlt/** — HashiCorp Vault primer, dev server setup, KV engine examples, and a script that mounts a first secrets engine at a custom path.
- **docs/** — Foundational concept primers under `docs/concepts/`, plus notes about the kit itself.
- **CHANGELOG.md** — Dated record of additions, reworks, and navigation corrections.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Docs | Snippets | Scripts | Configs | Manifests | Notebooks | Dockerfiles | Templates | Last verified |
|------|-------|------|----------|---------|---------|-----------|-----------|-------------|-----------|---------------|
| AWS | 2 | 1 | 3 | 6 | 2 | — | 1 | — | — | 2026-09-23 |
| Ansible | 10 | 4 | 2 | 4 | 8 | 8 | 2 | 1 | 48 | 2026-09-16 |
| ArgoCD | 3 | 1 | 1 | 2 | 3 | — | — | — | — | 2026-10-02 |
| Azure | 4 | 1 | 3 | 3 | — | 1 | — | — | — | 2026-09-19 |
| Docker | 6 | 7 | 2 | 5 | 1 | 6 | 3 | 9 | 12 | 2026-09-29 |
| FluxCD | 2 | 1 | — | 1 | 1 | — | — | — | — | 2026-09-30 |
| GCP | 2 | 1 | 2 | 5 | 3 | — | — | — | — | 2026-09-28 |
| Git | 8 | 15 | 1 | 11 | — | — | 1 | — | 22 | 2026-09-25 |
| GitHub | 11 | 6 | 3 | 6 | 7 | 1 | 1 | 1 | 11 | 2026-10-01 |
| GitHub Actions | 6 | 5 | 1 | 3 | 5 | — | — | — | — | 2026-09-11 |
| GitLab CI | 4 | 1 | 1 | 4 | 4 | — | — | — | — | 2026-10-02 |
| Grafana (`graf/`) | 3 | 2 | — | 1 | — | — | — | — | — | 2026-09-29 |
| Grafana Cloud (`grafc/`) | 1 | — | 1 | — | 1 | — | — | — | — | 2026-09-30 |
| Helm | 3 | 4 | 1 | 3 | 4 | 4 | 1 | — | — | 2026-09-18 |
| Kubernetes | 9 | 4 | 2 | 3 | 1 | 5 | 2 | — | 10 | 2026-09-04 |
| OpenTelemetry (`otel/`) | 2 | 1 | 2 | 1 | 1 | — | — | — | — | 2026-09-30 |
| OpenTofu | 2 | 3 | — | 2 | 2 | — | 1 | — | — | 2026-09-18 |
| Prometheus | 2 | 1 | 1 | 2 | 3 | — | — | — | — | 2026-09-30 |
| Pulumi (`plm/`) | 1 | 1 | 1 | 1 | — | — | — | — | — | 2026-09-20 |
| Terraform | 6 | 4 | 3 | 3 | 8 | 2 | 2 | — | 10 | 2026-09-17 |
| Trivy | 5 | 1 | 2 | 4 | 2 | — | — | — | — | 2026-09-23 |
| HashiCorp Vault (`vlt/`) | 2 | 1 | — | 2 | — | — | — | — | — | 2026-09-19 |

</details>

## Status

Current focus is the seam between CI and the cluster: a GitLab runner that can reach Kubernetes and roll a digest-pinned image, dynamic child pipelines for job sets that only exist at run time, and ArgoCD reading from a private GitHub repo with a multi-cluster ApplicationSet. The rest of the kit stays where it is — production patterns for AKS, Helm chart validation, Ansible rollout safeguards, and environment promotion across Terraform, containers, and CI/CD.

---
_Last updated: 2026-10-02_