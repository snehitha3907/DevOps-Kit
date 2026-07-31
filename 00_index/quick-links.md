# Quick Links

## I need to...

### Set up Linux and networking fundamentals
- [Process and permission patterns in devops](../docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md)
- [Filesystem permissions and process management script](../docs/concepts/linux-system-administration/2026-07-18-filesystem-permissions-and-process-management.sh)
- [Netcat and curl connectivity script](../docs/concepts/networking-fundamentals/2026-07-18-netcat-and-curl-connectivity.sh)

### Install a tool
- [Install Ansible + run first ad-hoc command](../Ansible/scripts/install-and-first-adhoc.sh)
- [Install Ansible + explore modules](../Ansible/scripts/2026-07-19-install-ansible-and-explore-modules.sh)
- [Install AWS CLI v2 and configure profiles](../AWS/scripts/2026-07-13-install-aws-cli-v2-and-configure.sh)
- [Install Azure CLI and login](../Azure/scripts/2026-07-13-install-azure-cli-and-login.sh)
- [Install Docker + run first container](../Docker/scripts/install-and-run-first-container.sh)
- [Install gcloud CLI + configure credentials](../GCP/scripts/2026-07-16-install-gcloud-cli-and-configure-creds.sh)
- [Install Git + make first commit](../Git/scripts/install-and-first-commit.sh)
- [Install Helm + explore CLI](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh)
- [Install kind + create first K8s cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
- [Install OpenTofu + verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- [Install Prometheus + verify metrics](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh)
- [Install Terraform + init/plan](../Terraform/scripts/install-and-init.sh)
- [Install GitLab Runner + register](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh)
- [Install gh Actions extension + list runs](../GitHub Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh)
- [Install Trivy + scan filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh)

### Explore CLI and primer concepts
- [Ansible primer](../Ansible/notes/0000-primer-ansible.md)
- [ArgoCD primer](../ArgoCD/notes/0000-primer-argocd.md)
- [AWS primer](../AWS/notes/0000-primer-aws.md)
- [Azure primer](../Azure/notes/0000-primer-azure.md)
- [Docker primer](../Docker/notes/0000-primer-docker.md)
- [GCP primer](../GCP/notes/0000-primer-gcp.md)
- [Git primer](../Git/notes/0000-primer-git.md)
- [GitHub primer](../GitHub/notes/0000-primer-github.md)
- [GitHub Actions primer](../GitHub Actions/notes/0000-primer-github-actions.md)
- [GitLab CI/CD primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- [Helm primer](../Helm/notes/0000-primer-helm.md)
- [Kubernetes primer](../Kubernetes/notes/0000-primer-kubernetes.md)
- [OpenTofu primer](../OpenTofu/notes/0000-primer-opentofu.md)
- [Prometheus primer](../Prometheus/notes/0000-primer-prometheus.md)
- [Terraform primer](../Terraform/notes/0000-primer-terraform.md)
- [Trivy primer](../Trivy/notes/0000-primer-trivy.md)
- [CI/CD Concepts primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
- [Containerization Concepts primer](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
- [Infrastructure as Code Concepts primer](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
- [Linux & System Administration primer](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
- [Monitoring & Observability Concepts primer](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
- [Networking Fundamentals primer](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
- [Scripting & Automation (Bash/Python) primer](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
- [Version Control Concepts primer](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)

### Write a playbook / pipeline / config
- [Ansible collection requirements and Docker lifecycle playbook](../Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml)
- [Ansible nginx playbook snippet](../Ansible/snippets/nginx-playbook.yaml)
- [Ansible Docker + Python setup playbook](../Ansible/configs/docker-python-setup.yaml)
- [Ansible nginx/PHP-FPM/UFW playbook](../Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml)
- [Ansible inventory and ping playbook](../Ansible/configs/2026-07-19-first-inventory-and-ping-playbook.yaml)
- [Scan Ansible for antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py)
- [GitHub Actions CI workflow with env/secrets](../GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml)
- [GitHub Actions hello workflow](../GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml)
- [GitLab CI first pipeline](../GitLab CI/configs/2026-06-22-first-pipeline.yaml)
- [Helm chart inspection config](../Helm/configs/2026-07-23-first-helm-chart-inspection.yaml)
- [OpenTofu minimal local config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)
- [Prometheus minimal scrape config](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml)
- [Terraform local file config](../Terraform/configs/local-file.tf)
- [Terraform reusable S3 module](../Terraform/configs/reusable-s3-module/README.md)
- [Docker Compose multi-service app](../Docker/configs/multi-service-app.yaml)
- [Docker Go + Redis with health checks](../Docker/manifests/2026-06-28-go-redis-compose-healthchecks.yaml)
- [Kubernetes stateless app manifest](../Kubernetes/manifests/stateless-app.yaml)
- [ArgoCD first application manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- [AWS minimal config with named profiles](../AWS/configs/2026-07-13-minimal-aws-config.ini)

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
- [Deployment and Service with probes and limits](../Kubernetes/manifests/deployment-service-with-probes-limits.yaml)
- [K8s Basics tutorial notes](../Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md)
- [First kubectl version check and pod from manifest](../Kubernetes/notes/2026-07-19-first-kubectl-version-and-pod-from-manifest.md)
- [Ingress path-based routing](../Kubernetes/docs/ingress-path-based-routing.md)
- [Pod troubleshooting shell snippet](../Kubernetes/snippets/pod-troubleshoot-shell.sh)

### Work with Terraform
- [Bootstrap a structured Terraform project](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh)
- [Workspaces + remote state locking guide](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md)
- [for_each vs count notebook](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- [Simple EC2 app manifest](../Terraform/manifests/simple-ec2-app.tf)

### Work with GCP
- [GCP primer](../GCP/notes/0000-primer-gcp.md)
- [Install gcloud CLI + configure credentials](../GCP/scripts/2026-07-16-install-gcloud-cli-and-configure-creds.sh)
- [List Compute instances and GCS buckets](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)

### Scan for vulnerabilities
- [Trivy CLI exploration](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)
- [Scan container image with Trivy](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh)
- [Trivy Python wrapper snippet](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)
