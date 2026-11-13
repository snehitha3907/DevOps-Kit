# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible · 114 files

- **primer:** [Ansible — quick primer](../Ansible/notes/0000-primer-ansible.md)
- **Notes** (10): [Ansible — quick primer](../Ansible/notes/0000-primer-ansible.md), [Exploring Ansible CLI](../Ansible/notes/2026-06-06-exploring-ansible-cli.md), [Following Ansible Getting Started Guide](../Ansible/notes/2026-06-11-ansible-getting-started.md)  _…and 7 more — browse the folder._
- **Docs** (7): [Wiring ansible-lint into an Ansible workflow](../Ansible/docs/2026-06-15-wiring-ansible-lint.md), [Ansible 14 and ansible-core 2.21 migration guide](../Ansible/docs/ansible-14-core-2-21-migration-guide.md), [Ansible execution environments: building and deploying custom EE images](../Ansible/docs/ansible-execution-environments-custom-images.md)  _…and 4 more — browse the folder._
- **Snippets** (2): [last_verified: 2026-08-12 · Ansible](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py), [Nginx Playbook](../Ansible/snippets/nginx-playbook.yaml)
- **Scripts** (4): [last_verified: 2026-07-19 · Ansible 2.18](../Ansible/scripts/2026-07-19-install-ansible-and-explore-modules.sh), [Install Ansible and run my first ad-hoc command](../Ansible/scripts/install-and-first-adhoc.sh), [Run my first Ansible playbook to configure a local target](../Ansible/scripts/run-first-playbook.sh)  _…and 1 more — browse the folder._
- **Configs** (10): [last_verified: 2026-07-19 · Ansible 2.18](../Ansible/configs/2026-07-19-first-inventory-and-ping-playbook.yaml), [last_verified: 2026-07-19 · Ansible (version-independent)](../Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml), [last_verified: 2026-07-27 · Ansible n/a](../Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml)  _…and 7 more — browse the folder._
- **Manifests** (10): [last_verified: 2026-10-28 · ansible-core 2.21.5](../Ansible/manifests/ansible-playbook-migration.yaml), [last_verified: 2026-08-24 · Ansible](../Ansible/manifests/group_vars/all.yaml), [last_verified: 2026-08-24 · Ansible](../Ansible/manifests/inventory/production.ini)  _…and 7 more — browse the folder._
- **Notebooks** (2): [Ansible Variable Precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb), [Comparing Execution Patterns Block Rescue Serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb)
- **Dockerfiles** (1): [last_verified: 2026-07-25 · Ansible n/a](../Ansible/dockerfiles/ansible-control-node.Dockerfile)
- **Templates** (68): [Ansible project scaffold](../Ansible/templates/ansible-project-scaffold/README.md), [Ansible](../Ansible/templates/ansible-project-scaffold/ansible.cfg), [All](../Ansible/templates/ansible-project-scaffold/group_vars/all.yml)  _…and 65 more — browse the folder._

## ArgoCD · 27 files

- **primer:** [ArgoCD — quick primer](../ArgoCD/notes/0000-primer-argocd.md)
- **Notes** (3): [ArgoCD — quick primer](../ArgoCD/notes/0000-primer-argocd.md), [ArgoCD quickstart — what tripped me up](../ArgoCD/notes/2026-08-11-argocd-quickstart.md), [ArgoCD install manifest stub](../ArgoCD/notes/install.yaml)
- **Docs** (2): [Argo CD with HashiCorp Vault and External Secrets: keeping secrets out of Git, plus RBAC, notification and webhook patterns that hold up in production](../ArgoCD/docs/argocd-vault-external-secrets.md), [How I wired ArgoCD with GitHub for GitOps deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md)
- **Snippets** (1): [last_verified: 2026-09-09 · ArgoCD CLI](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)
- **Scripts** (3): [last_verified: 2026-07-23](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh), [last_verified: 2026-10-20 · ArgoCD 3.3.3](../ArgoCD/scripts/argocd-application-helper.py), [last_verified: 2026-10-02 · ArgoCD CLI](../ArgoCD/scripts/build-argocd-application-from-scratch.sh)
- **Configs** (3): [last_verified: 2026-07-23](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml), [last_verified: 2026-08-11](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml), [last_verified: 2026-10-02](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml)
- **Manifests** (2): [Deployment](../ArgoCD/manifests/guestbook/deployment.yaml), [last_verified: 2026-10-20 · Argo CD (argoproj.io/v1alpha1 ApplicationSet and Application API)](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml)
- **Templates** (13): [Multi-Cluster Argo CD GitOps Repository Template](../ArgoCD/templates/multi-cluster-gitops-repo/README.md), [Sample App](../ArgoCD/templates/multi-cluster-gitops-repo/applications/sample-app.yaml), [Matrix Generator](../ArgoCD/templates/multi-cluster-gitops-repo/applicationset/matrix-generator.yaml)  _…and 10 more — browse the folder._

## AWS · 25 files

