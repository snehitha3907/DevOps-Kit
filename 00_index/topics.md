# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible · 112 files

- **primer:** [Ansible](../Ansible/notes/0000-primer-ansible.md)
- **Notes** (10):
  - [All](../Ansible/notes/group_vars/all.yml)
  - [Ansible](../Ansible/notes/ansible.cfg)
  - [Ansible Quickstart Trip Ups](../Ansible/notes/2026-09-04-ansible-quickstart-trip-ups.md)
  - _…and 7 more — browse `Ansible/`._
- **Docs** (7):
  - [Integrating Ansible With Network Devices](../Ansible/docs/integrating-ansible-with-network-devices.md)
  - [Integrated Ansible Docker Ci Pipeline Testing](../Ansible/docs/integrated-ansible-docker-ci-pipeline-testing.md)
  - [Ansible Upgrade Playbook And Preflight Checks](../Ansible/docs/ansible-upgrade-playbook-and-preflight-checks.md)
  - _…and 4 more — browse `Ansible/`._
- **Snippets** (2):
  - [Nginx Playbook](../Ansible/snippets/nginx-playbook.yaml)
  - [Lint Ansible Playbook](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py)
- **Scripts** (4):
  - [Scan Ansible Antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py)
  - [Run First Playbook](../Ansible/scripts/run-first-playbook.sh)
  - [Install And First Adhoc](../Ansible/scripts/install-and-first-adhoc.sh)
  - _…and 1 more — browse `Ansible/`._
- **Configs** (8):
  - [Nginx Webserver](../Ansible/configs/nginx-webserver.yaml)
  - [Docker Python Setup](../Ansible/configs/docker-python-setup.yaml)
  - [Docker Lifecycle Playbook](../Ansible/configs/docker-lifecycle-playbook.yml)
  - _…and 5 more — browse `Ansible/`._
- **Manifests** (10):
  - [Playbook Migration](../ans/manifests/playbook-migration.yaml)
  - [Main](../Ansible/manifests/roles/webserver/tasks/main.yaml)
  - [Main](../Ansible/manifests/roles/webserver/handlers/main.yaml)
  - _…and 7 more — browse `Ansible/`._
- **Notebooks** (2):
  - [Comparing Execution Patterns Block Rescue Serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb)
  - [Ansible Variable Precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb)
- **Dockerfiles** (1):
  - [Ansible Control Node](../Ansible/dockerfiles/ansible-control-node.Dockerfile)
- **Templates** (68):
  - [Main](../Ansible/templates/production-ansible-project/roles/webserver/vars/main.yml)
  - [Site Conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/site.conf.j2)
  - [Nginx Conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/nginx.conf.j2)
  - _…and 65 more — browse `Ansible/`._

## ArgoCD · 27 files

- **primer:** [Argocd](../ArgoCD/notes/0000-primer-argocd.md)
- **Notes** (3):
  - [Install](../ArgoCD/notes/install.yaml)
  - [Argocd Quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md)
  - [Argocd](../ArgoCD/notes/0000-primer-argocd.md)
- **Docs** (2):
  - [How I Wired Argocd With Github For Gitops Deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md)
  - [Argocd Vault External Secrets](../ArgoCD/docs/argocd-vault-external-secrets.md)
- **Snippets** (1):
  - [Sync App And Verify Health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)
- **Scripts** (3):
  - [Build Argocd Application From Scratch](../ArgoCD/scripts/build-argocd-application-from-scratch.sh)
  - [Argocd Application Helper](../ArgoCD/scripts/argocd-application-helper.py)
  - [Install Argocd And Access Ui](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)
