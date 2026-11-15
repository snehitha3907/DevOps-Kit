# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## AWS · 25 files

- **primer:** [Primer AWS](../AWS/notes/0000-primer-aws.md)

- **Notes** (2): [Primer Already Exists](../AWS/notes/2026-07-13-primer-already-exists.md)
  - _…and 1 more — browse `AWS/`._

- **Docs** (2): [IAM Policy Least Privilege Walkthrough](../AWS/docs/iam-policy-least-privilege-walkthrough.md), [IAM Cross Account Roles Least Privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md)

- **Snippets** (3): [Create S3 Bucket And Upload Object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py), [List And Tag EC2 Instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [List EC2 And S3](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)

- **Scripts** (7): [VPC With Private Endpoints](../AWS/scripts/vpc-with-private-endpoints.py), [Build VPC EC2 Rds Stack](../AWS/scripts/build-vpc-ec2-rds-stack.py), [Deploy Static Website To S3](../AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh)
  - _…and 4 more — browse `AWS/`._

- **Configs** (3): [Ecs Service Deployment Blue Green](../AWS/configs/ecs-service-deployment-blue-green.yaml), [Minimal AWS Config](../AWS/configs/2026-07-13-minimal-aws-config.ini), [Minimal AWS Config](../AWS/configs/2026-07-12-minimal-aws-config.ini)

- **Notebooks** (1): [Comparing Deployment Approaches Boto3 Cloudformation Cdk](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)

- **Templates** (7): [Variables](../aws/templates/aws-control-tower-landing-zone/variables.tf), [Template](../AWS/templates/cloudformation-multi-account-stack-set/template.yaml), [Outputs](../aws/templates/aws-control-tower-landing-zone/outputs.tf)
  - _…and 4 more — browse `AWS/`._

## Ansible · 114 files

- **primer:** [Primer Ansible](../Ansible/notes/0000-primer-ansible.md)

- **Notes** (10): [Ansible](../Ansible/notes/ansible.cfg), [All](../Ansible/notes/group_vars/all.yml), [Ansible Quickstart Trip Ups](../Ansible/notes/2026-09-04-ansible-quickstart-trip-ups.md)
  - _…and 7 more — browse `Ansible/`._

- **Docs** (7): [Integrating Ansible With Network Devices](../Ansible/docs/integrating-ansible-with-network-devices.md), [Integrated Ansible Docker CI Pipeline Testing](../Ansible/docs/integrated-ansible-docker-ci-pipeline-testing.md), [Ansible Upgrade Playbook And Preflight Checks](../Ansible/docs/ansible-upgrade-playbook-and-preflight-checks.md)
  - _…and 4 more — browse `Ansible/`._

- **Snippets** (2): [Nginx Playbook](../Ansible/snippets/nginx-playbook.yaml), [Lint Ansible Playbook](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py)

- **Scripts** (4): [Scan Ansible Antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py), [Run First Playbook](../Ansible/scripts/run-first-playbook.sh), [Install And First Adhoc](../Ansible/scripts/install-and-first-adhoc.sh)
  - _…and 1 more — browse `Ansible/`._

- **Configs** (10): [Nginx Webserver](../Ansible/configs/nginx-webserver.yaml), [Lab Inventory](../Ansible/configs/lab-inventory.ini), [Docker Python Setup](../Ansible/configs/docker-python-setup.yaml)
  - _…and 7 more — browse `Ansible/`._

- **Manifests** (10): [Production](../Ansible/manifests/inventory/production.ini), [Playbook Migration](../ans/manifests/playbook-migration.yaml), [Multi Server Deployment](../Ansible/manifests/multi-server-deployment.yaml)
  - _…and 7 more — browse `Ansible/`._

- **Notebooks** (2): [Comparing Execution Patterns Block Rescue Serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb), [Ansible Variable Precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb)

- **Dockerfiles** (1): [Ansible Control Node.dockerfile](../Ansible/dockerfiles/ansible-control-node.Dockerfile)

- **Templates** (68): [Webservers](../Ansible/templates/production-ansible-project/playbooks/webservers.yml), [Webservers](../Ansible/templates/ansible-project-scaffold/group_vars/webservers.yml), [Webservers](../Ansible/templates/ansible-project-scaffold/playbooks/webservers.yml)
  - _…and 65 more — browse `Ansible/`._

## ArgoCD · 27 files

- **primer:** [Primer Argocd](../ArgoCD/notes/0000-primer-argocd.md)

- **Notes** (3): [Install](../ArgoCD/notes/install.yaml), [Argocd Quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md)
  - _…and 1 more — browse `ArgoCD/`._

- **Docs** (2): [How I Wired Argocd With Github For Gitops Deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md), [Argocd Vault External Secrets](../ArgoCD/docs/argocd-vault-external-secrets.md)

- **Snippets** (1): [Sync App And Verify Health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)

- **Scripts** (3): [Build Argocd Application From Scratch](../ArgoCD/scripts/build-argocd-application-from-scratch.sh), [Argocd Application Helper](../ArgoCD/scripts/argocd-application-helper.py), [Install Argocd And Access UI](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)

- **Configs** (3): [Guestbook Applicationset Multi Cluster](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml), [Guestbook Applicationset](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml), [First Application Manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)

- **Manifests** (2): [Multi Cluster Fleet Applicationset](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml), [Deployment](../ArgoCD/manifests/guestbook/deployment.yaml)

- **Templates** (13): [Values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/values.yaml), [Values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/dev/values.yaml), [Values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/prod/values.yaml)
  - _…and 10 more — browse `ArgoCD/`._

## Azure · 28 files

- **primer:** [Primer Azure](../Azure/notes/0000-primer-azure.md)

- **Notes** (4): [First Login And Resource List](../Azure/notes/2026-09-18-first-login-and-resource-list.md), [Azure Quickstart Trip Ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md), [Azure CLI Quickstart Trip Ups](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md)
  - _…and 1 more — browse `Azure/`._

- **Docs** (2): [Comparing Azure CLI Bicep Python SDK](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md), [Azure Devops Pipeline Bicep Integration](../Azure/docs/azure-devops-pipeline-bicep-integration.md)

- **Snippets** (3): [Create Vnet Nsg And Linux VM](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh), [Create Resource Group And List Regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [Create Resource Group And List Regions](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)

- **Scripts** (5): [Resource Group Cleanup](../Azure/scripts/resource-group-cleanup.sh), [Cleanup Resource Groups](../Azure/scripts/cleanup-resource-groups.sh), [Azure VM Scale Set Autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
  - _…and 2 more — browse `Azure/`._

- **Configs** (2): [Container Apps Microservices](../Azure/configs/container-apps-microservices.yaml), [Azure Key Vault Access Policy](../az/configs/azure-key-vault-access-policy.json)

- **Manifests** (2): [Production Aks Cluster](../Azure/manifests/production-aks-cluster.bicep), [Container Apps Multi Service Deployment](../az/manifests/container-apps-multi-service-deployment.yaml)

- **Templates** (10): [Policy](../Azure/templates/aks-cluster-with-addons/modules/addons/policy.bicep), [Network Policy](../Azure/templates/aks-cluster-with-addons/modules/addons/network-policy.bicep), [Monitoring](../Azure/templates/aks-cluster-with-addons/modules/addons/monitoring.bicep)
  - _…and 7 more — browse `Azure/`._

## Docker · 58 files

- **primer:** [Primer Docker](../Docker/notes/0000-primer-docker.md)

- **Notes** (6): [Compose](../Docker/notes/compose.yaml), [Docker Tutorial Tripups](../Docker/notes/2026-08-12-docker-tutorial-tripups.md), [Docker Compose Quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
  - _…and 3 more — browse `Docker/`._

- **Docs** (11): [Package](../Docker/docs/package.json), [Integrating Docker With Kubernetes](../Docker/docs/integrating-docker-with-kubernetes.md), [Docker Run Vs Compose](../Docker/docs/docker-run-vs-compose.md)
  - _…and 8 more — browse `Docker/`._

- **Snippets** (2): [Analyze Image Layers](../Docker/snippets/analyze-image-layers.py), [Build Run And Cleanup](../Docker/snippets/2026-08-12-build-run-and-cleanup.py)

- **Scripts** (5): [Multi Stage Go Dockerfile](../Docker/scripts/multi-stage-go-dockerfile.sh), [Install And Run First Container](../Docker/scripts/install-and-run-first-container.sh), [Install And Run Container](../Docker/scripts/install-and-run-container.sh)
  - _…and 2 more — browse `Docker/`._

- **Configs** (1): [Multi Service App](../Docker/configs/multi-service-app.yaml)

- **Manifests** (9): [Prometheus](../Docker/manifests/prometheus.yml), [Production Swarm Stack](../Docker/manifests/production-swarm-stack.yaml), [Production Docker Deployment With Ha](../docker/manifests/production-docker-deployment-with-ha.yaml)
  - _…and 6 more — browse `Docker/`._

- **Notebooks** (3): [Comparing Docker Networking Drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb), [Comparing Docker Build Strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb), [Comparing Compose Swarm Kubernetes Local Orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb)

- **Dockerfiles** (9): [Tried Building First Image.dockerfile](../Docker/dockerfiles/tried-building-first-image.Dockerfile), [Simple Go Server.dockerfile](../Docker/dockerfiles/simple-go-server.Dockerfile), [Production Ready Go HTTP Server.dockerfile](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
  - _…and 6 more — browse `Docker/`._

- **Templates** (12): [Main](../Docker/templates/go-microservice/main.go), [Go](../Docker/templates/go-microservice/go.mod), [Compose](../Docker/templates/multi-service-compose-with-healthchecks/compose.yaml)
  - _…and 9 more — browse `Docker/`._

## Flux CD · 8 files

- **Notes** (2): [Flux Quickstart Trip Ups](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md), [Explore Flux CLI Command Surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)

- **Docs** (2): [How I Wired Flux CD With Github For Gitops Deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md), [Flux CD Readme Coverage And Topics Update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md)

- **Scripts** (2): [Bootstrap Flux On Kind](../FluxCD/scripts/bootstrap-flux-on-kind.sh), [Install Flux CLI And Run Flux Check Pre](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)

- **Configs** (2): [Helmrelease Image Automation](../FluxCD/configs/helmrelease-image-automation.yaml), [Minimal Gitrepository And Kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)

## GCP · 15 files

- **primer:** [Primer GCP](../GCP/notes/0000-primer-gcp.md)

- **Notes** (2): [Gcloud SDK Quickstart Trip Ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md)
  - _…and 1 more — browse `GCP/`._

- **Docs** (1): [GCP Readme Coverage And Topics](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)

- **Snippets** (2): [List Compute And GCS With Gcloud](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh), [List Compute And GCS With Gcloud](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)

- **Scripts** (6): [Create GCS Bucket And Setup IAM](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh), [Cloud Run Terraform From Scratch](../gcp/scripts/cloud-run-terraform-from-scratch.py), [Build Cloud Run Service Terraform](../GCP/scripts/build-cloud-run-service-terraform.py)
  - _…and 3 more — browse `GCP/`._

- **Configs** (4): [Service Account And IAM Config](../GCP/configs/service-account-and-iam-config.yaml), [Gcloud IAM Config](../gcp/configs/gcloud-iam-config.yaml), [Instance Template With Startup Script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml)
  - _…and 1 more — browse `GCP/`._

## Git · 85 files

- **primer:** [Primer Git](../Git/notes/0000-primer-git.md)

- **Notes** (6): [Readme](../Git/notes/README.md), [Git Branching Tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md), [Git Branching Tutorial](../Git/notes/2026-06-07-git-branching-tutorial.md)
  - _…and 3 more — browse `Git/`._

- **Docs** (15): [Worktree Workflows Parallel Branches](../Git/docs/worktree-workflows-parallel-branches.md), [Wiring Git Hooks Into Pre Commit Workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md), [Regression Test](../Git/docs/scripts/regression-test.sh)
  - _…and 12 more — browse `Git/`._

- **Snippets** (1): [First Commit](../Git/snippets/first-commit.sh)

- **Scripts** (14): [Squash Wip Commits](../Git/scripts/squash-wip-commits.sh), [Setup Gitattributes Filters And Merge](../Git/scripts/setup-gitattributes-filters-and-merge.sh), [Semver Changelog Workflow](../Git/scripts/semver-changelog-workflow.sh)
  - _…and 11 more — browse `Git/`._

- **Notebooks** (3): [Merge Rebase Squash Comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb), [Merge Rebase Squash Comparison](../Git/notebooks/merge-rebase-squash-comparison.ipynb), [Comparing Git Merge Strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb)

- **Templates** (46): [Workflow Automation](../Git/templates/git-workflow-automation/ci/github-actions/workflow-automation.yml), [Test](../Git/templates/git-workflow-automation/ci/gitlab-ci/test.yml), [Setup Workflow](../Git/templates/git-workflow-automation/scripts/setup-workflow.sh)
  - _…and 43 more — browse `Git/`._

## GitHub · 56 files

- **primer:** [Primer Github](../GitHub/notes/0000-primer-github.md)

- **Notes** (11): [Gh CLI Quickstart Trip Ups](../GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md), [Primer Already Exists](../GitHub/notes/2026-06-19-primer-already-exists.md), [Hello World Guide And Github Flow](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md)
  - _…and 8 more — browse `GitHub/`._

- **Docs** (7): [Release Automation Tags Milestones And Releases End To End](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md), [Protection](../GitHub/docs/protection.json), [How I Wired Deploy Keys Vs Fine Grained Pats For Cicd](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)
  - _…and 4 more — browse `GitHub/`._

- **Snippets** (3): [Open PR And Wait For CI](../GitHub/snippets/open-pr-and-wait-for-ci.sh), [List Repos With Python](../GitHub/snippets/list-repos-with-python.py), [Github Issues API](../GitHub/snippets/github-issues-api.py)

- **Scripts** (7): [Tried Commenting On First Issue](../GitHub/scripts/tried-commenting-on-first-issue.sh), [Tried Auth And Profile](../GitHub/scripts/tried-auth-and-profile.sh), [Provision Repo With API](../GitHub/scripts/provision-repo-with-api.py)
  - _…and 4 more — browse `GitHub/`._

- **Configs** (7): [Stale](../GitHub/configs/dot-github-repository/stale.yml), [Labels](../GitHub/configs/dot-github-repository/labels.yaml), [Issue Templates And Labels](../GitHub/configs/issue-templates-and-labels.yaml)
  - _…and 4 more — browse `GitHub/`._

- **Manifests** (1): [Github Environments Deployment Protection](../GitHub/manifests/github-environments-deployment-protection.yaml)

- **Notebooks** (2): [Comparing API Approaches Release Automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb), [Analyzing Github Actions Usage Across Org Repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb)

- **Dockerfiles** (1): [Self Hosted Runner.dockerfile](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)

- **Templates** (17): [Test](../GitHub/templates/github-repo-scaffold/.github/workflows/ci/test.yml), [Lint](../GitHub/templates/github-repo-scaffold/.github/workflows/ci/lint.yml), [Feature Request](../GitHub/templates/github-repo-scaffold/.github/ISSUE_TEMPLATE/feature_request.yml)
  - _…and 14 more — browse `GitHub/`._

## GitHub Actions · 26 files

- **primer:** [Primer Github Actions](../GitHub Actions/notes/0000-primer-github-actions.md)

- **Notes** (5): [Test](../GitHub Actions/notes/test.yml), [CI](../GitHub Actions/notes/ci.yml), [Primer Already Exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)
  - _…and 2 more — browse `GitHub Actions/`._

- **Docs** (7): [Test](../GitHub Actions/docs/test.yml), [Github Actions OIDC With AWS](../GitHub Actions/docs/github-actions-oidc-with-aws.md), [Composite Actions Vs Reusable Workflows](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md)
  - _…and 4 more — browse `GitHub Actions/`._

- **Snippets** (1): [Trigger Workflow Dispatch Poll Status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)

- **Scripts** (4): [Self Hosted Runner Registration Cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh), [Manage Secrets Across Repos](../GitHub Actions/scripts/manage-secrets-across-repos.py), [Install Gh Actions Extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh)
  - _…and 1 more — browse `GitHub Actions/`._

- **Configs** (5): [Reusable Deployment Workflow Environment Gates Approval](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml), [Matrix Node Workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml), [Hello Workflow](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)
  - _…and 2 more — browse `GitHub Actions/`._

- **Dockerfiles** (1): [Custom Runner.dockerfile](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)

- **Templates** (3): [Reusable Deploy](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml), [Deploy Caller](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml), [Readme](../GitHub Actions/templates/multi-env-deploy/README.md)

## GitLab CI · 50 files

- **primer:** [Primer Gitlab CI CD](../GitLab/notes/0000-primer-gitlab-ci-cd.md)

- **Notes** (8): [Gitlab CI Runner Variables Artifacts](../GitLab/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md), [Gitlab CI Runner Variables Artifacts](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md), [Following Gitlab CI Quickstart](../GitLab/notes/2026-06-24-following-gitlab-ci-quickstart.md)
  - _…and 5 more — browse `GitLab CI/`._

- **Docs** (4): [Gitlab CI CD With Kubernetes](../GitLab/docs/gitlab-ci-cd-with-kubernetes.md), [Gitlab CI CD With Kubernetes](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md), [Gitlab CI CD Pipeline Library Patterns](../GitLab/docs/gitlab-ci-cd-pipeline-library-patterns.md)
  - _…and 1 more — browse `GitLab CI/`._

- **Snippets** (2): [Trigger Pipeline And Poll Jobs](../GitLab/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh), [Trigger Pipeline And Poll Jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)

- **Scripts** (10): [Gitlab Pipeline Helper](../GitLab/scripts/gitlab-pipeline-helper.py), [Gitlab Pipeline Helper](../GitLab CI/scripts/gitlab-pipeline-helper.py), [Dynamic Child Pipeline](../GitLab/scripts/dynamic-child-pipeline.sh)
  - _…and 7 more — browse `GitLab CI/`._

- **Configs** (8): [Minimal Gitlab CI Docker Build Deploy Kubernetes](../GitLab/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml), [Minimal Gitlab CI Docker Build Deploy Kubernetes](../GitLab CI/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml), [Multi Project Pipeline With Triggers](../GitLab/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml)
  - _…and 5 more — browse `GitLab CI/`._

- **Dockerfiles** (2): [Gitlab Runner Dind Kaniko.dockerfile](../GitLab/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile), [Gitlab Runner Dind Kaniko.dockerfile](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)

- **Templates** (16): [Test](../GitLab/templates/modular-pipeline-repo/.gitlab/ci/test.yml), [Test](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/test.yml), [Lib](../GitLab/templates/modular-pipeline-repo/.gitlab/ci/lib.yml)
  - _…and 13 more — browse `GitLab CI/`._

## Grafana · 10 files

- **primer:** [Primer Grafana](../graf/notes/0000-primer-grafana.md)

- **Notes** (4): [Grafana Quickstart Trip Ups](../graf/notes/2026-10-13-grafana-quickstart-trip-ups.md), [Grafana Quickstart Trip Ups](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md), [Explore Grafana UI](../graf/notes/2026-09-25-explore-grafana-ui.md)
  - _…and 1 more — browse `graf/`._

- **Docs** (3): [How I Wired Grafana Into Prometheus And Alertmanager For Unified Metrics And Alert Visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md), [Grafana Navigation Dedup](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [Grafana Coverage And Topics](../graf/docs/2026-09-25-grafana-coverage-and-topics.md)

- **Scripts** (2): [Build Multi Panel Service Dashboard Via HTTP API](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py), [Install Grafana With Docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)

- **Configs** (1): [Minimal Datasource Dashboard Provisioning](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)

## Grafana Cloud · 6 files

- **Notes** (2): [Grafana Cloud Quickstart Trip Ups](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md), [First Hosted Dashboard](../grafc/notes/2026-09-30-first-hosted-dashboard.md)

- **Snippets** (1): [First Dashboard Over HTTP](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)

- **Scripts** (1): [Create Stack And Send Metrics](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)

- **Configs** (2): [Prometheus Remote Write Grafana Cloud](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml), [Minimal Metrics Scrape Config](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml)

## HashiCorp Vault · 11 files

- **primer:** [Primer Vlt](../vlt/notes/0000-primer-vlt.md)

- **Notes** (3): [Vault Quickstart Trip Ups](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md), [Explore Vault CLI Secrets Policies](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md)
  - _…and 1 more — browse `vlt/`._

- **Docs** (2): [Vault Agent Secret Injection](../vlt/docs/vault-agent-secret-injection.md), [Vlt Readme Layout And Coverage](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md)

- **Scripts** (4): [Dynamic Database Credentials](../vlt/scripts/dynamic-database-credentials.py), [Write Read List Kv V2 Secret](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py), [Install Vault And First Secrets Engine](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh)
  - _…and 1 more — browse `vlt/`._

- **Configs** (2): [Vault Approle](../vlt/configs/vault-approle.hcl), [Minimal Read Only Policy Bound To Group](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl)

## Helm · 63 files

- **primer:** [Primer Helm](../Helm/notes/0000-primer-helm.md)

- **Notes** (3): [Values](../Helm/notes/values.yaml), [Helm Quickstart Tripups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md)
  - _…and 1 more — browse `Helm/`._

- **Docs** (6): [Values Management Approaches](../Helm/docs/values-management-approaches.md), [Helm Chart Testing Strategies](../Helm/docs/helm-chart-testing-strategies.md), [Chart Testing Ct Lint](../Helm/docs/chart-testing-ct-lint.md)
  - _…and 3 more — browse `Helm/`._

- **Snippets** (1): [Nginx Helm Chart Custom Values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)

- **Scripts** (5): [Validate Chart Values Across Environments](../Helm/scripts/validate-chart-values-across-environments.sh), [Helm Dep Validate](../Helm/scripts/helm-dep-validate.go), [Dummy Test](../Helm/scripts/dummy-test.sh)
  - _…and 2 more — browse `Helm/`._

- **Configs** (5): [Multi Cluster Gitops Values](../Helm/configs/multi-cluster-gitops-values.yaml), [Live Release Values](../Helm/configs/2026-09-02-live-release-values.yaml), [Production Deployment Values](../Helm/configs/2026-08-30-production-deployment-values.yaml)
  - _…and 2 more — browse `Helm/`._

- **Manifests** (15): [Values](../Helm/manifests/demo-chart/values.yaml), [Values](../Helm/manifests/redis-chart/values.yaml), [Values Staging](../Helm/manifests/demo-chart/values-staging.yaml)
  - _…and 12 more — browse `Helm/`._

- **Notebooks** (1): [Release Lifecycle Drill](../Helm/notebooks/release-lifecycle-drill.ipynb)

- **Templates** (27): [Values](../Helm/templates/microservice-chart/values.yaml), [Values](../Helm/templates/microservice-chart/charts/postgresql/values.yaml), [Values](../Helm/templates/helm-library-scaffold/values.yaml)
  - _…and 24 more — browse `Helm/`._

## Jenkins · 3 files

- **primer:** [Primer Jenkins](../jnk/notes/0000-primer-jenkins.md)

- **Notes** (2): [Install Jenkins And Run First CLI Command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md)
  - _…and 1 more — browse `jnk/`._

- **Scripts** (1): [Trigger First Jenkins Job Via CLI](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

## Kubernetes · 102 files

- **primer:** [Primer Kubernetes](../Kubernetes/notes/0000-primer-kubernetes.md)

- **Notes** (10): [My First Pod](../Kubernetes/notes/my-first-pod.yaml), [Deployment](../Kubernetes/notes/deployment.yaml), [Install Kubectl And Explore First Cluster](../k8s/notes/2026-10-27-install-kubectl-and-explore-first-cluster.md)
  - _…and 7 more — browse `Kubernetes/`._

- **Docs** (6): [Prometheus](../Kubernetes/docs/prometheus.yml), [Kubernetes Service Mesh Comparison](../k8s/docs/kubernetes-service-mesh-comparison.md), [Integrating Kubernetes With Prometheus](../Kubernetes/docs/integrating-kubernetes-with-prometheus.md)
  - _…and 3 more — browse `Kubernetes/`._

- **Snippets** (2): [Pod Troubleshoot Shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh), [First Pod And Service With Kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh)

- **Scripts** (4): [Rollout Status And Pod Readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh), [Pod Lifecycle](../Kubernetes/scripts/pod-lifecycle.sh), [Install Kind And First Cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
  - _…and 1 more — browse `Kubernetes/`._

- **Configs** (1): [Deployment Service Go App With Probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)

- **Manifests** (7): [Stateless App](../Kubernetes/manifests/stateless-app.yaml), [Production Deployment Hpa Pdb Networkpolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml), [Go Service Deployment With Probes Hpa](../Kubernetes/manifests/go-service-deployment-with-probes-hpa.yaml)
  - _…and 4 more — browse `Kubernetes/`._

- **Notebooks** (2): [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb), [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)

- **Templates** (70): [Zz Generated.deepcopy](../Kubernetes/templates/kubebuilder-operator-scaffold/api/v1alpha1/zz_generated.deepcopy.go), [Webapp Types](../Kubernetes/templates/kubebuilder-operator-scaffold/api/v1alpha1/webapp_types.go), [Webapp Controller](../Kubernetes/templates/kubebuilder-operator-scaffold/controllers/webapp_controller.go)
  - _…and 67 more — browse `Kubernetes/`._

## OpenTelemetry · 10 files

- **primer:** [Primer Opentelemetry](../otel/notes/0000-primer-opentelemetry.md)

- **Notes** (2): [Quickstart Trip Ups](../otel/notes/2026-09-30-quickstart-trip-ups.md)
  - _…and 1 more — browse `otel/`._

- **Docs** (2): [Context Propagation W3c Vs B3](../otel/docs/context-propagation-w3c-vs-b3.md), [Opentelemetry Readme Coverage](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md)

- **Snippets** (2): [Instrumented HTTP Server](../otel/snippets/2026-09-30-instrumented-http-server.go), [First Trace Span](../otel/snippets/2026-09-26-first-trace-span.py)

- **Scripts** (2): [Custom Span Processor Resource Detector](../otel/scripts/custom-span-processor-resource-detector.py), [Install Collector And Run Otlp Pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh)

- **Configs** (2): [Collector Otlp Real Pipeline](../otel/configs/collector-otlp-real-pipeline.yaml), [Collector Otlp Export](../otel/configs/2026-09-30-collector-otlp-export.yaml)

## OpenTofu · 19 files

- **primer:** [Primer Opentofu](../OpenTofu/notes/0000-primer-opentofu.md)

- **Notes** (2): [Opentofu Quickstart Trip Ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md)
  - _…and 1 more — browse `OpenTofu/`._

- **Docs** (4): [Remote State S3 Backend Workspace Isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md), [Opentofu Provider Development Custom Provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md), [Backup](../OpenTofu/docs/backup.json)
  - _…and 1 more — browse `OpenTofu/`._

- **Scripts** (3): [Tofu Plan Apply With Policy Checks](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh), [S3 Dynamodb Remote State Bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh), [Install Opentofu And Verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)

- **Configs** (2): [Minimal Local Backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl), [Minimal Local Config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)

- **Notebooks** (2): [Comparing Opentofu And Terraform State Management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb), [Comparing Opentofu And Terraform AWS Provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)

- **Templates** (6): [Versions](../OpenTofu/templates/aws-reusable-module/versions.tf), [Variables](../OpenTofu/templates/aws-reusable-module/variables.tf), [Outputs](../OpenTofu/templates/aws-reusable-module/outputs.tf)
  - _…and 3 more — browse `OpenTofu/`._

## Prometheus · 40 files

- **primer:** [Primer Prometheus](../Prometheus/notes/0000-primer-prometheus.md)

- **Notes** (2): [Prometheus Getting Started Trip Ups](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md)
  - _…and 1 more — browse `Prometheus/`._

- **Docs** (4): [Prometheus Recording Rules And Alert Reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md), [Prometheus Kubernetes Integration](../Prometheus/docs/prometheus-kubernetes-integration.md), [Integrating Prometheus With Related Tools](../pro/docs/integrating-prometheus-with-related-tools.md)
  - _…and 1 more — browse `Prometheus/`._

- **Snippets** (1): [Promql Target Health Check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)

- **Scripts** (6): [Custom Metrics Service](../Prometheus/scripts/custom-metrics-service.py), [Custom App Metrics Collector](../Prometheus/scripts/custom-app-metrics-collector.go), [Custom App Exporter](../Prometheus/scripts/custom-app-exporter.py)
  - _…and 3 more — browse `Prometheus/`._

- **Configs** (5): [Recording Vs Alerting Rules](../Prometheus/configs/recording-vs-alerting-rules.yaml), [Prometheus Scrape Config And Remote Write Tuning](../Prometheus/configs/prometheus-scrape-config-and-remote-write-tuning.yaml), [Production Prometheus](../Prometheus/configs/production-prometheus.yml)
  - _…and 2 more — browse `Prometheus/`._

- **Manifests** (3): [Prometheus Grafana Stack Deployment](../pro/manifests/prometheus-grafana-stack-deployment.yaml), [Production Prometheus Ha](../pro/manifests/production-prometheus-ha.yaml), [Production Prometheus Ha](../Prometheus/manifests/production-prometheus-ha.yaml)

- **Notebooks** (1): [Querying Prometheus With Promql Step Through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)

- **Templates** (18): [Validate Rules](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-rules.sh), [Validate Config](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-config.sh), [System Overview](../Prometheus/templates/prometheus-alertmanager-grafana-stack/grafana/dashboards/system-overview.json)
  - _…and 15 more — browse `Prometheus/`._

## Pulumi · 25 files

- **primer:** [Primer Plm](../plm/notes/0000-primer-plm.md)

- **Notes** (2): [Pulumi Quickstart Trip Ups](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md)
  - _…and 1 more — browse `Pulumi/`._

- **Docs** (2): [Multi Stack Project Structure](../plm/docs/multi-stack-project-structure.md), [Plm Readme Layout And Coverage](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md)

- **Snippets** (1): [Minimal Bucket With Pulumi Python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)

- **Scripts** (4): [Provision S3 Bucket With Pulumi Ts](../plm/scripts/provision-s3-bucket-with-pulumi-ts.ts), [Network Component VPC Subnets](../plm/scripts/network-component-vpc-subnets.py), [Create S3 Bucket With Pulumi](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py)
  - _…and 1 more — browse `Pulumi/`._

- **Configs** (3): [Pulumi Yaml And Stack Config Reference](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml), [Minimal Project And Stack Config](../plm/configs/minimal-project-and-stack-config.yaml), [Minimal Pulumi Project And Stack Config](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml)

- **Templates** (13): [Tsconfig](../plm/templates/pulumi-typescript-project-scaffold/tsconfig.json), [Requirements](../Pulumi/templates/pulumi-python-project-scaffold/requirements.txt), [Package](../plm/templates/pulumi-typescript-project-scaffold/package.json)
  - _…and 10 more — browse `Pulumi/`._

## Terraform · 74 files

- **primer:** [Primer Terraform](../Terraform/notes/0000-primer-terraform.md)

- **Notes** (6): [Install Terraform And First Local File](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md), [Terraform State Management Tutorial](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md), [Following Provider Tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md)
  - _…and 3 more — browse `Terraform/`._

- **Docs** (8): [Wiring Terraform Outputs Into Dependent Modules](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md), [Terraform Vs Opentofu Migration Guide](../tf/docs/terraform-vs-opentofu-migration-guide.md), [Terraform Testing Strategies Tflint Terratest](../Terraform/docs/terraform-testing-strategies-tflint-terratest.md)
  - _…and 5 more — browse `Terraform/`._

- **Snippets** (3): [Reusable Module For Each Validation](../Terraform/snippets/reusable-module-for-each-validation.hcl), [Terraform CLI Exploration](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [Scaffold S3 Bucket Module Remote State](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)

- **Scripts** (4): [Validate Provider Schema](../Terraform/scripts/validate-provider-schema.go), [Install And Init](../Terraform/scripts/install-and-init.sh), [Generate Ansible Inventory From Terraform State](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py)
  - _…and 1 more — browse `Terraform/`._

- **Configs** (10): [Variables](../Terraform/configs/reusable-s3-module/variables.tf), [Terraform Module Version Pinning And Migration Plan](../Terraform/configs/terraform-module-version-pinning-and-migration-plan.hcl), [Provider Schema Contract](../Terraform/configs/provider-schema-contract.json)
  - _…and 7 more — browse `Terraform/`._

- **Manifests** (2): [Simple EC2 App](../Terraform/manifests/simple-ec2-app.tf), [Reusable VPC Module](../Terraform/manifests/reusable-vpc-module.hcl)

- **Notebooks** (2): [Comparing Terraform Vs Opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb), [Comparing For Each Vs Count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)

- **Templates** (39): [Versions](../Terraform/templates/terraform-module-registry-publishing/versions.tf), [Versions](../tf/templates/multi-environment-terraform-project-scaffold/versions.tf), [Variables](../Terraform/templates/terraform-module-registry-publishing/variables.tf)
  - _…and 36 more — browse `Terraform/`._

## Trivy · 17 files

- **primer:** [Primer Trivy](../Trivy/notes/0000-primer-trivy.md)

- **Notes** (5): [Trivy Quickstart Follow Along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md), [Trivy Quickstart Trip Ups](../Trivy/notes/2026-08-29-trivy-quickstart-trip-ups.md), [Trivy Quickstart Trip Ups](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)
  - _…and 2 more — browse `Trivy/`._

- **Docs** (2): [Trivy SBOM Generation And Vulnerability Reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md), [Choosing Scan Modes And Pipeline Wiring](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md)

- **Snippets** (2): [Scan Image Fail Critical Cves](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py), [Trivy Python Wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)

- **Scripts** (5): [Trivy Policy As Code OPA Rego](../Trivy/scripts/trivy-policy-as-code-opa-rego.sh), [Trivy Fs Repo Scan Workflow](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh), [Scan Images From File Consolidated Sarif](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)
  - _…and 2 more — browse `Trivy/`._

- **Configs** (3): [Trivy Operator Admission Control](../Trivy/configs/trivy-operator-admission-control.yaml), [Trivy Config With Scan Policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [Trivy Config](../Trivy/configs/2026-08-12-trivy-config.yaml)

  AWS: 25 files
  Ansible: 114 files
  ArgoCD: 27 files
  Azure: 28 files
  Docker: 58 files
  Flux CD: 8 files
  GCP: 15 files
  Git: 85 files
  GitHub: 56 files
  GitHub Actions: 26 files
  GitLab CI: 50 files
  Grafana: 10 files
  Grafana Cloud: 6 files
  HashiCorp Vault: 11 files
  Helm: 63 files
  Jenkins: 3 files
  Kubernetes: 102 files
  OpenTelemetry: 10 files
  OpenTofu: 19 files
  Prometheus: 40 files
  Pulumi: 25 files
  Terraform: 74 files
  Trivy: 17 files
