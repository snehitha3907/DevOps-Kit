# DevOps-Kit
> A working engineer's DevOps reference — notes, scripts, configs, and snippets for the tools you reach for daily.

![Last commit](https://img.shields.io/github/last-commit/snehitha3907/DevOps-Kit)
![Files](https://img.shields.io/badge/files-64-blue)
![Python](https://img.shields.io/badge/python-3776AB?logo=python&logoColor=white)
![Shell](https://img.shields.io/badge/shell-4EAA25?logo=gnu-bash&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-7B42BC?logo=terraform&logoColor=white)

```
DevOps-Kit/
├── Ansible/
│   ├── configs/
│   │   ├── docker-python-setup.yaml
│   │   └── nginx-webserver.yaml
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
│   │   ├── 2026-06-12-tried-local-with-vars.tf
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
│   ├── scripts/
│   │   ├── 2026-06-12-bootstrap-terraform-project.sh
│   │   └── install-and-init.sh
└── 00_index/
    ├── glossary.md
    ├── quick-links.md
    └── topics.md
```

First-contact notes, setup scripts, and configs for six tool families a DevOps engineer reaches for every day: Docker, Git, GitHub, Kubernetes, Terraform, and Ansible. Each tool directory follows the same layout — a primer, CLI exploration notes, executable scripts, and any configs or manifests picked up along the way. The kit is meant to be cloned and used as a quick-touch reference, not a tutorial site.

## Coverage

| Tool       | Notes | Scripts | Snippets | Docs | Manifests | Configs |
|------------|-------|---------|----------|------|-----------|---------|
| Ansible    | 4     | 2       | 1        | 1    | —         | 2       |
| Docker     | 4     | 3       | —        | 1    | 1         | 1       |
| General    | —     | —       | —        | 2    | —         | —       |
| Git        | 4     | 3       | 1        | —    | —         | —       |
| GitHub     | 5     | 4       | 2        | —    | —         | 1       |
| Kubernetes | 3     | 2       | —        | —    | 1         | —       |
| Terraform  | 3     | 2       | —        | —    | 1         | 5       |

## Quick links

- [Ansible Docker + Python setup](Ansible/configs/docker-python-setup.yaml) — Playbook for configuring Docker and Python on managed nodes.
- [Ansible playbook troubleshooting](Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md) — Debugging SSH, pipx, and permission issues in playbooks.
- [Docker web + database manifest](Docker/manifests/2026-06-13-web-db-compose.yaml) — Compose manifest for nginx web service with PostgreSQL.
- [Terraform local config with vars](Terraform/configs/2026-06-12-tried-local-with-vars.tf) — Local provider configuration with variables and outputs.
- [Terraform bootstrap script](Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh) — Script to bootstrap a structured Terraform project.

## Layout

- **Ansible/** — Primer notes, getting-started notes, ad-hoc and playbook scripts, and snippets.
- **Docker/** — Primer, CLI notes, configs, dockerfiles, docs, scripts, and compose multi-service script.
- **Git/** — Primer, install notes, CLI exploration, install script, commit snippet, branching workflow, and merge conflict practice.
- **GitHub/** — Primer notes, configs, scripts for CLI and web UI, and Python snippets.
- **General/** — Project-level cleanup notes and rework checks.
- **Kubernetes/** — Primer notes, kubectl exploration, tutorial notes, install script, manifests, and pod lifecycle scripts.
- **Terraform/** — Primer notes, getting-started notes, install and bootstrap scripts, configs, reusable module, and manifests.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

## Status

Currently working through L1 first-contact notes for the remaining tool families. Coverage is strongest on Docker and Git; GitHub and Terraform are filling in.

---
_Last updated: 2026-06-15_
