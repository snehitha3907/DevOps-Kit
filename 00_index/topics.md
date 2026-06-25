# Topics

## Ansible

- [note] [Ansible/notes/0000-primer-ansible.md](../Ansible/notes/0000-primer-ansible.md) — Primer covering control node, inventory, playbooks, and modules.
- [note] [Ansible/notes/2026-06-06-exploring-ansible-cli.md](../Ansible/notes/2026-06-06-exploring-ansible-cli.md) — Walkthrough of basic Ansible CLI commands and ad-hoc usage.
- [note] [Ansible/notes/2026-06-11-ansible-getting-started.md](../Ansible/notes/2026-06-11-ansible-getting-started.md) — Notes for moving from first ad-hoc commands to a first playbook.
- [note] [Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md](../Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md) — SSH, pipx, and permission issues encountered.
- [note] [Ansible/notes/2026-06-19-primer-already-exists.md](../Ansible/notes/2026-06-19-primer-already-exists.md) — Confirmation that the Ansible primer already covered the required content.
- [script] [Ansible/scripts/install-and-first-adhoc.sh](../Ansible/scripts/install-and-first-adhoc.sh) — Script to install Ansible and run a first ad-hoc command.
- [script] [Ansible/scripts/run-first-playbook.sh](../Ansible/scripts/run-first-playbook.sh) — Script to run a first playbook against inventory.
- [snippet] [Ansible/snippets/nginx-playbook.yaml](../Ansible/snippets/nginx-playbook.yaml) — Minimal nginx deployment playbook snippet.
- [config] [Ansible/configs/docker-python-setup.yaml](../Ansible/configs/docker-python-setup.yaml) — Playbook to configure Docker and Python on multiple hosts.
- [config] [Ansible/configs/nginx-webserver.yaml](../Ansible/configs/nginx-webserver.yaml) — Playbook to provision nginx on web servers.
- [notebook] [Ansible/notebooks/ansible-variable-precedence.ipynb](../Ansible/notebooks/ansible-variable-precedence.ipynb) — Jupyter notebook comparing group_vars, host_vars, playbook vars, and roles.
- [doc] [Ansible/docs/2026-06-15-wiring-ansible-lint.md](../Ansible/docs/2026-06-15-wiring-ansible-lint.md) — Integrating ansible-lint into the playbook workflow.

## Docker

- [note] [Docker/notes/0000-primer-docker.md](../Docker/notes/0000-primer-docker.md) — Primer covering images, containers, Dockerfile, layers, volumes, and registries.
- [note] [Docker/notes/2026-06-05-explore-docker-cli.md](../Docker/notes/2026-06-05-explore-docker-cli.md) — Walkthrough of common Docker commands.
- [note] [Docker/notes/2026-06-06-exploring-docker-cli.md](../Docker/notes/2026-06-06-exploring-docker-cli.md) — Hands-on walkthrough of running containers.
- [note] [Docker/notes/2026-06-07-docker-compose-quickstart.md](../Docker/notes/2026-06-07-docker-compose-quickstart.md) — Notes on docker compose syntax and gotchas.
- [script] [Docker/scripts/2026-06-12-compose-multi-service.sh](../Docker/scripts/2026-06-12-compose-multi-service.sh) — Script for bringing up a multi-service compose stack.
- [script] [Docker/scripts/docker-health-check-and-cleanup.sh](../Docker/scripts/docker-health-check-and-cleanup.sh) — Container health check and dangling resource cleanup.
- [script] [Docker/scripts/install-and-run-container.sh](../Docker/scripts/install-and-run-container.sh) — Script to install Docker and run nginx.
- [script] [Docker/scripts/install-and-run-first-container.sh](../Docker/scripts/install-and-run-first-container.sh) — Script to install Docker and run first container.
- [dockerfile] [Docker/dockerfiles/build-and-run-first.Dockerfile](../Docker/dockerfiles/build-and-run-first.Dockerfile) — Minimal Dockerfile for building and running a first container.
- [dockerfile] [Docker/dockerfiles/first-docker-image.Dockerfile](../Docker/dockerfiles/first-docker-image.Dockerfile) — First Dockerfile for building a custom image.
- [dockerfile] [Docker/dockerfiles/tried-building-first-image.Dockerfile](../Docker/dockerfiles/tried-building-first-image.Dockerfile) — Attempted Dockerfile for building a custom image.
- [dockerfile] [Docker/dockerfiles/multi-stage-go-http-server.Dockerfile](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile) — Multi-stage build for a Go HTTP server.
- [doc] [Docker/docs/docker-run-vs-compose.md](../Docker/docs/docker-run-vs-compose.md) — Decision guide for when to use docker run vs compose.
- [manifest] [Docker/manifests/2026-06-13-web-db-compose.yaml](../Docker/manifests/2026-06-13-web-db-compose.yaml) — Compose manifest for nginx web service with PostgreSQL.
- [config] [Docker/configs/multi-service-app.yaml](../Docker/configs/multi-service-app.yaml) — Multi-service application configuration.
- [notebook] [Docker/notebooks/comparing-docker-networking-drivers.ipynb](../Docker/notebooks/comparing-docker-networking-drivers.ipynb) — Jupyter notebook comparing bridge, host, overlay, and macvlan drivers.

