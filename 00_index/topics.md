# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible  ·  12 files
- **primer:** [0000-primer-ansible.md](../Ansible/notes/0000-primer-ansible.md) — Primer covering control node, inventory, playbooks, and modules.
- **notes** (5): newest → [2026-06-19-primer-already-exists.md](../Ansible/notes/2026-06-19-primer-already-exists.md), [2026-06-13-ansible-playbook-troubleshooting.md](../Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md), [2026-06-11-ansible-getting-started.md](../Ansible/notes/2026-06-11-ansible-getting-started.md)
- **scripts** (2): [install-and-first-adhoc.sh](../Ansible/scripts/install-and-first-adhoc.sh), [run-first-playbook.sh](../Ansible/scripts/run-first-playbook.sh)
- **configs** (2): [docker-python-setup.yaml](../Ansible/configs/docker-python-setup.yaml), [nginx-webserver.yaml](../Ansible/configs/nginx-webserver.yaml)
- **docs** (1): [2026-06-15-wiring-ansible-lint.md](../Ansible/docs/2026-06-15-wiring-ansible-lint.md)
- _…and 2 more under `Ansible/` — browse the folder._

## Docker  ·  20 files
- **primer:** [0000-primer-docker.md](../Docker/notes/0000-primer-docker.md) — Primer covering images, containers, Dockerfile, layers, volumes, and registries.
- **notes** (4): newest → [2026-06-07-docker-compose-quickstart.md](../Docker/notes/2026-06-07-docker-compose-quickstart.md), [2026-06-06-exploring-docker-cli.md](../Docker/notes/2026-06-06-exploring-docker-cli.md), [2026-06-05-explore-docker-cli.md](../Docker/notes/2026-06-05-explore-docker-cli.md)
- **scripts** (4): [install-and-run-first-container.sh](../Docker/scripts/install-and-run-first-container.sh), [2026-06-12-compose-multi-service.sh](../Docker/scripts/2026-06-12-compose-multi-service.sh), [docker-health-check-and-cleanup.sh](../Docker/scripts/docker-health-check-and-cleanup.sh)
- **dockerfiles** (4): [multi-stage-go-http-server.Dockerfile](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile), [first-docker-image.Dockerfile](../Docker/dockerfiles/first-docker-image.Dockerfile), [build-and-run-first.Dockerfile](../Docker/dockerfiles/build-and-run-first.Dockerfile)
- **docs** (2): [docker-run-vs-compose.md](../Docker/docs/docker-run-vs-compose.md), [docker-build-mount-vs-copy-caching.md](../Docker/docs/docker-build-mount-vs-copy-caching.md)
- **manifests** (2): [2026-06-13-web-db-compose.yaml](../Docker/manifests/2026-06-13-web-db-compose.yaml), [2026-06-28-go-redis-compose-healthchecks.yaml](../Docker/manifests/2026-06-28-go-redis-compose-healthchecks.yaml)
- **configs** (1): [multi-service-app.yaml](../Docker/configs/multi-service-app.yaml)
- **notebooks** (1): [comparing-docker-networking-drivers.ipynb](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
- _…and 2 more under `Docker/dockerfiles/` — browse the folder._

## Git  ·  19 files
- **primer:** [0000-primer-git.md](../Git/notes/0000-primer-git.md) — Primer covering repos, commits, staging, branches, remotes, and merging.
- **notes** (4): newest → [2026-06-07-git-branching-tutorial.md](../Git/notes/2026-06-07-git-branching-tutorial.md), [2026-06-04-explore-git-cli.md](../Git/notes/2026-06-04-explore-git-cli.md), [2026-06-04-install-git.md](../Git/notes/2026-06-04-install-git.md)
- **scripts** (8): [install-and-first-commit.sh](../Git/scripts/install-and-first-commit.sh), [minimal-branching-workflow.sh](../Git/scripts/minimal-branching-workflow.sh), [squash-wip-commits.sh](../Git/scripts/squash-wip-commits.sh)
- **docs** (3): [git-workflows-comparison.md](../Git/docs/git-workflows-comparison.md), [git-worktrees-parallel-feature-development.md](../Git/docs/git-worktrees-parallel-feature-development.md), [git-worktrees-parallel-development.md](../Git/docs/git-worktrees-parallel-development.md)
- **templates** (3): [pre-commit](../Git/templates/git-hooks/pre-commit), [commit-msg](../Git/templates/git-hooks/commit-msg), [post-checkout](../Git/templates/git-hooks/post-checkout)
- **snippets** (1): [first-commit.sh](../Git/snippets/first-commit.sh)
- _…and 5 more under `Git/` — browse the folder._

## GitHub  ·  20 files
- **primer:** [0000-primer-github.md](../GitHub/notes/0000-primer-github.md) — Primer covering repos, PRs, issues, forks.
- **notes** (10): newest → [2026-06-19-primer-already-exists.md](../GitHub/notes/2026-06-19-primer-already-exists.md), [2026-06-15-hello-world-guide-and-github-flow.md](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md), [2026-06-15-explore-github-web-ui.md](../GitHub/notes/2026-06-15-explore-github-web-ui.md)
- **scripts** (6): [auth-and-profile.sh](../GitHub/scripts/auth-and-profile.sh), [2026-06-12-create-repo-and-pr.sh](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh), [provision-repo-with-api.py](../GitHub/scripts/provision-repo-with-api.py)
- **snippets** (2): [github-issues-api.py](../GitHub/snippets/github-issues-api.py), [list-repos-with-python.py](../GitHub/snippets/list-repos-with-python.py)
- **docs** (1): [how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)
- **configs** (1): [issue-templates-and-labels.yaml](../GitHub/configs/issue-templates-and-labels.yaml)
- _…and 11 more under `GitHub/` — browse the folder._

## GitHub Actions  ·  2 files
- **notes** (1): [2026-06-23-following-github-actions-quickstart.md](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md) — Notes on workflow setup, triggers, and runner environment observations.
- **configs** (1): [2026-06-23-first-ci-workflow-with-env-and-secrets.yaml](../GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml) — CI workflow with environment variables and secrets.

## GitLab CI  ·  5 files
- **primer:** [0000-primer-gitlab-ci-cd.md](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md) — Primer covering pipelines, runners, stages, jobs, and the `.gitlab-ci.yml` format.
- **notes** (2): newest → [2026-06-24-following-gitlab-ci-quickstart.md](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md), [0000-primer-gitlab-ci-cd.md](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **scripts** (2): [2026-06-22-install-runner-and-register.sh](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh), [2026-06-24-run-first-local-pipeline.sh](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh)
- **configs** (1): [2026-06-22-first-pipeline.yaml](../GitLab CI/configs/2026-06-22-first-pipeline.yaml)

## Kubernetes  ·  8 files
- **primer:** [0000-primer-kubernetes.md](../Kubernetes/notes/0000-primer-kubernetes.md) — Primer covering pods, deployments, services.
- **notes** (4): newest → [2026-06-15-following-kubernetes-basics-tutorial.md](../Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md), [2026-06-08-kubernetes-interactive-tutorial.md](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md), [2026-06-06-exploring-kubectl.md](../Kubernetes/notes/2026-06-06-exploring-kubectl.md)
- **scripts** (2): [install-kind-and-first-cluster.sh](../Kubernetes/scripts/install-kind-and-first-cluster.sh), [pod-lifecycle.sh](../Kubernetes/scripts/pod-lifecycle.sh)
- **manifests** (2): [stateless-app.yaml](../Kubernetes/manifests/stateless-app.yaml), [2026-06-15-configmap-secret-mounted-pod.yaml](../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml)

## Terraform  ·  17 files
- **primer:** [0000-primer-terraform.md](../Terraform/notes/0000-primer-terraform.md) — Primer covering providers, state, plan, apply.
- **notes** (4): newest → [2026-06-24-following-provider-tutorial.md](../Terraform/notes/2026-06-24-following-provider-tutorial.md), [2026-06-10-terraform-getting-started.md](../Terraform/notes/2026-06-10-terraform-getting-started.md), [2026-06-06-exploring-terraform-cli.md](../Terraform/notes/2026-06-06-exploring-terraform-cli.md)
- **docs** (2): [2026-06-29-terraform-workspaces-and-remote-state-locking.md](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md), [how-i-wired-terraform-workspaces-and-remote-state-locking.md](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md)
- **scripts** (2): [install-and-init.sh](../Terraform/scripts/install-and-init.sh), [2026-06-12-bootstrap-terraform-project.sh](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh)
- **notebooks** (1): [2026-07-02-comparing-for-each-vs-count.ipynb](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **configs** (2): [local-file.tf](../Terraform/configs/local-file.tf), [reusable-s3-module/](../Terraform/configs/reusable-s3-module/)
- **manifests** (1): [simple-ec2-app.tf](../Terraform/manifests/simple-ec2-app.tf)
- _…and 4 more under `Terraform/configs/reusable-s3-module/` — browse the folder._

## Trivy  ·  2 files
- **notes** (1): [2026-06-25-exploring-trivy-cli.md](../Trivy/notes/2026-06-25-exploring-trivy-cli.md) — CLI exploration covering scan targets, output formats, and filtering.
- **scripts** (1): [2026-06-26-scanned-first-container-image.sh](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh) — Script to scan a container image with Trivy and parse JSON output.

## Concepts  ·  1 file
- **docs** (1): [0000-primer-ci-cd-concepts.md](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md) — Primer covering CI/CD terminology, pipeline stages, and a concrete GitHub Actions example.