- **Configs** (3):
  - [Guestbook Applicationset Multi Cluster](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml)
  - [Guestbook Applicationset](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml)
  - [First Application Manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- **Manifests** (2):
  - [Multi Cluster Fleet Applicationset](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml)
  - [Deployment](../ArgoCD/manifests/guestbook/deployment.yaml)
- **Templates** (13):
  - [Values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/values.yaml)
  - [Kustomization](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/kustomization.yaml)
  - [Values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/prod/values.yaml)
  - _…and 10 more — browse `ArgoCD/`._

## AWS · 25 files

- **primer:** [Aws](../AWS/notes/0000-primer-aws.md)
- **Notes** (2):
  - [Primer Already Exists](../AWS/notes/2026-07-13-primer-already-exists.md)
  - [Aws](../AWS/notes/0000-primer-aws.md)
- **Docs** (2):
  - [Iam Policy Least Privilege Walkthrough](../AWS/docs/iam-policy-least-privilege-walkthrough.md)
  - [Iam Cross Account Roles Least Privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md)
- **Snippets** (3):
  - [Create S3 Bucket And Upload Object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py)
  - [List And Tag Ec2 Instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh)
  - [List Ec2 And S3](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)
- **Scripts** (7):
  - [Vpc With Private Endpoints](../AWS/scripts/vpc-with-private-endpoints.py)
  - [Build Vpc Ec2 Rds Stack](../AWS/scripts/build-vpc-ec2-rds-stack.py)
  - [Deploy Static Website To S3](../AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh)
  - _…and 4 more — browse `AWS/`._
- **Configs** (3):
  - [Ecs Service Deployment Blue Green](../AWS/configs/ecs-service-deployment-blue-green.yaml)
  - [Minimal Aws Config](../AWS/configs/2026-07-13-minimal-aws-config.ini)
  - [Minimal Aws Config](../AWS/configs/2026-07-12-minimal-aws-config.ini)
- **Notebooks** (1):
  - [Comparing Deployment Approaches Boto3 Cloudformation Cdk](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)
- **Templates** (7):
  - [Variables](../aws/templates/aws-control-tower-landing-zone/variables.tf)
  - [Outputs](../aws/templates/aws-control-tower-landing-zone/outputs.tf)
  - [Main](../aws/templates/aws-control-tower-landing-zone/main.tf)
  - _…and 4 more — browse `AWS/`._

## Azure · 28 files

- **primer:** [Azure](../Azure/notes/0000-primer-azure.md)
- **Notes** (4):
  - [First Login And Resource List](../Azure/notes/2026-09-18-first-login-and-resource-list.md)
  - [Azure Quickstart Trip Ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md)
  - [Azure Cli Quickstart Trip Ups](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md)
  - _…and 1 more — browse `Azure/`._
- **Docs** (2):
  - [Comparing Azure Cli Bicep Python Sdk](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md)
  - [Azure Devops Pipeline Bicep Integration](../Azure/docs/azure-devops-pipeline-bicep-integration.md)
- **Snippets** (3):
  - [Create Vnet Nsg And Linux Vm](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh)
  - [Create Resource Group And List Regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh)
  - [Create Resource Group And List Regions](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)
- **Scripts** (5):
  - [Resource Group Cleanup](../Azure/scripts/resource-group-cleanup.sh)
  - [Cleanup Resource Groups](../Azure/scripts/cleanup-resource-groups.sh)
  - [Azure Vm Scale Set Autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
  - _…and 2 more — browse `Azure/`._
- **Configs** (2):
  - [Azure Key Vault Access Policy](../az/configs/azure-key-vault-access-policy.json)
  - [Container Apps Microservices](../Azure/configs/container-apps-microservices.yaml)
- **Manifests** (2):
  - [Container Apps Multi Service Deployment](../az/manifests/container-apps-multi-service-deployment.yaml)
  - [Production Aks Cluster](../Azure/manifests/production-aks-cluster.bicep)
- **Templates** (10):
  - [Aks Cluster](../Azure/templates/aks-cluster-with-addons/modules/aks-cluster.bicep)
  - [Policy](../Azure/templates/aks-cluster-with-addons/modules/addons/policy.bicep)
  - [Network Policy](../Azure/templates/aks-cluster-with-addons/modules/addons/network-policy.bicep)
  - _…and 7 more — browse `Azure/`._

## Docker · 58 files

- **primer:** [Docker](../Docker/notes/0000-primer-docker.md)
- **Notes** (6):
  - [Compose](../Docker/notes/compose.yaml)
  - [Docker Tutorial Tripups](../Docker/notes/2026-08-12-docker-tutorial-tripups.md)
  - [Docker Compose Quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
  - _…and 3 more — browse `Docker/`._
- **Docs** (11):
  - [Docker Production Hardening Runbook](../docker/docs/docker-production-hardening-runbook.md)
  - [Package](../Docker/docs/package.json)
  - [Integrating Docker With Kubernetes](../Docker/docs/integrating-docker-with-kubernetes.md)
  - _…and 8 more — browse `Docker/`._
- **Snippets** (2):
  - [Analyze Image Layers](../Docker/snippets/analyze-image-layers.py)
  - [Build Run And Cleanup](../Docker/snippets/2026-08-12-build-run-and-cleanup.py)
- **Scripts** (5):
  - [Multi Stage Go Dockerfile](../Docker/scripts/multi-stage-go-dockerfile.sh)
  - [Install And Run First Container](../Docker/scripts/install-and-run-first-container.sh)
  - [Install And Run Container](../Docker/scripts/install-and-run-container.sh)
  - _…and 2 more — browse `Docker/`._
- **Configs** (1):
  - [Multi Service App](../Docker/configs/multi-service-app.yaml)
- **Manifests** (9):
  - [Production Docker Deployment With Ha](../docker/manifests/production-docker-deployment-with-ha.yaml)
  - [Docker Compose Multi Stage](../docker/manifests/docker-compose-multi-stage.yaml)
  - [Prometheus](../Docker/manifests/prometheus.yml)
  - _…and 6 more — browse `Docker/`._
- **Notebooks** (3):
  - [Comparing Docker Networking Drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
  - [Comparing Docker Build Strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb)
  - [Comparing Compose Swarm Kubernetes Local Orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb)
- **Dockerfiles** (9):
  - [Tried Building First Image](../Docker/dockerfiles/tried-building-first-image.Dockerfile)
  - [Simple Go Server](../Docker/dockerfiles/simple-go-server.Dockerfile)
  - [Production Ready Go Http Server](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
  - _…and 6 more — browse `Docker/`._
- **Templates** (12):
  - [Compose](../Docker/templates/multi-service-compose-with-healthchecks/compose.yaml)
  - [App](../Docker/templates/multi-service-compose-with-healthchecks/app/app.py)
  - [Dockerfile](../Docker/templates/multi-service-compose-with-healthchecks/app/Dockerfile)
  - _…and 9 more — browse `Docker/`._

## FluxCD · 8 files

- **Notes** (2):
  - [Flux Quickstart Trip Ups](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md)
  - [Explore Flux Cli Command Surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)
- **Docs** (2):
  - [How I Wired Flux Cd With Github For Gitops Deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md)
  - [Flux Cd Readme Coverage And Topics Update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md)
- **Scripts** (2):
  - [Bootstrap Flux On Kind](../FluxCD/scripts/bootstrap-flux-on-kind.sh)
  - [Install Flux Cli And Run Flux Check Pre](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- **Configs** (2):
  - [Helmrelease Image Automation](../FluxCD/configs/helmrelease-image-automation.yaml)
  - [Minimal Gitrepository And Kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)

## GCP · 15 files

- **primer:** [Gcp](../GCP/notes/0000-primer-gcp.md)
- **Notes** (2):
  - [Gcloud Sdk Quickstart Trip Ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md)
  - [Gcp](../GCP/notes/0000-primer-gcp.md)
- **Docs** (1):
  - [Gcp Readme Coverage And Topics](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)
- **Snippets** (2):
  - [List Compute And Gcs With Gcloud](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh)
  - [List Compute And Gcs With Gcloud](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)
- **Scripts** (6):
  - [Cloud Run Terraform From Scratch](../gcp/scripts/cloud-run-terraform-from-scratch.py)
  - [Create Gcs Bucket And Setup Iam](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh)
  - [Build Cloud Run Service Terraform](../GCP/scripts/build-cloud-run-service-terraform.py)
  - _…and 3 more — browse `GCP/`._
- **Configs** (4):
  - [Gcloud Iam Config](../gcp/configs/gcloud-iam-config.yaml)
  - [Service Account And Iam Config](../GCP/configs/service-account-and-iam-config.yaml)
  - [Instance Template With Startup Script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml)
  - _…and 1 more — browse `GCP/`._

## Git · 85 files

- **primer:** [Git](../Git/notes/0000-primer-git.md)
- **Notes** (6):
  - [Readme](../Git/notes/README.md)
  - [Git Branching Tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md)
  - [Git Branching Tutorial](../Git/notes/2026-06-07-git-branching-tutorial.md)
  - _…and 3 more — browse `Git/`._
- **Docs** (15):
  - [Git Production Rollback And Recovery Runbook](../git/docs/git-production-rollback-and-recovery-runbook.md)
  - [Worktree Workflows Parallel Branches](../Git/docs/worktree-workflows-parallel-branches.md)
  - [Wiring Git Hooks Into Pre Commit Workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md)
  - _…and 12 more — browse `Git/`._
- **Snippets** (1):
  - [First Commit](../Git/snippets/first-commit.sh)
- **Scripts** (14):
  - [Pre Receive Hook Integrity And Quota Enforcement](../git/scripts/pre-receive-hook-integrity-and-quota-enforcement.sh)
  - [Squash Wip Commits](../Git/scripts/squash-wip-commits.sh)
  - [Setup Gitattributes Filters And Merge](../Git/scripts/setup-gitattributes-filters-and-merge.sh)
  - _…and 11 more — browse `Git/`._
- **Notebooks** (3):
  - [Merge Rebase Squash Comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb)
  - [Merge Rebase Squash Comparison](../Git/notebooks/merge-rebase-squash-comparison.ipynb)
  - [Comparing Git Merge Strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb)
- **Templates** (46):
  - [Setup Workflow](../Git/templates/git-workflow-automation/scripts/setup-workflow.sh)
  - [Semantic Version](../Git/templates/git-workflow-automation/scripts/semantic-version.sh)
  - [Install Hooks](../Git/templates/git-workflow-automation/scripts/install-hooks.sh)
  - _…and 43 more — browse `Git/`._

## GitHub · 56 files

- **primer:** [Github](../GitHub/notes/0000-primer-github.md)
- **Notes** (11):
  - [Gh Cli Quickstart Trip Ups](../GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md)
  - [Primer Already Exists](../GitHub/notes/2026-06-19-primer-already-exists.md)
  - [Hello World Guide And Github Flow](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md)
  - _…and 8 more — browse `GitHub/`._
- **Docs** (7):
  - [Release Automation Tags Milestones And Releases End To End](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md)
  - [Protection](../GitHub/docs/protection.json)
  - [How I Wired Deploy Keys Vs Fine Grained Pats For Cicd](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)
  - _…and 4 more — browse `GitHub/`._
- **Snippets** (3):
  - [Open Pr And Wait For Ci](../GitHub/snippets/open-pr-and-wait-for-ci.sh)
  - [List Repos With Python](../GitHub/snippets/list-repos-with-python.py)
  - [Github Issues Api](../GitHub/snippets/github-issues-api.py)
- **Scripts** (7):
  - [Tried Commenting On First Issue](../GitHub/scripts/tried-commenting-on-first-issue.sh)
  - [Tried Auth And Profile](../GitHub/scripts/tried-auth-and-profile.sh)
  - [Provision Repo With Api](../GitHub/scripts/provision-repo-with-api.py)
  - _…and 4 more — browse `GitHub/`._
- **Configs** (7):
  - [Issue Templates And Labels](../GitHub/configs/issue-templates-and-labels.yaml)
  - [Stale](../GitHub/configs/dot-github-repository/stale.yml)
  - [Labels](../GitHub/configs/dot-github-repository/labels.yaml)
  - _…and 4 more — browse `GitHub/`._
- **Manifests** (1):
  - [Github Environments Deployment Protection](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **Notebooks** (2):
  - [Comparing Api Approaches Release Automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb)
  - [Analyzing Github Actions Usage Across Org Repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb)
- **Dockerfiles** (1):
  - [Self Hosted Runner](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)
- **Templates** (17):
  - [Security](../GitHub/templates/github-security-compliance/SECURITY.md)
  - [Readme](../GitHub/templates/github-security-compliance/README.md)
  - [Compliance](../GitHub/templates/github-security-compliance/COMPLIANCE.md)
  - _…and 14 more — browse `GitHub/`._

## GitHub Actions · 26 files

- **primer:** [Github Actions](../GitHub Actions/notes/0000-primer-github-actions.md)
- **Notes** (5):
  - [Test](../GitHub Actions/notes/test.yml)
  - [Ci](../GitHub Actions/notes/ci.yml)
  - [Primer Already Exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)
  - _…and 2 more — browse `GitHub Actions/`._
- **Docs** (7):
  - [Test](../GitHub Actions/docs/test.yml)
  - [Github Actions Oidc With Aws](../GitHub Actions/docs/github-actions-oidc-with-aws.md)
  - [Composite Actions Vs Reusable Workflows](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md)
  - _…and 4 more — browse `GitHub Actions/`._
- **Snippets** (1):
  - [Trigger Workflow Dispatch Poll Status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)
- **Scripts** (4):
  - [Self Hosted Runner Registration Cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh)
  - [Manage Secrets Across Repos](../GitHub Actions/scripts/manage-secrets-across-repos.py)
  - [Install Gh Actions Extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh)
  - _…and 1 more — browse `GitHub Actions/`._
- **Configs** (5):
  - [Reusable Deployment Workflow Environment Gates Approval](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml)
  - [Matrix Node Workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml)
  - [Hello Workflow](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)
  - _…and 2 more — browse `GitHub Actions/`._
- **Dockerfiles** (1):
  - [Custom Runner](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)
- **Templates** (3):
  - [Reusable Deploy](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml)
  - [Deploy Caller](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml)
  - [Readme](../GitHub Actions/templates/multi-env-deploy/README.md)

## GitLab CI · 25 files

- **primer:** [Gitlab Ci Cd](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **Notes** (4):
  - [Gitlab Ci Runner Variables Artifacts](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md)
  - [Following Gitlab Ci Quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md)
  - [Gitlab Ci Cd](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
  - _…and 1 more — browse `GitLab CI/`._
- **Docs** (2):
  - [Gitlab Ci Cd With Kubernetes](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md)
  - [Gitlab Ci Cd Pipeline Library Patterns](../GitLab CI/docs/gitlab-ci-cd-pipeline-library-patterns.md)
- **Snippets** (1):
  - [Trigger Pipeline And Poll Jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- **Scripts** (5):
  - [Gitlab Pipeline Helper](../GitLab CI/scripts/gitlab-pipeline-helper.py)
  - [Dynamic Child Pipeline](../GitLab CI/scripts/dynamic-child-pipeline.sh)
  - [Local Ci Pipeline Validator](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh)
  - _…and 2 more — browse `GitLab CI/`._
- **Configs** (4):
  - [Minimal Gitlab Ci Docker Build Deploy Kubernetes](../GitLab CI/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml)
  - [Multi Project Pipeline With Triggers](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml)
  - [Minimal Pipeline Stages Cache Artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
  - _…and 1 more — browse `GitLab CI/`._
- **Dockerfiles** (1):
  - [Gitlab Runner Dind Kaniko](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)
- **Templates** (8):
  - [Kind Runner Bootstrap](../GitLab CI/templates/modular-pipeline-repo/scripts/kind-runner-bootstrap.sh)
  - [Readme](../GitLab CI/templates/modular-pipeline-repo/README.md)
  - [Test](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/test.yml)
  - _…and 5 more — browse `GitLab CI/`._

## Grafana · 10 files

- **primer:** [Grafana](../graf/notes/0000-primer-grafana.md)
- **Notes** (4):
  - [Grafana Quickstart Trip Ups](../graf/notes/2026-10-13-grafana-quickstart-trip-ups.md)
  - [Grafana Quickstart Trip Ups](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md)
  - [Explore Grafana Ui](../graf/notes/2026-09-25-explore-grafana-ui.md)
  - _…and 1 more — browse `graf/`._
- **Docs** (3):
  - [How I Wired Grafana Into Prometheus And Alertmanager For Unified Metrics And Alert Visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md)
  - [Grafana Navigation Dedup](../graf/docs/2026-09-25-grafana-navigation-dedup.md)
  - [Grafana Coverage And Topics](../graf/docs/2026-09-25-grafana-coverage-and-topics.md)
- **Scripts** (2):
  - [Build Multi Panel Service Dashboard Via Http Api](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py)
  - [Install Grafana With Docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)
- **Configs** (1):
  - [Minimal Datasource Dashboard Provisioning](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)

## Grafana Cloud · 6 files

- **Notes** (2):
  - [Grafana Cloud Quickstart Trip Ups](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md)
  - [First Hosted Dashboard](../grafc/notes/2026-09-30-first-hosted-dashboard.md)
- **Snippets** (1):
  - [First Dashboard Over Http](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)
- **Scripts** (1):
  - [Create Stack And Send Metrics](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)
- **Configs** (2):
  - [Prometheus Remote Write Grafana Cloud](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml)
  - [Minimal Metrics Scrape Config](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml)

## HashiCorp Vault · 11 files

- **primer:** [Vlt](../vlt/notes/0000-primer-vlt.md)
- **Notes** (3):
  - [Vault Quickstart Trip Ups](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md)
  - [Explore Vault Cli Secrets Policies](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md)
  - [Vlt](../vlt/notes/0000-primer-vlt.md)
- **Docs** (2):
  - [Vault Agent Secret Injection](../vlt/docs/vault-agent-secret-injection.md)
  - [Vlt Readme Layout And Coverage](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md)
- **Scripts** (4):
  - [Dynamic Database Credentials](../vlt/scripts/dynamic-database-credentials.py)
  - [Write Read List Kv V2 Secret](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py)
  - [Install Vault And First Secrets Engine](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh)
  - _…and 1 more — browse `vlt/`._
- **Configs** (2):
  - [Vault Approle](../vlt/configs/vault-approle.hcl)
  - [Minimal Read Only Policy Bound To Group](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl)

## Helm · 63 files

- **primer:** [Helm](../Helm/notes/0000-primer-helm.md)
- **Notes** (3):
  - [Values](../Helm/notes/values.yaml)
  - [Helm Quickstart Tripups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md)
  - [Helm](../Helm/notes/0000-primer-helm.md)
- **Docs** (6):
  - [Values Management Approaches](../Helm/docs/values-management-approaches.md)
  - [Helm Chart Testing Strategies](../Helm/docs/helm-chart-testing-strategies.md)
  - [Chart Testing Ct Lint](../Helm/docs/chart-testing-ct-lint.md)
  - _…and 3 more — browse `Helm/`._
- **Snippets** (1):
  - [Nginx Helm Chart Custom Values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **Scripts** (5):
  - [Validate Chart Values Across Environments](../Helm/scripts/validate-chart-values-across-environments.sh)
  - [Helm Dep Validate](../Helm/scripts/helm-dep-validate.go)
  - [Dummy Test](../Helm/scripts/dummy-test.sh)
  - _…and 2 more — browse `Helm/`._
- **Configs** (5):
  - [Multi Cluster Gitops Values](../Helm/configs/multi-cluster-gitops-values.yaml)
  - [Live Release Values](../Helm/configs/2026-09-02-live-release-values.yaml)
  - [Production Deployment Values](../Helm/configs/2026-08-30-production-deployment-values.yaml)
  - _…and 2 more — browse `Helm/`._
- **Manifests** (15):
  - [Values](../Helm/manifests/redis-chart/values.yaml)
  - [Service](../Helm/manifests/redis-chart/templates/service.yaml)
  - [Deployment](../Helm/manifests/redis-chart/templates/deployment.yaml)
  - _…and 12 more — browse `Helm/`._
- **Notebooks** (1):
  - [Release Lifecycle Drill](../Helm/notebooks/release-lifecycle-drill.ipynb)
- **Templates** (27):
  - [Values](../Helm/templates/microservice-chart/values.yaml)
  - [Values Schema](../Helm/templates/microservice-chart/values.schema.json)
  - [Test Connection](../Helm/templates/microservice-chart/templates/tests/test-connection.yaml)
  - _…and 24 more — browse `Helm/`._

## Jenkins · 3 files

- **primer:** [Jenkins](../jnk/notes/0000-primer-jenkins.md)
- **Notes** (2):
  - [Install Jenkins And Run First Cli Command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md)
  - [Jenkins](../jnk/notes/0000-primer-jenkins.md)
- **Scripts** (1):
  - [Trigger First Jenkins Job Via Cli](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

## Kubernetes · 102 files

- **primer:** [Kubernetes](../Kubernetes/notes/0000-primer-kubernetes.md)
- **Notes** (10):
  - [Install Kubectl And Explore First Cluster](../k8s/notes/2026-10-27-install-kubectl-and-explore-first-cluster.md)
  - [My First Pod](../Kubernetes/notes/my-first-pod.yaml)
  - [Deployment](../Kubernetes/notes/deployment.yaml)
  - _…and 7 more — browse `Kubernetes/`._
- **Docs** (6):
  - [Kubernetes Service Mesh Comparison](../k8s/docs/kubernetes-service-mesh-comparison.md)
  - [Prometheus](../Kubernetes/docs/prometheus.yml)
  - [Integrating Kubernetes With Prometheus](../Kubernetes/docs/integrating-kubernetes-with-prometheus.md)
  - _…and 3 more — browse `Kubernetes/`._
- **Snippets** (2):
  - [Pod Troubleshoot Shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
  - [First Pod And Service With Kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh)
- **Scripts** (4):
  - [Rollout Status And Pod Readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh)
  - [Pod Lifecycle](../Kubernetes/scripts/pod-lifecycle.sh)
  - [Install Kind And First Cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
  - _…and 1 more — browse `Kubernetes/`._
- **Configs** (1):
  - [Deployment Service Go App With Probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)
- **Manifests** (7):
  - [Deploy My First Nginx Pod With Kubectl](../k8s/manifests/2026-10-27-deploy-my-first-nginx-pod-with-kubectl.yaml)
  - [Stateless App](../Kubernetes/manifests/stateless-app.yaml)
  - [Production Deployment Hpa Pdb Networkpolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml)
  - _…and 4 more — browse `Kubernetes/`._
- **Notebooks** (2):
  - [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb)
  - [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)
- **Templates** (70):
  - [Security Falco Kyverno](../k8s/templates/workload-clusters/cluster-resource-sets/security-falco-kyverno.yaml)
  - [Monitoring Prometheus](../k8s/templates/workload-clusters/cluster-resource-sets/monitoring-prometheus.yaml)
  - [Logging Loki](../k8s/templates/workload-clusters/cluster-resource-sets/logging-loki.yaml)
  - _…and 67 more — browse `Kubernetes/`._

## OpenTelemetry · 10 files

- **primer:** [Opentelemetry](../otel/notes/0000-primer-opentelemetry.md)
- **Notes** (2):
  - [Quickstart Trip Ups](../otel/notes/2026-09-30-quickstart-trip-ups.md)
  - [Opentelemetry](../otel/notes/0000-primer-opentelemetry.md)
- **Docs** (2):
  - [Context Propagation W3c Vs B3](../otel/docs/context-propagation-w3c-vs-b3.md)
  - [Opentelemetry Readme Coverage](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md)
- **Snippets** (2):
  - [Instrumented Http Server](../otel/snippets/2026-09-30-instrumented-http-server.go)
  - [First Trace Span](../otel/snippets/2026-09-26-first-trace-span.py)
- **Scripts** (2):
  - [Custom Span Processor Resource Detector](../otel/scripts/custom-span-processor-resource-detector.py)
  - [Install Collector And Run Otlp Pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh)
- **Configs** (2):
  - [Collector Otlp Real Pipeline](../otel/configs/collector-otlp-real-pipeline.yaml)
  - [Collector Otlp Export](../otel/configs/2026-09-30-collector-otlp-export.yaml)

## OpenTofu · 19 files

- **primer:** [Opentofu](../OpenTofu/notes/0000-primer-opentofu.md)
- **Notes** (2):
  - [Opentofu Quickstart Trip Ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md)
  - [Opentofu](../OpenTofu/notes/0000-primer-opentofu.md)
- **Docs** (4):
  - [Remote State S3 Backend Workspace Isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md)
  - [Opentofu Provider Development Custom Provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md)
  - [Backup](../OpenTofu/docs/backup.json)
  - _…and 1 more — browse `OpenTofu/`._
- **Scripts** (3):
  - [Tofu Plan Apply With Policy Checks](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh)
  - [S3 Dynamodb Remote State Bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh)
  - [Install Opentofu And Verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- **Configs** (2):
  - [Minimal Local Backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl)
  - [Minimal Local Config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)
- **Notebooks** (2):
  - [Comparing Opentofu And Terraform State Management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb)
  - [Comparing Opentofu And Terraform Aws Provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)
- **Templates** (6):
  - [Versions](../OpenTofu/templates/aws-reusable-module/versions.tf)
  - [Variables](../OpenTofu/templates/aws-reusable-module/variables.tf)
  - [Outputs](../OpenTofu/templates/aws-reusable-module/outputs.tf)
  - _…and 3 more — browse `OpenTofu/`._

## Prometheus · 40 files

- **primer:** [Prometheus](../Prometheus/notes/0000-primer-prometheus.md)
- **Notes** (2):
  - [Prometheus Getting Started Trip Ups](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md)
  - [Prometheus](../Prometheus/notes/0000-primer-prometheus.md)
- **Docs** (4):
  - [Integrating Prometheus With Related Tools](../pro/docs/integrating-prometheus-with-related-tools.md)
  - [Prometheus Recording Rules And Alert Reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md)
  - [Prometheus Kubernetes Integration](../Prometheus/docs/prometheus-kubernetes-integration.md)
  - _…and 1 more — browse `Prometheus/`._
- **Snippets** (1):
  - [Promql Target Health Check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)
- **Scripts** (6):
  - [Prometheus Alerting Rule Validation](../pro/scripts/2026-10-29-prometheus-alerting-rule-validation.sh)
  - [Custom Metrics Service](../Prometheus/scripts/custom-metrics-service.py)
  - [Custom App Metrics Collector](../Prometheus/scripts/custom-app-metrics-collector.go)
  - _…and 3 more — browse `Prometheus/`._
- **Configs** (5):
  - [Recording Vs Alerting Rules](../Prometheus/configs/recording-vs-alerting-rules.yaml)
  - [Prometheus Scrape Config And Remote Write Tuning](../Prometheus/configs/prometheus-scrape-config-and-remote-write-tuning.yaml)
  - [Production Prometheus](../Prometheus/configs/production-prometheus.yml)
  - _…and 2 more — browse `Prometheus/`._
- **Manifests** (3):
  - [Prometheus Grafana Stack Deployment](../pro/manifests/prometheus-grafana-stack-deployment.yaml)
  - [Production Prometheus Ha](../pro/manifests/production-prometheus-ha.yaml)
  - [Production Prometheus Ha](../Prometheus/manifests/production-prometheus-ha.yaml)
- **Notebooks** (1):
  - [Querying Prometheus With Promql Step Through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)
- **Templates** (18):
  - [Validate Rules](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-rules.sh)
  - [Validate Config](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-config.sh)
  - [Recording](../Prometheus/templates/prometheus-project-scaffold/rules/recording.yml)
  - _…and 15 more — browse `Prometheus/`._

## Pulumi · 25 files

- **primer:** [Plm](../plm/notes/0000-primer-plm.md)
- **Notes** (2):
  - [Pulumi Quickstart Trip Ups](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md)
  - [Plm](../plm/notes/0000-primer-plm.md)
- **Docs** (2):
  - [Multi Stack Project Structure](../plm/docs/multi-stack-project-structure.md)
  - [Plm Readme Layout And Coverage](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md)
- **Snippets** (1):
  - [Minimal Bucket With Pulumi Python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)
- **Scripts** (4):
  - [Provision S3 Bucket With Pulumi Ts](../plm/scripts/provision-s3-bucket-with-pulumi-ts.ts)
  - [Network Component Vpc Subnets](../plm/scripts/network-component-vpc-subnets.py)
  - [Create S3 Bucket With Pulumi](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py)
  - _…and 1 more — browse `Pulumi/`._
- **Configs** (3):
  - [Pulumi Yaml And Stack Config Reference](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml)
  - [Minimal Project And Stack Config](../plm/configs/minimal-project-and-stack-config.yaml)
  - [Minimal Pulumi Project And Stack Config](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml)
- **Templates** (13):
  - [Tsconfig](../plm/templates/pulumi-typescript-project-scaffold/tsconfig.json)
  - [Package](../plm/templates/pulumi-typescript-project-scaffold/package.json)
  - [Index](../plm/templates/pulumi-typescript-project-scaffold/index.ts)
  - _…and 10 more — browse `Pulumi/`._

## Terraform · 74 files

- **primer:** [Terraform](../Terraform/notes/0000-primer-terraform.md)
- **Notes** (6):
  - [Install Terraform And First Local File](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md)
  - [Terraform State Management Tutorial](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md)
  - [Following Provider Tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md)
  - _…and 3 more — browse `Terraform/`._
- **Docs** (8):
  - [Terraform Vs Opentofu Migration Guide](../tf/docs/terraform-vs-opentofu-migration-guide.md)
  - [Wiring Terraform Outputs Into Dependent Modules](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md)
  - [Terraform Testing Strategies Tflint Terratest](../Terraform/docs/terraform-testing-strategies-tflint-terratest.md)
  - _…and 5 more — browse `Terraform/`._
- **Snippets** (3):
  - [Reusable Module For Each Validation](../Terraform/snippets/reusable-module-for-each-validation.hcl)
  - [Terraform Cli Exploration](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh)
  - [Scaffold S3 Bucket Module Remote State](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)
- **Scripts** (4):
  - [Validate Provider Schema](../Terraform/scripts/validate-provider-schema.go)
  - [Install And Init](../Terraform/scripts/install-and-init.sh)
  - [Generate Ansible Inventory From Terraform State](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py)
  - _…and 1 more — browse `Terraform/`._
- **Configs** (10):
  - [Terraform Module Version Pinning And Migration Plan](../Terraform/configs/terraform-module-version-pinning-and-migration-plan.hcl)
  - [Variables](../Terraform/configs/reusable-s3-module/variables.tf)
  - [Outputs](../Terraform/configs/reusable-s3-module/outputs.tf)
  - _…and 7 more — browse `Terraform/`._
- **Manifests** (2):
  - [Simple Ec2 App](../Terraform/manifests/simple-ec2-app.tf)
  - [Reusable Vpc Module](../Terraform/manifests/reusable-vpc-module.hcl)
- **Notebooks** (2):
  - [Comparing Terraform Vs Opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb)
  - [Comparing For Each Vs Count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **Templates** (39):
  - [Versions](../tf/templates/multi-environment-terraform-project-scaffold/versions.tf)
  - [Variables](../tf/templates/multi-environment-terraform-project-scaffold/variables.tf)
  - [Destroy](../tf/templates/multi-environment-terraform-project-scaffold/scripts/destroy.sh)
  - _…and 36 more — browse `Terraform/`._

## Trivy · 17 files

- **primer:** [Trivy](../Trivy/notes/0000-primer-trivy.md)
- **Notes** (5):
  - [Trivy Quickstart Follow Along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md)
  - [Trivy Quickstart Trip Ups](../Trivy/notes/2026-08-29-trivy-quickstart-trip-ups.md)
  - [Trivy Quickstart Trip Ups](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)
  - _…and 2 more — browse `Trivy/`._
- **Docs** (2):
  - [Trivy Sbom Generation And Vulnerability Reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md)
  - [Choosing Scan Modes And Pipeline Wiring](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md)
- **Snippets** (2):
  - [Scan Image Fail Critical Cves](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py)
  - [Trivy Python Wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)
- **Scripts** (5):
  - [Trivy Policy As Code Opa Rego](../Trivy/scripts/trivy-policy-as-code-opa-rego.sh)
  - [Trivy Fs Repo Scan Workflow](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh)
  - [Scan Images From File Consolidated Sarif](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)
  - _…and 2 more — browse `Trivy/`._
- **Configs** (3):
  - [Trivy Operator Admission Control](../Trivy/configs/trivy-operator-admission-control.yaml)
  - [Trivy Config With Scan Policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml)
  - [Trivy Config](../Trivy/configs/2026-08-12-trivy-config.yaml)

## Foundational Concepts

- **Linux System Administration** · 8 files
  - **primer:** [Linux System Administration](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
  - [Systemd Watchdog Restart And Page](../docs/concepts/linux-system-administration/scripts/systemd-watchdog-restart-and-page.sh)
  - [Systemd Health Check Log Alerting](../docs/concepts/linux-system-administration/scripts/systemd-health-check-log-alerting.sh)
  - [Systemd Health Check And Log Rotation](../docs/concepts/linux-system-administration/scripts/systemd-health-check-and-log-rotation.sh)
  - _…and 4 more under `docs/concepts/linux-system-administration/` — browse the folder._

- **Scripting Automation Bash Python** · 11 files
  - **primer:** [Scripting Automation Bash Python](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
  - [Retry Backoff Logging](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-08-retry-backoff-logging.py)
  - [Log Parsing Filtering](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py)
  - [Service Health Check](../docs/concepts/scripting-automation-bash-python/scripts/service-health-check.sh)
  - _…and 7 more under `docs/concepts/scripting-automation-bash-python/` — browse the folder._

- **Networking Fundamentals** · 11 files
  - **primer:** [Networking Fundamentals](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
  - [Tcp Port And Dns Sockets](../docs/concepts/networking-fundamentals/snippets/2026-09-24-tcp-port-and-dns-sockets.py)
  - [Tcp Tls Health Probes With Latency](../docs/concepts/networking-fundamentals/scripts/tcp-tls-health-probes-with-latency.sh)
  - [Sample Health Check Targets](../docs/concepts/networking-fundamentals/scripts/sample-health-check-targets.json)
  - _…and 7 more under `docs/concepts/networking-fundamentals/` — browse the folder._

- **Version Control Concepts** · 10 files
  - **primer:** [Version Control Concepts](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
  - [Branch Divergence Rev List](../docs/concepts/version-control-concepts/snippets/2026-09-23-branch-divergence-rev-list.py)
  - [Conventional Changelog From Git Log](../docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py)
  - [Branch Management Merge Validation](../docs/concepts/version-control-concepts/scripts/branch-management-merge-validation.sh)
  - _…and 6 more under `docs/concepts/version-control-concepts/` — browse the folder._

- **Containerization Concepts** · 8 files
  - **primer:** [Containerization Concepts](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
  - [Inspect Image Layers With Docker Sdk](../docs/concepts/containerization-concepts/snippets/2026-09-24-inspect-image-layers-with-docker-sdk.py)
  - [Inspect Image Layers](../docs/concepts/containerization-concepts/snippets/2026-08-08-inspect-image-layers.py)
  - [Build And Push Pipeline](../docs/concepts/containerization-concepts/scripts/build-and-push-pipeline.py)
  - _…and 4 more under `docs/concepts/containerization-concepts/` — browse the folder._

- **Ci Cd Concepts** · 9 files
  - **primer:** [Ci Cd Concepts](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
  - [Parallelized Ci Stage Runner](../docs/concepts/ci-cd-concepts/snippets/2026-08-08-parallelized-ci-stage-runner.sh)
  - [Cicd Common Patterns](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh)
  - [Artifact Promotion Rollback](../docs/concepts/ci-cd-concepts/scripts/artifact-promotion-rollback.sh)
  - _…and 5 more under `docs/concepts/ci-cd-concepts/` — browse the folder._

- **Infrastructure As Code Concepts** · 7 files
  - **primer:** [Infrastructure As Code Concepts](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
  - [Parse And Validate Terraform State](../docs/concepts/infrastructure-as-code-concepts/snippets/2026-09-06-parse-and-validate-terraform-state.py)
  - [Iac State Workflow](../docs/concepts/infrastructure-as-code-concepts/scripts/2026-08-25-iac-state-workflow.sh)
  - [Terraform Vs Ansible Container Infra](../docs/concepts/infrastructure-as-code-concepts/notebooks/terraform-vs-ansible-container-infra.ipynb)
  - _…and 3 more under `docs/concepts/infrastructure-as-code-concepts/` — browse the folder._

- **Monitoring Observability Concepts** · 8 files
  - **primer:** [Monitoring Observability Concepts](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
  - [Scripted Health Gate With Correlated Logs](../docs/concepts/monitoring-observability-concepts/scripts/scripted-health-gate-with-correlated-logs.py)
  - [Health Checks And Log Correlation](../docs/concepts/monitoring-observability-concepts/scripts/health-checks-and-log-correlation.py)
  - [Metrics Exporter Structured Logger](../docs/concepts/monitoring-observability-concepts/scripts/2026-09-08-metrics-exporter-structured-logger.py)
  - _…and 4 more under `docs/concepts/monitoring-observability-concepts/` — browse the folder._

## docs (kit notes)

Notes about the kit itself, kept alongside the content they refer to. Browse `docs/`.
- [Kubernetes Readme Tree Update](../docs/2026-07-21-kubernetes-readme-tree-update.md)
- [Audit 004 Check](../docs/2026-07-19-audit-004-check.md)
- [Ansible Notebooks Readme Verified](../docs/2026-07-19-ansible-notebooks-readme-verified.md)
- [Removed Dead General References](../docs/2026-07-11-removed-dead-general-references.md)

## docs/audit

Audit notes tracking README, coverage, and topic-map corrections. Browse `docs/audit/`.
- [Manifest](../docs/audit/MANIFEST.json)
- [Repo Audit 014](../docs/audit/2026-10-21-repo-audit-014.md)
- [Repo Audit 013](../docs/audit/2026-10-10-repo-audit-013.md)
- [Audit 012 Docker Dockerfile Count](../docs/audit/2026-09-07-audit-012-docker-dockerfile-count.md)

