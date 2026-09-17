# Quick Links

## I need to...

### Set up a cloud provider

- [Install Azure CLI and login](../Azure/scripts/2026-07-13-install-azure-cli-and-login.sh)
- [Provision resource group + storage account](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh)
- [VM scale set with autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
- [Install AWS CLI v2 and configure profiles](../AWS/scripts/2026-07-13-install-aws-cli-v2-and-configure.sh)
- [Deploy static website to S3](../AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh)
- [Install gcloud CLI + configure credentials](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)
- [Create GCS bucket and set up IAM](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh)

### Install a tool

- [Install Ansible + run first ad-hoc command](../Ansible/scripts/install-and-first-adhoc.sh)
- [Install Docker + run first container](../Docker/scripts/install-and-run-first-container.sh)
- [Install Helm + explore CLI](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh)
- [Install kind + create first K8s cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
- [Install OpenTofu + verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- [Install Prometheus + verify metrics](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh)
- [Install Terraform + init/plan](../Terraform/scripts/install-and-init.sh)
- [Install Git + make first commit](../Git/scripts/install-and-first-commit.sh)
- [Install Trivy + scan filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh)
- [Install GitLab Runner + register](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh)

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

### Write a playbook / pipeline / config

- [Ansible nginx playbook snippet](../Ansible/snippets/nginx-playbook.yaml)
- [Ansible Docker + Python setup playbook](../Ansible/configs/docker-python-setup.yaml)
- [Ansible collection requirements and Docker lifecycle playbook](../Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml)
- [Scan Ansible for antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py)
- [GitHub Actions CI workflow with env/secrets](../GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml)
- [GitHub Actions matrix node workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml)
- [Reusable deployment workflow with environment gates](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml)
- [GitLab CI first pipeline](../GitLab CI/configs/2026-06-22-first-pipeline.yaml)
- [Helm redis chart manifests](../Helm/manifests/redis-chart/Chart.yaml)
- [Helm live-release values config](../Helm/configs/2026-09-02-live-release-values.yaml)
- [Helm production-deployment values config](../Helm/configs/2026-08-30-production-deployment-values.yaml)
- [Azure AKS cluster Bicep manifest](../Azure/manifests/production-aks-cluster.bicep)
- [OpenTofu minimal local config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)
- [Prometheus minimal scrape config](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml)
- [Terraform local file config](../Terraform/configs/local-file.tf)
- [Terraform reusable S3 module](../Terraform/configs/reusable-s3-module/README.md)
- [Docker Compose multi-service app config](../Docker/configs/multi-service-app.yaml)
- [Production Compose stack](../Docker/manifests/production-compose-stack.yaml)
- [Go + Redis + Prometheus Compose stack](../Docker/manifests/go-redis-prometheus-compose.yaml)
- [Trivy config with scan policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml)
- [Kubernetes Deployment + Service with probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)

### Work with Terraform

- [Wire outputs into a dependent module](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md)
- [Scaffold a reusable S3 bucket module + remote state](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)
- [Reusable VPC module manifest](../Terraform/manifests/reusable-vpc-module.hcl)
- [Multi-environment scaffold with workspaces + remote state](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/README.md)
- [Bootstrap a structured Terraform project](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh)
- [for_each vs count notebook](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- [Terraform coverage correction doc](../Terraform/docs/2026-09-17-coverage-correction.md)

### Work with OpenTofu

- [OpenTofu quickstart trip-ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md)
- [State management tutorial notes](../OpenTofu/docs/2026-08-25-state-management-tutorial-notes.md)
- [Minimal local backend config](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl)

### Work with Git

- [Branching tutorial](../Git/notes/2026-06-07-git-branching-tutorial.md)
- [Minimal branching workflow script](../Git/scripts/minimal-branching-workflow.sh)
- [Merge conflict practice](../Git/scripts/2026-06-10-merge-conflict-practice.sh)
- [Conventional commit hook](../Git/scripts/commit-msg-conventional-commit.sh)
- [Squash WIP commits](../Git/scripts/squash-wip-commits.sh)
- [Branch management and tag creation](../Git/scripts/branch-management-and-tag-creation.sh)
- [Git workflows comparison](../Git/docs/git-workflows-comparison.md)
- [Git worktrees for parallel development](../Git/docs/git-worktrees-parallel-feature-development.md)
- [Automate git bisect with a regression test](../Git/docs/automating-git-bisect-with-scripted-regression-tests.md)
- [Wiring Git hooks into a pre-commit workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md)
- [Git coverage correction doc](../Git/docs/2026-09-17-git-coverage-correction.md)
- [Git merge strategies notebook](../Git/notebooks/comparing-git-merge-strategies.ipynb)
- [Repository scaffold template](../Git/templates/git-repository-skeleton/README.md)

### Work with Docker

- [Docker Compose quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
- [Multi-stage Go HTTP server Dockerfile](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
- [Production-ready Go HTTP server Dockerfile](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
- [Build mount vs COPY caching comparison](../Docker/docs/docker-build-mount-vs-copy-caching.md)
- [docker run vs compose decision guide](../Docker/docs/docker-run-vs-compose.md)
- [Go microservice project scaffold](../Docker/templates/go-microservice/README.md)
- [Container health check + cleanup script](../Docker/scripts/docker-health-check-and-cleanup.sh)
- [Image layer analyzer](../Docker/snippets/analyze-image-layers.py)
- [Docker networking drivers notebook](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)

### Ship with GitHub Actions

- [Composite actions vs reusable workflows](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md)
- [Self-hosted runner registration + cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh)
- [Trigger a workflow_dispatch and poll status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)

### Work with Kubernetes

- [K8s interactive tutorial walkthrough](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)
- [Pod lifecycle management script](../Kubernetes/scripts/pod-lifecycle.sh)
- [Deployment and Service with probes and limits](../Kubernetes/manifests/deployment-service-with-probes-limits.yaml)
- [Go service Deployment with probes + HPA](../Kubernetes/manifests/go-service-deployment-with-probes-hpa.yaml)
- [Ingress path-based routing](../Kubernetes/docs/ingress-path-based-routing.md)
- [Integrating Kubernetes with Prometheus](../Kubernetes/docs/integrating-kubernetes-with-prometheus.md)
- [Kubernetes workload-type comparisons notebook](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb)
- [Pod troubleshooting shell snippet](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
- [K8s deployment scaffold with Helm + Kustomize overlays](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/Chart.yaml)

### Sync a GitOps app

- [ArgoCD quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md)
- [First ArgoCD Application manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- [Sync an app and verify health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)

### Work with AWS

- [AWS CLI quickstart walkthrough](../AWS/scripts/2026-08-14-aws-cli-quickstart-walkthrough.sh)
- [List EC2 instances and S3 buckets](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)
- [List and tag EC2 instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh)

### Work with Azure

- [Azure quickstart trip-ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md)
- [Create resource group and list regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh)
- [Provision a VM scale set with load balancer and autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)

### Work with GCP

- [Create GCS bucket and set up IAM](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh)
- [List Compute instances and GCS buckets](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh)
- [Install gcloud CLI + configure credentials](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)

### Work with Helm

- [Helm quickstart trip-ups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md)
- [Helm live-release values config](../Helm/configs/2026-09-02-live-release-values.yaml)
- [Helm production-deployment values config](../Helm/configs/2026-08-30-production-deployment-values.yaml)
- [Helm live-values config](../Helm/configs/2026-08-29-live-values.yaml)
- [Helm chart inspection config](../Helm/configs/2026-07-23-first-helm-chart-inspection.yaml)
- [Helm redis chart manifests](../Helm/manifests/redis-chart/Chart.yaml)
- [Nginx chart custom-values install](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)

### Scan for vulnerabilities

- [Trivy CLI exploration](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)
- [Trivy quickstart follow-along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md)
- [Scan container image with Trivy](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh)
- [Fail a build on critical CVEs](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py)
- [Trivy config with scan policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml)

### CI/CD concepts

- [CI/CD concepts primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
- [Preview environments with gated promotion](../docs/concepts/ci-cd-concepts/docs/ephemeral-preview-environments-gated-promotion.md)
- [Simulated CI/CD pipeline script](../docs/concepts/ci-cd-concepts/scripts/2026-08-04-simulated-cicd-pipeline.sh)
- [CI/CD common patterns snippet](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh)

### Containerization concepts

- [Containerization concepts primer](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
- [Smaller images, base caching, runtimes](../docs/concepts/containerization-concepts/docs/2026-08-08-smaller-images-base-caching-runtimes.md)
- [Inspect image layers with Python](../docs/concepts/containerization-concepts/snippets/2026-08-08-inspect-image-layers.py)
- [Docker build, tag, and run lifecycle script](../docs/concepts/containerization-concepts/scripts/2026-09-06-docker-build-tag-run-lifecycle.sh)

### Infrastructure as code concepts

- [Infrastructure as Code concepts primer](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
- [Terraform and Ansible division of responsibility](../docs/concepts/infrastructure-as-code-concepts/docs/2026-08-08-terraform-ansible-division-of-responsibility.md)
- [Declarative vs imperative IaC notebook](../docs/concepts/infrastructure-as-code-concepts/notebooks/2026-08-08-declarative-vs-imperative-iac.ipynb)
- [IaC state workflow sandbox](../docs/concepts/infrastructure-as-code-concepts/scripts/2026-08-25-iac-state-workflow.sh)

### Monitoring and observability

- [Monitoring & Observability concepts primer](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
- [Combining metrics, logs, and traces](../docs/concepts/monitoring-observability-concepts/docs/2026-08-09-combining-metrics-logs-traces-observability.md)
- [Check Prometheus target health with PromQL](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)

### Scripting and automation

- [Scripting & Automation concepts primer](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
- [Bash scripting exercises](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-07-bash-scripting-exercises.sh)
- [Config parsing with jq and retry patterns](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-23-config-parsing-jq-retry.sh)

### Version control concepts

- [Version Control concepts primer](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
- [Branch protection, merge strategies, and release automation](../docs/concepts/version-control-concepts/docs/branch-protection-merge-strategies-release-automation.md)
- [Git feature-branch rebase, merge, and tag script](../docs/concepts/version-control-concepts/scripts/2026-08-08-git-feature-branch-rebase-merge-tag.sh)
- [Conventional changelog from git log](../docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py)
