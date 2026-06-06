# DevOps-Kit
> A working engineer's reference for Docker, Git, and Kubernetes — notes, scripts, and snippets.

## What's in here

```
DevOps-Kit/
├── Ansible/
│   └── notes/
│       └── 0000-primer-ansible.md
├── CHANGELOG.md
├── Docker/
│   ├── notes/
│   │   ├── 0000-primer-docker.md
│   │   └── 2026-06-06-exploring-docker-cli.md
│   └── scripts/
│       └── install-and-run-first-container.sh
├── Git/
│   ├── notes/
│   │   ├── 0000-primer-git.md
│   │   ├── 2026-06-04-install-git.md
│   │   └── 2026-06-04-explore-git-cli.md
│   ├── scripts/
│   │   └── install-and-first-commit.sh
│   └── snippets/
│       └── first-commit.sh
├── GitHub/
│   └── notes/
│       └── 0000-primer-github.md
├── Kubernetes/
│   └── notes/
│       └── 0000-primer-kubernetes.md
├── Terraform/
│   └── scripts/
│       └── install-and-init.sh
└── 00_index/
    └── quick-links.md
```

A collection of first-contact notes, setup scripts, and reference snippets for tools a DevOps engineer reaches for daily. Each tool directory follows a consistent layout: a primer, CLI exploration notes, and executable scripts to get from zero to running.

## Coverage

| Tool       | Notes | Scripts | Snippets |
|------------|-------|---------|----------|
| Ansible    | 1     | —       | —        |
| Docker     | 1     | 1       | —        |
| Git        | 3     | 1       | 1        |
| GitHub     | 1     | —       | —        |
| Kubernetes | 2     | 1       | —        |
| Terraform  | 1     | 1       | —        |

## Quick links

- [Ansible primer](Ansible/notes/0000-primer-ansible.md) — Foundational Ansible concepts: control node, inventory, playbooks, modules.
- [Docker primer](Docker/notes/0000-primer-docker.md) — Foundational Docker concepts: images, containers, Dockerfile, volumes.
- [Git primer](Git/notes/0000-primer-git.md) — Core Git concepts: commits, branches, remotes, staging.
- [Git install notes](Git/notes/2026-06-04-install-git.md) — Installing Git on common platforms.
- [Git CLI exploration](Git/notes/2026-06-04-explore-git-cli.md) — Hands-on walkthrough of Git commands.
- [Git install script](Git/scripts/install-and-first-commit.sh) — Script to install Git and make the first commit.
- [Git first-commit snippet](Git/snippets/first-commit.sh) — Minimal shell snippet for initialising a repo and committing.
- [GitHub primer](GitHub/notes/0000-primer-github.md) — Core GitHub concepts: repos, PRs, issues, forks.
- [Kubernetes primer](Kubernetes/notes/0000-primer-kubernetes.md) — Foundational Kubernetes concepts: pods, deployments, services.
- [Kubernetes install + first cluster script](Kubernetes/scripts/install-kind-and-first-cluster.sh) — Script to install kind and create your first cluster.
- [Kubernetes kubectl exploration notes](Kubernetes/notes/2026-06-06-exploring-kubectl.md) — Hands-on walkthrough of kubectl commands.
- [Terraform primer](Terraform/notes/0000-primer-terraform.md) — Core Terraform concepts: providers, state, plan, apply.
- [Terraform install + init script](Terraform/scripts/install-and-init.sh) — Script to install Terraform and run your first init/plan/apply.

## Layout

- **Ansible/** — Primer notes.
- **Docker/** — Primer and CLI notes.
- **Git/** — Primer, install notes, CLI exploration, install script, and commit snippet.
- **GitHub/** — Primer notes.
- **Kubernetes/** — Primer notes and install script.
- **Terraform/** — Primer notes and install script.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

---
_Last updated: 2026-06-06_
