# DevOps-Kit
> A working engineer's reference for Docker, Git, GitHub, Kubernetes, Terraform, and Ansible — notes, scripts, configs, and snippets.

## What's in here

A collection of first-contact notes, setup scripts, and reference material for tools a DevOps engineer reaches for daily. Each tool directory follows a consistent layout: a primer, CLI exploration notes, executable scripts, and supplementary content (snippets, configs, Dockerfiles). Covers six tool families across 32 files.

## Coverage

| Tool       | Notes | Scripts | Snippets | Configs | Dockerfiles |
|------------|-------|---------|----------|---------|-------------|
| Ansible    | 2     | 1       | —        | —       | —           |
| Docker     | 4     | 2       | —        | 1       | 1           |
| Git        | 4     | 2       | 1        | —       | —           |
| GitHub     | 2     | 1       | —        | —       | —           |
| Kubernetes | 2     | 1       | —        | —       | —           |
| Terraform  | 2     | 1       | —        | —       | —           |

## Quick links

- [Docker: multi-service app config](Docker/configs/multi-service-app.yaml) — Docker Compose config for a multi-service application.
- [Docker: compose quickstart](Docker/notes/2026-06-07-docker-compose-quickstart.md) — Notes on getting started with Docker Compose.
- [Docker: first image Dockerfile](Docker/dockerfiles/first-docker-image.Dockerfile) — Minimal Dockerfile that builds and runs a first image.
- [GitHub: web UI and CLI notes](GitHub/notes/2026-06-07-explore-github-web-and-cli.md) — Walkthrough of GitHub's web UI and gh CLI.
- [GitHub: auth and profile script](GitHub/scripts/auth-and-profile.sh) — Script to authenticate with gh CLI and configure profile basics.

## Layout

- **Ansible/** — Primer, CLI notes, and ad-hoc script.
- **Docker/** — Primer, CLI notes, compose quickstart, install scripts, multi-service config, and Dockerfile.
- **Git/** — Primer, install notes, CLI exploration, branching tutorial, install script, branching workflow, and commit snippet.
- **GitHub/** — Primer, web/CLI notes, auth script, and issue interaction script.
- **Kubernetes/** — Primer, kubectl notes, interactive tutorial, and kind install script.
- **Terraform/** — Primer, CLI notes, and install/init script.
- **00_index/** — Navigation index files (topics, quick-links, glossary).
- **CHANGELOG.md** — Kit-level change log.

---
_Last updated: 2026-06-08_
