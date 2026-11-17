# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible · 114 files

- **primer:** [Ansible](../Ansible/notes/0000-primer-ansible.md)
- **Notes** (10): [Ansible](../Ansible/notes/0000-primer-ansible.md), [Exploring Ansible Cli](../Ansible/notes/2026-06-06-exploring-ansible-cli.md), [Ansible Getting Started](../Ansible/notes/2026-06-11-ansible-getting-started.md)
  - _…and 7 more under `Ansible/` — browse the folder._
- **Docs** (7): [Wiring Ansible Lint](../Ansible/docs/2026-06-15-wiring-ansible-lint.md), [Ansible 14 Core 2 21 Migration Guide](../Ansible/docs/ansible-14-core-2-21-migration-guide.md), [Ansible Execution Environments Custom Images](../Ansible/docs/ansible-execution-environments-custom-images.md)
  - _…and 4 more under `Ansible/` — browse the folder._
- **Snippets** (2): [Lint Ansible Playbook](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py), [Nginx Playbook](../Ansible/snippets/nginx-playbook.yaml)
- **Scripts** (4): [Install Ansible And Explore Modules](../Ansible/scripts/2026-07-19-install-ansible-and-explore-modules.sh), [Install And First Adhoc](../Ansible/scripts/install-and-first-adhoc.sh), [Run First Playbook](../Ansible/scripts/run-first-playbook.sh)
  - _…and 1 more under `Ansible/` — browse the folder._
- **Configs** (10): [First Inventory And Ping Playbook](../Ansible/configs/2026-07-19-first-inventory-and-ping-playbook.yaml), [Nginx Phpfpm Ufw Ubuntu](../Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml), [Ansible Collection Requirements And Docker Lifecycle Playbook](../Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml)
  - _…and 7 more under `Ansible/` — browse the folder._
- **Manifests** (10): [Ansible Playbook Migration](../Ansible/manifests/ansible-playbook-migration.yaml), [All](../Ansible/manifests/group_vars/all.yaml), [Production](../Ansible/manifests/inventory/production.ini)
  - _…and 7 more under `Ansible/` — browse the folder._
- **Notebooks** (2): [Ansible Variable Precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb), [Comparing Execution Patterns Block Rescue Serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb)
- **Dockerfiles** (1): [Ansible Control Node](../Ansible/dockerfiles/ansible-control-node.Dockerfile)
- **Templates** (68): [Readme](../Ansible/templates/ansible-project-scaffold/README.md), [Ansible](../Ansible/templates/ansible-project-scaffold/ansible.cfg), [All](../Ansible/templates/ansible-project-scaffold/group_vars/all.yml)
  - _…and 65 more under `Ansible/` — browse the folder._

## ArgoCD · 27 files

- **primer:** [ArgoCD](../ArgoCD/notes/0000-primer-argocd.md)
- **Notes** (3): [Argocd](../ArgoCD/notes/0000-primer-argocd.md), [Argocd Quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md), [Install](../ArgoCD/notes/install.yaml)
- **Docs** (2): [Argocd Vault External Secrets](../ArgoCD/docs/argocd-vault-external-secrets.md), [How I Wired Argocd With Github For Gitops Deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md)
- **Snippets** (1): [Sync App And Verify Health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)
- **Scripts** (3): [Install Argocd And Access Ui](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh), [Argocd Application Helper](../ArgoCD/scripts/argocd-application-helper.py), [Build Argocd Application From Scratch](../ArgoCD/scripts/build-argocd-application-from-scratch.sh)
- **Configs** (3): [First Application Manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml), [Guestbook Applicationset](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml), [Guestbook Applicationset Multi Cluster](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml)
- **Manifests** (2): [Deployment](../ArgoCD/manifests/guestbook/deployment.yaml), [Multi Cluster Fleet Applicationset](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml)
- **Templates** (13): [Readme](../ArgoCD/templates/multi-cluster-gitops-repo/README.md), [Sample App](../ArgoCD/templates/multi-cluster-gitops-repo/applications/sample-app.yaml), [Matrix Generator](../ArgoCD/templates/multi-cluster-gitops-repo/applicationset/matrix-generator.yaml)
  - _…and 10 more under `ArgoCD/` — browse the folder._

## AWS · 25 files

