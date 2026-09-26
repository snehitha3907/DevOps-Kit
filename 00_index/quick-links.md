# Quick Links

## I need to...

### Set up a cloud provider

- [Install Azure CLI and login](../Azure/scripts/2026-07-13-install-azure-cli-and-login.sh)
- [Provision a resource group and storage account](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh)
- [Provision a VM scale set with autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
- [Install AWS CLI v2 and configure profiles](../AWS/scripts/2026-07-13-install-aws-cli-v2-and-configure.sh)
- [Deploy a static website to S3](../AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh)
- [Create an S3 bucket and upload an object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py)
- [Install gcloud CLI and configure credentials](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)
- [Create a GCS bucket and set up IAM](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh)

### Install a tool

- [Install Ansible and run a first ad-hoc command](../Ansible/scripts/install-and-first-adhoc.sh)
- [Install Docker and run a first container](../Docker/scripts/install-and-run-first-container.sh)
- [Install Helm and explore the CLI](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh)
- [Install kind and create a first cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
- [Install OpenTofu and verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- [Install Prometheus and verify the metrics endpoint](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh)
- [Install Terraform, init, and plan](../Terraform/scripts/install-and-init.sh)
- [Install Git and make a first commit](../Git/scripts/install-and-first-commit.sh)
- [Install Trivy and scan a filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh)
- [Install the Vault CLI and start a dev server](../vlt/scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh)
- [Install the Pulumi CLI and init a project](../plm/scripts/2026-09-19-install-pulumi-cli-and-init-project.sh)
- [Install Grafana and open the login page](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)
- [Install a GitLab runner and register it](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh)
- [Install the Flux CLI and run a pre-flight check](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- [Install the ArgoCD CLI and reach the UI](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)

### Read a primer first

- [Linux & System Administration](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
- [Networking Fundamentals](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
- [Scripting & Automation (Bash/Python)](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
- [Version Control Concepts](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
- [CI/CD Concepts](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
- [Containerization Concepts](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
- [Infrastructure as Code Concepts](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
- [Monitoring & Observability Concepts](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
- [Ansible](../Ansible/notes/0000-primer-ansible.md) · [ArgoCD](../ArgoCD/notes/0000-primer-argocd.md) · [AWS](../AWS/notes/0000-primer-aws.md) · [Azure](../Azure/notes/0000-primer-azure.md) · [Docker](../Docker/notes/0000-primer-docker.md) · [GCP](../GCP/notes/0000-primer-gcp.md) · [Git](../Git/notes/0000-primer-git.md) · [GitHub](../GitHub/notes/0000-primer-github.md) · [GitHub Actions](../GitHub Actions/notes/0000-primer-github-actions.md) · [GitLab CI/CD](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md) · [Grafana](../graf/notes/0000-primer-grafana.md) · [Helm](../Helm/notes/0000-primer-helm.md) · [Kubernetes](../Kubernetes/notes/0000-primer-kubernetes.md) · [OpenTelemetry](../otel/notes/0000-primer-opentelemetry.md) · [OpenTofu](../OpenTofu/notes/0000-primer-opentofu.md) · [Prometheus](../Prometheus/notes/0000-primer-prometheus.md) · [Terraform](../Terraform/notes/0000-primer-terraform.md) · [Trivy](../Trivy/notes/0000-primer-trivy.md) · [HashiCorp Vault](../vlt/notes/0000-primer-vlt.md) · [Pulumi](../plm/notes/0000-primer-plm.md)

### Write a playbook, pipeline, or config

- [Ansible nginx playbook](../Ansible/snippets/nginx-playbook.yaml)
- [Ansible Docker and Python setup playbook](../Ansible/configs/docker-python-setup.yaml)
- [Collection requirements and a Docker lifecycle playbook](../Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml)
- [Scan Ansible for antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py)
- [GitHub Actions CI workflow with env and secrets](../GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml)
- [GitHub Actions matrix node workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml)
- [Reusable deployment workflow with environment gates](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml)
- [GitLab CI first pipeline](../GitLab CI/configs/2026-06-22-first-pipeline.yaml)
- [GitLab CI stages, cache, and artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
- [GitLab CI multi-project pipeline with a downstream trigger](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml)
- [Helm redis chart](../Helm/manifests/redis-chart/Chart.yaml)
- [Helm live-release values](../Helm/configs/2026-09-02-live-release-values.yaml)
- [Helm production-deployment values](../Helm/configs/2026-08-30-production-deployment-values.yaml)
- [Azure AKS cluster in Bicep](../Azure/manifests/production-aks-cluster.bicep)
- [OpenTofu minimal local config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)
- [Prometheus minimal scrape config](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml)
- [Terraform local file config](../Terraform/configs/local-file.tf)
- [Terraform reusable S3 module](../Terraform/configs/reusable-s3-module/README.md)
- [Docker Compose multi-service config](../Docker/configs/multi-service-app.yaml)
- [Production Compose stack](../Docker/manifests/production-compose-stack.yaml)
- [Go, Redis, and Prometheus Compose stack](../Docker/manifests/go-redis-prometheus-compose.yaml)
- [Trivy config with scan policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml)
- [Kubernetes Deployment and Service with probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)

### Work with Terraform

- [Wire outputs into a dependent module](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md)
- [Scaffold a reusable S3 bucket module with remote state](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)
- [Reusable VPC module](../Terraform/manifests/reusable-vpc-module.hcl)
- [Multi-environment scaffold with workspaces and remote state](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/README.md)
- [Bootstrap a structured Terraform project](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh)
- [local_file and random_pet across two providers](../Terraform/configs/2026-09-19-local-file-random-provider.hcl)
- [for_each vs count notebook](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- [Generate an Ansible inventory from Terraform state](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py)

### Work with OpenTofu

- [OpenTofu quickstart trip-ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md)
- [State management tutorial notes](../OpenTofu/docs/2026-08-25-state-management-tutorial-notes.md)
- [Minimal local backend config](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl)
- [S3 backend with workspace isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md)
- [OpenTofu vs Terraform for AWS provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)
- [S3 and DynamoDB remote-state bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh)

### Provision with Pulumi

- [Pulumi primer](../plm/notes/0000-primer-plm.md)
- [Install the CLI and init a project](../plm/scripts/2026-09-19-install-pulumi-cli-and-init-project.sh)
- [Minimal bucket with Pulumi Python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)

### Manage secrets with Vault

- [HashiCorp Vault primer](../vlt/notes/0000-primer-vlt.md)
- [Install the CLI and start a dev server](../vlt/scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh)
- [Explore the Vault CLI — secrets and policies](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md)

### Work with Git

- [Branching tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md)
- [Minimal branching workflow](../Git/scripts/minimal-branching-workflow.sh)
- [Merge conflict practice](../Git/scripts/2026-06-10-merge-conflict-practice.sh)
- [Conventional commit hook](../Git/scripts/commit-msg-conventional-commit.sh)
- [Squash WIP commits](../Git/scripts/squash-wip-commits.sh)
- [Branch management and tag creation](../Git/scripts/branch-management-and-tag-creation.sh)
- [gitattributes filters and merge drivers](../Git/scripts/setup-gitattributes-filters-and-merge.sh)
- [Git workflow comparison](../Git/docs/git-workflows-comparison.md)
- [Worktrees for parallel development](../Git/docs/git-worktrees-parallel-feature-development.md)
- [Worktree setup gotchas](../Git/docs/git-worktrees-parallel-feature-development-setup-workflow-gotchas.md)
- [Worktree workflows for parallel branches](../Git/docs/worktree-workflows-parallel-branches.md)
- [Automate `git bisect` with a regression test](../Git/docs/automating-git-bisect-with-scripted-regression-tests.md)
- [Bisect runner — drives `git bisect run` end to end](../Git/scripts/bisect-automation-runner.sh)
- [Wiring hooks into a pre-commit workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md)
- [Merge strategies notebook](../Git/notebooks/comparing-git-merge-strategies.ipynb)
- [Repository skeleton scaffold](../Git/templates/git-repository-skeleton/README.md)
- [Trunk-based delivery with short-lived branches](../docs/concepts/version-control-concepts/2026-09-25-trunk-based-delivery-short-lived-branches.md)

### Work with GitHub

- [gh CLI quickstart trip-ups](../GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md)
- [Create a repo and open a PR](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh)
- [Provision a repo with the API](../GitHub/scripts/provision-repo-with-api.py)
- [Production repository scaffold](../GitHub/templates/github-repo-scaffold/README.md)
- [Apply branch protection via the API](../GitHub/templates/github-repo-scaffold/configure-branch-protection.sh)
- [Release automation end to end](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md)
- [Deploy keys vs fine-grained PATs for CI/CD](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)
- [Environments deployment protection](../GitHub/manifests/github-environments-deployment-protection.yaml)

### Work with Docker

- [Compose quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
- [Compose vs Swarm vs Kubernetes](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb)
- [Multi-stage Go HTTP server Dockerfile](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
- [Production-ready Go HTTP server Dockerfile](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
- [Production Python web-service Dockerfile](../Docker/dockerfiles/production-python-web-service.Dockerfile)
- [Build mount vs COPY caching](../Docker/docs/docker-build-mount-vs-copy-caching.md)
- [docker run vs compose](../Docker/docs/docker-run-vs-compose.md)
- [Go microservice scaffold](../Docker/templates/go-microservice/README.md)
- [Production Swarm stack with secrets and rolling updates](../Docker/manifests/production-swarm-stack.yaml)
- [Health check and cleanup script](../Docker/scripts/docker-health-check-and-cleanup.sh)
- [Image layer analyzer](../Docker/snippets/analyze-image-layers.py)
- [Networking drivers notebook](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)

### Ship with GitHub Actions

- [Composite actions vs reusable workflows](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md)
- [Self-hosted runner registration and cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh)
- [Self-hosted runner Dockerfile (Docker-in-Docker)](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)
- [Trigger a `workflow_dispatch` and poll status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)

### Ship with GitLab CI

- [GitLab CI/CD primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- [Runner setup, variables, and artifacts trip-ups](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md)
- [Stages, cache, and artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
- [Validate a pipeline locally](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh)
- [Trigger a pipeline via the API and poll jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- [Run a first local pipeline](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh)

### Work with Kubernetes

- [Interactive tutorial walkthrough](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)
- [First pod and service with kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh)
- [Production deployment with HPA, PDB, and NetworkPolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml)
- [Rollout status and pod readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh)
- [Pod lifecycle script](../Kubernetes/scripts/pod-lifecycle.sh)
- [Deployment and Service with probes and limits](../Kubernetes/manifests/deployment-service-with-probes-limits.yaml)
- [Go service Deployment with probes and an HPA](../Kubernetes/manifests/go-service-deployment-with-probes-hpa.yaml)
- [Ingress path-based routing](../Kubernetes/docs/ingress-path-based-routing.md)
- [Integrating with Prometheus](../Kubernetes/docs/integrating-kubernetes-with-prometheus.md)
- [Workload-type comparison notebook](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb)
- [Pod troubleshooting shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
- [Helm and Kustomize overlay scaffold](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/Chart.yaml)

### Sync a GitOps app

- [ArgoCD quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md)
- [First ArgoCD Application manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- [Sync an app and verify health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)
- [Flux CLI command surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)
- [Install the Flux CLI and run `flux check --pre`](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)

### Work with AWS

- [AWS CLI quickstart walkthrough](../AWS/scripts/2026-08-14-aws-cli-quickstart-walkthrough.sh)
- [List EC2 instances and S3 buckets](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)
- [List and tag EC2 instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh)
- [Build a VPC with EC2 and RDS end to end](../AWS/scripts/build-vpc-ec2-rds-stack.py)
- [Scope least-privilege IAM policies](../AWS/docs/iam-policy-least-privilege-walkthrough.md)
- [boto3 vs CloudFormation vs CDK on the same stack](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)

### Work with Azure

- [First login and resource list](../Azure/notes/2026-09-18-first-login-and-resource-list.md)
- [Azure quickstart trip-ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md)
- [CLI vs Bicep vs Python SDK](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md)
- [Create a resource group and list regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh)
- [Create a VNet, NSG, and Linux VM](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh)
- [VM scale set with a load balancer](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)

### Work with GCP

- [gcloud quickstart trip-ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md)
- [Launch a VM, firewall rule, and SSH in](../GCP/scripts/2026-09-21-launch-vm-firewall-and-ssh.sh)
- [Instance template with a startup script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml)
- [Create a GCS bucket and set up IAM](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh)
- [List Compute instances and GCS buckets](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh)
- [Install gcloud CLI and configure credentials](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)

### Work with Helm

- [Helm quickstart trip-ups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md)
- [Values management approaches](../Helm/docs/values-management-approaches.md)
- [Demo web service chart](../Helm/scripts/demo-web-service-chart.sh)
- [Live-release values](../Helm/configs/2026-09-02-live-release-values.yaml)
- [Production-deployment values](../Helm/configs/2026-08-30-production-deployment-values.yaml)
- [Live-values config](../Helm/configs/2026-08-29-live-values.yaml)
- [Chart inspection config](../Helm/configs/2026-07-23-first-helm-chart-inspection.yaml)
- [Redis chart](../Helm/manifests/redis-chart/Chart.yaml)
- [nginx chart with custom values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)

### Scan for vulnerabilities

- [Trivy CLI exploration](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)
- [Quickstart follow-along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md)
- [Choose a scan mode and wire it into a pipeline](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md)
- [Scan a container image](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh)
- [Fail a build on critical CVEs](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py)
- [Config with scan policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml)
- [Repo scan workflow with SARIF output](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh)
- [Batch image scanning from a file](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)

### Collect metrics

- [Prometheus primer](../Prometheus/notes/0000-primer-prometheus.md)
- [Minimal scrape config](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml)
- [Container monitoring config](../Prometheus/configs/2026-09-05-minimal-container-monitoring-config.yml)
- [Install Prometheus and verify metrics](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh)
- [Check target health with PromQL](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)

### Trace a request

- [OpenTelemetry primer](../otel/notes/0000-primer-opentelemetry.md)
- [Install a collector and run the OTLP pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh)
- [First trace span with the Python SDK](../otel/snippets/2026-09-26-first-trace-span.py)

### Visualize metrics

- [Grafana primer](../graf/notes/0000-primer-grafana.md)
- [Poking around the Grafana UI](../graf/notes/2026-09-25-explore-grafana-ui.md)
- [Install Grafana with Docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)

### Check a target is actually up

- [Test TCP port reachability and DNS resolution](../docs/concepts/networking-fundamentals/scripts/2026-09-25-testing-tcp-port-reachability-dns-resolution.py)
- [TCP port and DNS checks with sockets](../docs/concepts/networking-fundamentals/snippets/2026-09-24-tcp-port-and-dns-sockets.py)
- [TCP/TLS probes with latency](../docs/concepts/networking-fundamentals/scripts/tcp-tls-health-probes-with-latency.sh)
- [Netcat and curl connectivity](../docs/concepts/networking-fundamentals/scripts/2026-07-18-netcat-and-curl-connectivity.sh)
- [Health check and log correlation](../docs/concepts/monitoring-observability-concepts/scripts/health-checks-and-log-correlation.py)
- [Scripted health gate with correlated logs](../docs/concepts/monitoring-observability-concepts/scripts/scripted-health-gate-with-correlated-logs.py)

### Automate with a script

- [Scripting & Automation primer](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
- [Bash scripting exercises](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-07-bash-scripting-exercises.sh)
- [Config parsing with `jq` and retry](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-23-config-parsing-jq-retry.sh)
- [Parallel tasks with structured logging](../docs/concepts/scripting-automation-bash-python/scripts/2026-09-23-parallel-tasks-with-logging.sh)
- [Retry, backoff, and logging](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-08-retry-backoff-logging.py)
- [Log parsing and filtering](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py)

### Reason about CI/CD pipelines

- [CI/CD concepts primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
- [Preview environments with gated promotion](../docs/concepts/ci-cd-concepts/docs/ephemeral-preview-environments-gated-promotion.md)
- [Artifact promotion, environments, and rollbacks](../docs/concepts/ci-cd-concepts/docs/artifact-promotion-environment-rollbacks.md)
- [Simulated pipeline](../docs/concepts/ci-cd-concepts/scripts/2026-08-04-simulated-cicd-pipeline.sh)
- [Artifact promotion and rollback](../docs/concepts/ci-cd-concepts/scripts/artifact-promotion-rollback.sh)
- [Common patterns](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh)
- [Parallelized CI stage runner](../docs/concepts/ci-cd-concepts/snippets/2026-08-08-parallelized-ci-stage-runner.sh)
- [Branch protection, merge strategies, and release automation](../docs/concepts/version-control-concepts/docs/branch-protection-merge-strategies-release-automation.md)

### Troublesage a host

- [Process and permission patterns](../docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md)
- [Filesystem permissions and process management](../docs/concepts/linux-system-administration/scripts/2026-07-18-filesystem-permissions-and-process-management.sh)
- [systemd health check and log rotation](../docs/concepts/linux-system-administration/scripts/systemd-health-check-and-log-rotation.sh)
- [systemd timers and journald shipping](../docs/concepts/linux-system-administration/docs/systemd-timers-journald-shipping.md)
- [systemd health check and log alerting](../docs/concepts/linux-system-administration/scripts/systemd-health-check-log-alerting.sh)
- [Linux system performance analysis](../docs/concepts/linux-system-administration/notebooks/linux-system-performance-analysis.ipynb)
- [Network troubleshooting patterns](../docs/concepts/networking-fundamentals/notes/2026-08-07-network-troubleshooting-patterns.md)
- [Kubernetes pod troubleshooting shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
- [Ansible playbook troubleshooting](../Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md)
