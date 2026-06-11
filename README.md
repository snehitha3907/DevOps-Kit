# DevOps-Kit
> A working engineer's reference for Docker, Git, GitHub, Kubernetes, Terraform, and Ansible — notes, scripts, configs, and snippets.

## What\'s in here

```
DevOps-Kit/
├── Ansible/
│   ├── notes/
│   │   ├── 0000-primer-ansible.md
│   │   └── 2026-06-06-exploring-ansible-cli.md
│   └── scripts/
│       └── install-and-first-adhoc.sh
├── CHANGELOG.md
├── Docker/
│   ├── configs/
│   │   └── multi-service-app.yaml
│   ├── docs/
│   │   └── docker-run-vs-compose.md
│   ├── dockerfiles/
│   │   ├── first-docker-image.Dockerfile
│   │   └── tried-building-first-image.Dockerfile
│   ├── notes/
│   │   ├── 0000-primer-docker.md
│   │   ├── 2026-06-05-explore-docker-cli.md
│   │   ├── 2026-06-06-exploring-docker-cli.md
│   │   └── 2026-06-07-docker-compose-quickstart.md
│   └── scripts/
│       ├── install-and-run-container.sh
│       └── install-and-run-first-container.sh
├── Git/
│   ├── notes/
│   │   ├── 0000-primer-git.md
│   │   ├── 2026-06-04-install-git.md
│   │   ├── 2026-06-04-explore-git-cli.md
│   │   └── 2026-06-07-git-branching-tutorial.md
│   ├── scripts/
│   │   ├── 2026-06-10-merge-conflict-practice.sh
│   │   ├── install-and-first-commit.sh
│   │   └── minimal-branching-workflow.sh
│   └── snippets/
│       └── first-commit.sh
├── GitHub/
│   ├── notes/
│   │   ├── 0000-primer-github.md
│   │   ├── 2026-06-07-explore-github-web-and-cli.md
│   │   ├── 2026-06-10-exploring-github-repos-issues-prs.md
│   │   └── 2026-06-10-github-platform-features.md
│   └── scripts/
│       ├── auth-and-profile.sh
│       ├── tried-auth-and-profile.sh
│       └── tried-commenting-on-first-issue.sh
├── Kubernetes/
│   ├── manifests/
│   │   └── stateless-app.yaml
│   ├── notes/
│   │   ├── 0000-primer-kubernetes.md
│   │   ├── 2026-06-06-exploring-kubectl.md
│   │   └── 2026-06-08-kubernetes-interactive-tutorial.md
│   └── scripts/
│       ├── install-kind-and-first-cluster.sh
│       └── pod-lifecycle.sh
├── Terraform/
│   ├── configs/
│   │   └── local-file.tf
│   ├── manifests/
│   │   └── simple-ec2-app.tf
│   ├── notes/
│   │   ├── 0000-primer-terraform.md
│   │   └── 2026-06-06-exploring-terraform-cli.md
│   └── scripts/
│       └── install-and-init.sh
└── 00_index/
    ├── glossary.md
    ├── quick-links.md
    └── topics.md
```

A collection of first-contact notes, setup scripts, and reference snippets for tools a DevOps engineer reaches for daily. Each tool directory follows a consistent layout: a primer, CLI exploration notes, and executable scripts to get from zero to running.

## Coverage

| Tool       | Notes | Scripts | Snippets | Docs | Manifests | Configs |
|------------|-------|---------|----------|------|-----------|---------|
| Ansible    | 2     | 1       | —        | —    | —         | —       |
| Docker     | 4     | 2       | —        | 1    | —         | 1       |
| Git        | 4     | 3       | 1        | —    | —         | —       |
| GitHub     | 4     | 3       | —        | —    | —         | —       |
| Kubernetes | 3     | 2       | —        | —    | 1         | —       |
| Terraform  | 2     | 1       | —        | —    | 1         | 1       |

## Quick links

