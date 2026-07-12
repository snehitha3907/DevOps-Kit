# Quick Links

## I need to...

### Set up and explore a tool
- [Ansible primer](../Ansible/notes/0000-primer-ansible.md)
- [Docker primer](../Docker/notes/0000-primer-docker.md)
- [Git primer](../Git/notes/0000-primer-git.md)
- [GitHub primer](../GitHub/notes/0000-primer-github.md)
- [GitHub Actions primer](../GitHub%20Actions/notes/0000-primer-github-actions.md)
- [Kubernetes primer](../Kubernetes/notes/0000-primer-kubernetes.md)
- [Terraform primer](../Terraform/notes/0000-primer-terraform.md)
- [GitLab CI/CD primer](../GitLab%20CI/notes/0000-primer-gitlab-ci-cd.md)
- [CI/CD Concepts primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)

### Install a tool
- [Install Ansible + run first ad-hoc command](../Ansible/scripts/install-and-first-adhoc.sh)
- [Install Docker + run first container](../Docker/scripts/install-and-run-first-container.sh)
- [Install Git + make first commit](../Git/scripts/install-and-first-commit.sh)
- [Install kind + create first K8s cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
- [Install Terraform + init/plan](../Terraform/scripts/install-and-init.sh)
- [Install GitLab Runner + register](../GitLab%20CI/scripts/2026-06-22-install-runner-and-register.sh)
- [Install gh Actions extension + list runs](../GitHub%20Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh)

### Explore CLI
- [Ansible CLI walkthrough](../Ansible/notes/2026-06-06-exploring-ansible-cli.md)
- [Docker CLI walkthrough](../Docker/notes/2026-06-06-exploring-docker-cli.md)
- [Git CLI walkthrough](../Git/notes/2026-06-04-explore-git-cli.md)
- [Kubectl walkthrough](../Kubernetes/notes/2026-06-06-exploring-kubectl.md)
- [Terraform CLI walkthrough](../Terraform/notes/2026-06-06-exploring-terraform-cli.md)
- [Trivy CLI exploration](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)
- [GitHub CLI (gh) walkthrough](../GitHub/notes/2026-06-07-explore-github-web-and-cli.md)

### Write a playbook / pipeline / config
- [Ansible nginx playbook snippet](../Ansible/snippets/nginx-playbook.yaml)
- [Ansible Docker + Python setup playbook](../Ansible/configs/docker-python-setup.yaml)
- [GitHub Actions CI workflow with env/secrets](../GitHub%20Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml)
- [GitHub Actions hello workflow](../GitHub%20Actions/configs/2026-07-11-first-ci-workflow-hello.yaml)
- [GitLab CI first pipeline](../GitLab%20CI/configs/2026-06-22-first-pipeline.yaml)
- [Terraform local file config](../Terraform/configs/local-file.tf)
- [Terraform reusable S3 module](../Terraform/configs/reusable-s3-module/)
- [Docker Compose multi-service app](../Docker/configs/multi-service-app.yaml)
- [Docker Go + Redis with health checks](../Docker/manifests/2026-06-28-go-redis-compose-healthchecks.yaml)
- [Kubernetes stateless app manifest](../Kubernetes/manifests/stateless-app.yaml)

### Work with Git
- [Branching tutorial](../Git/notes/2026-06-07-git-branching-tutorial.md)
- [Minimal branching workflow script](../Git/scripts/minimal-branching-workflow.sh)
- [Merge conflict practice](../Git/scripts/2026-06-10-merge-conflict-practice.sh)
- [Conventional commit hook](../Git/scripts/commit-msg-conventional-commit.sh)
- [Squash WIP commits](../Git/scripts/squash-wip-commits.sh)
- [Git workflows comparison](../Git/docs/git-workflows-comparison.md)
- [Git worktrees for parallel development](../Git/docs/git-worktrees-parallel-feature-development.md)

### Work with Docker
- [Docker Compose quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
- [Multi-stage Go HTTP server Dockerfile](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
- [Build mount vs COPY caching comparison](../Docker/docs/docker-build-mount-vs-copy-caching.md)
- [docker run vs compose decision guide](../Docker/docs/docker-run-vs-compose.md)
- [Docker networking drivers notebook](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
- [Container health check + cleanup script](../Docker/scripts/docker-health-check-and-cleanup.sh)
- [Compose multi-service stack script](../Docker/scripts/2026-06-12-compose-multi-service.sh)

### Work with GitHub
- [GitHub flow + Hello World guide](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md)
- [GitHub platform features (wiki, projects, insights)](../GitHub/notes/2026-06-10-github-platform-features.md)
- [Provision repo with GitHub API](../GitHub/scripts/provision-repo-with-api.py)
- [GitHub issues API snippet](../GitHub/snippets/github-issues-api.py)
- [Issue templates and labels config](../GitHub/configs/issue-templates-and-labels.yaml)
- [Issue forms and labels (.github repo)](../GitHub/configs/dot-github-repository/)
- [Stale issue/PR automation (.github repo)](../GitHub/configs/dot-github-repository/stale.yml)
- [Deploy keys vs PATs for CI/CD](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)

### Work with Kubernetes
- [K8s interactive tutorial walkthrough](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)
- [Pod lifecycle management script](../Kubernetes/scripts/pod-lifecycle.sh)
- [ConfigMap + Secret mounted pod manifest](../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml)
- [K8s Basics tutorial notes](../Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md)

### Work with Terraform
- [Bootstrap a structured Terraform project](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh)
- [Workspaces + remote state locking guide](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md)
- [for_each vs count notebook](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- [Simple EC2 app manifest](../Terraform/manifests/simple-ec2-app.tf)

### Scan for vulnerabilities
- [Trivy CLI exploration](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)
- [Scan container image with Trivy](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh)
