# Quick Links

## I need to...

### Read a primer first

**Foundational concepts**
- [Linux & System Administration](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
- [Networking Fundamentals](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
- [Scripting & Automation (Bash/Python)](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
- [Version Control Concepts](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
- [CI/CD Concepts](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
- [Containerization Concepts](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
- [Infrastructure as Code Concepts](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
- [Monitoring & Observability Concepts](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)

**Tools**
- [Git](../Git/notes/0000-primer-git.md)
- [GitHub](../GitHub/notes/0000-primer-github.md)
- [Docker](../Docker/notes/0000-primer-docker.md)
- [Trivy](../Trivy/notes/0000-primer-trivy.md)
- [GitHub Actions](../GitHub Actions/notes/0000-primer-github-actions.md)
- [AWS](../AWS/notes/0000-primer-aws.md)
- [Terraform](../Terraform/notes/0000-primer-terraform.md)
- [Ansible](../Ansible/notes/0000-primer-ansible.md)
- [Kubernetes](../Kubernetes/notes/0000-primer-kubernetes.md)
- [Helm](../Helm/notes/0000-primer-helm.md)
- [ArgoCD](../ArgoCD/notes/0000-primer-argocd.md)
- [Prometheus](../Prometheus/notes/0000-primer-prometheus.md)
- [Grafana](../graf/notes/0000-primer-grafana.md)
- [OpenTelemetry](../otel/notes/0000-primer-opentelemetry.md)
- [HashiCorp Vault](../vlt/notes/0000-primer-vlt.md)
- [Azure](../Azure/notes/0000-primer-azure.md)
- [GCP](../GCP/notes/0000-primer-gcp.md)
- [GitLab CI](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- [Jenkins](../jnk/notes/0000-primer-jenkins.md)
- [OpenTofu](../OpenTofu/notes/0000-primer-opentofu.md)
- [Pulumi](../plm/notes/0000-primer-plm.md)

### Install a tool

- [Install Ansible and run a first ad-hoc command](../Ansible/scripts/install-and-first-adhoc.sh)
- [Install Docker and run a first container](../Docker/scripts/install-and-run-first-container.sh)
- [Install Helm and explore the CLI](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh)
- [Install Jenkins and explore core concepts](../jnk/notes/0000-primer-jenkins.md)
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
- [Install AWS CLI v2 and configure](../AWS/scripts/2026-07-12-install-aws-cli-v2-and-configure.sh)
- [Install Azure CLI and log in](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh)
- [Install gcloud CLI and configure creds](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)

### Build and ship a container

- [Package the sample app as a Docker image](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
- [Run the app and Postgres with Compose](../Docker/manifests/app-postgres-healthchecks.compose.yaml)
- [Scan an image with Trivy](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py)

### Provision infrastructure

- [Provision a small network with Terraform](../Terraform/manifests/simple-ec2-app.tf)
- [Build a reusable VPC module](../Terraform/manifests/reusable-vpc-module.hcl)
- [Bootstrap OpenTofu remote state](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh)
- [Pulumi network component](../plm/scripts/network-component-vpc-subnets.py)

### Run CI/CD pipelines

- [First CI workflow hello](../GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml)
- [Reusable deployment workflow](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml)
- [GitLab minimal pipeline](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
- [Jenkins first job via CLI](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

### Deploy to Kubernetes

- [Deploy a stateless app](../Kubernetes/manifests/stateless-app.yaml)
- [Production deployment with HPA/PDB](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml)
- [Package the app as a Helm chart](../Helm/templates/microservice-chart/values.yaml)
- [ArgoCD first application manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- [Flux minimal GitRepository/Kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)

### Observe and alert

- [Prometheus scrape config](../Prometheus/configs/prometheus-scrape-config-and-remote-write-tuning.yaml)
- [Grafana datasource/dashboard provisioning](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)
- [OpenTelemetry collector OTLP pipeline](../otel/configs/collector-otlp-real-pipeline.yaml)

### Manage secrets

- [Vault KV v2 read/write](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py)
- [Vault AppRole config](../vlt/configs/vault-approle.hcl)