- **primer:** [AWS CLI — quick primer](../AWS/notes/0000-primer-aws.md)
- **Notes** (2): [AWS CLI — quick primer](../AWS/notes/0000-primer-aws.md), [AWS primer already exists](../AWS/notes/2026-07-13-primer-already-exists.md)
- **Docs** (2): [IAM cross-account roles with least privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md), [IAM policy walkthrough: scoping least-privilege for a small app stack](../AWS/docs/iam-policy-least-privilege-walkthrough.md)
- **Snippets** (3): [last_verified: 2026-08-12 · AWS CLI](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh), [last_verified: 2026-08-16 · AWS CLI v2](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [last_verified: 2026-09-21 · AWS boto3 n/a](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py)
- **Scripts** (7): [Install AWS CLI v2 and set up credentials](../AWS/scripts/2026-07-12-install-aws-cli-v2-and-configure.sh), [last_verified: 2026-07-13 · AWS CLI v2](../AWS/scripts/2026-07-13-install-aws-cli-v2-and-configure.sh), [last_verified: 2026-08-13 · AWS CLI v2](../AWS/scripts/2026-08-13-install-aws-cli-v2-and-configure-app-default.sh)  _…and 4 more — browse the folder._
- **Configs** (3): [Minimal Aws Config](../AWS/configs/2026-07-12-minimal-aws-config.ini), [Minimal Aws Config](../AWS/configs/2026-07-13-minimal-aws-config.ini), [last_verified: 2026-10-07 · AWS ECS](../AWS/configs/ecs-service-deployment-blue-green.yaml)
- **Notebooks** (1): [Comparing Deployment Approaches Boto3 Cloudformation CDK](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)
- **Templates** (7): [cloudformation-multi-account-stack-set](../AWS/templates/cloudformation-multi-account-stack-set/README.md), [last_verified: 2026-10-07 · AWS CloudFormation · n/a](../AWS/templates/cloudformation-multi-account-stack-set/examples/deploy.sh), [last_verified: 2026-10-07 · AWS CloudFormation · n/a](../AWS/templates/cloudformation-multi-account-stack-set/template.yaml)  _…and 4 more — browse the folder._

## Azure · 28 files

- **primer:** [Azure CLI — quick primer](../Azure/notes/0000-primer-azure.md)
- **Notes** (4): [Azure CLI — quick primer](../Azure/notes/0000-primer-azure.md), [Azure CLI quickstart — what tripped me up](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md), [Azure quickstart — what tripped me up](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md)  _…and 1 more — browse the folder._
- **Docs** (2): [Azure DevOps pipeline integration with Bicep deployments](../Azure/docs/azure-devops-pipeline-bicep-integration.md), [Comparing Azure CLI, Bicep, and the Python SDK for provisioning a small app stack](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md)
- **Snippets** (3): [last_verified: 2026-07-13 - Azure CLI n/a](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh), [last_verified: 2026-08-23 · Azure CLI](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [last_verified: 2026-09-16 · Azure CLI](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh)
- **Scripts** (5): [last_verified: 2026-07-13 - Azure CLI n/a](../Azure/scripts/2026-07-13-install-azure-cli-and-login.sh), [last_verified: 2026-08-17 · Azure CLI](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh), [last_verified: 2026-09-17 · Azure CLI](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)  _…and 2 more — browse the folder._
- **Configs** (2): [last_verified: 2026-10-09 · Azure Container Apps (n/a)](../Azure/configs/container-apps-microservices.yaml), [Azure Key Vault Access Policy](../az/configs/azure-key-vault-access-policy.json)
- **Manifests** (2): [Production AKS Cluster](../Azure/manifests/production-aks-cluster.bicep), [last_verified: 2026-10-25 · Azure Container Apps (n/a)](../az/manifests/container-apps-multi-service-deployment.yaml)
- **Templates** (10): [aks-cluster-with-addons](../Azure/templates/aks-cluster-with-addons/README.md), [last_verified: 2026-10-07 · Azure CLI 2.55+ · Bicep 0.26.x](../Azure/templates/aks-cluster-with-addons/examples/deploy.sh), [Main](../Azure/templates/aks-cluster-with-addons/main.bicep)  _…and 7 more — browse the folder._

## Docker · 58 files

- **primer:** [Docker — quick primer](../Docker/notes/0000-primer-docker.md)
- **Notes** (6): [Docker — quick primer](../Docker/notes/0000-primer-docker.md), [Exploring Docker CLI](../Docker/notes/2026-06-05-explore-docker-cli.md), [Exploring the Docker CLI — images, containers, and Docker Hub](../Docker/notes/2026-06-06-exploring-docker-cli.md)  _…and 3 more — browse the folder._
- **Docs** (11): [Docker build cache and multi-stage layering](../Docker/docs/docker-build-cache-and-multi-stage-layering.md), [Docker build --mount vs COPY for dependency caching in multi-stage builds](../Docker/docs/docker-build-mount-vs-copy-caching.md), [Docker BuildKit advanced features: cache mounts and secrets](../Docker/docs/docker-buildkit-cache-mounts-secrets.md)  _…and 8 more — browse the folder._
- **Snippets** (2): [last_verified: 2026-08-12 · Docker n/a](../Docker/snippets/2026-08-12-build-run-and-cleanup.py), [last_verified: 2026-08-04 · Docker n/a](../Docker/snippets/analyze-image-layers.py)
- **Scripts** (5): [2026-06-12-compose-multi-service.sh](../Docker/scripts/2026-06-12-compose-multi-service.sh), [docker-health-check-and-cleanup.sh](../Docker/scripts/docker-health-check-and-cleanup.sh), [Install Docker and run nginx container](../Docker/scripts/install-and-run-container.sh)  _…and 2 more — browse the folder._
- **Configs** (1): [Multi Service App](../Docker/configs/multi-service-app.yaml)
- **Manifests** (9): [Web Db Compose](../Docker/manifests/2026-06-13-web-db-compose.yaml), [docker-compose.yml — Go HTTP server + Redis with health checks](../Docker/manifests/2026-06-28-go-redis-compose-healthchecks.yaml), [last_verified: 2026-11-08 · Docker Compose n/a](../Docker/manifests/app-postgres-healthchecks.compose.yaml)  _…and 6 more — browse the folder._
- **Notebooks** (3): [Comparing Compose Swarm Kubernetes Local Orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb), [Comparing Docker Build Strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb), [Comparing Docker Networking Drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
- **Dockerfiles** (9): [Build And Run First](../Docker/dockerfiles/build-and-run-first.Dockerfile), [First Docker Image](../Docker/dockerfiles/first-docker-image.Dockerfile), [Multi Stage Go HTTP Server](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)  _…and 6 more — browse the folder._
- **Templates** (12): [last_verified: 2026-08-05 · Docker n/a](../Docker/templates/go-microservice/.dockerignore), [last_verified: 2026-08-05 · Docker n/a](../Docker/templates/go-microservice/Dockerfile), [last_verified: 2026-08-05 · Docker n/a](../Docker/templates/go-microservice/Makefile)  _…and 9 more — browse the folder._

## Flux CD · 8 files

- **Notes** (2): [Exploring the Flux CLI command surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md), [Flux quickstart, and what tripped me up](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md)
- **Docs** (2): [Flux CD: README Coverage table and topics.md update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md), [Wiring Flux CD with GitHub for GitOps Deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md)
- **Scripts** (2): [last_verified: 2026-09-19 · Flux CD 2.x (flux CLI)](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh), [last_verified: 2026-10-20 · Flux CD 2.x (flux CLI)](../FluxCD/scripts/bootstrap-flux-on-kind.sh)
- **Configs** (2): [last_verified: 2026-09-30 · Flux CD (n/a)](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml), [last_verified: 2026-10-20 · Flux CD 2.x (HelmRelease + ImageAutomation)](../FluxCD/configs/helmrelease-image-automation.yaml)

## GCP · 15 files

- **primer:** [Google Cloud SDK — quick primer](../GCP/notes/0000-primer-gcp.md)
- **Notes** (2): [Google Cloud SDK — quick primer](../GCP/notes/0000-primer-gcp.md), [Following the gcloud quickstart — what tripped me up](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md)
- **Docs** (1): [GCP/ coverage note — 2026-09-28](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)
- **Snippets** (2): [last_verified: 2026-07-16 · GCP SDK (gcloud CLI)](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh), [last_verified: 2026-08-23 · GCP SDK (gcloud CLI)](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh)
- **Scripts** (6): [last_verified: 2026-07-16 · GCP SDK (gcloud CLI)](../GCP/scripts/2026-07-16-install-gcloud-cli-and-configure-creds.sh), [last_verified: 2026-08-23 · GCP SDK (gcloud CLI)](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh), [last_verified: 2026-09-21 · GCP gcloud CLI](../GCP/scripts/2026-09-21-launch-vm-firewall-and-ssh.sh)  _…and 3 more — browse the folder._
- **Configs** (4): [last_verified: 2026-08-14 · GCP SDK (gcloud CLI)](../GCP/configs/2026-08-14-minimal-gcloud-config-and-startup-script.yaml), [last_verified: 2026-09-21 · GCP gcloud CLI](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml), [last_verified: 2026-08-24 · GCP IAM · n/a](../GCP/configs/service-account-and-iam-config.yaml)  _…and 1 more — browse the folder._

## Git · 85 files

- **primer:** [Git — quick primer](../Git/notes/0000-primer-git.md)
- **Notes** (6): [Git — quick primer](../Git/notes/0000-primer-git.md), [Exploring the Git CLI — init, add, commit, log](../Git/notes/2026-06-04-explore-git-cli.md), [Installing Git — first try](../Git/notes/2026-06-04-install-git.md)  _…and 3 more — browse the folder._
- **Docs** (15): [.Pre Commit Config](../Git/docs/.pre-commit-config.yaml), [git/ folder README coverage](../Git/docs/2026-08-04-git-folder-readme-coverage.md), [Document Git/docs/ folder in README Layout](../Git/docs/2026-08-22-document-git-docs-folder-in-readme.md)  _…and 12 more — browse the folder._
- **Snippets** (1): [First Commit](../Git/snippets/first-commit.sh)
- **Scripts** (14): [Simulate a merge conflict and resolve it — practicing the full cycle](../Git/scripts/2026-06-10-merge-conflict-practice.sh), [batch-git-ops.sh — Run git operations across multiple repositories](../Git/scripts/batch-git-ops.sh), [last_verified: 2026-09-25 · git (n/a)](../Git/scripts/bisect-automation-runner.sh)  _…and 11 more — browse the folder._
- **Notebooks** (3): [Comparing Git Merge Strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb), [Merge Rebase Squash Comparison](../Git/notebooks/merge-rebase-squash-comparison.ipynb), [Merge Rebase Squash Comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb)
- **Templates** (46): [commit-msg hook — validate commit message format](../Git/templates/git-hooks/commit-msg), [post-checkout hook — maintain hooks and display context after branch switch](../Git/templates/git-hooks/post-checkout), [post-commit hook — log commit metadata and suggest follow-up actions](../Git/templates/git-hooks/post-commit)  _…and 43 more — browse the folder._

## GitHub · 56 files

- **primer:** [GitHub — quick primer](../GitHub/notes/0000-primer-github.md)
- **Notes** (11): [GitHub — quick primer](../GitHub/notes/0000-primer-github.md), [Exploring GitHub web UI and CLI](../GitHub/notes/2026-06-07-explore-github-web-and-cli.md), [Exploring GitHub repos, issues, and PRs](../GitHub/notes/2026-06-10-exploring-github-repos-issues-prs.md)  _…and 8 more — browse the folder._
- **Docs** (7): [Document GitHub/docs/ in README Layout](../GitHub/docs/2026-08-22-document-github-docs-in-readme.md), [Document GitHub/notebooks/ in README Layout](../GitHub/docs/2026-08-22-document-github-notebooks-in-readme.md), [How I set up branch protection rules and required reviews for CI](../GitHub/docs/branch-protection-and-required-reviews-for-ci.md)  _…and 4 more — browse the folder._
- **Snippets** (3): [List open issues](../GitHub/snippets/github-issues-api.py), [Print repo names for my user.](../GitHub/snippets/list-repos-with-python.py), [last_verified: 2026-08-22 · GitHub CLI (gh)](../GitHub/snippets/open-pr-and-wait-for-ci.sh)
- **Scripts** (7): [Authenticate with gh and explore my profile](../GitHub/scripts/2026-06-10-auth-and-explore-profile.sh), [2026-06-12-create-repo-and-pr.sh](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh), [Log in to GitHub and poke around my profile](../GitHub/scripts/auth-and-profile.sh)  _…and 4 more — browse the folder._
- **Configs** (7): [last_verified: 2026-08-22 · GitHub Actions · n/a](../GitHub/configs/2026-08-22-pr-checker-workflow.yaml), [last_verified: 2026-07-04 · GitHub n/a](../GitHub/configs/dot-github-repository/config.yml), [last_verified: 2026-07-04 · GitHub n/a](../GitHub/configs/dot-github-repository/issue-forms/bug-report.yaml)  _…and 4 more — browse the folder._
- **Manifests** (1): [last_verified: 2026-09-21 · GitHub n/a](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **Notebooks** (2): [Analyzing Github Actions Usage Across Org Repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb), [Comparing API Approaches Release Automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb)
- **Dockerfiles** (1): [last_verified: 2026-09-21 · GitHub self-hosted runner image](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)
- **Templates** (17): [last_verified: 2026-09-19 · GitHub n/a](../GitHub/templates/github-repo-scaffold/.github/ISSUE_TEMPLATE/bug_report.yml), [last_verified: 2026-09-19 · GitHub n/a](../GitHub/templates/github-repo-scaffold/.github/ISSUE_TEMPLATE/documentation.yml), [last_verified: 2026-09-19 · GitHub n/a](../GitHub/templates/github-repo-scaffold/.github/ISSUE_TEMPLATE/feature_request.yml)  _…and 14 more — browse the folder._

## GitHub Actions · 26 files

- **primer:** [GitHub Actions — quick primer](../GitHub Actions/notes/0000-primer-github-actions.md)
- **Notes** (5): [GitHub Actions — quick primer](../GitHub Actions/notes/0000-primer-github-actions.md), [GitHub Actions quickstart — what tripped me up](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md), [GitHub Actions primer already exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)  _…and 2 more — browse the folder._
- **Docs** (7): [CI](../GitHub Actions/docs/.github/workflows/ci.yml), [GitHub Actions quickstart — what tripped me up](../GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md), [Choosing between artifacts, cache, and external storage for build outputs in GitHub Actions](../GitHub Actions/docs/choosing-between-artifacts-cache-external-storage.md)  _…and 4 more — browse the folder._
- **Snippets** (1): [last_verified: 2026-08-15 · GitHub REST API](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)
- **Scripts** (4): [last_verified: 2026-07-11 · gh (GitHub CLI) 2.x](../GitHub Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh), [last_verified: 2026-07-13 · gh (GitHub CLI) 2.x](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh), [last_verified: 2026-10-03 · GitHub Actions n/a](../GitHub Actions/scripts/manage-secrets-across-repos.py)  _…and 1 more — browse the folder._
- **Configs** (5): [My first CI workflow with environment variables and secrets](../GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml), [last_verified: 2026-07-11 · GitHub Actions (SaaS)](../GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml), [last_verified: 2026-07-13 · GitHub Actions (SaaS)](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)  _…and 2 more — browse the folder._
- **Dockerfiles** (1): [syntax=docker/dockerfile:1](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)
- **Templates** (3): [Multi-environment deploy template](../GitHub Actions/templates/multi-env-deploy/README.md), [last_verified: 2026-10-03 · GitHub Actions n/a](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml), [last_verified: 2026-10-03 · GitHub Actions n/a](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml)

## GitLab CI · 25 files

- **primer:** [GitLab CI/CD — quick primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **Notes** (4): [.Gitlab CI](../GitLab CI/notes/.gitlab-ci.yml), [GitLab CI/CD — quick primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md), [Following the GitLab CI/CD quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md)  _…and 1 more — browse the folder._
- **Docs** (2): [GitLab CI/CD pipeline library patterns](../GitLab CI/docs/gitlab-ci-cd-pipeline-library-patterns.md), [GitLab CI/CD with Kubernetes — end-to-end walkthrough](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md)
- **Snippets** (1): [last_verified: 2026-09-20 - GitLab CI (n/a)](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- **Scripts** (5): [Install GitLab Runner and register for a project](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh), [Run First Local Pipeline](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh), [last_verified: 2026-09-21 · GitLab CI gitlab-runner](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh)  _…and 2 more — browse the folder._
- **Configs** (4): [My first .gitlab-ci.yml — build a Go project and run tests](../GitLab CI/configs/2026-06-22-first-pipeline.yaml), [last_verified: 2026-09-20 - GitLab CI (n/a)](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml), [last_verified: 2026-09-22 · GitLab CI (n/a)](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml)  _…and 1 more — browse the folder._
- **Dockerfiles** (1): [last_verified: 2026-10-22 · GitLab Runner self-hosted image](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)
- **Templates** (8): [last_verified: 2026-10-22 · GitLab CI (n/a)](../GitLab CI/templates/modular-pipeline-repo/.gitlab-ci.yml), [last_verified: 2026-10-22 · GitLab CI (n/a)](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/build.yml), [last_verified: 2026-10-22 · GitLab CI (n/a)](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/deploy.yml)  _…and 5 more — browse the folder._

## Helm · 63 files

- **primer:** [Helm — quick primer](../Helm/notes/0000-primer-helm.md)
- **Notes** (3): [Helm — quick primer](../Helm/notes/0000-primer-helm.md), [Helm quickstart — what tripped me up](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [Values](../Helm/notes/values.yaml)
- **Docs** (6): [Helm/ folder already in README Layout and Coverage table](../Helm/docs/2026-07-22-helm-added-to-readme.md), [Add Helm/ folder to DevOps-Kit README Layout and Coverage table](../Helm/docs/2026-07-25-add-helm-to-readme-layout-and-coverage.md), [Helm/ already in README](../Helm/docs/2026-07-25-helm-readme-already-documented.md)  _…and 3 more — browse the folder._
- **Snippets** (1): [last_verified: 2026-08-11 · Helm 4.2.2](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **Scripts** (5): [last_verified: 2026-07-23 · Helm n/a](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh), [last_verified: 2026-09-17 · Helm n/a](../Helm/scripts/demo-web-service-chart.sh), [last_verified: 2026-09-17 · Helm](../Helm/scripts/dummy-test.sh)  _…and 2 more — browse the folder._
- **Configs** (5): [last_verified: 2026-07-23 · Helm n/a](../Helm/configs/2026-07-23-first-helm-chart-inspection.yaml), [last_verified: 2026-08-29 · Helm n/a](../Helm/configs/2026-08-29-live-values.yaml), [last_verified: 2026-08-30 · Helm n/a](../Helm/configs/2026-08-30-production-deployment-values.yaml)  _…and 2 more — browse the folder._
- **Manifests** (15): [Chart](../Helm/manifests/demo-chart/Chart.yaml), [demo-chart](../Helm/manifests/demo-chart/README.md), [ Helpers](../Helm/manifests/demo-chart/templates/_helpers.tpl)  _…and 12 more — browse the folder._
- **Notebooks** (1): [Release Lifecycle Drill](../Helm/notebooks/release-lifecycle-drill.ipynb)
- **Templates** (27): [last_verified: 2026-10-21 · Helm · n/a](../Helm/templates/helm-library-scaffold/Chart.yaml), [helm-library-scaffold — Helm chart library scaffold](../Helm/templates/helm-library-scaffold/README.md), [last_verified: 2026-10-21 · Helm · n/a](../Helm/templates/helm-library-scaffold/templates/_helpers.tpl)  _…and 24 more — browse the folder._

## Jenkins · 3 files

- **primer:** [Jenkins — quick primer](../jnk/notes/0000-primer-jenkins.md)
- **Notes** (2): [Jenkins — quick primer](../jnk/notes/0000-primer-jenkins.md), [Jenkins — install and run my first CLI command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md)
- **Scripts** (1): [last_verified: 2026-10-27 · Jenkins n/a](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

## Kubernetes · 102 files

- **primer:** [Kubernetes — quick primer](../Kubernetes/notes/0000-primer-kubernetes.md)
- **Notes** (10): [Kubernetes — quick primer](../Kubernetes/notes/0000-primer-kubernetes.md), [Exploring kubectl — pods, deployments, and services](../Kubernetes/notes/2026-06-06-exploring-kubectl.md), [Following the Kubernetes interactive tutorial](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)  _…and 7 more — browse the folder._
- **Docs** (6): [Kubernetes Gateway API migration from Ingress](../Kubernetes/docs/gateway-api-migration-from-ingress.md), [Kubernetes ingress with path-based routing for multiple services](../Kubernetes/docs/ingress-path-based-routing.md), [Ingress](../Kubernetes/docs/ingress.yaml)  _…and 3 more — browse the folder._
- **Snippets** (2): [last_verified: 2026-09-18 · Kubernetes](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh), [last_verified: 2026-07-22 - n/a](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
- **Scripts** (4): [Custom Resource Reconciliation Controller](../Kubernetes/scripts/custom-resource-reconciliation-controller.go), [Install kind and kubectl, then spin up my first cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh), [Following the k8s-002 manifest, manage pod lifecycle: create, inspect, delete](../Kubernetes/scripts/pod-lifecycle.sh)  _…and 1 more — browse the folder._
- **Configs** (1): [last_verified: 2026-08-12 · Kubernetes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)
- **Manifests** (7): [Configmap Secret Mounted Pod](../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml), [last_verified: 2026-10-14 · Kubernetes n/a](../Kubernetes/manifests/cluster-api-bootstrap.yaml), [Deployment Service With Probes Limits](../Kubernetes/manifests/deployment-service-with-probes-limits.yaml)  _…and 4 more — browse the folder._
- **Notebooks** (2): [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb), [Comparing Kubernetes Workload Types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb)
- **Templates** (70): [last_verified: 2026-08-26 · Kubernetes · n/a](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/Chart.yaml), [last_verified: 2026-08-26 · Kubernetes · n/a](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/templates/_helpers.tpl), [last_verified: 2026-08-26 · Kubernetes · n/a](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/templates/deployment.yaml)  _…and 67 more — browse the folder._

## OpenTelemetry · 10 files

- **primer:** [OpenTelemetry — quick primer](../otel/notes/0000-primer-opentelemetry.md)
- **Notes** (2): [OpenTelemetry — quick primer](../otel/notes/0000-primer-opentelemetry.md), [Following the OpenTelemetry quickstart — what tripped me up](../otel/notes/2026-09-30-quickstart-trip-ups.md)
- **Docs** (2): [otel/ coverage note — 2026-09-25](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md), [Context propagation with OpenTelemetry: W3C tracecontext vs B3](../otel/docs/context-propagation-w3c-vs-b3.md)
- **Snippets** (2): [last_verified: 2026-09-26 · opentelemetry-sdk n/a](../otel/snippets/2026-09-26-first-trace-span.py), [Instrumented HTTP Server](../otel/snippets/2026-09-30-instrumented-http-server.go)
- **Scripts** (2): [last_verified: 2026-09-26 · OpenTelemetry n/a](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh), [last_verified: 2026-10-14 · opentelemetry-sdk n/a](../otel/scripts/custom-span-processor-resource-detector.py)
- **Configs** (2): [last_verified: 2026-09-30 · OpenTelemetry n/a](../otel/configs/2026-09-30-collector-otlp-export.yaml), [last_verified: 2026-10-14 · OpenTelemetry n/a](../otel/configs/collector-otlp-real-pipeline.yaml)

## OpenTofu · 19 files

- **primer:** [OpenTofu — quick primer](../OpenTofu/notes/0000-primer-opentofu.md)
- **Notes** (2): [OpenTofu — quick primer](../OpenTofu/notes/0000-primer-opentofu.md), [Following the official OpenTofu quickstart — what tripped me up](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md)
- **Docs** (4): [What I learned doing the OpenTofu state management tutorial](../OpenTofu/docs/2026-08-25-state-management-tutorial-notes.md), [Backup](../OpenTofu/docs/backup.json), [OpenTofu Provider Development: Creating a Custom Provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md)  _…and 1 more — browse the folder._
- **Scripts** (3): [last_verified: 2026-07-18 · OpenTofu n/a](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh), [last_verified: 2026-09-18 · OpenTofu n/a](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh), [last_verified: 2026-10-06 · OpenTofu n/a](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh)
- **Configs** (2): [last_verified: 2026-07-18 · OpenTofu n/a](../OpenTofu/configs/2026-07-18-minimal-local-config.tf), [last_verified: 2026-08-25 · OpenTofu · n/a](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl)
- **Notebooks** (2): [Comparing Opentofu And Terraform Aws Provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb), [Comparing Opentofu And Terraform State Management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb)
- **Templates** (6): [aws-reusable-module — a shared OpenTofu VPC module for AWS](../OpenTofu/templates/aws-reusable-module/README.md), [last_verified: 2026-10-05 · OpenTofu n/a](../OpenTofu/templates/aws-reusable-module/examples/basic/main.tf), [last_verified: 2026-10-05 · OpenTofu n/a](../OpenTofu/templates/aws-reusable-module/main.tf)  _…and 3 more — browse the folder._

## Prometheus · 40 files

- **primer:** [Prometheus — quick primer](../Prometheus/notes/0000-primer-prometheus.md)
- **Notes** (2): [Prometheus — quick primer](../Prometheus/notes/0000-primer-prometheus.md), [Prometheus getting started — what tripped me up](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md)
- **Docs** (4): [Wiring Prometheus Alertmanager with PagerDuty for on-call rotations](../Prometheus/docs/alertmanager-pagerduty-oncall-rotations.md), [Prometheus integration with Kubernetes: service discovery, pod annotations, kube-state-metrics, and managed Prometheus differences](../Prometheus/docs/prometheus-kubernetes-integration.md), [Prometheus recording rules and alert reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md)  _…and 1 more — browse the folder._
- **Snippets** (1): [last_verified: 2026-09-05 · Prometheus n/a](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)
- **Scripts** (6): [last_verified: 2026-07-23 · Prometheus n/a](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh), [last_verified: 2026-10-29 · Prometheus n/a](../Prometheus/scripts/2026-10-29-prometheus-alerting-rule-validation.sh), [last_verified: 2026-09-30 · Prometheus n/a](../Prometheus/scripts/custom-app-exporter.py)  _…and 3 more — browse the folder._
- **Configs** (5): [last_verified: 2026-07-23 · Prometheus n/a](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml), [last_verified: 2026-09-05 · Prometheus n/a](../Prometheus/configs/2026-09-05-minimal-container-monitoring-config.yml), [last_verified: 2026-10-19 · Prometheus n/a](../Prometheus/configs/production-prometheus.yml)  _…and 2 more — browse the folder._
- **Manifests** (3): [last_verified: 2026-10-29 · Prometheus n/a](../Prometheus/manifests/production-prometheus-ha.yaml), [last_verified: 2026-10-29 · Prometheus n/a](../pro/manifests/production-prometheus-ha.yaml), [last_verified: 2026-10-29 · Prometheus n/a](../pro/manifests/prometheus-grafana-stack-deployment.yaml)
- **Notebooks** (1): [Querying Prometheus With Promql Step Through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)
- **Templates** (18): [last_verified: 2026-10-19 · Docker Compose (n/a)](../Prometheus/templates/prometheus-alertmanager-grafana-stack/.env.example), [Prometheus + Alertmanager + Grafana Monitoring Stack](../Prometheus/templates/prometheus-alertmanager-grafana-stack/README.md), [last_verified: 2026-10-19 · Alertmanager n/a](../Prometheus/templates/prometheus-alertmanager-grafana-stack/alertmanager.yml)  _…and 15 more — browse the folder._

## Pulumi · 25 files

- **primer:** [Pulumi — quick primer](../plm/notes/0000-primer-plm.md)
- **Notes** (2): [Pulumi — quick primer](../plm/notes/0000-primer-plm.md), [Pulumi quickstart — what tripped me up](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md)
- **Docs** (2): [Document plm/ in README Layout + Coverage table](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md), [How I structured a multi-stack Pulumi project: dev/staging stacks, StackReference, and cross-stack resource wiring](../plm/docs/multi-stack-project-structure.md)
- **Snippets** (1): [last_verified: 2026-09-19 · pulumi n/a](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)
- **Scripts** (4): [last_verified: 2026-09-19 · pulumi n/a](../plm/scripts/2026-09-19-install-pulumi-cli-and-init-project.sh), [last_verified: 2026-09-30 · pulumi n/a](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py), [last_verified: 2026-10-14 · pulumi n/a](../plm/scripts/network-component-vpc-subnets.py)  _…and 1 more — browse the folder._
- **Configs** (3): [last_verified: 2026-09-30 · pulumi n/a](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml), [last_verified: 2026-10-14 · pulumi n/a](../plm/configs/minimal-project-and-stack-config.yaml), [last_verified: 2026-10-29 · pulumi n/a](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml)
- **Templates** (13): [last_verified: 2026-10-30 · Pulumi n/a](../Pulumi/templates/pulumi-python-project-scaffold/Pulumi.dev.yaml), [last_verified: 2026-10-30 · Pulumi n/a](../Pulumi/templates/pulumi-python-project-scaffold/Pulumi.prod.yaml), [last_verified: 2026-10-30 · Pulumi n/a](../Pulumi/templates/pulumi-python-project-scaffold/Pulumi.yaml)  _…and 10 more — browse the folder._

## Terraform · 74 files

- **primer:** [Terraform — quick primer](../Terraform/notes/0000-primer-terraform.md)
- **Notes** (6): [Terraform — quick primer](../Terraform/notes/0000-primer-terraform.md), [Exploring Terraform CLI](../Terraform/notes/2026-06-06-exploring-terraform-cli.md), [Terraform getting-started tutorial](../Terraform/notes/2026-06-10-terraform-getting-started.md)  _…and 3 more — browse the folder._
- **Docs** (8): [How I wired Terraform workspaces and remote state locking with S3 + DynamoDB](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md), [Terraform coverage correction](../Terraform/docs/2026-09-17-coverage-correction.md), [How I wired Terraform workspaces and remote state locking with S3 + DynamoDB](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md)  _…and 5 more — browse the folder._
- **Snippets** (3): [last_verified: 2026-08-17 · Terraform](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh), [last_verified: 2026-09-04 · Terraform · n/a](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [last_verified: 2026-08-17 · Terraform](../Terraform/snippets/reusable-module-for-each-validation.hcl)
- **Scripts** (4): [Bootstrap a Terraform project with variables and outputs](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh), [last_verified: 2026-08-22 · Terraform · n/a](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py), [Install Terraform and run my first project](../Terraform/scripts/install-and-init.sh)  _…and 1 more — browse the folder._
- **Configs** (10): [I kept the variable block inline here so the whole config is one file](../Terraform/configs/2026-06-12-tried-local-with-vars.tf), [last_verified: 2026-09-19 · terraform n/a](../Terraform/configs/2026-09-19-local-file-random-provider.hcl), [Local File](../Terraform/configs/local-file.tf)  _…and 7 more — browse the folder._
- **Manifests** (2): [last_verified: 2026-08-25 · Terraform · n/a](../Terraform/manifests/reusable-vpc-module.hcl), [Simple EC2 App](../Terraform/manifests/simple-ec2-app.tf)
- **Notebooks** (2): [Comparing For Each Vs Count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb), [Comparing Terraform Vs Opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb)
- **Templates** (39): [Multi-environment Terraform with workspaces and remote state — Project Scaffold](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/README.md), [last_verified: 2026-09-13 · Terraform · n/a](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/environments/dev/backend.tf), [last_verified: 2026-09-13 · Terraform · n/a](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/environments/dev/terraform.tfvars)  _…and 36 more — browse the folder._

## Trivy · 17 files

- **primer:** [Trivy — quick primer](../Trivy/notes/0000-primer-trivy.md)
- **Notes** (5): [Trivy — quick primer](../Trivy/notes/0000-primer-trivy.md), [Trivy CLI exploration — what can I scan and how do I read the output](../Trivy/notes/2026-06-25-exploring-trivy-cli.md), [Trivy quickstart — what tripped me up](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)  _…and 2 more — browse the folder._
- **Docs** (2): [Trivy scan modes — image vs fs vs repo vs sbom, with a pipeline example](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md), [Trivy SBOM Generation and Vulnerability Reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md)
- **Snippets** (2): [last_verified: 2026-07-12 · Trivy latest](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py), [last_verified: 2026-08-16 · Trivy latest](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py)
- **Scripts** (5): [Scanning a container image with Trivy and parsing the JSON output](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh), [last_verified: 2026-07-12 · Trivy latest](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh), [last_verified: 2026-09-21 · Trivy latest](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)  _…and 2 more — browse the folder._
- **Configs** (3): [last_verified: 2026-08-12 · Trivy n/a](../Trivy/configs/2026-08-12-trivy-config.yaml), [last_verified: 2026-08-27 · Trivy n/a](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [last_verified: 2026-10-18 · Trivy Operator 0.22.0](../Trivy/configs/trivy-operator-admission-control.yaml)

## Grafana · 10 files

- **primer:** [Grafana — quick primer](../graf/notes/0000-primer-grafana.md)
- **Notes** (4): [Grafana — quick primer](../graf/notes/0000-primer-grafana.md), [Poking around the Grafana UI — data sources, panels, dashboards](../graf/notes/2026-09-25-explore-grafana-ui.md), [2026-09-29-grafana-quickstart-trip-ups.md](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md)  _…and 1 more — browse the folder._
- **Docs** (3): [graf/ coverage note — 2026-09-25](../graf/docs/2026-09-25-grafana-coverage-and-topics.md), [graf/ navigation dedup note — 2026-09-25](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [How I wired Grafana into Prometheus and Alertmanager for unified metrics and alert visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md)
- **Scripts** (2): [last_verified: 2026-09-25 · Grafana n/a](../graf/scripts/2026-09-25-install-grafana-with-docker.sh), [last_verified: 2026-10-20 · graf 11.x](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py)
- **Configs** (1): [last_verified: 2026-10-13 · Grafana n/a](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)

## HashiCorp Vault · 11 files

- **primer:** [HashiCorp Vault — quick primer](../vlt/notes/0000-primer-vlt.md)
- **Notes** (3): [HashiCorp Vault — quick primer](../vlt/notes/0000-primer-vlt.md), [Exploring the vault CLI — secrets, policies, and what's there](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md), [Vault dev-mode quickstart — what tripped me up](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md)
- **Docs** (2): [Document vlt/ in README Layout + Coverage table and topics.md](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md), [Wiring Vault Agent into a containerized app for secret injection](../vlt/docs/vault-agent-secret-injection.md)
- **Scripts** (4): [last_verified: 2026-09-19 · vault n/a](../vlt/scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh), [last_verified: 2026-09-30 · vault n/a](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh), [last_verified: 2026-10-07 · hvac (Vault API client)](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py)  _…and 1 more — browse the folder._
- **Configs** (2): [last_verified: 2026-10-07 · Vault policy HCL](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl), [last_verified: 2026-10-25 · Vault n/a](../vlt/configs/vault-approle.hcl)

## Grafana Cloud · 6 files

- **Notes** (2): [My first hosted dashboard in Grafana Cloud](../grafc/notes/2026-09-30-first-hosted-dashboard.md), [Grafana Cloud quickstart — what tripped me up](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md)
- **Snippets** (1): [First Dashboard Over HTTP](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)
- **Scripts** (1): [last_verified: 2026-10-19 · Grafana Cloud (n/a)](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)
- **Configs** (2): [last_verified: 2026-09-30 · Grafana Cloud (n/a)](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml), [last_verified: 2026-10-19 · Grafana Cloud (n/a)](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml)

## Foundational Concepts

- **Linux & System Administration** · 8 files
  - **primer:** [Linux & System Administration — quick primer](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
  - [Linux process and file permission patterns in DevOps workflows](../docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md)
  - [systemd timers + journald forwarding for audit-ready workflows](../docs/concepts/linux-system-administration/docs/systemd-timers-journald-shipping.md)
  - [Linux System Performance Analysis](../docs/concepts/linux-system-administration/notebooks/linux-system-performance-analysis.ipynb)
  _…and 4 more — browse the folder._

- **Scripting & Automation (Bash/Python)** · 11 files
  - **primer:** [Scripting & Automation (Bash/Python) — quick primer](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
  - [Combining scripting with IaC: automation patterns for Terraform and Ansible workflows](../docs/concepts/scripting-automation-bash-python/docs/combining-scripting-with-iac-automation-patterns.md)
  - [Site](../docs/concepts/scripting-automation-bash-python/docs/site.yml)
  - [Bash Python Glue Patterns](../docs/concepts/scripting-automation-bash-python/notebooks/2026-08-11-bash-python-glue-patterns.ipynb)
  _…and 7 more — browse the folder._

- **Networking Fundamentals** · 11 files
  - **primer:** [Networking Fundamentals — quick primer](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
  - [DNS TLS Load Balancing Visualization](../docs/concepts/networking-fundamentals/notebooks/2026-08-10-dns-tls-load-balancing-visualization.ipynb)
  - [Network Health Telemetry Visualization](../docs/concepts/networking-fundamentals/notebooks/network-health-telemetry-visualization.ipynb)
  - [Network troubleshooting patterns for containers and services](../docs/concepts/networking-fundamentals/notes/2026-08-07-network-troubleshooting-patterns.md)
  _…and 7 more — browse the folder._

- **Version Control Concepts** · 10 files
  - **primer:** [Version Control Concepts — quick primer](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
  - [Trunk-based delivery with short-lived branches: protecting main, merge queues, and CODEOWNERS](../docs/concepts/version-control-concepts/2026-09-25-trunk-based-delivery-short-lived-branches.md)
  - [Branch protection, merge strategies, and release automation: wiring version control into CI/CD](../docs/concepts/version-control-concepts/docs/branch-protection-merge-strategies-release-automation.md)
  - [Version control and IaC: managing Terraform modules and environment promotion with Git branching](../docs/concepts/version-control-concepts/docs/terraform-modules-environment-promotion.md)
  _…and 6 more — browse the folder._

- **Containerization Concepts** · 8 files
  - **primer:** [Containerization Concepts — quick primer](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
  - [Smaller images through base-image selection, layer caching, and minimal runtimes](../docs/concepts/containerization-concepts/docs/2026-08-08-smaller-images-base-caching-runtimes.md)
  - [Image scanning and signing in the container build pipeline](../docs/concepts/containerization-concepts/docs/image-scanning-and-signing-in-a-build-pipeline.md)
  - [Container Network Topology Service Discovery](../docs/concepts/containerization-concepts/notebooks/container-network-topology-service-discovery.ipynb)
  _…and 4 more — browse the folder._

- **CI/CD Concepts** · 9 files
  - **primer:** [CI/CD Concepts — quick primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
  - [Combining CI/CD with artifact promotion gates and environment-based rollbacks](../docs/concepts/ci-cd-concepts/2026-08-10-artifact-promotion-gates-rollbacks.md)
  - [Combining CI/CD concepts with artifact promotion and environment-based rollbacks](../docs/concepts/ci-cd-concepts/docs/artifact-promotion-environment-rollbacks.md)
  - [How I wired preview-environment gates into a multi-environment deployment workflow](../docs/concepts/ci-cd-concepts/docs/ephemeral-preview-environments-gated-promotion.md)
  _…and 5 more — browse the folder._

- **Infrastructure as Code Concepts** · 7 files
  - **primer:** [Infrastructure as Code Concepts — quick primer](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
  - [Terraform provisions, Ansible configures: splitting IaC duties](../docs/concepts/infrastructure-as-code-concepts/docs/2026-08-08-terraform-ansible-division-of-responsibility.md)
  - [Terraform and Docker integration patterns](../docs/concepts/infrastructure-as-code-concepts/docs/terraform-docker-integration-patterns.md)
  - [Declarative Vs Imperative IaC](../docs/concepts/infrastructure-as-code-concepts/notebooks/2026-08-08-declarative-vs-imperative-iac.ipynb)
  _…and 3 more — browse the folder._

- **Monitoring & Observability Concepts** · 8 files
  - **primer:** [Monitoring & Observability Concepts — quick primer](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
  - [Stitching metrics, logs, and traces into one request story](../docs/concepts/monitoring-observability-concepts/docs/2026-08-09-combining-metrics-logs-traces-observability.md)
  - [Integrating observability into CI/CD: pipeline health telemetry, DORA metrics, and deployment markers](../docs/concepts/monitoring-observability-concepts/docs/cicd-pipeline-health-telemetry-dora-deployment-markers.md)
  - [Scraping Endpoint Three Pillars](../docs/concepts/monitoring-observability-concepts/notebooks/2026-08-11-scraping-endpoint-three-pillars.ipynb)
  _…and 4 more — browse the folder._

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
