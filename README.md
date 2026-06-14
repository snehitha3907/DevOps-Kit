# DevOps-Kit
> A working engineer's reference for Docker, Git, GitHub, Kubernetes, Terraform, and Ansible — notes, scripts, configs, and snippets.

## What\'s in here

```
DevOps-Kit/
├── Ansible/
│   ├── configs/
│   │   └── docker-python-setup.yaml
│   ├── notes/
│   │   ├── 0000-primer-ansible.md
│   │   ├── 2026-06-06-exploring-ansible-cli.md
│   │   ├── 2026-06-11-ansible-getting-started.md
│   │   └── 2026-06-13-ansible-playbook-troubleshooting.md
│   ├── scripts/
│   │   ├── install-and-first-adhoc.sh
│   │   └── run-first-playbook.sh
│   └── snippets/
│       └── nginx-playbook.yaml
├── CHANGELOG.md
├── Docker/
│   ├── configs/
│   │   └── multi-service-app.yaml
│   ├── docs/
│   │   └── docker-run-vs-compose.md
│   ├── dockerfiles/
│   │   ├── first-docker-image.Dockerfile
│   │   └── tried-building-first-image.Dockerfile
│   ├── manifests/
│   │   └── 2026-06-13-web-db-compose.yaml
│   ├── notes/
│   │   ├── 0000-primer-docker.md
│   │   ├── 2026-06-05-explore-docker-cli.md
│   │   ├── 2026-06-06-exploring-docker-cli.md
│   │   └── 2026-06-07-docker-compose-quickstart.md
│   └── scripts/
│       ├── 2026-06-12-compose-multi-service.sh
│       ├── install-and-run-container.sh
│       └── install-and-run-first-container.sh
├── General/
│   └── docs/
│       ├── 2026-06-13-rework-undocumented-files.md
│       └── 2026-06-14-rework-gen002-already-documented.md
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
│   ├── configs/
│   │   └── issue-templates-and-labels.yaml
│   ├── notes/
│   │   ├── 0000-primer-github.md
│   │   ├── 2026-06-07-explore-github-web-and-cli.md
│   │   ├── 2026-06-10-exploring-github-repos-issues-prs.md
│   │   ├── 2026-06-10-github-platform-features.md
│   │   └── 2026-06-11-following-github-cli-quickstart.md
│   ├── scripts/
│   │   ├── 2026-06-12-create-repo-and-pr.sh
│   │   ├── auth-and-profile.sh
│   │   ├── tried-auth-and-profile.sh
│   │   └── tried-commenting-on-first-issue.sh
│   └── snippets/
│       ├── github-issues-api.py
│       └── list-repos-with-python.py
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
│   │   ├── local-file.tf
│   │   └── reusable-s3-module/
│   │       ├── README.md
│   │       ├── examples/
│   │       │   └── basic/
│   │       │       └── main.tf
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   ├── manifests/
│   │   └── simple-ec2-app.tf
│   ├── notes/
│   │   ├── 0000-primer-terraform.md
│   │   ├── 2026-06-06-exploring-terraform-cli.md
│   │   └── 2026-06-10-terraform-getting-started.md
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
| Ansible    | 3     | 2       | 1        | —    | —         | 1       |
| Docker     | 4     | 3       | —        | 1    | 1         | 1       |
| General    | —     | —       | —        | 2    | —         | —       |
| Git        | 4     | 3       | 1        | —    | —         | —       |
| GitHub     | 5     | 4       | 2        | —    | —         | 1       |
| Kubernetes | 3     | 2       | —        | —    | 1         | —       |
| Terraform  | 3     | 1       | —        | —    | 1         | 4       |

## Quick links

- [Ansible primer](Ansible/notes/0000-primer-ansible.md) — Foundational Ansible concepts: control node, inventory, playbooks, modules.
- [Ansible CLI exploration](Ansible/notes/2026-06-06-exploring-ansible-cli.md) — Hands-on walkthrough of ad-hoc commands and inventory.
- [Ansible getting started](Ansible/notes/2026-06-11-ansible-getting-started.md) — Notes for moving from first ad-hoc commands to a first playbook.
- [Ansible first ad-hoc script](Ansible/scripts/install-and-first-adhoc.sh) — Script to install Ansible and run the first ad-hoc command.
- [Ansible first playbook script](Ansible/scripts/run-first-playbook.sh) — Script to run a first playbook against inventory.
- [Ansible nginx playbook snippet](Ansible/snippets/nginx-playbook.yaml) — Minimal nginx deployment playbook snippet.
- [Ansible troubleshooting notes](Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md) — SSH, pipx, and permission issues encountered.
- [Docker primer](Docker/notes/0000-primer-docker.md) — Foundational Docker concepts: images, containers, Dockerfile, volumes.
- [Docker CLI exploration](Docker/notes/2026-06-06-exploring-docker-cli.md) — Hands-on walkthrough of running containers.
- [Docker CLI exploration (alt)](Docker/notes/2026-06-05-explore-docker-cli.md) — Alternate notes on Docker commands.
- [Docker Compose quickstart](Docker/notes/2026-06-07-docker-compose-quickstart.md) — Notes on compose syntax and gotchas.
- [Docker Compose multi-service script](Docker/scripts/2026-06-12-compose-multi-service.sh) — Script for bringing up a multi-service compose stack.
- [Docker web and database manifest](Docker/manifests/2026-06-13-web-db-compose.yaml) — Compose manifest for an nginx web service with PostgreSQL.
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
- [GitHub repos, issues, and PRs exploration](GitHub/notes/2026-06-10-exploring-github-repos-issues-prs.md) — Exploration of GitHub API workflows for repos, issues, and PRs.
- [GitHub platform features](GitHub/notes/2026-06-10-github-platform-features.md) — Notes on GitHub wiki, projects, and insights.
- [GitHub CLI quickstart follow-up](GitHub/notes/2026-06-11-following-github-cli-quickstart.md) — Follow-up notes from the GitHub CLI quickstart.
- [GitHub auth script](GitHub/scripts/auth-and-profile.sh) — Script to authenticate and view profile info.
- [GitHub auth attempt script](GitHub/scripts/tried-auth-and-profile.sh) — Script attempting GitHub authentication.
- [GitHub issue comment script](GitHub/scripts/tried-commenting-on-first-issue.sh) — Script to comment on issues.
- [GitHub create repo and PR script](GitHub/scripts/2026-06-12-create-repo-and-pr.sh) — Script to create a repository and open a pull request.
- [GitHub issue templates config](GitHub/configs/issue-templates-and-labels.yaml) — Repository issue templates and labels configuration.
- [GitHub issues API snippet](GitHub/snippets/github-issues-api.py) — Python snippet for working with GitHub issues via the API.
- [GitHub list repos snippet](GitHub/snippets/list-repos-with-python.py) — Python snippet for listing repositories.
- [Kubernetes primer](Kubernetes/notes/0000-primer-kubernetes.md) — Foundational Kubernetes concepts: pods, deployments, services.
- [Kubernetes kubectl exploration](Kubernetes/notes/2026-06-06-exploring-kubectl.md) — Hands-on walkthrough of kubectl commands.
- [Kubernetes interactive tutorial notes](Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md) — Notes from the k8s.io tutorial.
- [Kubernetes install script](Kubernetes/scripts/install-kind-and-first-cluster.sh) — Script to install kind and create your first cluster.
- [Kubernetes pod lifecycle script](Kubernetes/scripts/pod-lifecycle.sh) — Script managing pod lifecycle operations.
- [Kubernetes stateless app manifest](Kubernetes/manifests/stateless-app.yaml) — Deployment and Service manifest for a stateless app.
- [Terraform primer](Terraform/notes/0000-primer-terraform.md) — Core Terraform concepts: providers, state, plan, apply.
- [Terraform CLI exploration](Terraform/notes/2026-06-06-exploring-terraform-cli.md) — Hands-on walkthrough of init/plan/apply.
- [Terraform getting started](Terraform/notes/2026-06-10-terraform-getting-started.md) — Follow-up notes for the first Terraform workflow.
- [Terraform install script](Terraform/scripts/install-and-init.sh) — Script to install Terraform and run your first init/plan/apply.
- [Terraform local file config](Terraform/configs/local-file.tf) — Example Terraform configuration for local file resource.
- [Terraform reusable S3 module](Terraform/configs/reusable-s3-module/main.tf) — Reusable S3 module configuration.
- [Terraform EC2 app manifest](Terraform/manifests/simple-ec2-app.tf) — EC2 instance with security group manifest for AWS.

## Layout

- **Ansible/** — Primer notes, getting-started notes, ad-hoc and playbook scripts, and snippets.
- **Docker/** — Primer, CLI notes, configs, dockerfiles, docs, scripts, and compose multi-service script.
- **Git/** — Primer, install notes, CLI exploration, install script, commit snippet, branching workflow, and merge conflict practice.
- **GitHub/** — Primer notes, configs, scripts for CLI and web UI, and Python snippets.
- **General/** — Project-level cleanup notes and rework checks.
- **Kubernetes/** — Primer notes, kubectl exploration, tutorial notes, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, getting-started notes, install script, configs, reusable module, and manifests.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

---
_Last updated: 2026-06-14_
