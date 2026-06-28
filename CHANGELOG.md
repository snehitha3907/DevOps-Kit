# Changelog

## 2026-06-28

- Added lifecycle rules to reusable S3 module (tf-012) — expiration, transition, noncurrent version handling, multipart upload cleanup (`Terraform/configs/reusable-s3-module/`)

## 2026-06-27

- Reworked Docker build --mount vs COPY docs with L3 transitional voice (doc-011 rework) (`Docker/docs/docker-build-mount-vs-copy-caching.md`)

## 2026-06-26

- Added Trivy container image scan with JSON parsing script (trv-005) (`Trivy/scripts/2026-06-26-scanned-first-container-image.sh`)
- Added Docker build --mount vs COPY for dependency caching docs (doc-011) (`Docker/docs/docker-build-mount-vs-copy-caching.md`)

## 2026-06-25

- Added Trivy CLI exploration notes (trv-004) (`Trivy/notes/2026-06-25-exploring-trivy-cli.md`)

## 2026-06-24

- Added multi-stage Go HTTP server Dockerfile (doc-010) (`Docker/dockerfiles/multi-stage-go-http-server.Dockerfile`)
- Added run-first-local-pipeline script (gl-005) (`GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh`)
- Added following the providers tutorial notes (tf-010) (`Terraform/notes/2026-06-24-following-provider-tutorial.md`)
- Added following the GitLab CI/CD quickstart notes (gl-004) (`GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md`)

## 2026-06-23

- Added following GitHub Actions quickstart notes (ga-004) (`GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md`)
- Added CI/CD Concepts primer (con-005) (`docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md`)
- Added first CI workflow with env vars and secrets (ga-005) (`GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml`)

## 2026-06-22

- Added GitLab CI/CD primer (gl-001) (`GitLab CI/notes/0000-primer-gitlab-ci-cd.md`)
- Added GitLab Runner install and register script (gl-002) (`GitLab CI/scripts/2026-06-22-install-runner-and-register.sh`)
- Added first .gitlab-ci.yml pipeline config (gl-003) (`GitLab CI/configs/2026-06-22-first-pipeline.yaml`)

## 2026-06-19

- Flagged GitHub primer already exists (gh-001) (`GitHub/notes/2026-06-19-primer-already-exists.md`)
- Flagged Ansible primer already exists (ans-001) (`Ansible/notes/2026-06-19-primer-already-exists.md`)
- Updated README Layout and Coverage table to document Ansible/docs/, Docker/docs/, Docker/notebooks/ (gen-007) (`General/docs/2026-06-19-update-readme-layout-ansible-docker.md`)

## 2026-06-18

- Added changelog generator from conventional commits script (git-004) (`Git/scripts/changelog-from-conventional-commits.py`)

## 2026-06-17

- Added Git hooks project scaffold template (git-003) (`Git/templates/git-hooks/`)
- Added Git workflows comparison doc (git-001) (`Git/docs/git-workflows-comparison.md`)
- Added batch git operations across multiple repos script (git-002) (`Git/scripts/batch-git-ops.sh`)

## 2026-06-16

- Added Docker container health-check and dangling resource cleanup script (doc-013) (`Docker/scripts/docker-health-check-and-cleanup.sh`)
- Reworked GitHub web UI exploration notes with L1 scratchy voice (gh-013) (`GitHub/notes/2026-06-15-explore-github-web-ui.md`)
- Updated README tree and Coverage table with 10 previously undocumented files (audit-007) (`General/docs/2026-06-16-audit-007-undocumented-files.md`)
- Added interactive rebase automation script for squashing WIP commits before PR (git-003) (`Git/scripts/squash-wip-commits.sh`)
- Added git worktrees docs for parallel feature development (git-002) (`Git/docs/git-worktrees-parallel-feature-development.md`)
- Added conventional commit message hook script (git-001) (`Git/scripts/commit-msg-conventional-commit.sh`)

## 2026-06-15

- Added Ansible variable precedence comparison notebook (`Ansible/notebooks/ansible-variable-precedence.ipynb`)
- Added Ansible-lint workflow docs (`Ansible/docs/2026-06-15-wiring-ansible-lint.md`)
- Added General rework note for gen-003 already-documented files (`General/docs/2026-06-15-rework-gen003-already-documented.md`)
- Added Hello World guide and GitHub flow notes (gh-014 rework) (`GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md`)
- Added following Kubernetes Basics tutorial notes (`Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md`)
- Added ConfigMap and Secret mounted Pod manifest (`Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml`)

## 2026-06-14

- Added Nginx web server Ansible config with idempotency checks (`Ansible/configs/nginx-webserver.yaml`)
- Added General rework note for gen-002 already-documented files (`General/docs/2026-06-14-rework-gen002-already-documented.md`)
- Added following the official GitHub quickstart (CLI + web UI) notes (`GitHub/notes/2026-06-13-github-quickstart-cli-and-web.md`)

## 2026-06-13

- Added Docker web app and database compose manifest (`Docker/manifests/2026-06-13-web-db-compose.yaml`)
- Added Ansible playbook troubleshooting notes (`Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md`)
- Added Docker and Python setup Ansible config (`Ansible/configs/docker-python-setup.yaml`)
- Added General rework note for already-documented files (`General/docs/2026-06-13-rework-undocumented-files.md`)

## 2026-06-12

