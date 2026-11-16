# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## AWS · 25 files

- **primer:** [AWS CLI — quick primer](../AWS/notes/0000-primer-aws.md)
- **Notes** (2): [AWS primer already exists](../AWS/notes/2026-07-13-primer-already-exists.md), [AWS CLI — quick primer](../AWS/notes/0000-primer-aws.md)
- **Docs** (2): [IAM policy walkthrough: scoping least-privilege for a small app stack](../AWS/docs/iam-policy-least-privilege-walkthrough.md), [IAM cross-account roles with least privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md)
- **Snippets** (3): [I wanted one small Python example that creates a bucket, then uploads a file.](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py), [I wanted to see what EC2 instances I have running and practice tagging them with the AWS CLI.](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [I wanted to see what EC2 instances and S3 buckets I have running.](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)
- **Scripts** (7): [CDK Python stack: VPC with isolated workload subnets and private endpoints](../AWS/scripts/vpc-with-private-endpoints.py), [Builds a minimal end-to-end AWS stack: VPC with public/private subnets,](../AWS/scripts/build-vpc-ec2-rds-stack.py), [I wanted one script that takes a local folder and publishes it as a](../AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh)
  _…and 4 more under `AWS/` — browse the folder._
- **Configs** (3): [Blue-green deployment configuration for an AWS ECS service.](../AWS/configs/ecs-service-deployment-blue-green.yaml), [Minimal Aws Config](../AWS/configs/2026-07-13-minimal-aws-config.ini), [Minimal Aws Config](../AWS/configs/2026-07-12-minimal-aws-config.ini)
- **Notebooks** (1): [Comparing Deployment Approaches Boto3 Cloudformation Cdk](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)
- **Templates** (7): [Input variables for the Control Tower landing zone scaffold.](../aws/templates/aws-control-tower-landing-zone/variables.tf), [Output values for the Control Tower landing zone scaffold.](../aws/templates/aws-control-tower-landing-zone/outputs.tf), [Terraform module scaffold for AWS Control Tower landing zone.](../aws/templates/aws-control-tower-landing-zone/main.tf)
  _…and 4 more under `AWS/` — browse the folder._

## Ansible · 114 files

- **primer:** [Ansible — quick primer](../Ansible/notes/0000-primer-ansible.md)
- **Notes** (10): [All](../Ansible/notes/group_vars/all.yml), [Ansible](../Ansible/notes/ansible.cfg), [Following the Ansible quickstart — what tripped me up](../Ansible/notes/2026-09-04-ansible-quickstart-trip-ups.md)
  _…and 7 more under `Ansible/` — browse the folder._
- **Docs** (7): [Integrating Ansible with Network Devices](../Ansible/docs/integrating-ansible-with-network-devices.md), [Integrating Ansible with Docker for CI pipeline testing](../Ansible/docs/integrated-ansible-docker-ci-pipeline-testing.md), [Ansible upgrade playbook and pre-flight check reference](../Ansible/docs/ansible-upgrade-playbook-and-preflight-checks.md)
  _…and 4 more under `Ansible/` — browse the folder._
- **Snippets** (2): [Nginx Playbook](../Ansible/snippets/nginx-playbook.yaml), [I wanted a small Python wrapper around ansible-lint that I can drop](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py)
- **Scripts** (4): [Scan Ansible Antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py), [Run my first Ansible playbook to configure a local target](../Ansible/scripts/run-first-playbook.sh), [Install Ansible and run my first ad-hoc command](../Ansible/scripts/install-and-first-adhoc.sh)
  _…and 1 more under `Ansible/` — browse the folder._
- **Configs** (10): [Nginx Webserver](../Ansible/configs/nginx-webserver.yaml), [Lab Inventory](../Ansible/configs/lab-inventory.ini), [Docker Python Setup](../Ansible/configs/docker-python-setup.yaml)
  _…and 7 more under `Ansible/` — browse the folder._
- **Manifests** (10): [Playbook Migration](../ans/manifests/playbook-migration.yaml), [Main](../Ansible/manifests/roles/webserver/tasks/main.yaml), [Main](../Ansible/manifests/roles/webserver/handlers/main.yaml)
  _…and 7 more under `Ansible/` — browse the folder._
- **Notebooks** (2): [Comparing Execution Patterns Block Rescue Serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb), [Ansible Variable Precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb)
- **Dockerfiles** (1): [Ansible Control Node](../Ansible/dockerfiles/ansible-control-node.Dockerfile)
- **Templates** (68): [webserver role — variables.](../Ansible/templates/production-ansible-project/roles/webserver/vars/main.yml), [Per-site virtual host. Rendered into sites-available/<server_name>.conf.](../Ansible/templates/production-ansible-project/roles/webserver/templates/site.conf.j2), [nginx.conf.j2 — the main nginx config. The `validate` in the task runs](../Ansible/templates/production-ansible-project/roles/webserver/templates/nginx.conf.j2)
  _…and 65 more under `Ansible/` — browse the folder._

## ArgoCD · 27 files

- **primer:** [ArgoCD — quick primer](../ArgoCD/notes/0000-primer-argocd.md)
- **Notes** (3): [ArgoCD install manifest stub](../ArgoCD/notes/install.yaml), [ArgoCD quickstart — what tripped me up](../ArgoCD/notes/2026-08-11-argocd-quickstart.md), [ArgoCD — quick primer](../ArgoCD/notes/0000-primer-argocd.md)
- **Docs** (2): [How I wired ArgoCD with GitHub for GitOps deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md), [Argo CD with HashiCorp Vault and External Secrets: keeping secrets out of Git, plus RBAC, notification and webhook patterns that hold up in production](../ArgoCD/docs/argocd-vault-external-secrets.md)
- **Snippets** (1): [I wanted to sync an ArgoCD app and check its health from the CLI](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)
- **Scripts** (3): [Build an ArgoCD Application from scratch and drive an automated sync to health.](../ArgoCD/scripts/build-argocd-application-from-scratch.sh), [Defaults for the connection options. They are applied after parsing so that](../ArgoCD/scripts/argocd-application-helper.py), [I installed ArgoCD on a kind cluster today](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)
- **Configs** (3): [Declarative ApplicationSet for multi-cluster deployments.](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml), [Declarative ApplicationSet for the guestbook example — I wanted to see how one](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml), [My first Application manifest — deploys the guestbook example](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- **Manifests** (2): [Fleet GitOps manifests: one ApplicationSet for the whole fleet, plus the](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml), [Deployment](../ArgoCD/manifests/guestbook/deployment.yaml)
- **Templates** (13): [Staging environment values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/values.yaml), [Kustomization](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/kustomization.yaml), [Production environment values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/prod/values.yaml)
  _…and 10 more under `ArgoCD/` — browse the folder._

## Azure · 28 files

- **primer:** [Azure CLI — quick primer](../Azure/notes/0000-primer-azure.md)
- **Notes** (4): [First Azure CLI login + resource list](../Azure/notes/2026-09-18-first-login-and-resource-list.md), [Azure quickstart — what tripped me up](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md), [Azure CLI quickstart — what tripped me up](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md)
  _…and 1 more under `Azure/` — browse the folder._
- **Docs** (2): [Comparing Azure CLI, Bicep, and the Python SDK for provisioning a small app stack](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md), [Azure DevOps pipeline integration with Bicep deployments](../Azure/docs/azure-devops-pipeline-bicep-integration.md)
- **Snippets** (3): [I wanted to stand up a small isolated network and a Linux VM using only the az CLI,](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh), [I wanted to create a resource group and see what Azure regions are available.](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [Quick snippet: create a resource group and list Azure regions](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)
- **Scripts** (5): [Purpose: delete leftover Azure resource groups that share a name prefix,](../Azure/scripts/resource-group-cleanup.sh), [Purpose: Find and delete Azure resource groups matching configurable criteria.](../Azure/scripts/cleanup-resource-groups.sh), [Purpose: stand up an Azure VM scale set behind a load balancer with](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
  _…and 2 more under `Azure/` — browse the folder._
- **Configs** (2): [Azure Key Vault Access Policy](../az/configs/azure-key-vault-access-policy.json), [Purpose: baseline Container Apps setup for two microservices (an HTTP API](../Azure/configs/container-apps-microservices.yaml)
- **Manifests** (2): [Purpose: Deploy a multi-service Azure Container Apps environment with](../az/manifests/container-apps-multi-service-deployment.yaml), [Production Aks Cluster](../Azure/manifests/production-aks-cluster.bicep)
- **Templates** (10): [Aks Cluster](../Azure/templates/aks-cluster-with-addons/modules/aks-cluster.bicep), [Policy](../Azure/templates/aks-cluster-with-addons/modules/addons/policy.bicep), [Network Policy](../Azure/templates/aks-cluster-with-addons/modules/addons/network-policy.bicep)
  _…and 7 more under `Azure/` — browse the folder._

## Docker · 58 files

- **primer:** [Docker — quick primer](../Docker/notes/0000-primer-docker.md)
- **Notes** (6): [Compose](../Docker/notes/compose.yaml), [Docker Get Started tutorial — what tripped me up](../Docker/notes/2026-08-12-docker-tutorial-tripups.md), [Docker Compose quickstart notes](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
  _…and 3 more under `Docker/` — browse the folder._
- **Docs** (11): [Docker production hardening runbook](../docker/docs/docker-production-hardening-runbook.md), [Package](../Docker/docs/package.json), [Integrating Docker with Kubernetes for production workloads](../Docker/docs/integrating-docker-with-kubernetes.md)
  _…and 8 more under `Docker/` — browse the folder._
- **Snippets** (2): [Analyze Image Layers](../Docker/snippets/analyze-image-layers.py), [Explicit tag so the image is never an anonymous <none> entry.](../Docker/snippets/2026-08-12-build-run-and-cleanup.py)
- **Scripts** (5): [multi-stage-go-dockerfile.sh](../Docker/scripts/multi-stage-go-dockerfile.sh), [Install Docker and run my first container](../Docker/scripts/install-and-run-first-container.sh), [Install Docker and run nginx container](../Docker/scripts/install-and-run-container.sh)
  _…and 2 more under `Docker/` — browse the folder._
- **Configs** (1): [Multi Service App](../Docker/configs/multi-service-app.yaml)
- **Manifests** (9): [Production Docker Deployment with HA](../docker/manifests/production-docker-deployment-with-ha.yaml), [Purpose](../docker/manifests/docker-compose-multi-stage.yaml), [Prometheus](../Docker/manifests/prometheus.yml)
  _…and 6 more under `Docker/` — browse the folder._
- **Notebooks** (3): [Comparing Docker Networking Drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb), [Comparing Docker Build Strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb), [Comparing Compose Swarm Kubernetes Local Orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb)
- **Dockerfiles** (9): [Tried Building First Image](../Docker/dockerfiles/tried-building-first-image.Dockerfile), [Simple Go Server](../Docker/dockerfiles/simple-go-server.Dockerfile), [Production-ready multi-stage Dockerfile for a Go HTTP server.](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
  _…and 6 more under `Docker/` — browse the folder._
- **Templates** (12): [Multi-service scaffold: app (built locally) + Postgres + Redis.](../Docker/templates/multi-service-compose-with-healthchecks/compose.yaml), [App](../Docker/templates/multi-service-compose-with-healthchecks/app/app.py), [Minimal runtime image for the scaffold's app service: stdlib-only HTTP server,](../Docker/templates/multi-service-compose-with-healthchecks/app/Dockerfile)
  _…and 9 more under `Docker/` — browse the folder._

## Flux CD · 8 files

- **Notes** (2): [Flux quickstart, and what tripped me up](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md), [Exploring the Flux CLI command surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)
- **Docs** (2): [Wiring Flux CD with GitHub for GitOps Deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md), [Flux CD: README Coverage table and topics.md update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md)
- **Scripts** (2): [Purpose](../FluxCD/scripts/bootstrap-flux-on-kind.sh), [I wanted to install the Flux CLI and run `flux check --pre` to see if a](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- **Configs** (2): [Purpose](../FluxCD/configs/helmrelease-image-automation.yaml), [The two objects I keep re-writing by hand while learning the quickstart, so I](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)

## GCP · 15 files

- **primer:** [Google Cloud SDK — quick primer](../GCP/notes/0000-primer-gcp.md)
- **Notes** (2): [Following the gcloud quickstart — what tripped me up](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md), [Google Cloud SDK — quick primer](../GCP/notes/0000-primer-gcp.md)
- **Docs** (1): [GCP/ coverage note — 2026-09-28](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)
- **Snippets** (2): [I wanted to see what's running in my GCP project and what storage buckets I have.](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh), [I wanted to list what I have in my GCP project — Compute Engine instances and GCS buckets.](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)
- **Scripts** (6): [Cloud Run Terraform From Scratch](../gcp/scripts/cloud-run-terraform-from-scratch.py), [Create Gcs Bucket And Setup Iam](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh), [Purpose: Generate and apply a minimal Terraform configuration that deploys](../GCP/scripts/build-cloud-run-service-terraform.py)
  _…and 3 more under `GCP/` — browse the folder._
- **Configs** (4): [Set core project and zone](../gcp/configs/gcloud-iam-config.yaml), [gcp-008: service account and IAM configuration for automated deployments.](../GCP/configs/service-account-and-iam-config.yaml), [gcp-014: minimal instance-template shape I pieced together — startup-script plus service account.](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml)
  _…and 1 more under `GCP/` — browse the folder._

## Git · 82 files

- **primer:** [Git — quick primer](../Git/notes/0000-primer-git.md)
- **Notes** (6): [Git notes companion README](../Git/notes/README.md), [Git branching tutorial — what tripped me up](../Git/notes/2026-08-11-git-branching-tutorial.md), [Git branching tutorial — what I learned and what tripped me up](../Git/notes/2026-06-07-git-branching-tutorial.md)
  _…and 3 more under `Git/` — browse the folder._
- **Docs** (15): [Git — production rollback and recovery runbook](../git/docs/git-production-rollback-and-recovery-runbook.md), [Worktree workflows: parallel branches without stash juggling](../Git/docs/worktree-workflows-parallel-branches.md), [Wiring Git hooks into a pre-commit workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md)
  _…and 12 more under `Git/` — browse the folder._
- **Snippets** (1): [First Commit](../Git/snippets/first-commit.sh)
- **Scripts** (14): [pre-receive hook — integrity and quota enforcement](../git/scripts/pre-receive-hook-integrity-and-quota-enforcement.sh), [squash-wip-commits.sh — automate interactive rebase to squash WIP commits before PR](../Git/scripts/squash-wip-commits.sh), [setup-gitattributes-filters-and-merge.sh — Reusable .gitattributes setup](../Git/scripts/setup-gitattributes-filters-and-merge.sh)
  _…and 11 more under `Git/` — browse the folder._
- **Notebooks** (3): [Merge Rebase Squash Comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb), [Merge Rebase Squash Comparison](../Git/notebooks/merge-rebase-squash-comparison.ipynb), [Comparing Git Merge Strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb)
- **Templates** (43): [setup-workflow.sh — interactive Git workflow setup](../Git/templates/git-workflow-automation/scripts/setup-workflow.sh), [semantic-version.sh — calculate next semantic version from conventional commits](../Git/templates/git-workflow-automation/scripts/semantic-version.sh), [install-hooks.sh — install Git workflow hooks](../Git/templates/git-workflow-automation/scripts/install-hooks.sh)
  _…and 40 more under `Git/` — browse the folder._

## GitHub · 45 files

- **primer:** [GitHub — quick primer](../GitHub/notes/0000-primer-github.md)
- **Notes** (11): [Following the gh CLI quickstart — what tripped me up](../GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md), [GitHub primer already exists](../GitHub/notes/2026-06-19-primer-already-exists.md), [Following the Hello World guide — GitHub flow from scratch](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md)
  _…and 8 more under `GitHub/` — browse the folder._
- **Docs** (7): [GitHub release automation: tags, milestones, and Releases end-to-end](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md), [Protection](../GitHub/docs/protection.json), [How I wired GitHub deploy keys vs fine-grained PATs for CI/CD access](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)
  _…and 4 more under `GitHub/` — browse the folder._
- **Snippets** (3): [Open a PR for the current branch and block until its CI checks finish reporting.](../GitHub/snippets/open-pr-and-wait-for-ci.sh), [Print repo names for my user.](../GitHub/snippets/list-repos-with-python.py), [List open issues](../GitHub/snippets/github-issues-api.py)
- **Scripts** (7): [Comment on my first issue with GitHub CLI](../GitHub/scripts/tried-commenting-on-first-issue.sh), [tried-auth-and-profile.sh — first try at auth + profile with gh CLI](../GitHub/scripts/tried-auth-and-profile.sh), [Provision Repo With Api](../GitHub/scripts/provision-repo-with-api.py)
  _…and 4 more under `GitHub/` — browse the folder._
- **Configs** (7): [labels config — compatible with github-label-sync](../GitHub/configs/issue-templates-and-labels.yaml), [Label automation — automatically marks and closes stale issues and PRs](../GitHub/configs/dot-github-repository/stale.yml), [Label definitions for .github repository — format compatible with label-sync tools](../GitHub/configs/dot-github-repository/labels.yaml)
  _…and 4 more under `GitHub/` — browse the folder._
- **Manifests** (1): [GitHub Environments and deployment protection rules: required reviewers,](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **Notebooks** (2): [Comparing Api Approaches Release Automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb), [Analyzing Github Actions Usage Across Org Repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb)
- **Dockerfiles** (1): [Purpose: Self-hosted GitHub Actions runner container with Docker-in-Docker and](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)
- **Templates** (6): [Security Policy](../GitHub/templates/github-security-compliance/SECURITY.md), [GitHub Repository Security & Compliance Template](../GitHub/templates/github-security-compliance/README.md), [Compliance Checklist](../GitHub/templates/github-security-compliance/COMPLIANCE.md)
  _…and 3 more under `GitHub/` — browse the folder._

## GitHub Actions · 25 files

- **primer:** [GitHub Actions — quick primer](../GitHub Actions/notes/0000-primer-github-actions.md)
- **Notes** (5): [Test](../GitHub Actions/notes/test.yml), [Ci](../GitHub Actions/notes/ci.yml), [GitHub Actions primer already exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)
  _…and 2 more under `GitHub Actions/` — browse the folder._
- **Docs** (6): [Test](../GitHub Actions/docs/test.yml), [GitHub Actions OIDC with AWS: a complete guide](../GitHub Actions/docs/github-actions-oidc-with-aws.md), [Composite actions vs reusable workflows: choosing the right pattern](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md)
  _…and 3 more under `GitHub Actions/` — browse the folder._
- **Snippets** (1): [Trigger Workflow Dispatch Poll Status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)
- **Scripts** (4): [Self-hosted runner registration and cleanup wrapper for ephemeral runners](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh), [Manage Secrets Across Repos](../GitHub Actions/scripts/manage-secrets-across-repos.py), [Install the gh Actions extension and list my workflow runs](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh)
  _…and 1 more under `GitHub Actions/` — browse the folder._
- **Configs** (5): [Reusable Deployment Workflow Environment Gates Approval](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml), [Minimal CI workflow with matrix strategy across multiple Node.js versions.](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml), [Hello Workflow](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)
  _…and 2 more under `GitHub Actions/` — browse the folder._
- **Dockerfiles** (1): [syntax=docker/dockerfile:1](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)
- **Templates** (3): [Reusable deployment workflow: deploys one build artifact to one environment.](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml), [Caller workflow: builds once, then promotes the same artifact](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml), [Multi-environment deploy template](../GitHub Actions/templates/multi-env-deploy/README.md)

## GitLab CI · 20 files

- **primer:** [GitLab CI/CD — quick primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **Notes** (4): [GitLab CI/CD quickstart — runner setup, variables, and artifacts trip-ups](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md), [Following the GitLab CI/CD quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md), [GitLab CI/CD — quick primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
  _…and 1 more under `GitLab CI/` — browse the folder._
- **Docs** (2): [GitLab CI/CD with Kubernetes — end-to-end walkthrough](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md), [GitLab CI/CD pipeline library patterns](../GitLab CI/docs/gitlab-ci-cd-pipeline-library-patterns.md)
- **Snippets** (1): [I wanted to kick off a pipeline from my laptop and watch it without](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- **Scripts** (5): [Gitlab Pipeline Helper](../GitLab CI/scripts/gitlab-pipeline-helper.py), [dynamic-child-pipeline.sh — scaffold a parent pipeline that writes its child](../GitLab CI/scripts/dynamic-child-pipeline.sh), [Local GitLab CI pipeline validator](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh)
  _…and 2 more under `GitLab CI/` — browse the folder._
- **Configs** (4): [Purpose: build one image from the commit, push it to the GitLab registry under an](../GitLab CI/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml), [I wanted one template that wires an upstream pipeline to a downstream](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml), [My minimal .gitlab-ci.yml — three stages with a pip cache and test artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
  _…and 1 more under `GitLab CI/` — browse the folder._
- **Dockerfiles** (1): [Purpose: Self-hosted GitLab Runner container with Docker-in-Docker, kaniko/buildah](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)
- **Templates** (3): [Kind runner bootstrap script for GitLab CI/CD](../GitLab CI/templates/modular-pipeline-repo/scripts/kind-runner-bootstrap.sh), [Modular GitLab CI/CD pipeline repository](../GitLab CI/templates/modular-pipeline-repo/README.md), [Root of the modular pipeline. It pulls the stage files in, declares the](../GitLab CI/templates/modular-pipeline-repo/.gitlab-ci.yml)

## Grafana · 10 files

- **primer:** [Grafana — quick primer](../graf/notes/0000-primer-grafana.md)
- **Notes** (4): [Grafana quickstart — what tripped me up](../graf/notes/2026-10-13-grafana-quickstart-trip-ups.md), [2026-09-29-grafana-quickstart-trip-ups.md](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md), [Poking around the Grafana UI — data sources, panels, dashboards](../graf/notes/2026-09-25-explore-grafana-ui.md)
  _…and 1 more under `graf/` — browse the folder._
- **Docs** (3): [How I wired Grafana into Prometheus and Alertmanager for unified metrics and alert visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md), [graf/ navigation dedup note — 2026-09-25](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [graf/ coverage note — 2026-09-25](../graf/docs/2026-09-25-grafana-coverage-and-topics.md)
- **Scripts** (2): [Build Multi Panel Service Dashboard Via Http Api](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py), [Install Grafana via Docker and check the login page answers (graf-002).](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)
- **Configs** (1): [My minimal provisioning config: one Prometheus datasource plus one simple](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)

## Grafana Cloud · 6 files

- **Notes** (2): [Grafana Cloud quickstart — what tripped me up](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md), [My first hosted dashboard in Grafana Cloud](../grafc/notes/2026-09-30-first-hosted-dashboard.md)
- **Snippets** (1): [First Dashboard Over Http](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)
- **Scripts** (1): [Purpose: Create a Grafana Cloud stack via the API and send a first metric](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)
- **Configs** (2): [Prometheus remote-write config pointing at a Grafana Cloud stack.](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml), [My first metrics-scraping config for the Grafana Cloud agent. The unix](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml)

## HashiCorp Vault · 11 files

- **primer:** [HashiCorp Vault — quick primer](../vlt/notes/0000-primer-vlt.md)
- **Notes** (3): [Vault dev-mode quickstart — what tripped me up](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md), [Exploring the vault CLI — secrets, policies, and what's there](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md), [HashiCorp Vault — quick primer](../vlt/notes/0000-primer-vlt.md)
- **Docs** (2): [Wiring Vault Agent into a containerized app for secret injection](../vlt/docs/vault-agent-secret-injection.md), [Document vlt/ in README Layout + Coverage table and topics.md](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md)
- **Scripts** (4): [vlt-017: Build a dynamic database credential flow with Vault database engine from scratch.](../vlt/scripts/dynamic-database-credentials.py), [vlt-014 scratch: write a KV v2 secret, read it back, and list its versions.](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py), [vlt-009 scratch: install Vault and run my first secrets-engine command.](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh)
  _…and 1 more under `vlt/` — browse the folder._
- **Configs** (2): [vlt-019: AppRole auth method, a least-privilege policy, and a token role.](../vlt/configs/vault-approle.hcl), [vlt-015 scratch: a least-privilege read-only policy, and the group it binds to.](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl)

## Helm · 63 files

- **primer:** [Helm — quick primer](../Helm/notes/0000-primer-helm.md)
- **Notes** (3): [Values](../Helm/notes/values.yaml), [Helm quickstart — what tripped me up](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [Helm — quick primer](../Helm/notes/0000-primer-helm.md)
- **Docs** (6): [Comparing Helm values management approaches: --set flags vs per-environment values files vs named templates](../Helm/docs/values-management-approaches.md), [Helm chart testing strategies](../Helm/docs/helm-chart-testing-strategies.md), [Helm chart testing with chart-testing and `ct lint`](../Helm/docs/chart-testing-ct-lint.md)
  _…and 3 more under `Helm/` — browse the folder._
- **Snippets** (1): [I followed the Helm quickstart to scaffold a minimal nginx chart](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **Scripts** (5): [validate-chart-values-across-environments.sh — render and cross-check one chart](../Helm/scripts/validate-chart-values-across-environments.sh), [Helm Dep Validate](../Helm/scripts/helm-dep-validate.go), [Dummy Test](../Helm/scripts/dummy-test.sh)
  _…and 2 more under `Helm/` — browse the folder._
- **Configs** (5): [Purpose: shared baseline values file for one release deployed to several](../Helm/configs/multi-cluster-gitops-values.yaml), [I started from the default `helm create` values.yaml and tuned it for a](../Helm/configs/2026-09-02-live-release-values.yaml), [I took the default helm create values.yaml and hardened it for a](../Helm/configs/2026-08-30-production-deployment-values.yaml)
  _…and 2 more under `Helm/` — browse the folder._
- **Manifests** (15): [Values](../Helm/manifests/redis-chart/values.yaml), [Service](../Helm/manifests/redis-chart/templates/service.yaml), [Deployment](../Helm/manifests/redis-chart/templates/deployment.yaml)
  _…and 12 more under `Helm/` — browse the folder._
- **Notebooks** (1): [Release Lifecycle Drill](../Helm/notebooks/release-lifecycle-drill.ipynb)
- **Templates** (27): [Default values for microservice-chart. A `helm install` with no overrides gets](../Helm/templates/microservice-chart/values.yaml), [Values.Schema](../Helm/templates/microservice-chart/values.schema.json), [Test Connection](../Helm/templates/microservice-chart/templates/tests/test-connection.yaml)
  _…and 24 more under `Helm/` — browse the folder._

## Jenkins · 3 files

- **primer:** [Jenkins — quick primer](../jnk/notes/0000-primer-jenkins.md)
- **Notes** (2): [Jenkins — install and run my first CLI command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md), [Jenkins — quick primer](../jnk/notes/0000-primer-jenkins.md)
- **Scripts** (1): [L1: Trigger my first Jenkins job via CLI (minimal example)](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

## Kubernetes · 102 files

- **primer:** [Kubernetes — quick primer](../Kubernetes/notes/0000-primer-kubernetes.md)
- **Notes** (10): [Kubernetes — Install kubectl and explore my first cluster (L1 notes)](../k8s/notes/2026-10-27-install-kubectl-and-explore-first-cluster.md), [My First Pod](../Kubernetes/notes/my-first-pod.yaml), [Deployment](../Kubernetes/notes/deployment.yaml)
  _…and 7 more under `Kubernetes/` — browse the folder._
- **Docs** (6): [Kubernetes Service Mesh Comparison: Istio vs Linkerd vs Consul for Enterprise Traffic Management](../k8s/docs/kubernetes-service-mesh-comparison.md), [Prometheus](../Kubernetes/docs/prometheus.yml), [Integrating Kubernetes with Prometheus for production monitoring](../Kubernetes/docs/integrating-kubernetes-with-prometheus.md)
  _…and 3 more under `Kubernetes/` — browse the folder._
- **Snippets** (2): [kp - Pod troubleshooting shell function](../Kubernetes/snippets/pod-troubleshoot-shell.sh), [I wanted to run my first container with kubectl, so I created a Pod and](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh)
- **Scripts** (4): [Reusable kubectl helper: rollout status and pod readiness health checks.](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh), [Following the k8s-002 manifest, manage pod lifecycle: create, inspect, delete](../Kubernetes/scripts/pod-lifecycle.sh), [Install kind and kubectl, then spin up my first cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
  _…and 1 more under `Kubernetes/` — browse the folder._
- **Configs** (1): [I started with a basic Deployment for a Go app and added probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)
- **Manifests** (7): [Deploy My First Nginx Pod With Kubectl](../k8s/manifests/2026-10-27-deploy-my-first-nginx-pod-with-kubectl.yaml), [Stateless App](../Kubernetes/manifests/stateless-app.yaml), [Purpose: one way to run a small web service with autoscaling, disruption](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml)
  _…and 4 more under `Kubernetes/` — browse the folder._
- **Notebooks** (2): [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb), [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)
- **Templates** (70): [Purpose: ClusterResourceSet for runtime security (Falco) and policy engine (Kyverno) — applies to clusters with enableSecurity=true](../k8s/templates/workload-clusters/cluster-resource-sets/security-falco-kyverno.yaml), [Purpose: ClusterResourceSet for Prometheus monitoring stack — applies to clusters with enableMonitoring=true](../k8s/templates/workload-clusters/cluster-resource-sets/monitoring-prometheus.yaml), [Purpose: ClusterResourceSet for Loki logging stack — applies to clusters with enableLogging=true](../k8s/templates/workload-clusters/cluster-resource-sets/logging-loki.yaml)
  _…and 67 more under `Kubernetes/` — browse the folder._

## OpenTelemetry · 10 files

- **primer:** [OpenTelemetry — quick primer](../otel/notes/0000-primer-opentelemetry.md)
- **Notes** (2): [Following the OpenTelemetry quickstart — what tripped me up](../otel/notes/2026-09-30-quickstart-trip-ups.md), [OpenTelemetry — quick primer](../otel/notes/0000-primer-opentelemetry.md)
- **Docs** (2): [Context propagation with OpenTelemetry: W3C tracecontext vs B3](../otel/docs/context-propagation-w3c-vs-b3.md), [otel/ coverage note — 2026-09-25](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md)
- **Snippets** (2): [Instrumented Http Server](../otel/snippets/2026-09-30-instrumented-http-server.go), [First Trace Span](../otel/snippets/2026-09-26-first-trace-span.py)
- **Scripts** (2): [Custom Span Processor Resource Detector](../otel/scripts/custom-span-processor-resource-detector.py), [Stand up a Collector, send it one span, read the span back out of its log (otel-002).](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh)
- **Configs** (2): [A real Collector pipeline: OTLP receiver in, memory_limiter + batch processors,](../otel/configs/collector-otlp-real-pipeline.yaml), [My minimal Collector config: OTLP in, batch, log out.](../otel/configs/2026-09-30-collector-otlp-export.yaml)

## OpenTofu · 19 files

- **primer:** [OpenTofu — quick primer](../OpenTofu/notes/0000-primer-opentofu.md)
- **Notes** (2): [Following the official OpenTofu quickstart — what tripped me up](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md), [OpenTofu — quick primer](../OpenTofu/notes/0000-primer-opentofu.md)
- **Docs** (4): [Wiring OpenTofu remote state to an S3 backend with workspace isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md), [OpenTofu Provider Development: Creating a Custom Provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md), [Backup](../OpenTofu/docs/backup.json)
  _…and 1 more under `OpenTofu/` — browse the folder._
- **Scripts** (3): [ot-011: wrapper around init/plan/apply with policy gates before apply.](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh), [ot-007: scaffold a small OpenTofu project that provisions its own remote-state](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh), [Install OpenTofu and verify with tofu --version](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- **Configs** (2): [I switched to the local backend so I can inspect the state file directly](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl), [I kept the variable block inline so the whole config is one file](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)
- **Notebooks** (2): [Comparing Opentofu And Terraform State Management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb), [Comparing Opentofu And Terraform Aws Provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)
- **Templates** (6): [Provider requirements for the shared module. The version upper bound lives](../OpenTofu/templates/aws-reusable-module/versions.tf), [Inputs for the shared VPC module. Every value a caller is likely to vary](../OpenTofu/templates/aws-reusable-module/variables.tf), [Every resource the module manages gets a referencing output so callers](../OpenTofu/templates/aws-reusable-module/outputs.tf)
  _…and 3 more under `OpenTofu/` — browse the folder._

## Prometheus · 40 files

- **primer:** [Prometheus — quick primer](../Prometheus/notes/0000-primer-prometheus.md)
- **Notes** (2): [Prometheus getting started — what tripped me up](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md), [Prometheus — quick primer](../Prometheus/notes/0000-primer-prometheus.md)
- **Docs** (4): [Integrating Prometheus with related tools](../pro/docs/integrating-prometheus-with-related-tools.md), [Prometheus recording rules and alert reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md), [Prometheus integration with Kubernetes: service discovery, pod annotations, kube-state-metrics, and managed Prometheus differences](../Prometheus/docs/prometheus-kubernetes-integration.md)
  _…and 1 more under `Prometheus/` — browse the folder._
- **Snippets** (1): [PromQL queries to check target health and alert on missing metrics.](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)
- **Scripts** (6): [Purpose: Validate Prometheus alerting/recording rule files with promtool](../pro/scripts/2026-10-29-prometheus-alerting-rule-validation.sh), [Custom Metrics Service](../Prometheus/scripts/custom-metrics-service.py), [Custom App Metrics Collector](../Prometheus/scripts/custom-app-metrics-collector.go)
  _…and 3 more under `Prometheus/` — browse the folder._
- **Configs** (5): [Purpose: side-by-side comparison of recording rules vs alerting rules.](../Prometheus/configs/recording-vs-alerting-rules.yaml), [Prometheus scrape config and remote write tuning reference.](../Prometheus/configs/prometheus-scrape-config-and-remote-write-tuning.yaml), [Purpose: production prometheus.yml — relabeling, external labels, exemplar](../Prometheus/configs/production-prometheus.yml)
  _…and 2 more under `Prometheus/` — browse the folder._
- **Manifests** (3): [Purpose: Deploy a Prometheus and Grafana monitoring stack on Kubernetes,](../pro/manifests/prometheus-grafana-stack-deployment.yaml), [Purpose: Production Prometheus HA deployment manifest for Kubernetes,](../pro/manifests/production-prometheus-ha.yaml), [Purpose: Production Prometheus HA deployment manifest for Kubernetes,](../Prometheus/manifests/production-prometheus-ha.yaml)
- **Notebooks** (1): [Querying Prometheus With Promql Step Through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)
- **Templates** (18): [Validate Prometheus rule files](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-rules.sh), [Validate Prometheus configuration](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-config.sh), [Recording](../Prometheus/templates/prometheus-project-scaffold/rules/recording.yml)
  _…and 15 more under `Prometheus/` — browse the folder._

## Pulumi · 19 files

- **primer:** [Pulumi — quick primer](../plm/notes/0000-primer-plm.md)
- **Notes** (2): [Pulumi quickstart — what tripped me up](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md), [Pulumi — quick primer](../plm/notes/0000-primer-plm.md)
- **Docs** (2): [How I structured a multi-stack Pulumi project: dev/staging stacks, StackReference, and cross-stack resource wiring](../plm/docs/multi-stack-project-structure.md), [Document plm/ in README Layout + Coverage table](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md)
- **Snippets** (1): [I tried the smallest Pulumi Python program: one bucket, one output.](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)
- **Scripts** (4): [I wrote the smallest Pulumi TypeScript program that provisions a real AWS](../plm/scripts/provision-s3-bucket-with-pulumi-ts.ts), [Purpose: reusable Network component wrapping a VPC with public/private subnets.](../plm/scripts/network-component-vpc-subnets.py), [I wrote the smallest Pulumi Python program that creates a real S3 bucket.](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py)
  _…and 1 more under `plm/` — browse the folder._
- **Configs** (3): [Pulumi.yaml and stack configuration reference.](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml), [A complete, minimal Pulumi project: the project file plus dev and prod](../plm/configs/minimal-project-and-stack-config.yaml), [Minimal Pulumi project config (the Pulumi.yaml shape) plus a dev stack's](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml)
- **Templates** (7): [Tsconfig](../plm/templates/pulumi-typescript-project-scaffold/tsconfig.json), [Package](../plm/templates/pulumi-typescript-project-scaffold/package.json), [Index](../plm/templates/pulumi-typescript-project-scaffold/index.ts)
  _…and 4 more under `plm/` — browse the folder._

## Terraform · 74 files

- **primer:** [Terraform — quick primer](../Terraform/notes/0000-primer-terraform.md)
- **Notes** (6): [Installing Terraform and my first plan/apply with local_file](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md), [Following the Terraform state management tutorial — what tripped me up](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md), [Following the Terraform providers tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md)
  _…and 3 more under `Terraform/` — browse the folder._
- **Docs** (8): [Terraform vs OpenTofu Migration Guide](../tf/docs/terraform-vs-opentofu-migration-guide.md), [How I wired Terraform output values into a dependent module](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md), [Terraform testing strategies: tflint, terratest, and infrastructure test harnesses](../Terraform/docs/terraform-testing-strategies-tflint-terratest.md)
  _…and 5 more under `Terraform/` — browse the folder._
- **Snippets** (3): [A reusable module pattern: accept a map of inputs, validate them up front,](../Terraform/snippets/reusable-module-for-each-validation.hcl), [init → plan → apply → destroy with the local provider](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [Scaffolding a reusable S3 bucket module with a remote state backend.](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)
- **Scripts** (4): [Validate Provider Schema](../Terraform/scripts/validate-provider-schema.go), [Install Terraform and run my first project](../Terraform/scripts/install-and-init.sh), [Generate Ansible Inventory From Terraform State](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py)
  _…and 1 more under `Terraform/` — browse the folder._
- **Configs** (10): [Purpose](../Terraform/configs/terraform-module-version-pinning-and-migration-plan.hcl), [Variables](../Terraform/configs/reusable-s3-module/variables.tf), [Outputs](../Terraform/configs/reusable-s3-module/outputs.tf)
  _…and 7 more under `Terraform/` — browse the folder._
- **Manifests** (2): [Simple Ec2 App](../Terraform/manifests/simple-ec2-app.tf), [Reusable VPC module: one VPC, public + private subnets across the given](../Terraform/manifests/reusable-vpc-module.hcl)
- **Notebooks** (2): [Comparing Terraform Vs Opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb), [Comparing For Each Vs Count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **Templates** (39): [Versions](../tf/templates/multi-environment-terraform-project-scaffold/versions.tf), [Variables](../tf/templates/multi-environment-terraform-project-scaffold/variables.tf), [Destroy](../tf/templates/multi-environment-terraform-project-scaffold/scripts/destroy.sh)
  _…and 36 more under `Terraform/` — browse the folder._

## Trivy · 17 files

- **primer:** [Trivy — quick primer](../Trivy/notes/0000-primer-trivy.md)
- **Notes** (5): [Trivy quickstart — what tripped me up](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md), [Trivy quickstart — what tripped me up](../Trivy/notes/2026-08-29-trivy-quickstart-trip-ups.md), [Trivy quickstart — what tripped me up](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)
  _…and 2 more under `Trivy/` — browse the folder._
- **Docs** (2): [Trivy SBOM Generation and Vulnerability Reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md), [Trivy scan modes — image vs fs vs repo vs sbom, with a pipeline example](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md)
- **Snippets** (2): [I wanted a quick way to scan a container image and hard-fail the build](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py), [Python wrapper that runs Trivy and parses JSON output for a summary report](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)
- **Scripts** (5): [Trivy policy-as-code with OPA/Rego custom checks](../Trivy/scripts/trivy-policy-as-code-opa-rego.sh), [Trivy filesystem and repository scan workflow](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh), [Batch image scanning pipeline: scan a list of images from a file and](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)
  _…and 2 more under `Trivy/` — browse the folder._
- **Configs** (3): [Trivy Operator admission control configuration for Kubernetes](../Trivy/configs/trivy-operator-admission-control.yaml), [I want CI to fail on anything I'd actually ship, but I also want](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [Trivy config — I only want to be stopped by the findings I care about,](../Trivy/configs/2026-08-12-trivy-config.yaml)

## Foundational Concepts

- **Ci-Cd-Concepts** · 9 files
  - **primer:** [0000 Primer Ci Cd Concepts](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
  - [Parallelized Ci Stage Runner](../docs/concepts/ci-cd-concepts/snippets/2026-08-08-parallelized-ci-stage-runner.sh), [Cicd Common Patterns](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh), [Artifact Promotion Rollback](../docs/concepts/ci-cd-concepts/scripts/artifact-promotion-rollback.sh)
  - _…and 5 more under `docs/concepts/ci-cd-concepts/` — browse the folder._

- **Containerization-Concepts** · 8 files
  - **primer:** [0000 Primer Containerization Concepts](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
  - [Inspect Image Layers With Docker Sdk](../docs/concepts/containerization-concepts/snippets/2026-09-24-inspect-image-layers-with-docker-sdk.py), [Inspect Image Layers](../docs/concepts/containerization-concepts/snippets/2026-08-08-inspect-image-layers.py), [Build And Push Pipeline](../docs/concepts/containerization-concepts/scripts/build-and-push-pipeline.py)
  - _…and 4 more under `docs/concepts/containerization-concepts/` — browse the folder._

- **Infrastructure-As-Code-Concepts** · 7 files
  - **primer:** [0000 Primer Infrastructure As Code Concepts](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
  - [Parse And Validate Terraform State](../docs/concepts/infrastructure-as-code-concepts/snippets/2026-09-06-parse-and-validate-terraform-state.py), [Iac State Workflow](../docs/concepts/infrastructure-as-code-concepts/scripts/2026-08-25-iac-state-workflow.sh), [Terraform Vs Ansible Container Infra](../docs/concepts/infrastructure-as-code-concepts/notebooks/terraform-vs-ansible-container-infra.ipynb)
  - _…and 3 more under `docs/concepts/infrastructure-as-code-concepts/` — browse the folder._

- **Linux-System-Administration** · 8 files
  - **primer:** [0000 Primer Linux System Administration](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
  - [Systemd Watchdog Restart And Page](../docs/concepts/linux-system-administration/scripts/systemd-watchdog-restart-and-page.sh), [Systemd Health Check Log Alerting](../docs/concepts/linux-system-administration/scripts/systemd-health-check-log-alerting.sh), [Systemd Health Check And Log Rotation](../docs/concepts/linux-system-administration/scripts/systemd-health-check-and-log-rotation.sh)
  - _…and 4 more under `docs/concepts/linux-system-administration/` — browse the folder._

- **Monitoring-Observability-Concepts** · 8 files
  - **primer:** [0000 Primer Monitoring Observability Concepts](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
  - [Scripted Health Gate With Correlated Logs](../docs/concepts/monitoring-observability-concepts/scripts/scripted-health-gate-with-correlated-logs.py), [Health Checks And Log Correlation](../docs/concepts/monitoring-observability-concepts/scripts/health-checks-and-log-correlation.py), [Metrics Exporter Structured Logger](../docs/concepts/monitoring-observability-concepts/scripts/2026-09-08-metrics-exporter-structured-logger.py)
  - _…and 4 more under `docs/concepts/monitoring-observability-concepts/` — browse the folder._

- **Networking-Fundamentals** · 11 files
  - **primer:** [0000 Primer Networking Fundamentals](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
  - [Tcp Port And Dns Sockets](../docs/concepts/networking-fundamentals/snippets/2026-09-24-tcp-port-and-dns-sockets.py), [Tcp Tls Health Probes With Latency](../docs/concepts/networking-fundamentals/scripts/tcp-tls-health-probes-with-latency.sh), [Sample Health Check Targets](../docs/concepts/networking-fundamentals/scripts/sample-health-check-targets.json)
  - _…and 7 more under `docs/concepts/networking-fundamentals/` — browse the folder._

- **Scripting-Automation-Bash-Python** · 11 files
  - **primer:** [0000 Primer Scripting Automation Bash Python](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
  - [Retry Backoff Logging](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-08-retry-backoff-logging.py), [Log Parsing Filtering](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py), [Service Health Check](../docs/concepts/scripting-automation-bash-python/scripts/service-health-check.sh)
  - _…and 7 more under `docs/concepts/scripting-automation-bash-python/` — browse the folder._

- **Version-Control-Concepts** · 10 files
  - **primer:** [0000 Primer Version Control Concepts](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
  - [Branch Divergence Rev List](../docs/concepts/version-control-concepts/snippets/2026-09-23-branch-divergence-rev-list.py), [Conventional Changelog From Git Log](../docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py), [Branch Management Merge Validation](../docs/concepts/version-control-concepts/scripts/branch-management-merge-validation.sh)
  - _…and 6 more under `docs/concepts/version-control-concepts/` — browse the folder._

## docs (kit notes)

Notes about the kit itself, kept alongside the content they refer to. Browse `docs/`.

- [Kubernetes files added to README tree](../docs/2026-07-21-kubernetes-readme-tree-update.md)
- [Checked README coverage for target files](../docs/2026-07-19-audit-004-check.md)
- [Ansible notebooks — README coverage verified](../docs/2026-07-19-ansible-notebooks-readme-verified.md)
- [Removed dead CHANGELOG references to General/docs/ files](../docs/2026-07-11-removed-dead-general-references.md)

## docs/audit

Notes about the kit itself, kept alongside the content they refer to. Browse `docs/`. The `docs/audit/` folder holds audit records.

- [Repo audit — 2026-10-21](../docs/audit/2026-10-21-repo-audit-014.md)
- [Repo audit — 2026-10-10](../docs/audit/2026-10-10-repo-audit-013.md)
- [Audit 012 — Docker dockerfile count (2026-09-07)](../docs/audit/2026-09-07-audit-012-docker-dockerfile-count.md)
- [Verified OpenTofu README entries](../docs/audit/2026-08-20-audit-011-opentofu-readme.md)
  _…and 2 more — browse `docs/`._
