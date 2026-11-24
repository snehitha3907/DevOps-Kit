# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## AWS · 25 files

- **primer:** [AWS CLI — quick primer](../AWS/notes/0000-primer-aws.md)

- **Notes** (2): [AWS primer already exists](../AWS/notes/2026-07-13-primer-already-exists.md), [AWS CLI — quick primer](../AWS/notes/0000-primer-aws.md)

- **Docs** (2): [IAM policy walkthrough: scoping least-privilege for a small app stack](../AWS/docs/iam-policy-least-privilege-walkthrough.md), [IAM cross-account roles with least privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md)

- **Snippets** (3): [List And Tag Ec2 Instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [Create S3 Bucket And Upload Object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py), [List Ec2 And S3](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)

- **Scripts** (7): [Aws Cli Quickstart Walkthrough](../AWS/scripts/2026-08-14-aws-cli-quickstart-walkthrough.sh), [Install Aws Cli V2 And Configure App Default](../AWS/scripts/2026-08-13-install-aws-cli-v2-and-configure-app-default.sh), [Vpc With Private Endpoints](../AWS/scripts/vpc-with-private-endpoints.py)
  - _…and 4 more under `AWS/` — browse the folder._

- **Configs** (3): [Ecs Service Deployment Blue Green](../AWS/configs/ecs-service-deployment-blue-green.yaml), [Minimal Aws Config](../AWS/configs/2026-07-13-minimal-aws-config.ini), [Minimal Aws Config](../AWS/configs/2026-07-12-minimal-aws-config.ini)

- **Notebooks** (1): [Comparing Deployment Approaches Boto3 Cloudformation Cdk](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)

- **Templates** (7): [Main](../aws/templates/aws-control-tower-landing-zone/main.tf), [Variables](../aws/templates/aws-control-tower-landing-zone/variables.tf), [Outputs](../aws/templates/aws-control-tower-landing-zone/outputs.tf)
  - _…and 4 more under `AWS/` — browse the folder._


## Ansible · 114 files

- **primer:** [Ansible — quick primer](../Ansible/notes/0000-primer-ansible.md)

- **Notes** (10): [What tripped me up running my first Ansible playbook](../Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md), [Exploring Ansible CLI](../Ansible/notes/2026-06-06-exploring-ansible-cli.md), [Following Ansible Getting Started Guide](../Ansible/notes/2026-06-11-ansible-getting-started.md)
  - _…and 7 more under `Ansible/` — browse the folder._

- **Docs** (7): [Ansible over Terraform local-exec for post-provisioning tasks](../Ansible/docs/ansible-over-terraform-local-exec.md), [Ansible 14 and ansible-core 2.21 migration guide](../Ansible/docs/ansible-14-core-2-21-migration-guide.md), [Integrating Ansible with Network Devices](../Ansible/docs/integrating-ansible-with-network-devices.md)
  - _…and 4 more under `Ansible/` — browse the folder._

- **Snippets** (2): [Nginx Playbook](../Ansible/snippets/nginx-playbook.yaml), [Lint Ansible Playbook](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py)

- **Scripts** (4): [Scan Ansible Antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py), [Install And First Adhoc](../Ansible/scripts/install-and-first-adhoc.sh), [Run First Playbook](../Ansible/scripts/run-first-playbook.sh)
  - _…and 1 more under `Ansible/` — browse the folder._

- **Configs** (10): [Nginx Phpfpm Ufw Ubuntu](../Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml), [Docker Lifecycle Playbook](../Ansible/configs/docker-lifecycle-playbook.yml), [Awx Job Template And Credential Config](../Ansible/configs/awx-job-template-and-credential-config.yaml)
  - _…and 7 more under `Ansible/` — browse the folder._

- **Manifests** (10): [Playbook Migration](../ans/manifests/playbook-migration.yaml), [Main](../Ansible/manifests/roles/webserver/handlers/main.yaml), [Main](../Ansible/manifests/roles/webserver/tasks/main.yaml)
  - _…and 7 more under `Ansible/` — browse the folder._

- **Notebooks** (2): [Comparing Execution Patterns Block Rescue Serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb), [Ansible Variable Precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb)

- **Dockerfiles** (1): [Ansible Control Node](../Ansible/dockerfiles/ansible-control-node.Dockerfile)

- **Templates** (68): [Site.conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/site.conf.j2), [Main](../Ansible/templates/production-ansible-project/roles/webserver/vars/main.yml), [Nginx.conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/nginx.conf.j2)
  - _…and 65 more under `Ansible/` — browse the folder._


## ArgoCD · 27 files

- **primer:** [ArgoCD — quick primer](../ArgoCD/notes/0000-primer-argocd.md)

- **Notes** (3): [Install](../ArgoCD/notes/install.yaml), [ArgoCD quickstart — what tripped me up](../ArgoCD/notes/2026-08-11-argocd-quickstart.md), [ArgoCD — quick primer](../ArgoCD/notes/0000-primer-argocd.md)

- **Docs** (2): [How I wired ArgoCD with GitHub for GitOps deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md), [Argo CD with HashiCorp Vault and External Secrets: keeping secrets out of Git, plus RBAC, notification and webhook patterns that hold up in production](../ArgoCD/docs/argocd-vault-external-secrets.md)

- **Snippets** (1): [Sync App And Verify Health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)

- **Scripts** (3): [Argocd Application Helper](../ArgoCD/scripts/argocd-application-helper.py), [Build Argocd Application From Scratch](../ArgoCD/scripts/build-argocd-application-from-scratch.sh), [Install Argocd And Access Ui](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)

- **Configs** (3): [Guestbook Applicationset](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml), [Guestbook Applicationset Multi Cluster](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml), [First Application Manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)

- **Manifests** (2): [Multi Cluster Fleet Applicationset](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml), [Deployment](../ArgoCD/manifests/guestbook/deployment.yaml)

- **Templates** (13): [Values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/values.yaml), [Kustomization](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/kustomization.yaml), [Values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/prod/values.yaml)
  - _…and 10 more under `ArgoCD/` — browse the folder._


## Azure · 28 files

- **primer:** [Azure CLI — quick primer](../Azure/notes/0000-primer-azure.md)

- **Notes** (4): [Azure CLI quickstart — what tripped me up](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md), [First Azure CLI login + resource list](../Azure/notes/2026-09-18-first-login-and-resource-list.md), [Azure quickstart — what tripped me up](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md)
  - _…and 1 more under `Azure/` — browse the folder._

- **Docs** (2): [Comparing Azure CLI, Bicep, and the Python SDK for provisioning a small app stack](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md), [Azure DevOps pipeline integration with Bicep deployments](../Azure/docs/azure-devops-pipeline-bicep-integration.md)

- **Snippets** (3): [Create Vnet Nsg And Linux Vm](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh), [Create Resource Group And List Regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [Create Resource Group And List Regions](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)

- **Scripts** (5): [Resource Group Cleanup](../Azure/scripts/resource-group-cleanup.sh), [Provision Resource Group And Storage Account](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh), [Azure Vm Scale Set Autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
  - _…and 2 more under `Azure/` — browse the folder._

- **Configs** (2): [Azure Key Vault Access Policy](../az/configs/azure-key-vault-access-policy.json), [Container Apps Microservices](../Azure/configs/container-apps-microservices.yaml)

- **Manifests** (2): [Container Apps Multi Service Deployment](../az/manifests/container-apps-multi-service-deployment.yaml), [Production Aks Cluster](../Azure/manifests/production-aks-cluster.bicep)

- **Templates** (10): [Aks Cluster](../Azure/templates/aks-cluster-with-addons/modules/aks-cluster.bicep), [Keyvault Provider](../Azure/templates/aks-cluster-with-addons/modules/addons/keyvault-provider.bicep), [Network Policy](../Azure/templates/aks-cluster-with-addons/modules/addons/network-policy.bicep)
  - _…and 7 more under `Azure/` — browse the folder._


## Docker · 58 files

- **primer:** [Docker — quick primer](../Docker/notes/0000-primer-docker.md)

- **Notes** (6): [Docker Get Started tutorial — what tripped me up](../Docker/notes/2026-08-12-docker-tutorial-tripups.md), [Exploring Docker CLI](../Docker/notes/2026-06-05-explore-docker-cli.md), [Exploring the Docker CLI — images, containers, and Docker Hub](../Docker/notes/2026-06-06-exploring-docker-cli.md)
  - _…and 3 more under `Docker/` — browse the folder._

- **Docs** (11): [Docker production hardening runbook](../docker/docs/docker-production-hardening-runbook.md), [Docker Compose](../Docker/docs/docker-compose.yml), [Docker build --mount vs COPY for dependency caching in multi-stage builds](../Docker/docs/docker-build-mount-vs-copy-caching.md)
  - _…and 8 more under `Docker/` — browse the folder._

- **Snippets** (2): [Analyze Image Layers](../Docker/snippets/analyze-image-layers.py), [Build Run And Cleanup](../Docker/snippets/2026-08-12-build-run-and-cleanup.py)

- **Scripts** (5): [Install And Run First Container](../Docker/scripts/install-and-run-first-container.sh), [Install And Run Container](../Docker/scripts/install-and-run-container.sh), [Docker Health Check And Cleanup](../Docker/scripts/docker-health-check-and-cleanup.sh)
  - _…and 2 more under `Docker/` — browse the folder._

- **Configs** (1): [Multi Service App](../Docker/configs/multi-service-app.yaml)

- **Manifests** (9): [Production Docker Deployment With Ha](../docker/manifests/production-docker-deployment-with-ha.yaml), [Docker Compose Multi Stage](../docker/manifests/docker-compose-multi-stage.yaml), [App Postgres Healthchecks.compose](../Docker/manifests/app-postgres-healthchecks.compose.yaml)
  - _…and 6 more under `Docker/` — browse the folder._

- **Notebooks** (3): [Comparing Docker Networking Drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb), [Comparing Docker Build Strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb), [Comparing Compose Swarm Kubernetes Local Orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb)

- **Dockerfiles** (9): [Simple Go Server](../Docker/dockerfiles/simple-go-server.Dockerfile), [Tried Building First Image](../Docker/dockerfiles/tried-building-first-image.Dockerfile), [Production Ready Go Http Server](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
  - _…and 6 more under `Docker/` — browse the folder._

- **Templates** (12): [Compose](../Docker/templates/multi-service-compose-with-healthchecks/compose.yaml), [Dockerfile](../Docker/templates/multi-service-compose-with-healthchecks/app/Dockerfile), [App](../Docker/templates/multi-service-compose-with-healthchecks/app/app.py)
  - _…and 9 more under `Docker/` — browse the folder._


## Flux CD · 8 files

- **Notes** (2): [Flux quickstart, and what tripped me up](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md), [Exploring the Flux CLI command surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)

- **Docs** (2): [Wiring Flux CD with GitHub for GitOps Deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md), [Flux CD: README Coverage table and topics.md update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md)

- **Scripts** (2): [Bootstrap Flux On Kind](../FluxCD/scripts/bootstrap-flux-on-kind.sh), [Install Flux Cli And Run Flux Check Pre](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)

- **Configs** (2): [Helmrelease Image Automation](../FluxCD/configs/helmrelease-image-automation.yaml), [Minimal Gitrepository And Kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)


## GCP · 15 files

- **primer:** [Google Cloud SDK — quick primer](../GCP/notes/0000-primer-gcp.md)

- **Notes** (2): [Following the gcloud quickstart — what tripped me up](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md), [Google Cloud SDK — quick primer](../GCP/notes/0000-primer-gcp.md)

- **Docs** (1): [GCP/ coverage note — 2026-09-28](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)

- **Snippets** (2): [List Compute And Gcs With Gcloud](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh), [List Compute And Gcs With Gcloud](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)

- **Scripts** (6): [Cloud Run Terraform From Scratch](../gcp/scripts/cloud-run-terraform-from-scratch.py), [Launch Vm Firewall And Ssh](../GCP/scripts/2026-09-21-launch-vm-firewall-and-ssh.sh), [Install Gcloud Cli And Configure Creds](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)
  - _…and 3 more under `GCP/` — browse the folder._

- **Configs** (4): [Gcloud Iam Config](../gcp/configs/gcloud-iam-config.yaml), [Instance Template With Startup Script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml), [Service Account And Iam Config](../GCP/configs/service-account-and-iam-config.yaml)
  - _…and 1 more under `GCP/` — browse the folder._


## Git · 85 files

- **primer:** [Git — quick primer](../Git/notes/0000-primer-git.md)

- **Notes** (6): [Exploring the Git CLI — init, add, commit, log](../Git/notes/2026-06-04-explore-git-cli.md), [Installing Git — first try](../Git/notes/2026-06-04-install-git.md), [Git branching tutorial — what tripped me up](../Git/notes/2026-08-11-git-branching-tutorial.md)
  - _…and 3 more under `Git/` — browse the folder._

- **Docs** (15): [Git — production rollback and recovery runbook](../git/docs/git-production-rollback-and-recovery-runbook.md), [Wiring Git hooks into a pre-commit workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md), [Worktree workflows: parallel branches without stash juggling](../Git/docs/worktree-workflows-parallel-branches.md)
  - _…and 12 more under `Git/` — browse the folder._

- **Snippets** (1): [First Commit](../Git/snippets/first-commit.sh)

- **Scripts** (14): [Pre Receive Hook Integrity And Quota Enforcement](../git/scripts/pre-receive-hook-integrity-and-quota-enforcement.sh), [Changelog From Conventional Commits](../Git/scripts/changelog-from-conventional-commits.py), [Minimal Branching Workflow](../Git/scripts/minimal-branching-workflow.sh)
  - _…and 11 more under `Git/` — browse the folder._

- **Notebooks** (3): [Merge Rebase Squash Comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb), [Merge Rebase Squash Comparison](../Git/notebooks/merge-rebase-squash-comparison.ipynb), [Comparing Git Merge Strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb)

- **Templates** (46): [Install Hooks](../Git/templates/git-workflow-automation/scripts/install-hooks.sh), [Semantic Version](../Git/templates/git-workflow-automation/scripts/semantic-version.sh), [Setup Workflow](../Git/templates/git-workflow-automation/scripts/setup-workflow.sh)
  - _…and 43 more under `Git/` — browse the folder._


## GitHub · 56 files

- **primer:** [GitHub — quick primer](../GitHub/notes/0000-primer-github.md)

- **Notes** (11): [Following the GitHub CLI quickstart](../GitHub/notes/2026-06-11-following-github-cli-quickstart.md), [Repos, issues, and PRs — first look](../GitHub/notes/2026-06-10-repos-issues-and-prs.md), [Exploring the GitHub web UI — profile, repo creation, and issues](../GitHub/notes/2026-06-15-explore-github-web-ui.md)
  - _…and 8 more under `GitHub/` — browse the folder._

- **Docs** (7): [GitHub release automation: tags, milestones, and Releases end-to-end](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md), [How I set up branch protection rules and required reviews for CI](../GitHub/docs/branch-protection-and-required-reviews-for-ci.md), [Protection](../GitHub/docs/protection.json)
  - _…and 4 more under `GitHub/` — browse the folder._

- **Snippets** (3): [List Repos With Python](../GitHub/snippets/list-repos-with-python.py), [Open Pr And Wait For Ci](../GitHub/snippets/open-pr-and-wait-for-ci.sh), [Github Issues Api](../GitHub/snippets/github-issues-api.py)

- **Scripts** (7): [Tried Auth And Profile](../GitHub/scripts/tried-auth-and-profile.sh), [Tried Commenting On First Issue](../GitHub/scripts/tried-commenting-on-first-issue.sh), [Provision Repo With Api](../GitHub/scripts/provision-repo-with-api.py)
  - _…and 4 more under `GitHub/` — browse the folder._

- **Configs** (7): [Issue Templates And Labels](../GitHub/configs/issue-templates-and-labels.yaml), [Labels](../GitHub/configs/dot-github-repository/labels.yaml), [Stale](../GitHub/configs/dot-github-repository/stale.yml)
  - _…and 4 more under `GitHub/` — browse the folder._

- **Manifests** (1): [Github Environments Deployment Protection](../GitHub/manifests/github-environments-deployment-protection.yaml)

- **Notebooks** (2): [Comparing Api Approaches Release Automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb), [Analyzing Github Actions Usage Across Org Repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb)

- **Dockerfiles** (1): [Self Hosted Runner](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)

- **Templates** (17): [Compliance Checklist](../GitHub/templates/github-security-compliance/COMPLIANCE.md), [Security Policy](../GitHub/templates/github-security-compliance/SECURITY.md), [GitHub Repository Security & Compliance Template](../GitHub/templates/github-security-compliance/README.md)
  - _…and 14 more under `GitHub/` — browse the folder._


## GitHub Actions · 26 files

- **primer:** [GitHub Actions — quick primer](../GitHub Actions/notes/0000-primer-github-actions.md)

- **Notes** (5): [GitHub Actions quickstart — what tripped me up](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md), [Ci](../GitHub Actions/notes/ci.yml), [GitHub Actions primer already exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)
  - _…and 2 more under `GitHub Actions/` — browse the folder._

- **Docs** (7): [Choosing between artifacts, cache, and external storage for build outputs in GitHub Actions](../GitHub Actions/docs/choosing-between-artifacts-cache-external-storage.md), [Ci](../GitHub Actions/docs/ci.yml), [GitHub Actions quickstart — what tripped me up](../GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md)
  - _…and 4 more under `GitHub Actions/` — browse the folder._

- **Snippets** (1): [Trigger Workflow Dispatch Poll Status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)

- **Scripts** (4): [Install Gh Actions Extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh), [Manage Secrets Across Repos](../GitHub Actions/scripts/manage-secrets-across-repos.py), [Self Hosted Runner Registration Cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh)
  - _…and 1 more under `GitHub Actions/` — browse the folder._

- **Configs** (5): [First Ci Workflow Hello](../GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml), [Reusable Deployment Workflow Environment Gates Approval](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml), [Matrix Node Workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml)
  - _…and 2 more under `GitHub Actions/` — browse the folder._

- **Dockerfiles** (1): [Custom Runner](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)

- **Templates** (3): [Deploy Caller](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml), [Reusable Deploy](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml), [Multi-environment deploy template](../GitHub Actions/templates/multi-env-deploy/README.md)


## GitLab CI · 25 files

- **primer:** [GitLab CI/CD — quick primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)

- **Notes** (4): [Following the GitLab CI/CD quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md), [GitLab CI/CD — quick primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md), [GitLab CI/CD quickstart — runner setup, variables, and artifacts trip-ups](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md)
  - _…and 1 more under `GitLab CI/` — browse the folder._

- **Docs** (2): [GitLab CI/CD with Kubernetes — end-to-end walkthrough](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md), [GitLab CI/CD pipeline library patterns](../GitLab CI/docs/gitlab-ci-cd-pipeline-library-patterns.md)

- **Snippets** (1): [Trigger Pipeline And Poll Jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)

- **Scripts** (5): [Dynamic Child Pipeline](../GitLab CI/scripts/dynamic-child-pipeline.sh), [Run First Local Pipeline](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh), [Local Ci Pipeline Validator](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh)
  - _…and 2 more under `GitLab CI/` — browse the folder._

- **Configs** (4): [Multi Project Pipeline With Triggers](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml), [Minimal Gitlab Ci Docker Build Deploy Kubernetes](../GitLab CI/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml), [Minimal Pipeline Stages Cache Artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
  - _…and 1 more under `GitLab CI/` — browse the folder._

- **Dockerfiles** (1): [Gitlab Runner Dind Kaniko](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)

- **Templates** (8): [Modular GitLab CI/CD pipeline repository](../GitLab CI/templates/modular-pipeline-repo/README.md), [Lib](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/lib.yml), [Helpers](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/helpers.sh)
  - _…and 5 more under `GitLab CI/` — browse the folder._


## Grafana · 13 files

- **primer:** [Grafana — quick primer](../graf/notes/0000-primer-grafana.md)

- **Notes** (4): [Poking around the Grafana UI — data sources, panels, dashboards](../graf/notes/2026-09-25-explore-grafana-ui.md), [2026-09-29-grafana-quickstart-trip-ups.md](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md), [Grafana quickstart — what tripped me up](../graf/notes/2026-10-13-grafana-quickstart-trip-ups.md)
  - _…and 1 more under `Grafana/` — browse the folder._

- **Docs** (3): [How I wired Grafana into Prometheus and Alertmanager for unified metrics and alert visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md), [graf/ navigation dedup note — 2026-09-25](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [graf/ coverage note — 2026-09-25](../graf/docs/2026-09-25-grafana-coverage-and-topics.md)

- **Scripts** (2): [Build Multi Panel Service Dashboard Via Http Api](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py), [Install Grafana With Docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)

- **Configs** (4): [Minimal Datasource Dashboard Provisioning](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml), [Dashboards Provider](../Grafana/configs/dashboards-provider.yaml), [Prometheus Datasource](../Grafana/configs/prometheus-datasource.yaml)
  - _…and 1 more under `Grafana/` — browse the folder._


## Grafana Cloud · 8 files

- **Notes** (2): [Grafana Cloud quickstart — what tripped me up](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md), [My first hosted dashboard in Grafana Cloud](../grafc/notes/2026-09-30-first-hosted-dashboard.md)

- **Snippets** (1): [First Dashboard Over Http](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)

- **Scripts** (1): [Create Stack And Send Metrics](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)

- **Configs** (4): [Prometheus Remote Write Grafana Cloud](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml), [Minimal Metrics Scrape Config](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml), [Prometheus Remote Write Grafana Cloud](../Grafana Cloud/configs/prometheus-remote-write-grafana-cloud.yaml)
  - _…and 1 more under `Grafana Cloud/` — browse the folder._


## HashiCorp Vault · 12 files

- **primer:** [HashiCorp Vault — quick primer](../vlt/notes/0000-primer-vlt.md)

- **Notes** (3): [Exploring the vault CLI — secrets, policies, and what's there](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md), [Vault dev-mode quickstart — what tripped me up](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md), [HashiCorp Vault — quick primer](../vlt/notes/0000-primer-vlt.md)

- **Docs** (2): [Wiring Vault Agent into a containerized app for secret injection](../vlt/docs/vault-agent-secret-injection.md), [Document vlt/ in README Layout + Coverage table and topics.md](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md)

- **Scripts** (4): [Dynamic Database Credentials](../vlt/scripts/dynamic-database-credentials.py), [Install Vault And First Secrets Engine](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh), [Write Read List Kv V2 Secret](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py)
  - _…and 1 more under `HashiCorp Vault/` — browse the folder._

- **Configs** (3): [Vault Approle](../vlt/configs/vault-approle.hcl), [Minimal Read Only Policy Bound To Group](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl), [App Read Only Policy](../Vault/configs/app-read-only-policy.hcl)


## Helm · 63 files

- **primer:** [Helm — quick primer](../Helm/notes/0000-primer-helm.md)

- **Notes** (3): [Helm quickstart — what tripped me up](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [Values](../Helm/notes/values.yaml), [Helm — quick primer](../Helm/notes/0000-primer-helm.md)

- **Docs** (6): [Helm chart testing strategies](../Helm/docs/helm-chart-testing-strategies.md), [Helm chart testing with chart-testing and `ct lint`](../Helm/docs/chart-testing-ct-lint.md), [Add Helm/ folder to DevOps-Kit README Layout and Coverage table](../Helm/docs/2026-07-25-add-helm-to-readme-layout-and-coverage.md)
  - _…and 3 more under `Helm/` — browse the folder._

- **Snippets** (1): [Nginx Helm Chart Custom Values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)

- **Scripts** (5): [Dummy Test](../Helm/scripts/dummy-test.sh), [Helm Dep Validate](../Helm/scripts/helm-dep-validate.go), [Validate Chart Values Across Environments](../Helm/scripts/validate-chart-values-across-environments.sh)
  - _…and 2 more under `Helm/` — browse the folder._

- **Configs** (5): [Live Values](../Helm/configs/2026-08-29-live-values.yaml), [Multi Cluster Gitops Values](../Helm/configs/multi-cluster-gitops-values.yaml), [Live Release Values](../Helm/configs/2026-09-02-live-release-values.yaml)
  - _…and 2 more under `Helm/` — browse the folder._

- **Manifests** (15): [Values](../Helm/manifests/redis-chart/values.yaml), [Service](../Helm/manifests/redis-chart/templates/service.yaml), [Deployment](../Helm/manifests/redis-chart/templates/deployment.yaml)
  - _…and 12 more under `Helm/` — browse the folder._

- **Notebooks** (1): [Release Lifecycle Drill](../Helm/notebooks/release-lifecycle-drill.ipynb)

- **Templates** (27): [Values.schema](../Helm/templates/microservice-chart/values.schema.json), [Values](../Helm/templates/microservice-chart/values.yaml), [Ingress](../Helm/templates/microservice-chart/templates/ingress.yaml)
  - _…and 24 more under `Helm/` — browse the folder._


## Jenkins · 4 files

- **primer:** [Jenkins — quick primer](../jnk/notes/0000-primer-jenkins.md)

- **Notes** (2): [Jenkins — install and run my first CLI command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md), [Jenkins — quick primer](../jnk/notes/0000-primer-jenkins.md)

- **Scripts** (2): [Jenkinsfile](../Jenkins/scripts/Jenkinsfile), [Trigger First Jenkins Job Via Cli](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)


## Kubernetes · 104 files

- **primer:** [Kubernetes — quick primer](../Kubernetes/notes/0000-primer-kubernetes.md)

- **Notes** (10): [Kubernetes — Install kubectl and explore my first cluster (L1 notes)](../k8s/notes/2026-10-27-install-kubectl-and-explore-first-cluster.md), [Installing kubectl and minikube — first Pod](../Kubernetes/notes/2026-09-04-kubectl-minikube-first-pod.md), [Following the Kubernetes interactive tutorial](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)
  - _…and 7 more under `Kubernetes/` — browse the folder._

- **Docs** (6): [Kubernetes Service Mesh Comparison: Istio vs Linkerd vs Consul for Enterprise Traffic Management](../k8s/docs/kubernetes-service-mesh-comparison.md), [Ingress](../Kubernetes/docs/ingress.yaml), [Kubernetes ingress with path-based routing for multiple services](../Kubernetes/docs/ingress-path-based-routing.md)
  - _…and 3 more under `Kubernetes/` — browse the folder._

- **Snippets** (2): [Pod Troubleshoot Shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh), [First Pod And Service With Kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh)

- **Scripts** (5): [Rollout Status And Pod Readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh), [Pod Lifecycle](../Kubernetes/scripts/pod-lifecycle.sh), [Inject Failure](../Kubernetes/scripts/inject-failure.sh)
  - _…and 2 more under `Kubernetes/` — browse the folder._

- **Configs** (2): [Incident Runbook](../Kubernetes/configs/incident-runbook.yaml), [Deployment Service Go App With Probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)

- **Manifests** (7): [Deploy My First Nginx Pod With Kubectl](../k8s/manifests/2026-10-27-deploy-my-first-nginx-pod-with-kubectl.yaml), [Production Deployment Hpa Pdb Networkpolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml), [Stateless App](../Kubernetes/manifests/stateless-app.yaml)
  - _…and 4 more under `Kubernetes/` — browse the folder._

- **Notebooks** (2): [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb), [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)

- **Templates** (70): [Logging Loki](../k8s/templates/workload-clusters/cluster-resource-sets/logging-loki.yaml), [Security Falco Kyverno](../k8s/templates/workload-clusters/cluster-resource-sets/security-falco-kyverno.yaml), [Csi Azure Disk](../k8s/templates/workload-clusters/cluster-resource-sets/csi-azure-disk.yaml)
  - _…and 67 more under `Kubernetes/` — browse the folder._


## OpenTelemetry · 12 files

- **primer:** [OpenTelemetry — quick primer](../otel/notes/0000-primer-opentelemetry.md)

- **Notes** (2): [Following the OpenTelemetry quickstart — what tripped me up](../otel/notes/2026-09-30-quickstart-trip-ups.md), [OpenTelemetry — quick primer](../otel/notes/0000-primer-opentelemetry.md)

- **Docs** (2): [Context propagation with OpenTelemetry: W3C tracecontext vs B3](../otel/docs/context-propagation-w3c-vs-b3.md), [otel/ coverage note — 2026-09-25](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md)

- **Snippets** (2): [Instrumented Http Server](../otel/snippets/2026-09-30-instrumented-http-server.go), [First Trace Span](../otel/snippets/2026-09-26-first-trace-span.py)

- **Scripts** (3): [Custom Span Processor Resource Detector](../otel/scripts/custom-span-processor-resource-detector.py), [Install Collector And Run Otlp Pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh), [Demo App](../OpenTelemetry/scripts/demo-app.py)

- **Configs** (3): [Collector Otlp Real Pipeline](../otel/configs/collector-otlp-real-pipeline.yaml), [Collector Otlp Export](../otel/configs/2026-09-30-collector-otlp-export.yaml), [Collector Debug](../OpenTelemetry/configs/collector-debug.yaml)


## OpenTofu · 19 files

- **primer:** [OpenTofu — quick primer](../OpenTofu/notes/0000-primer-opentofu.md)

- **Notes** (2): [Following the official OpenTofu quickstart — what tripped me up](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md), [OpenTofu — quick primer](../OpenTofu/notes/0000-primer-opentofu.md)

- **Docs** (4): [Backup](../OpenTofu/docs/backup.json), [OpenTofu Provider Development: Creating a Custom Provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md), [Wiring OpenTofu remote state to an S3 backend with workspace isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md)
  - _…and 1 more under `OpenTofu/` — browse the folder._

- **Scripts** (3): [S3 Dynamodb Remote State Bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh), [Tofu Plan Apply With Policy Checks](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh), [Install Opentofu And Verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)

- **Configs** (2): [Minimal Local Backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl), [Minimal Local Config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)

- **Notebooks** (2): [Comparing Opentofu And Terraform State Management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb), [Comparing Opentofu And Terraform Aws Provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)

- **Templates** (6): [Main](../OpenTofu/templates/aws-reusable-module/main.tf), [Versions](../OpenTofu/templates/aws-reusable-module/versions.tf), [Variables](../OpenTofu/templates/aws-reusable-module/variables.tf)
  - _…and 3 more under `OpenTofu/` — browse the folder._


## Prometheus · 40 files

- **primer:** [Prometheus — quick primer](../Prometheus/notes/0000-primer-prometheus.md)

- **Notes** (2): [Prometheus getting started — what tripped me up](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md), [Prometheus — quick primer](../Prometheus/notes/0000-primer-prometheus.md)

- **Docs** (4): [Integrating Prometheus with related tools](../pro/docs/integrating-prometheus-with-related-tools.md), [Prometheus recording rules and alert reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md), [Prometheus integration with Kubernetes: service discovery, pod annotations, kube-state-metrics, and managed Prometheus differences](../Prometheus/docs/prometheus-kubernetes-integration.md)
  - _…and 1 more under `Prometheus/` — browse the folder._

- **Snippets** (1): [Promql Target Health Check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)

- **Scripts** (6): [Prometheus Alerting Rule Validation](../pro/scripts/2026-10-29-prometheus-alerting-rule-validation.sh), [Custom App Exporter](../Prometheus/scripts/custom-app-exporter.py), [Custom App Metrics Collector](../Prometheus/scripts/custom-app-metrics-collector.go)
  - _…and 3 more under `Prometheus/` — browse the folder._

- **Configs** (5): [Recording Vs Alerting Rules](../Prometheus/configs/recording-vs-alerting-rules.yaml), [Minimal Container Monitoring Config](../Prometheus/configs/2026-09-05-minimal-container-monitoring-config.yml), [Prometheus Scrape Config And Remote Write Tuning](../Prometheus/configs/prometheus-scrape-config-and-remote-write-tuning.yaml)
  - _…and 2 more under `Prometheus/` — browse the folder._

- **Manifests** (3): [Prometheus Grafana Stack Deployment](../pro/manifests/prometheus-grafana-stack-deployment.yaml), [Production Prometheus Ha](../pro/manifests/production-prometheus-ha.yaml), [Production Prometheus Ha](../Prometheus/manifests/production-prometheus-ha.yaml)

- **Notebooks** (1): [Querying Prometheus With Promql Step Through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)

- **Templates** (18): [Validate Rules](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-rules.sh), [Recording](../Prometheus/templates/prometheus-project-scaffold/rules/recording.yml), [Validate Config](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-config.sh)
  - _…and 15 more under `Prometheus/` — browse the folder._


## Pulumi · 25 files

- **primer:** [Pulumi — quick primer](../plm/notes/0000-primer-plm.md)

- **Notes** (2): [Pulumi quickstart — what tripped me up](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md), [Pulumi — quick primer](../plm/notes/0000-primer-plm.md)

- **Docs** (2): [How I structured a multi-stack Pulumi project: dev/staging stacks, StackReference, and cross-stack resource wiring](../plm/docs/multi-stack-project-structure.md), [Document plm/ in README Layout + Coverage table](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md)

- **Snippets** (1): [Minimal Bucket With Pulumi Python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)

- **Scripts** (4): [Network Component Vpc Subnets](../plm/scripts/network-component-vpc-subnets.py), [Create S3 Bucket With Pulumi](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py), [Provision S3 Bucket With Pulumi Ts](../plm/scripts/provision-s3-bucket-with-pulumi-ts.ts)
  - _…and 1 more under `Pulumi/` — browse the folder._

- **Configs** (3): [Pulumi Yaml And Stack Config Reference](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml), [Minimal Project And Stack Config](../plm/configs/minimal-project-and-stack-config.yaml), [Minimal Pulumi Project And Stack Config](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml)

- **Templates** (13): [Tsconfig](../plm/templates/pulumi-typescript-project-scaffold/tsconfig.json), [Pulumi.prod](../plm/templates/pulumi-typescript-project-scaffold/Pulumi.prod.yaml), [Index](../plm/templates/pulumi-typescript-project-scaffold/index.ts)
  - _…and 10 more under `Pulumi/` — browse the folder._


## Terraform · 74 files

- **primer:** [Terraform — quick primer](../Terraform/notes/0000-primer-terraform.md)

- **Notes** (6): [Following the Terraform providers tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md), [Installing Terraform and my first plan/apply with local_file](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md), [Following the Terraform state management tutorial — what tripped me up](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md)
  - _…and 3 more under `Terraform/` — browse the folder._

- **Docs** (8): [Terraform vs OpenTofu Migration Guide](../tf/docs/terraform-vs-opentofu-migration-guide.md), [How I wired Terraform workspaces and remote state locking with S3 + DynamoDB](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md), [Terraform State Locking and Remote Backend Reference](../Terraform/docs/terraform-state-locking-remote-backend-reference.md)
  - _…and 5 more under `Terraform/` — browse the folder._

- **Snippets** (3): [Reusable Module For Each Validation](../Terraform/snippets/reusable-module-for-each-validation.hcl), [Terraform Cli Exploration](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [Scaffold S3 Bucket Module Remote State](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)

- **Scripts** (4): [Generate Ansible Inventory From Terraform State](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py), [Validate Provider Schema](../Terraform/scripts/validate-provider-schema.go), [Install And Init](../Terraform/scripts/install-and-init.sh)
  - _…and 1 more under `Terraform/` — browse the folder._

- **Configs** (10): [Terraform Module Version Pinning And Migration Plan](../Terraform/configs/terraform-module-version-pinning-and-migration-plan.hcl), [Main](../Terraform/configs/reusable-s3-module/main.tf), [Variables](../Terraform/configs/reusable-s3-module/variables.tf)
  - _…and 7 more under `Terraform/` — browse the folder._

- **Manifests** (2): [Simple Ec2 App](../Terraform/manifests/simple-ec2-app.tf), [Reusable Vpc Module](../Terraform/manifests/reusable-vpc-module.hcl)

- **Notebooks** (2): [Comparing Terraform Vs Opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb), [Comparing For Each Vs Count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)

- **Templates** (39): [Versions](../tf/templates/multi-environment-terraform-project-scaffold/versions.tf), [Variables](../tf/templates/multi-environment-terraform-project-scaffold/variables.tf), [Destroy](../tf/templates/multi-environment-terraform-project-scaffold/scripts/destroy.sh)
  - _…and 36 more under `Terraform/` — browse the folder._


## Trivy · 17 files

- **primer:** [Trivy — quick primer](../Trivy/notes/0000-primer-trivy.md)

- **Notes** (5): [Trivy quickstart — what tripped me up](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md), [Trivy quickstart — what tripped me up](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md), [Trivy CLI exploration — what can I scan and how do I read the output](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)
  - _…and 2 more under `Trivy/` — browse the folder._

- **Docs** (2): [Trivy SBOM Generation and Vulnerability Reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md), [Trivy scan modes — image vs fs vs repo vs sbom, with a pipeline example](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md)

- **Snippets** (2): [Scan Image Fail Critical Cves](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py), [Trivy Python Wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)

- **Scripts** (5): [Install Trivy And Scan Filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh), [Trivy Policy As Code Opa Rego](../Trivy/scripts/trivy-policy-as-code-opa-rego.sh), [Trivy Fs Repo Scan Workflow](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh)
  - _…and 2 more under `Trivy/` — browse the folder._

- **Configs** (3): [Trivy Operator Admission Control](../Trivy/configs/trivy-operator-admission-control.yaml), [Trivy Config With Scan Policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [Trivy Config](../Trivy/configs/2026-08-12-trivy-config.yaml)


## Foundational Concepts

- **CI/CD Concepts** · 9 files
  - **primer:** [CI/CD Concepts — quick primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
  - [8 more](../docs/concepts/ci-cd-concepts/) — [Parallelized Ci Stage Runner](../docs/concepts/ci-cd-concepts/snippets/2026-08-08-parallelized-ci-stage-runner.sh), [Cicd Common Patterns](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh), [Artifact Promotion Rollback](../docs/concepts/ci-cd-concepts/scripts/artifact-promotion-rollback.sh)

- **Containerization Concepts** · 8 files
  - **primer:** [Containerization Concepts — quick primer](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
  - [7 more](../docs/concepts/containerization-concepts/) — [Inspect Image Layers With Docker Sdk](../docs/concepts/containerization-concepts/snippets/2026-09-24-inspect-image-layers-with-docker-sdk.py), [Inspect Image Layers](../docs/concepts/containerization-concepts/snippets/2026-08-08-inspect-image-layers.py), [Build And Push Pipeline](../docs/concepts/containerization-concepts/scripts/build-and-push-pipeline.py)

- **Infrastructure as Code Concepts** · 7 files
  - **primer:** [Infrastructure as Code Concepts — quick primer](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
  - [6 more](../docs/concepts/infrastructure-as-code-concepts/) — [Parse And Validate Terraform State](../docs/concepts/infrastructure-as-code-concepts/snippets/2026-09-06-parse-and-validate-terraform-state.py), [Iac State Workflow](../docs/concepts/infrastructure-as-code-concepts/scripts/2026-08-25-iac-state-workflow.sh), [Terraform Vs Ansible Container Infra](../docs/concepts/infrastructure-as-code-concepts/notebooks/terraform-vs-ansible-container-infra.ipynb)

- **Linux & System Administration** · 8 files
  - **primer:** [Linux & System Administration — quick primer](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
  - [7 more](../docs/concepts/linux-system-administration/) — [Systemd Watchdog Restart And Page](../docs/concepts/linux-system-administration/scripts/systemd-watchdog-restart-and-page.sh), [Systemd Health Check And Log Rotation](../docs/concepts/linux-system-administration/scripts/systemd-health-check-and-log-rotation.sh), [Systemd Health Check Log Alerting](../docs/concepts/linux-system-administration/scripts/systemd-health-check-log-alerting.sh)

- **Monitoring & Observability Concepts** · 8 files
  - **primer:** [Monitoring & Observability Concepts — quick primer](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
  - [7 more](../docs/concepts/monitoring-observability-concepts/) — [Health Checks And Log Correlation](../docs/concepts/monitoring-observability-concepts/scripts/health-checks-and-log-correlation.py), [Scripted Health Gate With Correlated Logs](../docs/concepts/monitoring-observability-concepts/scripts/scripted-health-gate-with-correlated-logs.py), [Metrics Exporter Structured Logger](../docs/concepts/monitoring-observability-concepts/scripts/2026-09-08-metrics-exporter-structured-logger.py)

- **Networking Fundamentals** · 11 files
  - **primer:** [Networking Fundamentals — quick primer](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
  - [10 more](../docs/concepts/networking-fundamentals/) — [Tcp Port And Dns Sockets](../docs/concepts/networking-fundamentals/snippets/2026-09-24-tcp-port-and-dns-sockets.py), [Health Check Automation With Json Output](../docs/concepts/networking-fundamentals/scripts/health-check-automation-with-json-output.sh), [Sample Health Check Targets](../docs/concepts/networking-fundamentals/scripts/sample-health-check-targets.json)

- **Scripting & Automation (Bash/Python)** · 11 files
  - **primer:** [Scripting & Automation (Bash/Python) — quick primer](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
  - [10 more](../docs/concepts/scripting-automation-bash-python/) — [Retry Backoff Logging](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-08-retry-backoff-logging.py), [Log Parsing Filtering](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py), [Parallel Tasks With Logging](../docs/concepts/scripting-automation-bash-python/scripts/2026-09-23-parallel-tasks-with-logging.sh)

- **Version Control Concepts** · 10 files
  - **primer:** [Version Control Concepts — quick primer](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
  - [9 more](../docs/concepts/version-control-concepts/) — [Branch Divergence Rev List](../docs/concepts/version-control-concepts/snippets/2026-09-23-branch-divergence-rev-list.py), [Conventional Changelog From Git Log](../docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py), [Audit Branch Hygiene Stale Branch Cleanup](../docs/concepts/version-control-concepts/scripts/2026-09-25-audit-branch-hygiene-stale-branch-cleanup.py)

## docs (kit notes)

Notes about the kit itself, kept alongside the content they refer to. Browse `docs/`.
- [Removed dead CHANGELOG references to General/docs/ files](../docs/2026-07-11-removed-dead-general-references.md)
- [Ansible notebooks — README coverage verified](../docs/2026-07-19-ansible-notebooks-readme-verified.md)
- [Checked README coverage for target files](../docs/2026-07-19-audit-004-check.md)
- [Kubernetes files added to README tree](../docs/2026-07-21-kubernetes-readme-tree-update.md)

## docs/audit

Audit notes tracking README, coverage, and topic-map corrections. Browse `docs/audit/`.
- [Recounted the README Coverage table against disk](../docs/audit/2026-08-18-coverage-table-audit.md)
- [Verified GitHub README counts](../docs/audit/2026-08-20-audit-009-github-readme.md)
- [Verified OpenTofu README entries](../docs/audit/2026-08-20-audit-011-opentofu-readme.md)
- [Audit 012 — Docker dockerfile count (2026-09-07)](../docs/audit/2026-09-07-audit-012-docker-dockerfile-count.md)
- [Repo audit — 2026-10-10](../docs/audit/2026-10-10-repo-audit-013.md)
- [Repo audit — 2026-10-21](../docs/audit/2026-10-21-repo-audit-014.md)
- [Manifest](../docs/audit/MANIFEST.json)