## Git

- [note] [Git/notes/0000-primer-git.md](../Git/notes/0000-primer-git.md) — Primer covering repos, commits, staging, branches, remotes, and merging.
- [note] [Git/notes/2026-06-04-install-git.md](../Git/notes/2026-06-04-install-git.md) — Installation instructions for Git on Windows, macOS, and Linux.
- [note] [Git/notes/2026-06-04-explore-git-cli.md](../Git/notes/2026-06-04-explore-git-cli.md) — Walkthrough of common Git commands from init through log.
- [note] [Git/notes/2026-06-07-git-branching-tutorial.md](../Git/notes/2026-06-07-git-branching-tutorial.md) — Following the official branching tutorial.
- [script] [Git/scripts/install-and-first-commit.sh](../Git/scripts/install-and-first-commit.sh) — Script to install Git and create a first commit.
- [script] [Git/scripts/minimal-branching-workflow.sh](../Git/scripts/minimal-branching-workflow.sh) — Standalone script demonstrating branch/create/merge/rebase.
- [script] [Git/scripts/2026-06-10-merge-conflict-practice.sh](../Git/scripts/2026-06-10-merge-conflict-practice.sh) — Script for practicing merge conflicts.
- [script] [Git/scripts/squash-wip-commits.sh](../Git/scripts/squash-wip-commits.sh) — Automate interactive rebase to squash WIP commits before PR.
- [script] [Git/scripts/commit-msg-conventional-commit.sh](../Git/scripts/commit-msg-conventional-commit.sh) — Script to enforce conventional commit message format.
- [script] [Git/scripts/conventional-commits-hook.sh](../Git/scripts/conventional-commits-hook.sh) — Script to install a conventional commit hook into a repository.
- [script] [Git/scripts/batch-git-ops.sh](../Git/scripts/batch-git-ops.sh) — Run git commands across multiple repositories.
- [script] [Git/scripts/changelog-from-conventional-commits.py](../Git/scripts/changelog-from-conventional-commits.py) — Python script to generate changelog from conventional commits.
- [snippet] [Git/snippets/first-commit.sh](../Git/snippets/first-commit.sh) — Standalone shell snippet to init a repo and commit.
- [doc] [Git/docs/git-workflows-comparison.md](../Git/docs/git-workflows-comparison.md) — Comparison of feature branch, GitFlow, and trunk-based workflows.
- [doc] [Git/docs/git-worktrees-parallel-development.md](../Git/docs/git-worktrees-parallel-development.md) — Using git worktrees for parallel feature development.
- [doc] [Git/docs/git-worktrees-parallel-feature-development.md](../Git/docs/git-worktrees-parallel-feature-development.md) — Using git worktrees for parallel feature development (alternate notes).
- [template] [Git/templates/git-hooks/pre-commit](../Git/templates/git-hooks/pre-commit) — Pre-commit hook template.
- [template] [Git/templates/git-hooks/commit-msg](../Git/templates/git-hooks/commit-msg) — Commit message hook template.
- [template] [Git/templates/git-hooks/post-checkout](../Git/templates/git-hooks/post-checkout) — Post-checkout hook template.

