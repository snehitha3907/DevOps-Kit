# Quick Links

## I need to...

### Get started with a tool

- [Ansible primer](../Ansible/notes/0000-primer-ansible.md)
- [Docker primer](../Docker/notes/0000-primer-docker.md)
- [Git primer](../Git/notes/0000-primer-git.md)
- [GitHub primer](../GitHub/notes/0000-primer-github.md)
- [Kubernetes primer](../Kubernetes/notes/0000-primer-kubernetes.md)
- [Terraform primer](../Terraform/notes/0000-primer-terraform.md)
- [GitLab CI primer](../GitLab%20CI/notes/0000-primer-gitlab-ci-cd.md)
- [CI/CD concepts primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)

### Install and run a first command

- [Install Ansible and run ad-hoc commands](../Ansible/scripts/install-and-first-adhoc.sh)
- [Install Docker and run first container](../Docker/scripts/install-and-run-first-container.sh)
- [Install Git and make a first commit](../Git/scripts/install-and-first-commit.sh)
- [Install kind and create a first Kubernetes cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
- [Install Terraform and run init/plan](../Terraform/scripts/install-and-init.sh)
- [Install GitLab Runner and register for a project](../GitLab%20CI/scripts/2026-06-22-install-runner-and-register.sh)

### Explore a tool's CLI

- [Ansible CLI walkthrough](../Ansible/notes/2026-06-06-exploring-ansible-cli.md)
- [Docker CLI walkthrough](../Docker/notes/2026-06-06-exploring-docker-cli.md)
- [Git CLI walkthrough](../Git/notes/2026-06-04-explore-git-cli.md)
- [GitHub CLI walkthrough](../GitHub/notes/2026-06-07-explore-github-web-and-cli.md)
- [kubectl walkthrough](../Kubernetes/notes/2026-06-06-exploring-kubectl.md)
- [Terraform CLI walkthrough](../Terraform/notes/2026-06-06-exploring-terraform-cli.md)
- [Trivy CLI exploration](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)

### Write an Ansible playbook

- [Run a first playbook](../Ansible/scripts/run-first-playbook.sh)
- [Getting started with playbooks](../Ansible/notes/2026-06-11-ansible-getting-started.md)
- [Nginx deployment snippet](../Ansible/snippets/nginx-playbook.yaml)
- [Docker and Python setup playbook](../Ansible/configs/docker-python-setup.yaml)
- [Nginx web server playbook](../Ansible/configs/nginx-webserver.yaml)
- [Playbook troubleshooting](../Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md)
- [Ansible-lint integration](../Ansible/docs/2026-06-15-wiring-ansible-lint.md)
- [Variable precedence notebook](../Ansible/notebooks/ansible-variable-precedence.ipynb)

### Build and run containers

- [First Dockerfile](../Docker/dockerfiles/first-docker-image.Dockerfile)
- [Multi-stage Go HTTP server](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
- [Docker Compose quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
- [Multi-service compose stack](../Docker/scripts/2026-06-12-compose-multi-service.sh)
- [Web app + database compose manifest](../Docker/manifests/2026-06-13-web-db-compose.yaml)
- [docker run vs compose](../Docker/docs/docker-run-vs-compose.md)
- [Networking drivers notebook](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)

### Use Git effectively

- [Branching tutorial](../Git/notes/2026-06-07-git-branching-tutorial.md)
- [Branching workflow script](../Git/scripts/minimal-branching-workflow.sh)
- [Merge conflict practice](../Git/scripts/2026-06-10-merge-conflict-practice.sh)
- [Squash WIP commits](../Git/scripts/squash-wip-commits.sh)
- [Workflows comparison doc](../Git/docs/git-workflows-comparison.md)
- [Git worktrees for parallel development](../Git/docs/git-worktrees-parallel-feature-development.md)
- [Conventional commit hook](../Git/scripts/commit-msg-conventional-commit.sh)
- [Changelog from conventional commits](../Git/scripts/changelog-from-conventional-commits.py)
- [Batch git operations](../Git/scripts/batch-git-ops.sh)

### Work with GitHub

- [GitHub flow notes](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md)
- [Create a repo and open a PR](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh)
- [Platform features overview](../GitHub/notes/2026-06-10-github-platform-features.md)
- [Web UI exploration](../GitHub/notes/2026-06-15-explore-github-web-ui.md)
- [Issue templates and labels config](../GitHub/configs/issue-templates-and-labels.yaml)
- [GitHub issues API snippet](../GitHub/snippets/github-issues-api.py)
- [List repos with Python](../GitHub/snippets/list-repos-with-python.py)

### Set up CI/CD pipelines

- [GitHub Actions quickstart notes](../GitHub%20Actions/notes/2026-06-23-following-github-actions-quickstart.md)
- [GitHub Actions CI workflow config](../GitHub%20Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml)
- [GitLab CI quickstart notes](../GitLab%20CI/notes/2026-06-24-following-gitlab-ci-quickstart.md)
- [GitLab CI pipeline config](../GitLab%20CI/configs/2026-06-22-first-pipeline.yaml)
- [Run GitLab pipeline locally](../GitLab%20CI/scripts/2026-06-24-run-first-local-pipeline.sh)

### Manage Kubernetes workloads

- [Kubernetes Basics tutorial](../Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md)
- [Interactive tutorial walkthrough](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)
- [Stateless app manifest](../Kubernetes/manifests/stateless-app.yaml)
- [ConfigMap + Secret pod manifest](../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml)
- [Pod lifecycle script](../Kubernetes/scripts/pod-lifecycle.sh)

### Provision infrastructure with Terraform

- [Getting started notes](../Terraform/notes/2026-06-10-terraform-getting-started.md)
- [Bootstrap a structured project](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh)
- [Local file example](../Terraform/configs/local-file.tf)
- [Local provider with variables](../Terraform/configs/2026-06-12-tried-local-with-vars.tf)
- [Reusable S3 module](../Terraform/configs/reusable-s3-module/main.tf)
- [EC2 instance manifest](../Terraform/manifests/simple-ec2-app.tf)

### Scan for vulnerabilities

- [Trivy CLI exploration](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)

### Navigate the kit

- [Topics index](topics.md)
- [Glossary](glossary.md)
- [Learning path](learning-path.md)
