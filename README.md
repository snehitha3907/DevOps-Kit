# DevOps-Kit

> A working DevOps engineer's quick-reference for Docker, Kubernetes, Terraform, Ansible, Git, GitHub Actions, and the cloud-native toolchain.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Top language](https://img.shields.io/github/languages/top/snehitha3907/DevOps-Kit)
![Languages](https://img.shields.io/github/languages/count/snehitha3907/DevOps-Kit)
![Repo size](https://img.shields.io/github/repo-size/snehitha3907/DevOps-Kit)

> **New here? Start at [the learning path](00_index/learning-path.md).** It walks you from first-contact to confident in a sensible order — read that before this table.

## Who this is for

A working DevOps engineer's quick-reference: first-contact notes, runnable snippets, and configs for the tools you reach for every day. Use it as a shelf you grab from, not a tutorial site. It deliberately does not try to replace each tool's official docs.

## What's in here

First-contact notes, setup scripts, configs, and manifests across eighteen tool families spanning infrastructure provisioning, configuration management, containers, orchestration, CI/CD, observability, and security scanning. Each tool directory follows a consistent layout — a primer, CLI exploration notes, executable scripts, configs, and manifests or snippets picked up along the way. Foundational concept primers under `docs/concepts/` ground the tool-specific material, and Jupyter notebooks go deeper on specific topics.

## Quick links

- [Azure VM scale set with load balancer and autoscaling](Azure/scripts/azure-vm-scale-set-autoscaling.sh) — Provision a VM scale set behind a load balancer with autoscaling rules from the Azure CLI.
- [Git coverage correction](Git/docs/2026-09-17-git-coverage-correction.md) — Notes on reconciling the Git section of the README with what is on disk.
- [Terraform coverage correction](Terraform/docs/2026-09-17-coverage-correction.md) — Notes on reconciling the Terraform section of the README with what is on disk.
- [Production Ansible project scaffold](Ansible/templates/production-ansible-project/README.md) — Full project layout: ansible.cfg, inventory, group_vars, three roles, playbooks, and a CI workflow.
- [Ansible 14 and ansible-core 2.21 migration guide](Ansible/docs/ansible-14-core-2-21-migration-guide.md) — Move a working playbook suite to Ansible 14.3.1: collection compatibility checks, removed Paramiko and interpreter-discovery options, and staged verification.

## Layout

- **00_index/** — Navigation index files (topics, quick-links, glossary, learning-path).
- **AWS/** — Primer, CLI install and configure scripts, EC2 tagging and S3 static-site snippets, and minimal config files with named profiles.
- **Ansible/** — Primer, ad-hoc and playbook scripts, configs, snippets, an nginx template, role scaffold template, a production-ready project scaffold template (ansible.cfg, inventory, group_vars, 3 roles, playbooks, CI workflow), docs, a control-node Dockerfile, and a variable precedence notebook.
- **ArgoCD/** — Primer, quickstart notes, first application and ApplicationSet manifests, and a sync/health verification snippet for GitOps deployment on Kubernetes.
- **Azure/** — Primer, CLI install and login scripts, quickstart trip-up notes, resource group and storage account provisioning snippets, and a VM scale set with load balancer and autoscaling script.
- **Docker/** — Primer, CLI notes, dockerfiles, configs, compose manifests, scripts, docs, a networking drivers notebook, and a reusable Go microservice scaffold.
- **GCP/** — Primer, gcloud CLI install and configure scripts, Compute/GCS listing and IAM snippets, and configs for startup scripts and service accounts.
- **Git/** — Primer, install notes, CLI exploration, branching and merge-conflict scripts, commit snippets, hook and repository-scaffold templates, docs, and a merge-strategies notebook.
- **GitHub/** — Primer, CLI and web UI scripts, configs, docs (deploy-keys vs fine-grained PATs guide, branch protection and required reviews), and Python API snippets.
- **GitHub Actions/** — Quickstart notes, CI workflow configs including a reusable deployment workflow with environment gates, a composite-actions-vs-reusable-workflows guide, runner setup scripts, and REST API snippets.
- **GitLab CI/** — Primer, install and register runner scripts, pipeline configs, and a local pipeline runner.
- **Helm/** — Primer, install and explore CLI script, chart inspection walkthrough, redis chart manifests, live-release and production-deployment values configs, custom-values snippet, and docs.
- **Kubernetes/** — Primer, kubectl exploration, install script, manifests, pod lifecycle scripts, ingress docs, troubleshooting snippets, and a Helm + Kustomize overlay scaffold for deployments with probes and HPA.
- **OpenTofu/** — Primer, install script using the official get.opentofu.org installer, minimal local config, state management tutorial notes, and quickstart trip-ups for the open-source Terraform alternative.
- **Prometheus/** — Primer, getting-started trip-up notes, install and verify script, a minimal scrape config, a container-monitoring config, and a PromQL target-health snippet.
- **Terraform/** — Primer, install and bootstrap scripts, configs, a reusable S3 module, reusable VPC module, a multi-environment workspaces + remote-state scaffold, docs, notebooks, and manifests.
- **Trivy/** — Primer, CLI exploration notes, container scanning scripts, configs, and Python wrappers.
- **docs/** — Foundational concept primers, kit-level operational notes, and internal audit records.
- **CHANGELOG.md** — Kit-level changelog tracking additions, reworks, and audit fixes by date and artifact ID.

## Coverage

<details>
<summary>Coverage table</summary>

| Tool | Notes | Scripts | Configs | Snippets | Docs | Notebooks | Manifests | Templates | Dockerfiles | Last verified |
|------|-------|---------|---------|----------|------|-----------|-----------|-----------|-------------|---------------|
| AWS | 2 | 6 | 2 | 2 | — | — | — | — | — | 2026-08-15 |
| Ansible | 10 | 4 | 7 | 2 | 4 | 1 | 8 | 48 | 1 | 2026-09-16 |
| ArgoCD | 3 | 1 | 2 | 1 | — | — | — | — | — | 2026-08-11 |
| Azure | 3 | 3 | — | 3 | — | — | 1 | — | — | 2026-09-17 |
| Docker | 7 | 5 | 1 | 2 | 6 | 1 | 6 | 6 | 7 | 2026-09-09 |
| GCP | 1 | 3 | 2 | 2 | — | — | — | — | — | 2026-08-24 |
| Git | 8 | 9 | — | 1 | 13 | 1 | — | 22 | — | 2026-09-17 |
| GitHub | 10 | 6 | 7 | 3 | 5 | 1 | — | — | — | 2026-08-23 |
| GitHub Actions | 6 | 3 | 5 | 1 | 5 | — | — | — | — | 2026-09-11 |
| GitLab CI | 3 | 2 | 1 | — | — | — | — | — | — | — |
| Helm | 3 | 1 | 4 | 1 | 3 | — | 4 | — | — | 2026-09-02 |
| Kubernetes | 9 | 2 | 1 | 1 | 4 | 2 | 4 | 10 | — | 2026-09-04 |
| OpenTofu | 2 | 1 | 2 | — | 2 | — | — | — | — | 2026-08-25 |
| Prometheus | 2 | 1 | 2 | 1 | — | — | — | — | — | 2026-09-05 |
| Terraform | 6 | 3 | 7 | 3 | 4 | 2 | 2 | 10 | — | 2026-09-17 |
| Trivy | 5 | 2 | 2 | 2 | — | — | — | — | — | 2026-09-02 |

</details>

## Status

Coverage is strongest on Docker, Git, and GitHub, with deeper config sets in Ansible and Terraform and first-contact notes across the three clouds, ArgoCD, Helm, OpenTofu, Prometheus, and Trivy. Current focus is environment-promotion patterns: per-PR preview environments with gates, a reusable GitHub Actions deployment workflow with approvals, and a multi-environment Terraform scaffold with workspaces and remote state.

---

_Last updated: 2026-09-17_