## GitHub

- [note] [GitHub/notes/0000-primer-github.md](../GitHub/notes/0000-primer-github.md) — Primer covering repos, PRs, issues, forks.
- [note] [GitHub/notes/2026-06-07-explore-github-web-and-cli.md](../GitHub/notes/2026-06-07-explore-github-web-and-cli.md) — Walkthrough of gh CLI commands for repos, issues, PRs.
- [note] [GitHub/notes/2026-06-10-exploring-github-repos-issues-prs.md](../GitHub/notes/2026-06-10-exploring-github-repos-issues-prs.md) — Exploration of repos, issues, and PRs via GitHub API.
- [note] [GitHub/notes/2026-06-10-repos-issues-and-prs.md](../GitHub/notes/2026-06-10-repos-issues-and-prs.md) — Notes on managing repos, issues, and PRs via gh.
- [note] [GitHub/notes/2026-06-10-github-platform-features.md](../GitHub/notes/2026-06-10-github-platform-features.md) — GitHub platform features: wiki, projects, insights.
- [note] [GitHub/notes/2026-06-11-following-github-cli-quickstart.md](../GitHub/notes/2026-06-11-following-github-cli-quickstart.md) — Follow-up notes from the GitHub CLI quickstart.
- [note] [GitHub/notes/2026-06-13-github-quickstart-cli-and-web.md](../GitHub/notes/2026-06-13-github-quickstart-cli-and-web.md) — Notes from the official GitHub quickstart using both CLI and web UI.
- [note] [GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md) — Walkthrough of GitHub's Hello World guide and the GitHub flow.
- [note] [GitHub/notes/2026-06-15-explore-github-web-ui.md](../GitHub/notes/2026-06-15-explore-github-web-ui.md) — Web UI exploration covering profile, repos, issues.
- [note] [GitHub/notes/2026-06-19-primer-already-exists.md](../GitHub/notes/2026-06-19-primer-already-exists.md) — Confirmation that the GitHub primer already covered the required content.
- [script] [GitHub/scripts/2026-06-10-auth-and-explore-profile.sh](../GitHub/scripts/2026-06-10-auth-and-explore-profile.sh) — Script for GitHub authentication and profile exploration.
- [script] [GitHub/scripts/auth-and-profile.sh](../GitHub/scripts/auth-and-profile.sh) — Script to authenticate and view profile info.
- [script] [GitHub/scripts/tried-auth-and-profile.sh](../GitHub/scripts/tried-auth-and-profile.sh) — Script attempting GitHub authentication.
- [script] [GitHub/scripts/tried-commenting-on-first-issue.sh](../GitHub/scripts/tried-commenting-on-first-issue.sh) — Script to comment on issues.
- [script] [GitHub/scripts/2026-06-12-create-repo-and-pr.sh](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh) — Script to create a repository and open a pull request.
- [snippet] [GitHub/snippets/github-issues-api.py](../GitHub/snippets/github-issues-api.py) — Python snippet for working with GitHub issues via the API.
- [snippet] [GitHub/snippets/list-repos-with-python.py](../GitHub/snippets/list-repos-with-python.py) — Python snippet for listing repositories.
- [config] [GitHub/configs/issue-templates-and-labels.yaml](../GitHub/configs/issue-templates-and-labels.yaml) — Repository issue templates and labels configuration.

## GitHub Actions

- [note] [GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md](../GitHub%20Actions/notes/2026-06-23-following-github-actions-quickstart.md) — Notes on GitHub Actions workflow setup, triggers, and runner environment observations.
- [config] [GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml](../GitHub%20Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml) — CI workflow with environment variables and secrets for GitHub Actions.

## GitLab CI