- [Ansible primer](Ansible/notes/0000-primer-ansible.md) — Foundational Ansible concepts: control node, inventory, playbooks, modules.
- [Ansible CLI exploration](Ansible/notes/2026-06-06-exploring-ansible-cli.md) — Hands-on walkthrough of ad-hoc commands and inventory.
- [Docker primer](Docker/notes/0000-primer-docker.md) — Foundational Docker concepts: images, containers, Dockerfile, volumes.
- [Docker CLI exploration](Docker/notes/2026-06-06-exploring-docker-cli.md) — Hands-on walkthrough of running containers.
- [Docker CLI exploration (alt)](Docker/notes/2026-06-05-explore-docker-cli.md) — Alternate notes on Docker commands.
- [Docker Compose quickstart](Docker/notes/2026-06-07-docker-compose-quickstart.md) — Notes on compose syntax and gotchas.
- [docker run vs compose](Docker/docs/docker-run-vs-compose.md) — Decision guide for when to use each approach.
- [Git primer](Git/notes/0000-primer-git.md) — Core Git concepts: commits, branches, remotes, staging.
- [Git install notes](Git/notes/2026-06-04-install-git.md) — Installing Git on common platforms.
- [Git CLI exploration](Git/notes/2026-06-04-explore-git-cli.md) — Hands-on walkthrough of Git commands.
- [Git branching tutorial](Git/notes/2026-06-07-git-branching-tutorial.md) — Following the official branching tutorial.
- [Git install script](Git/scripts/install-and-first-commit.sh) — Script to install Git and make the first commit.
- [Git minimal branching workflow](Git/scripts/minimal-branching-workflow.sh) — Script demonstrating branch/create/merge/rebase.
- [Git first-commit snippet](Git/snippets/first-commit.sh) — Minimal shell snippet for initialising a repo and committing.
- [GitHub primer](GitHub/notes/0000-primer-github.md) — Core GitHub concepts: repos, PRs, issues, forks.
- [GitHub web and CLI exploration](GitHub/notes/2026-06-07-explore-github-web-and-cli.md) — Hands-on walkthrough of gh CLI commands.
- [GitHub auth script](GitHub/scripts/auth-and-profile.sh) — Script to authenticate and view profile info.
- [GitHub auth attempt script](GitHub/scripts/tried-auth-and-profile.sh) — Script attempting GitHub authentication.
- [GitHub issue comment script](GitHub/scripts/tried-commenting-on-first-issue.sh) — Script to comment on issues.
- [Kubernetes primer](Kubernetes/notes/0000-primer-kubernetes.md) — Foundational Kubernetes concepts: pods, deployments, services.
- [Kubernetes kubectl exploration](Kubernetes/notes/2026-06-06-exploring-kubectl.md) — Hands-on walkthrough of kubectl commands.
- [Kubernetes interactive tutorial notes](Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md) — Notes from the k8s.io tutorial.
- [Kubernetes install script](Kubernetes/scripts/install-kind-and-first-cluster.sh) — Script to install kind and create your first cluster.
- [Kubernetes pod lifecycle script](Kubernetes/scripts/pod-lifecycle.sh) — Script managing pod lifecycle operations.
- [Kubernetes stateless app manifest](Kubernetes/manifests/stateless-app.yaml) — Deployment and Service manifest for a stateless app.
- [Terraform primer](Terraform/notes/0000-primer-terraform.md) — Core Terraform concepts: providers, state, plan, apply.
- [Terraform CLI exploration](Terraform/notes/2026-06-06-exploring-terraform-cli.md) — Hands-on walkthrough of init/plan/apply.
- [Terraform install script](Terraform/scripts/install-and-init.sh) — Script to install Terraform and run your first init/plan/apply.
- [Terraform local file config](Terraform/configs/local-file.tf) — Example Terraform configuration for local file resource.
- [Terraform EC2 app manifest](Terraform/manifests/simple-ec2-app.tf) — EC2 instance with security group manifest for AWS.

## Layout

- **Ansible/** — Primer notes and scripts.
- **Docker/** — Primer, CLI notes, configs, dockerfiles, docs, and scripts.
- **Git/** — Primer, install notes, CLI exploration, install script, commit snippet, branching workflow, and merge conflict practice.
- **GitHub/** — Primer notes and scripts for CLI and web UI.
- **Kubernetes/** — Primer notes, kubectl exploration, tutorial notes, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, install script, configs, and manifests.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

---
_Last updated: 2026-06-11_