- **primer:** [AWS](../AWS/notes/0000-primer-aws.md)
- **Notes** (2): [Aws](../AWS/notes/0000-primer-aws.md), [Already Exists](../AWS/notes/2026-07-13-primer-already-exists.md)
- **Docs** (2): [Iam Cross Account Roles Least Privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md), [Iam Policy Least Privilege Walkthrough](../AWS/docs/iam-policy-least-privilege-walkthrough.md)
- **Snippets** (3): [List Ec2 And S3](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh), [List And Tag Ec2 Instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [Create S3 Bucket And Upload Object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py)
- **Scripts** (7): [Install Aws Cli V2 And Configure](../AWS/scripts/2026-07-12-install-aws-cli-v2-and-configure.sh), [Install Aws Cli V2 And Configure](../AWS/scripts/2026-07-13-install-aws-cli-v2-and-configure.sh), [Install Aws Cli V2 And Configure App Default](../AWS/scripts/2026-08-13-install-aws-cli-v2-and-configure-app-default.sh)
  - _…and 4 more under `AWS/` — browse the folder._
- **Configs** (3): [Minimal Aws Config](../AWS/configs/2026-07-12-minimal-aws-config.ini), [Minimal Aws Config](../AWS/configs/2026-07-13-minimal-aws-config.ini), [Ecs Service Deployment Blue Green](../AWS/configs/ecs-service-deployment-blue-green.yaml)
- **Notebooks** (1): [Comparing Deployment Approaches Boto3 Cloudformation Cdk](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)
- **Templates** (7): [Readme](../AWS/templates/cloudformation-multi-account-stack-set/README.md), [Deploy](../AWS/templates/cloudformation-multi-account-stack-set/examples/deploy.sh), [Template](../AWS/templates/cloudformation-multi-account-stack-set/template.yaml)
  - _…and 4 more under `AWS/` — browse the folder._

## Azure · 28 files

- **primer:** [Azure](../Azure/notes/0000-primer-azure.md)
- **Notes** (4): [Azure](../Azure/notes/0000-primer-azure.md), [Azure Cli Quickstart Trip Ups](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md), [Azure Quickstart Trip Ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md)
  - _…and 1 more under `Azure/` — browse the folder._
- **Docs** (2): [Azure Devops Pipeline Bicep Integration](../Azure/docs/azure-devops-pipeline-bicep-integration.md), [Comparing Azure Cli Bicep Python Sdk](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md)
- **Snippets** (3): [Create Resource Group And List Regions](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh), [Create Resource Group And List Regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [Create Vnet Nsg And Linux Vm](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh)
- **Scripts** (5): [Install Azure Cli And Login](../Azure/scripts/2026-07-13-install-azure-cli-and-login.sh), [Provision Resource Group And Storage Account](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh), [Azure Vm Scale Set Autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
  - _…and 2 more under `Azure/` — browse the folder._
- **Configs** (2): [Container Apps Microservices](../Azure/configs/container-apps-microservices.yaml), [Azure Key Vault Access Policy](../az/configs/azure-key-vault-access-policy.json)
- **Manifests** (2): [Production Aks Cluster](../Azure/manifests/production-aks-cluster.bicep), [Container Apps Multi Service Deployment](../az/manifests/container-apps-multi-service-deployment.yaml)
- **Templates** (10): [Readme](../Azure/templates/aks-cluster-with-addons/README.md), [Deploy](../Azure/templates/aks-cluster-with-addons/examples/deploy.sh), [Main](../Azure/templates/aks-cluster-with-addons/main.bicep)
  - _…and 7 more under `Azure/` — browse the folder._

## Docker · 58 files

- **primer:** [Docker](../Docker/notes/0000-primer-docker.md)
- **Notes** (6): [Docker](../Docker/notes/0000-primer-docker.md), [Explore Docker Cli](../Docker/notes/2026-06-05-explore-docker-cli.md), [Exploring Docker Cli](../Docker/notes/2026-06-06-exploring-docker-cli.md)
  - _…and 3 more under `Docker/` — browse the folder._
- **Docs** (11): [Docker Build Cache And Multi Stage Layering](../Docker/docs/docker-build-cache-and-multi-stage-layering.md), [Docker Build Mount Vs Copy Caching](../Docker/docs/docker-build-mount-vs-copy-caching.md), [Docker Buildkit Cache Mounts Secrets](../Docker/docs/docker-buildkit-cache-mounts-secrets.md)
  - _…and 8 more under `Docker/` — browse the folder._
- **Snippets** (2): [Build Run And Cleanup](../Docker/snippets/2026-08-12-build-run-and-cleanup.py), [Analyze Image Layers](../Docker/snippets/analyze-image-layers.py)
- **Scripts** (5): [Compose Multi Service](../Docker/scripts/2026-06-12-compose-multi-service.sh), [Docker Health Check And Cleanup](../Docker/scripts/docker-health-check-and-cleanup.sh), [Install And Run Container](../Docker/scripts/install-and-run-container.sh)
  - _…and 2 more under `Docker/` — browse the folder._
- **Configs** (1): [Multi Service App](../Docker/configs/multi-service-app.yaml)
- **Manifests** (9): [Web Db Compose](../Docker/manifests/2026-06-13-web-db-compose.yaml), [Go Redis Compose Healthchecks](../Docker/manifests/2026-06-28-go-redis-compose-healthchecks.yaml), [App Postgres Healthchecks.compose](../Docker/manifests/app-postgres-healthchecks.compose.yaml)
  - _…and 6 more under `Docker/` — browse the folder._
- **Notebooks** (3): [Comparing Compose Swarm Kubernetes Local Orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb), [Comparing Docker Build Strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb), [Comparing Docker Networking Drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
- **Dockerfiles** (9): [Build And Run First](../Docker/dockerfiles/build-and-run-first.Dockerfile), [First Docker Image](../Docker/dockerfiles/first-docker-image.Dockerfile), [Multi Stage Go Http Server](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
  - _…and 6 more under `Docker/` — browse the folder._
- **Templates** (12): [.dockerignore](../Docker/templates/go-microservice/.dockerignore), [Dockerfile](../Docker/templates/go-microservice/Dockerfile), [Makefile](../Docker/templates/go-microservice/Makefile)
  - _…and 9 more under `Docker/` — browse the folder._

## Flux CD · 8 files

- **Notes** (2): [Explore Flux Cli Command Surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md), [Flux Quickstart Trip Ups](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md)
- **Docs** (2): [Flux Cd Readme Coverage And Topics Update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md), [How I Wired Flux Cd With Github For Gitops Deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md)
- **Scripts** (2): [Install Flux Cli And Run Flux Check Pre](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh), [Bootstrap Flux On Kind](../FluxCD/scripts/bootstrap-flux-on-kind.sh)
- **Configs** (2): [Minimal Gitrepository And Kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml), [Helmrelease Image Automation](../FluxCD/configs/helmrelease-image-automation.yaml)

## GCP · 15 files

- **primer:** [GCP](../GCP/notes/0000-primer-gcp.md)
- **Notes** (2): [Gcp](../GCP/notes/0000-primer-gcp.md), [Gcloud Sdk Quickstart Trip Ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md)
- **Docs** (1): [Gcp Readme Coverage And Topics](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)
- **Snippets** (2): [List Compute And Gcs With Gcloud](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh), [List Compute And Gcs With Gcloud](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh)
- **Scripts** (6): [Install Gcloud Cli And Configure Creds](../GCP/scripts/2026-07-16-install-gcloud-cli-and-configure-creds.sh), [Install Gcloud Cli And Configure Creds](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh), [Launch Vm Firewall And Ssh](../GCP/scripts/2026-09-21-launch-vm-firewall-and-ssh.sh)
  - _…and 3 more under `GCP/` — browse the folder._
- **Configs** (4): [Minimal Gcloud Config And Startup Script](../GCP/configs/2026-08-14-minimal-gcloud-config-and-startup-script.yaml), [Instance Template With Startup Script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml), [Service Account And Iam Config](../GCP/configs/service-account-and-iam-config.yaml)
  - _…and 1 more under `GCP/` — browse the folder._

## Git · 85 files

- **primer:** [Git](../Git/notes/0000-primer-git.md)
- **Notes** (6): [Git](../Git/notes/0000-primer-git.md), [Explore Git Cli](../Git/notes/2026-06-04-explore-git-cli.md), [Install Git](../Git/notes/2026-06-04-install-git.md)
  - _…and 3 more under `Git/` — browse the folder._
- **Docs** (15): [.pre Commit Config](../Git/docs/.pre-commit-config.yaml), [Git Folder Readme Coverage](../Git/docs/2026-08-04-git-folder-readme-coverage.md), [Document Git Docs Folder In Readme](../Git/docs/2026-08-22-document-git-docs-folder-in-readme.md)
  - _…and 12 more under `Git/` — browse the folder._
- **Snippets** (1): [First Commit](../Git/snippets/first-commit.sh)
- **Scripts** (14): [Merge Conflict Practice](../Git/scripts/2026-06-10-merge-conflict-practice.sh), [Batch Git Ops](../Git/scripts/batch-git-ops.sh), [Bisect Automation Runner](../Git/scripts/bisect-automation-runner.sh)
  - _…and 11 more under `Git/` — browse the folder._
- **Notebooks** (3): [Comparing Git Merge Strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb), [Merge Rebase Squash Comparison](../Git/notebooks/merge-rebase-squash-comparison.ipynb), [Merge Rebase Squash Comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb)
- **Templates** (46): [Commit Msg](../Git/templates/git-hooks/commit-msg), [Post Checkout](../Git/templates/git-hooks/post-checkout), [Post Commit](../Git/templates/git-hooks/post-commit)
  - _…and 43 more under `Git/` — browse the folder._

## GitHub · 56 files

- **primer:** [GitHub](../GitHub/notes/0000-primer-github.md)
- **Notes** (11): [Github](../GitHub/notes/0000-primer-github.md), [Explore Github Web And Cli](../GitHub/notes/2026-06-07-explore-github-web-and-cli.md), [Exploring Github Repos Issues Prs](../GitHub/notes/2026-06-10-exploring-github-repos-issues-prs.md)
  - _…and 8 more under `GitHub/` — browse the folder._
- **Docs** (7): [Document Github Docs In Readme](../GitHub/docs/2026-08-22-document-github-docs-in-readme.md), [Document Github Notebooks In Readme](../GitHub/docs/2026-08-22-document-github-notebooks-in-readme.md), [Branch Protection And Required Reviews For Ci](../GitHub/docs/branch-protection-and-required-reviews-for-ci.md)
  - _…and 4 more under `GitHub/` — browse the folder._
- **Snippets** (3): [Github Issues Api](../GitHub/snippets/github-issues-api.py), [List Repos With Python](../GitHub/snippets/list-repos-with-python.py), [Open Pr And Wait For Ci](../GitHub/snippets/open-pr-and-wait-for-ci.sh)
- **Scripts** (7): [Auth And Explore Profile](../GitHub/scripts/2026-06-10-auth-and-explore-profile.sh), [Create Repo And Pr](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh), [Auth And Profile](../GitHub/scripts/auth-and-profile.sh)
  - _…and 4 more under `GitHub/` — browse the folder._
- **Configs** (7): [Pr Checker Workflow](../GitHub/configs/2026-08-22-pr-checker-workflow.yaml), [Config](../GitHub/configs/dot-github-repository/config.yml), [Bug Report](../GitHub/configs/dot-github-repository/issue-forms/bug-report.yaml)
  - _…and 4 more under `GitHub/` — browse the folder._
- **Manifests** (1): [Github Environments Deployment Protection](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **Notebooks** (2): [Analyzing Github Actions Usage Across Org Repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb), [Comparing Api Approaches Release Automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb)
- **Dockerfiles** (1): [Self Hosted Runner](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)
- **Templates** (17): [Bug Report](../GitHub/templates/github-repo-scaffold/.github/ISSUE_TEMPLATE/bug_report.yml), [Documentation](../GitHub/templates/github-repo-scaffold/.github/ISSUE_TEMPLATE/documentation.yml), [Feature Request](../GitHub/templates/github-repo-scaffold/.github/ISSUE_TEMPLATE/feature_request.yml)
  - _…and 14 more under `GitHub/` — browse the folder._

## GitHub Actions · 26 files

- **primer:** [GitHub Actions](../GitHub Actions/notes/0000-primer-github-actions.md)
- **Notes** (5): [Github Actions](../GitHub Actions/notes/0000-primer-github-actions.md), [Following Github Actions Quickstart](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md), [Already Exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)
  - _…and 2 more under `GitHub Actions/` — browse the folder._
- **Docs** (7): [Ci](../GitHub Actions/docs/.github/workflows/ci.yml), [Github Actions Quickstart Tripups](../GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md), [Choosing Between Artifacts Cache External Storage](../GitHub Actions/docs/choosing-between-artifacts-cache-external-storage.md)
  - _…and 4 more under `GitHub Actions/` — browse the folder._
- **Snippets** (1): [Trigger Workflow Dispatch Poll Status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)
- **Scripts** (4): [Install Gh Extension And List Runs](../GitHub Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh), [Install Gh Actions Extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh), [Manage Secrets Across Repos](../GitHub Actions/scripts/manage-secrets-across-repos.py)
  - _…and 1 more under `GitHub Actions/` — browse the folder._
- **Configs** (5): [First Ci Workflow With Env And Secrets](../GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml), [First Ci Workflow Hello](../GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml), [Hello Workflow](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)
  - _…and 2 more under `GitHub Actions/` — browse the folder._
- **Dockerfiles** (1): [Custom Runner](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)
- **Templates** (3): [Readme](../GitHub Actions/templates/multi-env-deploy/README.md), [Deploy Caller](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml), [Reusable Deploy](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml)

## GitLab CI · 50 files

- **primer:** [GitLab CI](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **Notes** (8): [.gitlab Ci](../GitLab CI/notes/.gitlab-ci.yml), [Gitlab Ci Cd](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md), [Following Gitlab Ci Quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md)
  - _…and 5 more under `GitLab CI/` — browse the folder._
- **Docs** (4): [Gitlab Ci Cd Pipeline Library Patterns](../GitLab CI/docs/gitlab-ci-cd-pipeline-library-patterns.md), [Gitlab Ci Cd With Kubernetes](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md), [Gitlab Ci Cd Pipeline Library Patterns](../GitLab/docs/gitlab-ci-cd-pipeline-library-patterns.md)
  - _…and 1 more under `GitLab CI/` — browse the folder._
- **Snippets** (2): [Trigger Pipeline And Poll Jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh), [Trigger Pipeline And Poll Jobs](../GitLab/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- **Scripts** (10): [Install Runner And Register](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh), [Run First Local Pipeline](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh), [Local Ci Pipeline Validator](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh)
  - _…and 7 more under `GitLab CI/` — browse the folder._
- **Configs** (8): [First Pipeline](../GitLab CI/configs/2026-06-22-first-pipeline.yaml), [Minimal Pipeline Stages Cache Artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml), [Multi Project Pipeline With Triggers](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml)
  - _…and 5 more under `GitLab CI/` — browse the folder._
- **Dockerfiles** (2): [Gitlab Runner Dind Kaniko](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile), [Gitlab Runner Dind Kaniko](../GitLab/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)
- **Templates** (16): [.gitlab Ci](../GitLab CI/templates/modular-pipeline-repo/.gitlab-ci.yml), [Build](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/build.yml), [Deploy](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/deploy.yml)
  - _…and 13 more under `GitLab CI/` — browse the folder._

## Grafana · 10 files

- **primer:** [Grafana](../graf/notes/0000-primer-grafana.md)
- **Notes** (4): [Grafana](../graf/notes/0000-primer-grafana.md), [Explore Grafana Ui](../graf/notes/2026-09-25-explore-grafana-ui.md), [Grafana Quickstart Trip Ups](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md)
  - _…and 1 more under `Grafana/` — browse the folder._
- **Docs** (3): [Grafana Coverage And Topics](../graf/docs/2026-09-25-grafana-coverage-and-topics.md), [Grafana Navigation Dedup](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [How I Wired Grafana Into Prometheus And Alertmanager For Unified Metrics And Alert Visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md)
- **Scripts** (2): [Install Grafana With Docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh), [Build Multi Panel Service Dashboard Via Http Api](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py)
- **Configs** (1): [Minimal Datasource Dashboard Provisioning](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)

## Grafana Cloud · 6 files

- **Notes** (2): [First Hosted Dashboard](../grafc/notes/2026-09-30-first-hosted-dashboard.md), [Grafana Cloud Quickstart Trip Ups](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md)
- **Snippets** (1): [First Dashboard Over Http](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)
- **Scripts** (1): [Create Stack And Send Metrics](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)
- **Configs** (2): [Minimal Metrics Scrape Config](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml), [Prometheus Remote Write Grafana Cloud](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml)

## HashiCorp Vault · 11 files

- **primer:** [HashiCorp Vault](../vlt/notes/0000-primer-vlt.md)
- **Notes** (3): [Vlt](../vlt/notes/0000-primer-vlt.md), [Explore Vault Cli Secrets Policies](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md), [Vault Quickstart Trip Ups](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md)
- **Docs** (2): [Vlt Readme Layout And Coverage](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md), [Vault Agent Secret Injection](../vlt/docs/vault-agent-secret-injection.md)
- **Scripts** (4): [Install Vault Cli And Start Dev Server](../vlt/scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh), [Install Vault And First Secrets Engine](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh), [Write Read List Kv V2 Secret](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py)
  - _…and 1 more under `Vault/` — browse the folder._
- **Configs** (2): [Minimal Read Only Policy Bound To Group](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl), [Vault Approle](../vlt/configs/vault-approle.hcl)

## Helm · 63 files

- **primer:** [Helm](../Helm/notes/0000-primer-helm.md)
- **Notes** (3): [Helm](../Helm/notes/0000-primer-helm.md), [Helm Quickstart Tripups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [Values](../Helm/notes/values.yaml)
- **Docs** (6): [Helm Added To Readme](../Helm/docs/2026-07-22-helm-added-to-readme.md), [Add Helm To Readme Layout And Coverage](../Helm/docs/2026-07-25-add-helm-to-readme-layout-and-coverage.md), [Helm Readme Already Documented](../Helm/docs/2026-07-25-helm-readme-already-documented.md)
  - _…and 3 more under `Helm/` — browse the folder._
- **Snippets** (1): [Nginx Helm Chart Custom Values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **Scripts** (5): [Install Helm And Explore Cli](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh), [Demo Web Service Chart](../Helm/scripts/demo-web-service-chart.sh), [Dummy Test](../Helm/scripts/dummy-test.sh)
  - _…and 2 more under `Helm/` — browse the folder._
- **Configs** (5): [First Helm Chart Inspection](../Helm/configs/2026-07-23-first-helm-chart-inspection.yaml), [Live Values](../Helm/configs/2026-08-29-live-values.yaml), [Production Deployment Values](../Helm/configs/2026-08-30-production-deployment-values.yaml)
  - _…and 2 more under `Helm/` — browse the folder._
- **Manifests** (15): [Chart](../Helm/manifests/demo-chart/Chart.yaml), [Readme](../Helm/manifests/demo-chart/README.md), [Helpers](../Helm/manifests/demo-chart/templates/_helpers.tpl)
  - _…and 12 more under `Helm/` — browse the folder._
- **Notebooks** (1): [Release Lifecycle Drill](../Helm/notebooks/release-lifecycle-drill.ipynb)
- **Templates** (27): [Chart](../Helm/templates/helm-library-scaffold/Chart.yaml), [Readme](../Helm/templates/helm-library-scaffold/README.md), [Helpers](../Helm/templates/helm-library-scaffold/templates/_helpers.tpl)
  - _…and 24 more under `Helm/` — browse the folder._

## Jenkins · 3 files

- **primer:** [Jenkins](../jnk/notes/0000-primer-jenkins.md)
- **Notes** (2): [Jenkins](../jnk/notes/0000-primer-jenkins.md), [Install Jenkins And Run First Cli Command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md)
- **Scripts** (1): [Trigger First Jenkins Job Via Cli](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

## Kubernetes · 102 files

- **primer:** [Kubernetes](../Kubernetes/notes/0000-primer-kubernetes.md)
- **Notes** (10): [Kubernetes](../Kubernetes/notes/0000-primer-kubernetes.md), [Exploring Kubectl](../Kubernetes/notes/2026-06-06-exploring-kubectl.md), [Kubernetes Interactive Tutorial](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)
  - _…and 7 more under `Kubernetes/` — browse the folder._
- **Docs** (6): [Gateway Api Migration From Ingress](../Kubernetes/docs/gateway-api-migration-from-ingress.md), [Ingress Path Based Routing](../Kubernetes/docs/ingress-path-based-routing.md), [Ingress](../Kubernetes/docs/ingress.yaml)
  - _…and 3 more under `Kubernetes/` — browse the folder._
- **Snippets** (2): [First Pod And Service With Kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh), [Pod Troubleshoot Shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
- **Scripts** (4): [Custom Resource Reconciliation Controller](../Kubernetes/scripts/custom-resource-reconciliation-controller.go), [Install Kind And First Cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh), [Pod Lifecycle](../Kubernetes/scripts/pod-lifecycle.sh)
  - _…and 1 more under `Kubernetes/` — browse the folder._
- **Configs** (1): [Deployment Service Go App With Probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)
- **Manifests** (7): [Configmap Secret Mounted Pod](../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml), [Cluster Api Bootstrap](../Kubernetes/manifests/cluster-api-bootstrap.yaml), [Deployment Service With Probes Limits](../Kubernetes/manifests/deployment-service-with-probes-limits.yaml)
  - _…and 4 more under `Kubernetes/` — browse the folder._
- **Notebooks** (2): [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb), [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb)
- **Templates** (70): [Chart](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/Chart.yaml), [Helpers](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/templates/_helpers.tpl), [Deployment](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/templates/deployment.yaml)
  - _…and 67 more under `Kubernetes/` — browse the folder._

## OpenTelemetry · 10 files

- **primer:** [OpenTelemetry](../otel/notes/0000-primer-opentelemetry.md)
- **Notes** (2): [Opentelemetry](../otel/notes/0000-primer-opentelemetry.md), [Quickstart Trip Ups](../otel/notes/2026-09-30-quickstart-trip-ups.md)
- **Docs** (2): [Opentelemetry Readme Coverage](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md), [Context Propagation W3c Vs B3](../otel/docs/context-propagation-w3c-vs-b3.md)
- **Snippets** (2): [First Trace Span](../otel/snippets/2026-09-26-first-trace-span.py), [Instrumented Http Server](../otel/snippets/2026-09-30-instrumented-http-server.go)
- **Scripts** (2): [Install Collector And Run Otlp Pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh), [Custom Span Processor Resource Detector](../otel/scripts/custom-span-processor-resource-detector.py)
- **Configs** (2): [Collector Otlp Export](../otel/configs/2026-09-30-collector-otlp-export.yaml), [Collector Otlp Real Pipeline](../otel/configs/collector-otlp-real-pipeline.yaml)

## OpenTofu · 19 files

- **primer:** [OpenTofu](../OpenTofu/notes/0000-primer-opentofu.md)
- **Notes** (2): [Opentofu](../OpenTofu/notes/0000-primer-opentofu.md), [Opentofu Quickstart Trip Ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md)
- **Docs** (4): [State Management Tutorial Notes](../OpenTofu/docs/2026-08-25-state-management-tutorial-notes.md), [Backup](../OpenTofu/docs/backup.json), [Opentofu Provider Development Custom Provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md)
  - _…and 1 more under `OpenTofu/` — browse the folder._
- **Scripts** (3): [Install Opentofu And Verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh), [S3 Dynamodb Remote State Bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh), [Tofu Plan Apply With Policy Checks](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh)
- **Configs** (2): [Minimal Local Config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf), [Minimal Local Backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl)
- **Notebooks** (2): [Comparing Opentofu And Terraform Aws Provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb), [Comparing Opentofu And Terraform State Management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb)
- **Templates** (6): [Readme](../OpenTofu/templates/aws-reusable-module/README.md), [Main](../OpenTofu/templates/aws-reusable-module/examples/basic/main.tf), [Main](../OpenTofu/templates/aws-reusable-module/main.tf)
  - _…and 3 more under `OpenTofu/` — browse the folder._

## Prometheus · 40 files

- **primer:** [Prometheus](../Prometheus/notes/0000-primer-prometheus.md)
- **Notes** (2): [Prometheus](../Prometheus/notes/0000-primer-prometheus.md), [Prometheus Getting Started Trip Ups](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md)
- **Docs** (4): [Alertmanager Pagerduty Oncall Rotations](../Prometheus/docs/alertmanager-pagerduty-oncall-rotations.md), [Prometheus Kubernetes Integration](../Prometheus/docs/prometheus-kubernetes-integration.md), [Prometheus Recording Rules And Alert Reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md)
  - _…and 1 more under `Prometheus/` — browse the folder._
- **Snippets** (1): [Promql Target Health Check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)
- **Scripts** (6): [Install Prometheus And Verify Metrics](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh), [Prometheus Alerting Rule Validation](../Prometheus/scripts/2026-10-29-prometheus-alerting-rule-validation.sh), [Custom App Exporter](../Prometheus/scripts/custom-app-exporter.py)
  - _…and 3 more under `Prometheus/` — browse the folder._
- **Configs** (5): [Minimal Scrape Config](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml), [Minimal Container Monitoring Config](../Prometheus/configs/2026-09-05-minimal-container-monitoring-config.yml), [Production Prometheus](../Prometheus/configs/production-prometheus.yml)
  - _…and 2 more under `Prometheus/` — browse the folder._
- **Manifests** (3): [Production Prometheus Ha](../Prometheus/manifests/production-prometheus-ha.yaml), [Production Prometheus Ha](../pro/manifests/production-prometheus-ha.yaml), [Prometheus Grafana Stack Deployment](../pro/manifests/prometheus-grafana-stack-deployment.yaml)
- **Notebooks** (1): [Querying Prometheus With Promql Step Through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)
- **Templates** (18): [.env](../Prometheus/templates/prometheus-alertmanager-grafana-stack/.env.example), [Readme](../Prometheus/templates/prometheus-alertmanager-grafana-stack/README.md), [Alertmanager](../Prometheus/templates/prometheus-alertmanager-grafana-stack/alertmanager.yml)
  - _…and 15 more under `Prometheus/` — browse the folder._

## Pulumi · 25 files

- **primer:** [Pulumi](../plm/notes/0000-primer-plm.md)
- **Notes** (2): [Plm](../plm/notes/0000-primer-plm.md), [Pulumi Quickstart Trip Ups](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md)
- **Docs** (2): [Plm Readme Layout And Coverage](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md), [Multi Stack Project Structure](../plm/docs/multi-stack-project-structure.md)
- **Snippets** (1): [Minimal Bucket With Pulumi Python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)
- **Scripts** (4): [Install Pulumi Cli And Init Project](../plm/scripts/2026-09-19-install-pulumi-cli-and-init-project.sh), [Create S3 Bucket With Pulumi](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py), [Network Component Vpc Subnets](../plm/scripts/network-component-vpc-subnets.py)
  - _…and 1 more under `Pulumi/` — browse the folder._
- **Configs** (3): [Minimal Pulumi Project And Stack Config](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml), [Minimal Project And Stack Config](../plm/configs/minimal-project-and-stack-config.yaml), [Pulumi Yaml And Stack Config Reference](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml)
- **Templates** (13): [Pulumi.dev](../Pulumi/templates/pulumi-python-project-scaffold/Pulumi.dev.yaml), [Pulumi.prod](../Pulumi/templates/pulumi-python-project-scaffold/Pulumi.prod.yaml), [Pulumi](../Pulumi/templates/pulumi-python-project-scaffold/Pulumi.yaml)
  - _…and 10 more under `Pulumi/` — browse the folder._

## Terraform · 74 files

- **primer:** [Terraform](../Terraform/notes/0000-primer-terraform.md)
- **Notes** (6): [Terraform](../Terraform/notes/0000-primer-terraform.md), [Exploring Terraform Cli](../Terraform/notes/2026-06-06-exploring-terraform-cli.md), [Terraform Getting Started](../Terraform/notes/2026-06-10-terraform-getting-started.md)
  - _…and 3 more under `Terraform/` — browse the folder._
- **Docs** (8): [Terraform Workspaces And Remote State Locking](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md), [Coverage Correction](../Terraform/docs/2026-09-17-coverage-correction.md), [How I Wired Terraform Workspaces And Remote State Locking](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md)
  - _…and 5 more under `Terraform/` — browse the folder._
- **Snippets** (3): [Scaffold S3 Bucket Module Remote State](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh), [Terraform Cli Exploration](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [Reusable Module For Each Validation](../Terraform/snippets/reusable-module-for-each-validation.hcl)
- **Scripts** (4): [Bootstrap Terraform Project](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh), [Generate Ansible Inventory From Terraform State](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py), [Install And Init](../Terraform/scripts/install-and-init.sh)
  - _…and 1 more under `Terraform/` — browse the folder._
- **Configs** (10): [Tried Local With Vars](../Terraform/configs/2026-06-12-tried-local-with-vars.tf), [Local File Random Provider](../Terraform/configs/2026-09-19-local-file-random-provider.hcl), [Local File](../Terraform/configs/local-file.tf)
  - _…and 7 more under `Terraform/` — browse the folder._
- **Manifests** (2): [Reusable Vpc Module](../Terraform/manifests/reusable-vpc-module.hcl), [Simple Ec2 App](../Terraform/manifests/simple-ec2-app.tf)
- **Notebooks** (2): [Comparing For Each Vs Count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb), [Comparing Terraform Vs Opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb)
- **Templates** (39): [Readme](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/README.md), [Backend](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/environments/dev/backend.tf), [Terraform](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/environments/dev/terraform.tfvars)
  - _…and 36 more under `Terraform/` — browse the folder._

## Trivy · 17 files

- **primer:** [Trivy](../Trivy/notes/0000-primer-trivy.md)
- **Notes** (5): [Trivy](../Trivy/notes/0000-primer-trivy.md), [Exploring Trivy Cli](../Trivy/notes/2026-06-25-exploring-trivy-cli.md), [Trivy Quickstart Trip Ups](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)
  - _…and 2 more under `Trivy/` — browse the folder._
- **Docs** (2): [Choosing Scan Modes And Pipeline Wiring](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md), [Trivy Sbom Generation And Vulnerability Reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md)
- **Snippets** (2): [Trivy Python Wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py), [Scan Image Fail Critical Cves](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py)
- **Scripts** (5): [Scanned First Container Image](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh), [Install Trivy And Scan Filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh), [Scan Images From File Consolidated Sarif](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)
  - _…and 2 more under `Trivy/` — browse the folder._
- **Configs** (3): [Trivy Config](../Trivy/configs/2026-08-12-trivy-config.yaml), [Trivy Config With Scan Policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [Trivy Operator Admission Control](../Trivy/configs/trivy-operator-admission-control.yaml)

## Foundational Concepts

- **CI/CD Concepts** · 9 files
  - **primer:** [CI/CD Concepts](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
  - [Artifact Promotion Gates Rollbacks](../docs/concepts/ci-cd-concepts/2026-08-10-artifact-promotion-gates-rollbacks.md)
  - [Artifact Promotion Environment Rollbacks](../docs/concepts/ci-cd-concepts/docs/artifact-promotion-environment-rollbacks.md)
  - [Ephemeral Preview Environments Gated Promotion](../docs/concepts/ci-cd-concepts/docs/ephemeral-preview-environments-gated-promotion.md)
  - _…and 5 more under `docs/concepts/ci-cd-concepts/` — browse the folder._

- **Containerization Concepts** · 8 files
  - **primer:** [Containerization Concepts](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
  - [Smaller Images Base Caching Runtimes](../docs/concepts/containerization-concepts/docs/2026-08-08-smaller-images-base-caching-runtimes.md)
  - [Image Scanning And Signing In A Build Pipeline](../docs/concepts/containerization-concepts/docs/image-scanning-and-signing-in-a-build-pipeline.md)
  - [Container Network Topology Service Discovery](../docs/concepts/containerization-concepts/notebooks/container-network-topology-service-discovery.ipynb)
  - _…and 4 more under `docs/concepts/containerization-concepts/` — browse the folder._

- **Infrastructure as Code Concepts** · 7 files
  - **primer:** [Infrastructure as Code Concepts](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
  - [Terraform Ansible Division Of Responsibility](../docs/concepts/infrastructure-as-code-concepts/docs/2026-08-08-terraform-ansible-division-of-responsibility.md)
  - [Terraform Docker Integration Patterns](../docs/concepts/infrastructure-as-code-concepts/docs/terraform-docker-integration-patterns.md)
  - [Declarative Vs Imperative Iac](../docs/concepts/infrastructure-as-code-concepts/notebooks/2026-08-08-declarative-vs-imperative-iac.ipynb)
  - _…and 3 more under `docs/concepts/infrastructure-as-code-concepts/` — browse the folder._

- **Linux & System Administration** · 8 files
  - **primer:** [Linux & System Administration](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
  - [Process And Permission Patterns In Devops](../docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md)
  - [Systemd Timers Journald Shipping](../docs/concepts/linux-system-administration/docs/systemd-timers-journald-shipping.md)
  - [Linux System Performance Analysis](../docs/concepts/linux-system-administration/notebooks/linux-system-performance-analysis.ipynb)
  - _…and 4 more under `docs/concepts/linux-system-administration/` — browse the folder._

- **Monitoring & Observability Concepts** · 8 files
  - **primer:** [Monitoring & Observability Concepts](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
  - [Combining Metrics Logs Traces Observability](../docs/concepts/monitoring-observability-concepts/docs/2026-08-09-combining-metrics-logs-traces-observability.md)
  - [Cicd Pipeline Health Telemetry Dora Deployment Markers](../docs/concepts/monitoring-observability-concepts/docs/cicd-pipeline-health-telemetry-dora-deployment-markers.md)
  - [Scraping Endpoint Three Pillars](../docs/concepts/monitoring-observability-concepts/notebooks/2026-08-11-scraping-endpoint-three-pillars.ipynb)
  - _…and 4 more under `docs/concepts/monitoring-observability-concepts/` — browse the folder._

- **Networking Fundamentals** · 11 files
  - **primer:** [Networking Fundamentals](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
  - [Dns Tls Load Balancing Visualization](../docs/concepts/networking-fundamentals/notebooks/2026-08-10-dns-tls-load-balancing-visualization.ipynb)
  - [Network Health Telemetry Visualization](../docs/concepts/networking-fundamentals/notebooks/network-health-telemetry-visualization.ipynb)
  - [Network Troubleshooting Patterns](../docs/concepts/networking-fundamentals/notes/2026-08-07-network-troubleshooting-patterns.md)
  - _…and 7 more under `docs/concepts/networking-fundamentals/` — browse the folder._

- **Scripting & Automation (Bash/Python)** · 11 files
  - **primer:** [Scripting & Automation (Bash/Python)](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
  - [Combining Scripting With Iac Automation Patterns](../docs/concepts/scripting-automation-bash-python/docs/combining-scripting-with-iac-automation-patterns.md)
  - [Site](../docs/concepts/scripting-automation-bash-python/docs/site.yml)
  - [Bash Python Glue Patterns](../docs/concepts/scripting-automation-bash-python/notebooks/2026-08-11-bash-python-glue-patterns.ipynb)
  - _…and 7 more under `docs/concepts/scripting-automation-bash-python/` — browse the folder._

- **Version Control Concepts** · 10 files
  - **primer:** [Version Control Concepts](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
  - [Trunk Based Delivery Short Lived Branches](../docs/concepts/version-control-concepts/2026-09-25-trunk-based-delivery-short-lived-branches.md)
  - [Branch Protection Merge Strategies Release Automation](../docs/concepts/version-control-concepts/docs/branch-protection-merge-strategies-release-automation.md)
  - [Terraform Modules Environment Promotion](../docs/concepts/version-control-concepts/docs/terraform-modules-environment-promotion.md)
  - _…and 6 more under `docs/concepts/version-control-concepts/` — browse the folder._

## docs (kit notes)

Notes about the kit itself, kept alongside the content they refer to. Browse `docs/`.
- [Removed Dead General References](../docs/2026-07-11-removed-dead-general-references.md)
- [Ansible Notebooks Readme Verified](../docs/2026-07-19-ansible-notebooks-readme-verified.md)
- [Audit 004 Check](../docs/2026-07-19-audit-004-check.md)
- [Kubernetes Readme Tree Update](../docs/2026-07-21-kubernetes-readme-tree-update.md)

## docs/audit

Audit notes tracking README, coverage, and topic-map corrections. Browse `docs/audit/`.
- [Coverage Table Audit](../docs/audit/2026-08-18-coverage-table-audit.md)
- [Audit 009 Github Readme](../docs/audit/2026-08-20-audit-009-github-readme.md)
- [Audit 011 Opentofu Readme](../docs/audit/2026-08-20-audit-011-opentofu-readme.md)
- [Audit 012 Docker Dockerfile Count](../docs/audit/2026-09-07-audit-012-docker-dockerfile-count.md)
- _…and 3 more under `docs/audit/` — browse the folder._