- [note] [GitLab CI/notes/0000-primer-gitlab-ci-cd.md](../GitLab%20CI/notes/0000-primer-gitlab-ci-cd.md) — Primer covering pipelines, runners, stages, jobs, and the `.gitlab-ci.yml` format.
- [script] [GitLab CI/scripts/2026-06-22-install-runner-and-register.sh](../GitLab%20CI/scripts/2026-06-22-install-runner-and-register.sh) — Script to install, configure, and register a GitLab Runner.
- [config] [GitLab CI/configs/2026-06-22-first-pipeline.yaml](../GitLab%20CI/configs/2026-06-22-first-pipeline.yaml) — Minimal `.gitlab-ci.yml` with build and test stages.
- [script] [GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh](../GitLab%20CI/scripts/2026-06-24-run-first-local-pipeline.sh) — Script to run a GitLab pipeline locally using the CLI.
- [note] [GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md](../GitLab%20CI/notes/2026-06-24-following-gitlab-ci-quickstart.md) — Notes following the GitLab CI quickstart guide with pipeline stages.

## Kubernetes

- [note] [Kubernetes/notes/0000-primer-kubernetes.md](../Kubernetes/notes/0000-primer-kubernetes.md) — Primer covering pods, deployments, services.
- [note] [Kubernetes/notes/2026-06-06-exploring-kubectl.md](../Kubernetes/notes/2026-06-06-exploring-kubectl.md) — Walkthrough of kubectl commands.
- [note] [Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md) — Notes from the k8s.io interactive tutorial.
- [note] [Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md](../Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md) — Notes from the official Kubernetes Basics interactive tutorial.
- [script] [Kubernetes/scripts/install-kind-and-first-cluster.sh](../Kubernetes/scripts/install-kind-and-first-cluster.sh) — Script to install kind and create first cluster.
- [script] [Kubernetes/scripts/pod-lifecycle.sh](../Kubernetes/scripts/pod-lifecycle.sh) — Script managing pod lifecycle operations.
- [manifest] [Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml](../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml) — Pod manifest with ConfigMap and Secret volume mounts.
- [manifest] [Kubernetes/manifests/stateless-app.yaml](../Kubernetes/manifests/stateless-app.yaml) — Deployment and Service manifest for a stateless app.

## Terraform

- [note] [Terraform/notes/0000-primer-terraform.md](../Terraform/notes/0000-primer-terraform.md) — Primer covering providers, state, plan, apply.
- [note] [Terraform/notes/2026-06-06-exploring-terraform-cli.md](../Terraform/notes/2026-06-06-exploring-terraform-cli.md) — Walkthrough of init/plan/apply commands.
- [note] [Terraform/notes/2026-06-10-terraform-getting-started.md](../Terraform/notes/2026-06-10-terraform-getting-started.md) — Follow-up notes for the first Terraform workflow.
- [note] [Terraform/notes/2026-06-24-following-provider-tutorial.md](../Terraform/notes/2026-06-24-following-provider-tutorial.md) — Notes following the Terraform providers tutorial.
- [script] [Terraform/scripts/install-and-init.sh](../Terraform/scripts/install-and-init.sh) — Script to install Terraform and run init/plan.
- [script] [Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh) — Script to bootstrap a structured Terraform project.
- [config] [Terraform/configs/2026-06-12-tried-local-with-vars.tf](../Terraform/configs/2026-06-12-tried-local-with-vars.tf) — Local provider configuration with variables and outputs.
- [config] [Terraform/configs/local-file.tf](../Terraform/configs/local-file.tf) — Example Terraform configuration for local file resource.
- [module] [Terraform/configs/reusable-s3-module/README.md](../Terraform/configs/reusable-s3-module/README.md) — Documentation for the reusable S3 module.
- [module] [Terraform/configs/reusable-s3-module/main.tf](../Terraform/configs/reusable-s3-module/main.tf) — Reusable S3 module main configuration.
- [module] [Terraform/configs/reusable-s3-module/outputs.tf](../Terraform/configs/reusable-s3-module/outputs.tf) — Reusable S3 module outputs.
- [module] [Terraform/configs/reusable-s3-module/variables.tf](../Terraform/configs/reusable-s3-module/variables.tf) — Reusable S3 module variables.
- [example] [Terraform/configs/reusable-s3-module/examples/basic/main.tf](../Terraform/configs/reusable-s3-module/examples/basic/main.tf) — Basic usage example for the S3 module.
- [manifest] [Terraform/manifests/simple-ec2-app.tf](../Terraform/manifests/simple-ec2-app.tf) — EC2 instance with security group manifest for AWS.
