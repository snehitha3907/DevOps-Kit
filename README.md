# DevOps-Kit

> A working DevOps engineer's quick-reference for Docker, Kubernetes, Terraform, Ansible, Git, and the cloud-native toolchain.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests across sixteen tool families spanning infrastructure provisioning, configuration management, containers, orchestration, CI/CD, observability, and security scanning. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and manifests or snippets picked up along the way. Foundational concept primers under `docs/concepts/` (CI/CD, containerization, infrastructure as code, Linux & system administration, monitoring & observability, networking fundamentals, scripting & automation, and version control) ground the tool-specific material, and Jupyter notebooks go deeper on specific topics. A lowercase `git/` companion directory holds bisect notes, branching mechanics, a pre-commit workflow guide, a merge-strategies notebook, and a second repo-scaffold template alongside the main `Git/` toolkit. A lowercase `k8s/` companion holds a Helm chart and Kustomize overlay scaffold for a Kubernetes Deployment with probes and HPA. A lowercase `tf/` companion holds first-contact Terraform notes alongside the main `Terraform/` toolkit.

## Quick links

- [Install Terraform and first local file](tf/notes/2026-09-03-install-terraform-and-first-local-file.md) — First-contact Terraform notes: install the CLI, initialise a local working directory, and run the first plan/apply against a local_file resource.
- [Terraform modules and environment promotion with Git branching](docs/concepts/version-control-concepts/docs/terraform-modules-environment-promotion.md) — Branching model for versioning and promoting Terraform modules across staging and production without rebuilding or hand-editing state.
- [Branch management and merge validation script](docs/concepts/version-control-concepts/scripts/branch-management-merge-validation.sh) — Comprehensive script covering branching, merging, and tag creation for version control workflows.
- [Terraform and Docker integration patterns](docs/concepts/infrastructure-as-code-concepts/docs/terraform-docker-integration-patterns.md) — Patterns for integrating Terraform infrastructure provisioning with Docker containerization in a real deployment pipeline.
- [Container build/push pipeline script](docs/concepts/containerization-concepts/scripts/build-and-push-pipeline.py) — Python script simulating a container build, tag, and push pipeline for a multi-stage CI workflow.

## Layout

- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **AWS/** — Primer, CLI install and configure scripts, EC2 tagging and S3 static-site snippets, and minimal config files with named profiles.
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, role scaffold template, docs, and a variable precedence notebook.
- **ArgoCD/** — Primer, quickstart notes, and first application and ApplicationSet manifests for GitOps deployment on Kubernetes.
- **Azure/** — Primer, CLI install and login scripts, quickstart trip-up notes, and resource group and storage account provisioning snippets.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, a networking drivers notebook, and a reusable Go microservice scaffold.
- **GCP/** — Primer, gcloud CLI install and configure scripts, Compute/GCS listing and IAM snippets, and configs for startup scripts and service accounts.
- **Git/** — Primer, install notes, CLI exploration, branching and merge-conflict scripts, commit snippets, hook and repository-scaffold templates, docs, and a merge-strategies notebook.
- **git/** — Companion lowercase directory mirroring a subset of `Git/` (bisect notes, branching mechanics, a pre-commit workflow guide, a merge-strategies notebook, and a second repo-scaffold); prefer `Git/` for the main toolkit.
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs (deploy-keys vs fine-grained PATs guide, branch protection and required reviews), and Python API snippets.
- **GitHub Actions/** — Quickstart notes, CI workflow configs, and REST API snippets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and a local pipeline runner.
- **Helm/** — Primer, install and explore CLI script, chart inspection walkthrough, redis chart manifests, live-release and production-deployment values configs, custom-values snippet, and docs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, pod lifecycle scripts, ingress docs, and troubleshooting snippets.
- **k8s/** — Companion lowercase directory holding a Helm chart and Kustomize overlay scaffold for a Kubernetes Deployment with probes, HPA, and dev/prod overlays. Prefer `Kubernetes/` for the main toolkit.
- **OpenTofu/** — Primer, install script using the official get.opentofu.org installer, minimal local config, state management tutorial notes, and quickstart trip-ups for the open-source Terraform alternative.
- **Prometheus/** — Primer, install and verify script, and a minimal scrape config for metrics collection.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, reusable VPC module, docs, notebooks, and manifests.
- **Trivy/** — Primer, CLI exploration notes, container scanning scripts, configs, and Python wrappers.
- **docs/** — Foundational concept primers, kit-level operational notes, and internal audit records.
- **CHANGELOG.md** — Chronological record of additions, reworks, and audit fixes.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Docs | Notebooks | Manifests | Templates | Dockerfiles | Last verified |
|------|-------|---------|---------|----------|------|-----------|-----------|-----------|-------------|---------------|
| Ansible | 7 | 4 | 7 | 2 | 3 | 1 | 8 | 14 | 1 | 2026-08-24 |
| ArgoCD | 2 | 1 | 2 | — | — | — | — | — | — | 2026-08-11 |
| AWS | 2 | 5 | 2 | 2 | — | — | — | — | — | 2026-08-16 |
| Azure | 3 | 2 | — | 2 | — | — | — | — | — | 2026-08-23 |
| Docker | 5 | 5 | 1 | 2 | 3 | 1 | 5 | 6 | 7 | 2026-08-12 |
| GCP | 1 | 3 | 2 | 2 | — | — | — | — | — | 2026-08-24 |
| Git | 4 | 9 | — | 1 | 5 | 1 | — | 21 | — | 2026-08-24 |
| GitHub | 10 | 6 | 7 | 3 | 4 | 1 | — | — | — | 2026-08-23 |
| GitHub Actions | 3 | 2 | 4 | 1 | 1 | — | — | — | — | 2026-08-15 |
| GitLab CI | 2 | 2 | 1 | — | — | — | — | — | — | — |
| Helm | 2 | 1 | 4 | 1 | 3 | — | 4 | — | — | 2026-09-02 |
| Kubernetes | 6 | 2 | 1 | 1 | 1 | 1 | 4 | — | — | 2026-08-25 |
| OpenTofu | 2 | 1 | 2 | — | 1 | — | — | — | — | 2026-08-25 |
| Prometheus | 1 | 1 | 1 | — | — | — | — | — | — | 2026-07-23 |
| Terraform | 5 | 3 | 6 | 2 | 3 | 1 | 2 | — | — | 2026-08-25 |
| Trivy | 5 | 2 | 2 | 2 | — | — | — | — | — | 2026-09-02 |
| git (companion) | 1 | — | — | — | 4 | 1 | — | 7 | — | 2026-08-25 |
| k8s (companion) | — | — | — | — | 1 | — | — | 10 | — | 2026-08-29 |
| tf (companion) | 1 | — | — | — | — | — | — | — | — | 2026-09-03 |

*Rows follow the on-disk capitalized tool directories, plus the lowercase `git/`, `k8s/`, and `tf/` companion directories which hold supplementary material. Prefer the capitalized folders for the main toolkit. `Last verified` is the most recent `last_verified` stamp found in that tool's docs, configs, and scripts.*

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub, with deeper config sets in Ansible and Terraform and first-contact notes across the three clouds, ArgoCD, Helm, OpenTofu, Prometheus, and Trivy. Current focus is Kubernetes workload hardening and Prometheus integration — a Go service Deployment with probes and autoscaling, a companion Helm/Kustomize scaffold, a new Kubernetes + Prometheus service-discovery guide, and a network health telemetry visualization notebook. The Trivy wrapper that fails a build on critical CVEs and the scan-policies config remain the security entry point.

---
_Last updated: 2026-09-04_