- Added Terraform bootstrap project script with variables and outputs (`Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh`)
- Added Terraform local provider config with variables and outputs (`Terraform/configs/2026-06-12-tried-local-with-vars.tf`)
- Added following GitHub CLI quickstart notes (`GitHub/notes/2026-06-11-following-github-cli-quickstart.md`)
- Added Docker compose multi-service stack script (`Docker/scripts/2026-06-12-compose-multi-service.sh`)
- Added GitHub create repo and open PR script (`GitHub/scripts/2026-06-12-create-repo-and-pr.sh`)
- Added GitHub issues API snippet (`GitHub/snippets/github-issues-api.py`)
- Added Ansible nginx playbook snippet (`Ansible/snippets/nginx-playbook.yaml`)

## 2026-06-11

- Added following GitHub CLI quickstart notes (`GitHub/notes/2026-06-11-following-github-cli-quickstart.md`)
- Added reusable S3 Terraform module with variables and outputs (`Terraform/configs/reusable-s3-module/`)
- Added GitHub list-repos REST API snippet (`GitHub/snippets/list-repos-with-python.py`)
- Added Ansible first playbook script (`Ansible/scripts/run-first-playbook.sh`)
- Added Ansible getting started notes (`Ansible/notes/2026-06-11-ansible-getting-started.md`)
- Added Terraform EC2 + security group manifest (`Terraform/manifests/simple-ec2-app.tf`)

## 2026-06-10

- Added Git merge conflict practice script (`Git/scripts/2026-06-10-merge-conflict-practice.sh`)
- Added GitHub platform features notes — wiki, projects, insights (`GitHub/notes/2026-06-10-github-platform-features.md`)
- Added first Docker image build Dockerfile (`Docker/dockerfiles/tried-building-first-image.Dockerfile`)
- Added GitHub auth + profile exploration script (`GitHub/scripts/tried-auth-and-profile.sh`)
- Added GitHub repos, issues, and PRs exploration notes (`GitHub/notes/2026-06-10-exploring-github-repos-issues-prs.md`)
- Added Terraform getting-started tutorial notes — Docker provider walkthrough (`Terraform/notes/2026-06-10-terraform-getting-started.md`)
- Added GitHub issue templates and labels config (`GitHub/configs/issue-templates-and-labels.yaml`)

## 2026-06-09

- Added Kubernetes stateless app manifest (`Kubernetes/manifests/stateless-app.yaml`)
- Added Kubernetes pod lifecycle script (`Kubernetes/scripts/pod-lifecycle.sh`)
- Added Terraform local file config (`Terraform/configs/local-file.tf`)

## 2026-06-08

- Added Kubernetes interactive tutorial walkthrough notes (`Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md`)
- Added GitHub CLI first issue comment script (`GitHub/scripts/tried-commenting-on-first-issue.sh`)
- Added docker run vs compose docs (`Docker/docs/docker-run-vs-compose.md`)

## 2026-06-07

- Added Docker Compose quickstart notes (`Docker/notes/2026-06-07-docker-compose-quickstart.md`)
- Added multi-service app Docker Compose config (`Docker/configs/multi-service-app.yaml`)
- Added Git branching tutorial notes (`Git/notes/2026-06-07-git-branching-tutorial.md`)
- Added minimal branching workflow script (`Git/scripts/minimal-branching-workflow.sh`)
- Added first Dockerfile (`Docker/dockerfiles/first-docker-image.Dockerfile`)
- Added GitHub auth + profile script (`GitHub/scripts/auth-and-profile.sh`)
- Added GitHub web UI + CLI exploration notes (`GitHub/notes/2026-06-07-explore-github-web-and-cli.md`)

## 2026-06-06

- Added Terraform CLI exploration notes (`Terraform/notes/2026-06-06-exploring-terraform-cli.md`)
- Added Ansible install + first ad-hoc script (`Ansible/scripts/install-and-first-adhoc.sh`)
- Added Ansible CLI exploration notes (`Ansible/notes/2026-06-06-exploring-ansible-cli.md`)
- Added Ansible primer (`Ansible/notes/0000-primer-ansible.md`)
- Added GitHub primer (`GitHub/notes/0000-primer-github.md`)
- Added Terraform install + init script (`Terraform/scripts/install-and-init.sh`)
- Added Docker install + first container script (`Docker/scripts/install-and-run-first-container.sh`)
- Added Docker CLI exploration notes (`Docker/notes/2026-06-06-exploring-docker-cli.md`)
- Added Kubernetes primer (`Kubernetes/notes/0000-primer-kubernetes.md`)
- Added kind install + first cluster script (`Kubernetes/scripts/install-kind-and-first-cluster.sh`)
- Added kubectl exploration notes (`Kubernetes/notes/2026-06-06-exploring-kubectl.md`)
- Added Terraform primer (`Terraform/notes/0000-primer-terraform.md`)

## 2026-06-05

- Added Docker install + run container script (`Docker/scripts/install-and-run-container.sh`)
- Added Docker CLI exploration notes (`Docker/notes/2026-06-05-explore-docker-cli.md`)
- Added Docker primer (`Docker/notes/0000-primer-docker.md`)

## 2026-06-04

- Added Git primer (`Git/notes/0000-primer-git.md`)
- Added Git install notes (`Git/notes/2026-06-04-install-git.md`)
- Added Git first-commit snippet (`Git/snippets/first-commit.sh`)
- Added Git install + first-commit script (`Git/scripts/install-and-first-commit.sh`)
- Added Git CLI exploration notes (`Git/notes/2026-06-04-explore-git-cli.md`)
