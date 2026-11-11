# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## AWS · 25 files

- **primer:** [0000-primer-aws](../AWS/notes/0000-primer-aws.md)
- **notes** (2): [2026-07-13-primer-already-exists](../AWS/notes/2026-07-13-primer-already-exists.md), [0000-primer-aws](../AWS/notes/0000-primer-aws.md)
- **docs** (2): [iam-policy-least-privilege-walkthrough](../AWS/docs/iam-policy-least-privilege-walkthrough.md), [iam-cross-account-roles-least-privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md)
- **scripts** (7): most recent → [2026-08-14-aws-cli-quickstart-walkthrough](../AWS/scripts/2026-08-14-aws-cli-quickstart-walkthrough.sh), [2026-08-13-install-aws-cli-v2-and-configure-app-default](../AWS/scripts/2026-08-13-install-aws-cli-v2-and-configure-app-default.sh), [vpc-with-private-endpoints](../AWS/scripts/vpc-with-private-endpoints.py)
- _…and 4 more under `AWS/scripts/` — browse the folder._
- **configs** (3): [ecs-service-deployment-blue-green](../AWS/configs/ecs-service-deployment-blue-green.yaml), [2026-07-13-minimal-aws-config](../AWS/configs/2026-07-13-minimal-aws-config.ini), [2026-07-12-minimal-aws-config](../AWS/configs/2026-07-12-minimal-aws-config.ini)
- **snippets** (3): [2026-08-16-list-and-tag-ec2-instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [2026-09-21-create-s3-bucket-and-upload-object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py), [2026-08-12-list-ec2-and-s3](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)
- **notebooks** (1): [comparing-deployment-approaches-boto3-cloudformation-cdk](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)
- **templates** (7): most recent → [main](../aws/templates/aws-control-tower-landing-zone/main.tf), [variables](../aws/templates/aws-control-tower-landing-zone/variables.tf), [outputs](../aws/templates/aws-control-tower-landing-zone/outputs.tf)
- _…and 4 more under `aws/templates/` — browse the folder._

## Ansible · 112 files

- **primer:** [0000-primer-ansible](../Ansible/notes/0000-primer-ansible.md)
- **notes** (10): most recent → [2026-06-13-ansible-playbook-troubleshooting](../Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md), [2026-06-06-exploring-ansible-cli](../Ansible/notes/2026-06-06-exploring-ansible-cli.md), [2026-06-11-ansible-getting-started](../Ansible/notes/2026-06-11-ansible-getting-started.md)
- _…and 7 more under `Ansible/notes/` — browse the folder._
- **docs** (7): most recent → [ansible-over-terraform-local-exec](../Ansible/docs/ansible-over-terraform-local-exec.md), [ansible-14-core-2-21-migration-guide](../Ansible/docs/ansible-14-core-2-21-migration-guide.md), [integrating-ansible-with-network-devices](../Ansible/docs/integrating-ansible-with-network-devices.md)
- _…and 4 more under `Ansible/docs/` — browse the folder._
- **scripts** (4): most recent → [scan-ansible-antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py), [install-and-first-adhoc](../Ansible/scripts/install-and-first-adhoc.sh), [run-first-playbook](../Ansible/scripts/run-first-playbook.sh)
- _…and 1 more under `Ansible/scripts/` — browse the folder._
- **configs** (8): most recent → [2026-07-19-nginx-phpfpm-ufw-ubuntu](../Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml), [docker-lifecycle-playbook](../Ansible/configs/docker-lifecycle-playbook.yml), [awx-job-template-and-credential-config](../Ansible/configs/awx-job-template-and-credential-config.yaml)
- _…and 5 more under `Ansible/configs/` — browse the folder._
- **manifests** (10): most recent → [playbook-migration](../ans/manifests/playbook-migration.yaml), [main](../Ansible/manifests/roles/webserver/handlers/main.yaml), [main](../Ansible/manifests/roles/webserver/tasks/main.yaml)
- _…and 7 more under `ans/manifests/` — browse the folder._
- **snippets** (2): [nginx-playbook](../Ansible/snippets/nginx-playbook.yaml), [2026-08-12-lint-ansible-playbook](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py)
- **notebooks** (2): [comparing-execution-patterns-block-rescue-serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb), [ansible-variable-precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb)
- **dockerfiles** (1): [ansible-control-node](../Ansible/dockerfiles/ansible-control-node.Dockerfile)
- **templates** (68): most recent → [site.conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/site.conf.j2), [main](../Ansible/templates/production-ansible-project/roles/webserver/vars/main.yml), [nginx.conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/nginx.conf.j2)
- _…and 65 more under `Ansible/templates/` — browse the folder._

## ArgoCD · 27 files

- **primer:** [0000-primer-argocd](../ArgoCD/notes/0000-primer-argocd.md)
- **notes** (3): [install](../ArgoCD/notes/install.yaml), [2026-08-11-argocd-quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md), [0000-primer-argocd](../ArgoCD/notes/0000-primer-argocd.md)
- **docs** (2): [how-i-wired-argocd-with-github-for-gitops-deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md), [argocd-vault-external-secrets](../ArgoCD/docs/argocd-vault-external-secrets.md)
- **scripts** (3): [argocd-application-helper](../ArgoCD/scripts/argocd-application-helper.py), [build-argocd-application-from-scratch](../ArgoCD/scripts/build-argocd-application-from-scratch.sh), [2026-07-23-install-argocd-and-access-ui](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)
- **configs** (3): [2026-08-11-guestbook-applicationset](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml), [guestbook-applicationset-multi-cluster](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml), [2026-07-23-first-application-manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- **manifests** (2): [multi-cluster-fleet-applicationset](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml), [deployment](../ArgoCD/manifests/guestbook/deployment.yaml)
- **snippets** (1): [2026-09-09-sync-app-and-verify-health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)
- **templates** (13): most recent → [values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/values.yaml), [kustomization](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/kustomization.yaml), [values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/prod/values.yaml)
- _…and 10 more under `ArgoCD/templates/` — browse the folder._

## Azure · 28 files

- **primer:** [0000-primer-azure](../Azure/notes/0000-primer-azure.md)
- **notes** (4): most recent → [2026-08-16-azure-cli-quickstart-trip-ups](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md), [2026-09-18-first-login-and-resource-list](../Azure/notes/2026-09-18-first-login-and-resource-list.md), [2026-08-23-azure-quickstart-trip-ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md)
- _…and 1 more under `Azure/notes/` — browse the folder._
- **docs** (2): [comparing-azure-cli-bicep-python-sdk](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md), [azure-devops-pipeline-bicep-integration](../Azure/docs/azure-devops-pipeline-bicep-integration.md)
- **scripts** (5): most recent → [resource-group-cleanup](../Azure/scripts/resource-group-cleanup.sh), [2026-08-17-provision-resource-group-and-storage-account](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh), [azure-vm-scale-set-autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
- _…and 2 more under `Azure/scripts/` — browse the folder._
- **configs** (2): [azure-key-vault-access-policy](../az/configs/azure-key-vault-access-policy.json), [container-apps-microservices](../Azure/configs/container-apps-microservices.yaml)
- **manifests** (2): [container-apps-multi-service-deployment](../az/manifests/container-apps-multi-service-deployment.yaml), [production-aks-cluster](../Azure/manifests/production-aks-cluster.bicep)
- **snippets** (3): [2026-09-16-create-vnet-nsg-and-linux-vm](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh), [2026-08-23-create-resource-group-and-list-regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [2026-07-13-create-resource-group-and-list-regions](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)
- **templates** (10): most recent → [aks-cluster](../Azure/templates/aks-cluster-with-addons/modules/aks-cluster.bicep), [keyvault-provider](../Azure/templates/aks-cluster-with-addons/modules/addons/keyvault-provider.bicep), [network-policy](../Azure/templates/aks-cluster-with-addons/modules/addons/network-policy.bicep)
- _…and 7 more under `Azure/templates/` — browse the folder._

## Docker · 57 files

- **primer:** [0000-primer-docker](../Docker/notes/0000-primer-docker.md)
- **notes** (6): most recent → [2026-08-12-docker-tutorial-tripups](../Docker/notes/2026-08-12-docker-tutorial-tripups.md), [2026-06-05-explore-docker-cli](../Docker/notes/2026-06-05-explore-docker-cli.md), [2026-06-06-exploring-docker-cli](../Docker/notes/2026-06-06-exploring-docker-cli.md)
- _…and 3 more under `Docker/notes/` — browse the folder._
- **docs** (10): most recent → [docker-production-hardening-runbook](../docker/docs/docker-production-hardening-runbook.md), [docker-compose](../Docker/docs/docker-compose.yml), [docker-build-mount-vs-copy-caching](../Docker/docs/docker-build-mount-vs-copy-caching.md)
- _…and 7 more under `docker/docs/` — browse the folder._
- **scripts** (5): most recent → [install-and-run-first-container](../Docker/scripts/install-and-run-first-container.sh), [install-and-run-container](../Docker/scripts/install-and-run-container.sh), [docker-health-check-and-cleanup](../Docker/scripts/docker-health-check-and-cleanup.sh)
- _…and 2 more under `Docker/scripts/` — browse the folder._
- **configs** (1): [multi-service-app](../Docker/configs/multi-service-app.yaml)
- **manifests** (9): most recent → [production-docker-deployment-with-ha](../docker/manifests/production-docker-deployment-with-ha.yaml), [docker-compose-multi-stage](../docker/manifests/docker-compose-multi-stage.yaml), [app-postgres-healthchecks.compose](../Docker/manifests/app-postgres-healthchecks.compose.yaml)
- _…and 6 more under `docker/manifests/` — browse the folder._
- **snippets** (2): [analyze-image-layers](../Docker/snippets/analyze-image-layers.py), [2026-08-12-build-run-and-cleanup](../Docker/snippets/2026-08-12-build-run-and-cleanup.py)
- **notebooks** (3): [comparing-docker-networking-drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb), [comparing-docker-build-strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb), [comparing-compose-swarm-kubernetes-local-orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb)
- **dockerfiles** (9): most recent → [simple-go-server](../Docker/dockerfiles/simple-go-server.Dockerfile), [tried-building-first-image](../Docker/dockerfiles/tried-building-first-image.Dockerfile), [production-ready-go-http-server](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
- _…and 6 more under `Docker/dockerfiles/` — browse the folder._
- **templates** (12): most recent → [compose](../Docker/templates/multi-service-compose-with-healthchecks/compose.yaml), [Dockerfile](../Docker/templates/multi-service-compose-with-healthchecks/app/Dockerfile), [app](../Docker/templates/multi-service-compose-with-healthchecks/app/app.py)
- _…and 9 more under `Docker/templates/` — browse the folder._

## Flux CD · 8 files

- **notes** (2): [2026-09-30-flux-quickstart-trip-ups](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md), [2026-09-19-explore-flux-cli-command-surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)
- **docs** (2): [how-i-wired-flux-cd-with-github-for-gitops-deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md), [2026-09-20-flux-cd-readme-coverage-and-topics-update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md)
- **scripts** (2): [bootstrap-flux-on-kind](../FluxCD/scripts/bootstrap-flux-on-kind.sh), [2026-09-19-install-flux-cli-and-run-flux-check-pre](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- **configs** (2): [helmrelease-image-automation](../FluxCD/configs/helmrelease-image-automation.yaml), [2026-09-30-minimal-gitrepository-and-kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)

## GCP · 15 files

- **primer:** [0000-primer-gcp](../GCP/notes/0000-primer-gcp.md)
- **notes** (2): [2026-09-20-gcloud-sdk-quickstart-trip-ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md), [0000-primer-gcp](../GCP/notes/0000-primer-gcp.md)
- **docs** (1): [2026-09-28-gcp-readme-coverage-and-topics](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)
- **scripts** (6): most recent → [cloud-run-terraform-from-scratch](../gcp/scripts/cloud-run-terraform-from-scratch.py), [2026-09-21-launch-vm-firewall-and-ssh](../GCP/scripts/2026-09-21-launch-vm-firewall-and-ssh.sh), [2026-08-23-install-gcloud-cli-and-configure-creds](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)
- _…and 3 more under `gcp/scripts/` — browse the folder._
- **configs** (4): most recent → [gcloud-iam-config](../gcp/configs/gcloud-iam-config.yaml), [2026-09-21-instance-template-with-startup-script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml), [service-account-and-iam-config](../GCP/configs/service-account-and-iam-config.yaml)
- _…and 1 more under `gcp/configs/` — browse the folder._
- **snippets** (2): [2026-08-23-list-compute-and-gcs-with-gcloud](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh), [2026-07-16-list-compute-and-gcs-with-gcloud](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)

## Git · 84 files

- **primer:** [0000-primer-git](../Git/notes/0000-primer-git.md)
- **notes** (6): most recent → [2026-06-04-explore-git-cli](../Git/notes/2026-06-04-explore-git-cli.md), [2026-06-04-install-git](../Git/notes/2026-06-04-install-git.md), [2026-08-11-git-branching-tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md)
- _…and 3 more under `Git/notes/` — browse the folder._
- **docs** (15): most recent → [git-production-rollback-and-recovery-runbook](../git/docs/git-production-rollback-and-recovery-runbook.md), [wiring-git-hooks-into-pre-commit-workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md), [worktree-workflows-parallel-branches](../Git/docs/worktree-workflows-parallel-branches.md)
- _…and 12 more under `git/docs/` — browse the folder._
- **scripts** (14): most recent → [pre-receive-hook-integrity-and-quota-enforcement](../git/scripts/pre-receive-hook-integrity-and-quota-enforcement.sh), [changelog-from-conventional-commits](../Git/scripts/changelog-from-conventional-commits.py), [minimal-branching-workflow](../Git/scripts/minimal-branching-workflow.sh)
- _…and 11 more under `git/scripts/` — browse the folder._
- **snippets** (1): [first-commit](../Git/snippets/first-commit.sh)
- **notebooks** (2): [merge-rebase-squash-comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb), [comparing-git-merge-strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb)
- **templates** (46): most recent → [install-hooks](../Git/templates/git-workflow-automation/scripts/install-hooks.sh), [semantic-version](../Git/templates/git-workflow-automation/scripts/semantic-version.sh), [setup-workflow](../Git/templates/git-workflow-automation/scripts/setup-workflow.sh)
- _…and 43 more under `Git/templates/` — browse the folder._

## GitHub · 56 files

- **primer:** [0000-primer-github](../GitHub/notes/0000-primer-github.md)
- **notes** (11): most recent → [2026-06-11-following-github-cli-quickstart](../GitHub/notes/2026-06-11-following-github-cli-quickstart.md), [2026-06-10-repos-issues-and-prs](../GitHub/notes/2026-06-10-repos-issues-and-prs.md), [2026-06-15-explore-github-web-ui](../GitHub/notes/2026-06-15-explore-github-web-ui.md)
- _…and 8 more under `GitHub/notes/` — browse the folder._
- **docs** (7): most recent → [release-automation-tags-milestones-and-releases-end-to-end](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md), [branch-protection-and-required-reviews-for-ci](../GitHub/docs/branch-protection-and-required-reviews-for-ci.md), [protection](../GitHub/docs/protection.json)
- _…and 4 more under `GitHub/docs/` — browse the folder._
- **scripts** (7): most recent → [tried-auth-and-profile](../GitHub/scripts/tried-auth-and-profile.sh), [tried-commenting-on-first-issue](../GitHub/scripts/tried-commenting-on-first-issue.sh), [provision-repo-with-api](../GitHub/scripts/provision-repo-with-api.py)
- _…and 4 more under `GitHub/scripts/` — browse the folder._
- **configs** (7): most recent → [issue-templates-and-labels](../GitHub/configs/issue-templates-and-labels.yaml), [labels](../GitHub/configs/dot-github-repository/labels.yaml), [stale](../GitHub/configs/dot-github-repository/stale.yml)
- _…and 4 more under `GitHub/configs/` — browse the folder._
- **manifests** (1): [github-environments-deployment-protection](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **snippets** (3): [list-repos-with-python](../GitHub/snippets/list-repos-with-python.py), [open-pr-and-wait-for-ci](../GitHub/snippets/open-pr-and-wait-for-ci.sh), [github-issues-api](../GitHub/snippets/github-issues-api.py)
- **notebooks** (2): [comparing-api-approaches-release-automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb), [analyzing-github-actions-usage-across-org-repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb)
- **dockerfiles** (1): [self-hosted-runner](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)
- **templates** (17): most recent → [COMPLIANCE](../GitHub/templates/github-security-compliance/COMPLIANCE.md), [SECURITY](../GitHub/templates/github-security-compliance/SECURITY.md), [README](../GitHub/templates/github-security-compliance/README.md)
- _…and 14 more under `GitHub/templates/` — browse the folder._

## GitHub Actions · 26 files

- **primer:** [0000-primer-github-actions](../GitHub Actions/notes/0000-primer-github-actions.md)
- **notes** (5): most recent → [2026-06-23-following-github-actions-quickstart](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md), [ci](../GitHub Actions/notes/ci.yml), [2026-07-13-primer-already-exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)
- _…and 2 more under `GitHub Actions/notes/` — browse the folder._
- **docs** (7): most recent → [choosing-between-artifacts-cache-external-storage](../GitHub Actions/docs/choosing-between-artifacts-cache-external-storage.md), [ci](../GitHub Actions/docs/ci.yml), [2026-08-07-github-actions-quickstart-tripups](../GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md)
- _…and 4 more under `GitHub Actions/docs/` — browse the folder._
- **scripts** (4): most recent → [2026-07-13-install-gh-actions-extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh), [manage-secrets-across-repos](../GitHub Actions/scripts/manage-secrets-across-repos.py), [self-hosted-runner-registration-cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh)
- _…and 1 more under `GitHub Actions/scripts/` — browse the folder._
- **configs** (5): most recent → [2026-07-11-first-ci-workflow-hello](../GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml), [reusable-deployment-workflow-environment-gates-approval](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml), [2026-08-07-matrix-node-workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml)
- _…and 2 more under `GitHub Actions/configs/` — browse the folder._
- **snippets** (1): [2026-08-15-trigger-workflow-dispatch-poll-status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)
- **dockerfiles** (1): [custom-runner](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)
- **templates** (3): [deploy-caller](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml), [reusable-deploy](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml), [README](../GitHub Actions/templates/multi-env-deploy/README.md)

## GitLab CI · 25 files

- **primer:** [0000-primer-gitlab-ci-cd](../GitLab/notes/0000-primer-gitlab-ci-cd.md)
- **notes** (4): most recent → [2026-06-24-following-gitlab-ci-quickstart](../GitLab/notes/2026-06-24-following-gitlab-ci-quickstart.md), [0000-primer-gitlab-ci-cd](../GitLab/notes/0000-primer-gitlab-ci-cd.md), [2026-09-19-gitlab-ci-runner-variables-artifacts](../GitLab/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md)
- _…and 1 more under `GitLab/notes/` — browse the folder._
- **docs** (2): [gitlab-ci-cd-with-kubernetes](../GitLab/docs/gitlab-ci-cd-with-kubernetes.md), [gitlab-ci-cd-pipeline-library-patterns](../GitLab/docs/gitlab-ci-cd-pipeline-library-patterns.md)
- **scripts** (5): most recent → [dynamic-child-pipeline](../GitLab/scripts/dynamic-child-pipeline.sh), [2026-06-24-run-first-local-pipeline](../GitLab/scripts/2026-06-24-run-first-local-pipeline.sh), [2026-09-21-local-ci-pipeline-validator](../GitLab/scripts/2026-09-21-local-ci-pipeline-validator.sh)
- _…and 2 more under `GitLab/scripts/` — browse the folder._
- **configs** (4): most recent → [2026-09-22-multi-project-pipeline-with-triggers](../GitLab/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml), [minimal-gitlab-ci-docker-build-deploy-kubernetes](../GitLab/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml), [2026-09-20-minimal-pipeline-stages-cache-artifacts](../GitLab/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
- _…and 1 more under `GitLab/configs/` — browse the folder._
- **snippets** (1): [2026-09-20-trigger-pipeline-and-poll-jobs](../GitLab/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- **dockerfiles** (1): [gitlab-runner-dind-kaniko](../GitLab/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)
- **templates** (8): most recent → [README](../GitLab/templates/modular-pipeline-repo/README.md), [lib](../GitLab/templates/modular-pipeline-repo/.gitlab/ci/lib.yml), [helpers](../GitLab/templates/modular-pipeline-repo/.gitlab/ci/helpers.sh)
- _…and 5 more under `GitLab/templates/` — browse the folder._

## Grafana · 10 files

Folder on disk is `graf/`.

- **primer:** [0000-primer-grafana](../graf/notes/0000-primer-grafana.md)
- **notes** (4): most recent → [2026-09-25-explore-grafana-ui](../graf/notes/2026-09-25-explore-grafana-ui.md), [2026-09-29-grafana-quickstart-trip-ups](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md), [2026-10-13-grafana-quickstart-trip-ups](../graf/notes/2026-10-13-grafana-quickstart-trip-ups.md)
- _…and 1 more under `graf/notes/` — browse the folder._
- **docs** (3): [how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md), [2026-09-25-grafana-navigation-dedup](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [2026-09-25-grafana-coverage-and-topics](../graf/docs/2026-09-25-grafana-coverage-and-topics.md)
- **scripts** (2): [build-multi-panel-service-dashboard-via-http-api](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py), [2026-09-25-install-grafana-with-docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)
- **configs** (1): [2026-10-13-minimal-datasource-dashboard-provisioning](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)

## Grafana Cloud · 6 files

Folder on disk is `grafc/`.

- **notes** (2): [2026-10-13-grafana-cloud-quickstart-trip-ups](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md), [2026-09-30-first-hosted-dashboard](../grafc/notes/2026-09-30-first-hosted-dashboard.md)
- **scripts** (1): [2026-10-19-create-stack-and-send-metrics](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)
- **configs** (2): [2026-10-19-prometheus-remote-write-grafana-cloud](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml), [2026-09-30-minimal-metrics-scrape-config](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml)
- **snippets** (1): [2026-09-30-first-dashboard-over-http](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)

## HashiCorp Vault · 11 files

Folder on disk is `vlt/`.

- **primer:** [0000-primer-vlt](../vlt/notes/0000-primer-vlt.md)
- **notes** (3): [2026-09-19-explore-vault-cli-secrets-policies](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md), [2026-10-07-vault-quickstart-trip-ups](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md), [0000-primer-vlt](../vlt/notes/0000-primer-vlt.md)
- **docs** (2): [vault-agent-secret-injection](../vlt/docs/vault-agent-secret-injection.md), [2026-09-19-vlt-readme-layout-and-coverage](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md)
- **scripts** (4): most recent → [dynamic-database-credentials](../vlt/scripts/dynamic-database-credentials.py), [2026-09-30-install-vault-and-first-secrets-engine](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh), [2026-10-07-write-read-list-kv-v2-secret](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py)
- _…and 1 more under `vlt/scripts/` — browse the folder._
- **configs** (2): [vault-approle](../vlt/configs/vault-approle.hcl), [2026-10-07-minimal-read-only-policy-bound-to-group](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl)

## Helm · 63 files

- **primer:** [0000-primer-helm](../Helm/notes/0000-primer-helm.md)
- **notes** (3): [2026-08-07-helm-quickstart-tripups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [values](../Helm/notes/values.yaml), [0000-primer-helm](../Helm/notes/0000-primer-helm.md)
- **docs** (6): most recent → [helm-chart-testing-strategies](../Helm/docs/helm-chart-testing-strategies.md), [chart-testing-ct-lint](../Helm/docs/chart-testing-ct-lint.md), [2026-07-25-add-helm-to-readme-layout-and-coverage](../Helm/docs/2026-07-25-add-helm-to-readme-layout-and-coverage.md)
- _…and 3 more under `Helm/docs/` — browse the folder._
- **scripts** (5): most recent → [dummy-test](../Helm/scripts/dummy-test.sh), [helm-dep-validate](../Helm/scripts/helm-dep-validate.go), [validate-chart-values-across-environments](../Helm/scripts/validate-chart-values-across-environments.sh)
- _…and 2 more under `Helm/scripts/` — browse the folder._
- **configs** (5): most recent → [2026-08-29-live-values](../Helm/configs/2026-08-29-live-values.yaml), [multi-cluster-gitops-values](../Helm/configs/multi-cluster-gitops-values.yaml), [2026-09-02-live-release-values](../Helm/configs/2026-09-02-live-release-values.yaml)
- _…and 2 more under `Helm/configs/` — browse the folder._
- **manifests** (15): most recent → [values](../Helm/manifests/redis-chart/values.yaml), [service](../Helm/manifests/redis-chart/templates/service.yaml), [deployment](../Helm/manifests/redis-chart/templates/deployment.yaml)
- _…and 12 more under `Helm/manifests/` — browse the folder._
- **snippets** (1): [2026-08-11-nginx-helm-chart-custom-values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **notebooks** (1): [release-lifecycle-drill](../Helm/notebooks/release-lifecycle-drill.ipynb)
- **templates** (27): most recent → [values.schema](../Helm/templates/microservice-chart/values.schema.json), [values](../Helm/templates/microservice-chart/values.yaml), [ingress](../Helm/templates/microservice-chart/templates/ingress.yaml)
- _…and 24 more under `Helm/templates/` — browse the folder._

## Jenkins · 3 files

Folder on disk is `jnk/`.

- **primer:** [0000-primer-jenkins](../jnk/notes/0000-primer-jenkins.md)
- **notes** (2): [2026-10-27-install-jenkins-and-run-first-cli-command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md), [0000-primer-jenkins](../jnk/notes/0000-primer-jenkins.md)
- **scripts** (1): [2026-10-27-trigger-first-jenkins-job-via-cli](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

## Kubernetes · 102 files

- **primer:** [0000-primer-kubernetes](../Kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (10): most recent → [2026-10-27-install-kubectl-and-explore-first-cluster](../k8s/notes/2026-10-27-install-kubectl-and-explore-first-cluster.md), [2026-09-04-kubectl-minikube-first-pod](../Kubernetes/notes/2026-09-04-kubectl-minikube-first-pod.md), [2026-06-08-kubernetes-interactive-tutorial](../Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md)
- _…and 7 more under `k8s/notes/` — browse the folder._
- **docs** (6): most recent → [kubernetes-service-mesh-comparison](../k8s/docs/kubernetes-service-mesh-comparison.md), [ingress](../Kubernetes/docs/ingress.yaml), [ingress-path-based-routing](../Kubernetes/docs/ingress-path-based-routing.md)
- _…and 3 more under `k8s/docs/` — browse the folder._
- **scripts** (4): most recent → [rollout-status-and-pod-readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh), [pod-lifecycle](../Kubernetes/scripts/pod-lifecycle.sh), [install-kind-and-first-cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
- _…and 1 more under `Kubernetes/scripts/` — browse the folder._
- **configs** (1): [2026-08-12-deployment-service-go-app-with-probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)
- **manifests** (7): most recent → [2026-10-27-deploy-my-first-nginx-pod-with-kubectl](../k8s/manifests/2026-10-27-deploy-my-first-nginx-pod-with-kubectl.yaml), [production-deployment-hpa-pdb-networkpolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml), [stateless-app](../Kubernetes/manifests/stateless-app.yaml)
- _…and 4 more under `k8s/manifests/` — browse the folder._
- **snippets** (2): [pod-troubleshoot-shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh), [2026-09-18-first-pod-and-service-with-kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh)
- **notebooks** (2): [comparing-kubernetes-workload-types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb), [2026-09-07-comparing-kubernetes-workload-types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)
- **templates** (70): most recent → [logging-loki](../k8s/templates/workload-clusters/cluster-resource-sets/logging-loki.yaml), [security-falco-kyverno](../k8s/templates/workload-clusters/cluster-resource-sets/security-falco-kyverno.yaml), [csi-azure-disk](../k8s/templates/workload-clusters/cluster-resource-sets/csi-azure-disk.yaml)
- _…and 67 more under `k8s/templates/` — browse the folder._

## OpenTelemetry · 10 files

Folder on disk is `otel/`.

- **primer:** [0000-primer-opentelemetry](../otel/notes/0000-primer-opentelemetry.md)
- **notes** (2): [2026-09-30-quickstart-trip-ups](../otel/notes/2026-09-30-quickstart-trip-ups.md), [0000-primer-opentelemetry](../otel/notes/0000-primer-opentelemetry.md)
- **docs** (2): [context-propagation-w3c-vs-b3](../otel/docs/context-propagation-w3c-vs-b3.md), [2026-09-25-opentelemetry-readme-coverage](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md)
- **scripts** (2): [custom-span-processor-resource-detector](../otel/scripts/custom-span-processor-resource-detector.py), [2026-09-26-install-collector-and-run-otlp-pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh)
- **configs** (2): [collector-otlp-real-pipeline](../otel/configs/collector-otlp-real-pipeline.yaml), [2026-09-30-collector-otlp-export](../otel/configs/2026-09-30-collector-otlp-export.yaml)
- **snippets** (2): [2026-09-30-instrumented-http-server](../otel/snippets/2026-09-30-instrumented-http-server.go), [2026-09-26-first-trace-span](../otel/snippets/2026-09-26-first-trace-span.py)

## OpenTofu · 19 files

- **primer:** [0000-primer-opentofu](../OpenTofu/notes/0000-primer-opentofu.md)
- **notes** (2): [2026-08-21-opentofu-quickstart-trip-ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md), [0000-primer-opentofu](../OpenTofu/notes/0000-primer-opentofu.md)
- **docs** (4): most recent → [backup](../OpenTofu/docs/backup.json), [opentofu-provider-development-custom-provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md), [remote-state-s3-backend-workspace-isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md)
- _…and 1 more under `OpenTofu/docs/` — browse the folder._
- **scripts** (3): [s3-dynamodb-remote-state-bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh), [tofu-plan-apply-with-policy-checks](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh), [2026-07-18-install-opentofu-and-verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- **configs** (2): [2026-08-25-minimal-local-backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl), [2026-07-18-minimal-local-config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)
- **notebooks** (2): [comparing-opentofu-and-terraform-state-management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb), [comparing-opentofu-and-terraform-aws-provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)
- **templates** (6): most recent → [main](../OpenTofu/templates/aws-reusable-module/main.tf), [versions](../OpenTofu/templates/aws-reusable-module/versions.tf), [variables](../OpenTofu/templates/aws-reusable-module/variables.tf)
- _…and 3 more under `OpenTofu/templates/` — browse the folder._

## Prometheus · 38 files

- **primer:** [0000-primer-prometheus](../Prometheus/notes/0000-primer-prometheus.md)
- **notes** (2): [2026-09-05-prometheus-getting-started-trip-ups](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md), [0000-primer-prometheus](../Prometheus/notes/0000-primer-prometheus.md)
- **docs** (4): most recent → [integrating-prometheus-with-related-tools](../pro/docs/integrating-prometheus-with-related-tools.md), [prometheus-recording-rules-and-alert-reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md), [prometheus-kubernetes-integration](../Prometheus/docs/prometheus-kubernetes-integration.md)
- _…and 1 more under `pro/docs/` — browse the folder._
- **scripts** (5): most recent → [2026-10-29-prometheus-alerting-rule-validation](../pro/scripts/2026-10-29-prometheus-alerting-rule-validation.sh), [custom-app-exporter](../Prometheus/scripts/custom-app-exporter.py), [custom-app-metrics-collector](../Prometheus/scripts/custom-app-metrics-collector.go)
- _…and 2 more under `pro/scripts/` — browse the folder._
- **configs** (5): most recent → [recording-vs-alerting-rules](../Prometheus/configs/recording-vs-alerting-rules.yaml), [2026-09-05-minimal-container-monitoring-config](../Prometheus/configs/2026-09-05-minimal-container-monitoring-config.yml), [prometheus-scrape-config-and-remote-write-tuning](../Prometheus/configs/prometheus-scrape-config-and-remote-write-tuning.yaml)
- _…and 2 more under `Prometheus/configs/` — browse the folder._
- **manifests** (2): [prometheus-grafana-stack-deployment](../pro/manifests/prometheus-grafana-stack-deployment.yaml), [production-prometheus-ha](../pro/manifests/production-prometheus-ha.yaml)
- **snippets** (1): [2026-09-05-promql-target-health-check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)
- **notebooks** (1): [querying-prometheus-with-promql-step-through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)
- **templates** (18): most recent → [validate-rules](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-rules.sh), [recording](../Prometheus/templates/prometheus-project-scaffold/rules/recording.yml), [validate-config](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-config.sh)
- _…and 15 more under `Prometheus/templates/` — browse the folder._

## Pulumi · 25 files

- **primer:** [0000-primer-plm](../plm/notes/0000-primer-plm.md)
- **notes** (2): [2026-09-30-pulumi-quickstart-trip-ups](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md), [0000-primer-plm](../plm/notes/0000-primer-plm.md)
- **docs** (2): [multi-stack-project-structure](../plm/docs/multi-stack-project-structure.md), [2026-09-20-plm-readme-layout-and-coverage](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md)
- **scripts** (4): most recent → [network-component-vpc-subnets](../plm/scripts/network-component-vpc-subnets.py), [2026-09-30-create-s3-bucket-with-pulumi](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py), [provision-s3-bucket-with-pulumi-ts](../plm/scripts/provision-s3-bucket-with-pulumi-ts.ts)
- _…and 1 more under `plm/scripts/` — browse the folder._
- **configs** (3): [pulumi-yaml-and-stack-config-reference](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml), [minimal-project-and-stack-config](../plm/configs/minimal-project-and-stack-config.yaml), [2026-09-30-minimal-pulumi-project-and-stack-config](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml)
- **snippets** (1): [2026-09-19-minimal-bucket-with-pulumi-python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)
- **templates** (13): most recent → [tsconfig](../plm/templates/pulumi-typescript-project-scaffold/tsconfig.json), [Pulumi.prod](../plm/templates/pulumi-typescript-project-scaffold/Pulumi.prod.yaml), [index](../plm/templates/pulumi-typescript-project-scaffold/index.ts)
- _…and 10 more under `plm/templates/` — browse the folder._

## Terraform · 74 files

- **primer:** [0000-primer-terraform](../Terraform/notes/0000-primer-terraform.md)
- **notes** (6): most recent → [2026-06-24-following-provider-tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md), [2026-09-03-install-terraform-and-first-local-file](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md), [2026-08-12-terraform-state-management-tutorial](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md)
- _…and 3 more under `Terraform/notes/` — browse the folder._
- **docs** (8): most recent → [terraform-vs-opentofu-migration-guide](../tf/docs/terraform-vs-opentofu-migration-guide.md), [how-i-wired-terraform-workspaces-and-remote-state-locking](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md), [terraform-state-locking-remote-backend-reference](../Terraform/docs/terraform-state-locking-remote-backend-reference.md)
- _…and 5 more under `tf/docs/` — browse the folder._
- **scripts** (4): most recent → [generate-ansible-inventory-from-terraform-state](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py), [validate-provider-schema](../Terraform/scripts/validate-provider-schema.go), [install-and-init](../Terraform/scripts/install-and-init.sh)
- _…and 1 more under `Terraform/scripts/` — browse the folder._
- **configs** (10): most recent → [terraform-module-version-pinning-and-migration-plan](../Terraform/configs/terraform-module-version-pinning-and-migration-plan.hcl), [main](../Terraform/configs/reusable-s3-module/main.tf), [variables](../Terraform/configs/reusable-s3-module/variables.tf)
- _…and 7 more under `Terraform/configs/` — browse the folder._
- **manifests** (2): [simple-ec2-app](../Terraform/manifests/simple-ec2-app.tf), [reusable-vpc-module](../Terraform/manifests/reusable-vpc-module.hcl)
- **snippets** (3): [reusable-module-for-each-validation](../Terraform/snippets/reusable-module-for-each-validation.hcl), [2026-09-04-terraform-cli-exploration](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [2026-08-17-scaffold-s3-bucket-module-remote-state](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)
- **notebooks** (2): [comparing-terraform-vs-opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb), [2026-07-02-comparing-for-each-vs-count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **templates** (39): most recent → [versions](../tf/templates/multi-environment-terraform-project-scaffold/versions.tf), [variables](../tf/templates/multi-environment-terraform-project-scaffold/variables.tf), [destroy](../tf/templates/multi-environment-terraform-project-scaffold/scripts/destroy.sh)
- _…and 36 more under `tf/templates/` — browse the folder._

## Trivy · 17 files

- **primer:** [0000-primer-trivy](../Trivy/notes/0000-primer-trivy.md)
- **notes** (5): most recent → [2026-09-02-trivy-quickstart-follow-along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md), [2026-08-14-trivy-quickstart-trip-ups](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md), [2026-06-25-exploring-trivy-cli](../Trivy/notes/2026-06-25-exploring-trivy-cli.md)
- _…and 2 more under `Trivy/notes/` — browse the folder._
- **docs** (2): [trivy-sbom-generation-and-vulnerability-reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md), [choosing-scan-modes-and-pipeline-wiring](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md)
- **scripts** (5): most recent → [2026-07-12-install-trivy-and-scan-filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh), [trivy-policy-as-code-opa-rego](../Trivy/scripts/trivy-policy-as-code-opa-rego.sh), [trivy-fs-repo-scan-workflow](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh)
- _…and 2 more under `Trivy/scripts/` — browse the folder._
- **configs** (3): [trivy-operator-admission-control](../Trivy/configs/trivy-operator-admission-control.yaml), [2026-08-27-trivy-config-with-scan-policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [2026-08-12-trivy-config](../Trivy/configs/2026-08-12-trivy-config.yaml)
- **snippets** (2): [2026-08-16-scan-image-fail-critical-cves](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py), [2026-07-12-trivy-python-wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)

## Foundational Concepts · 72 files

- [2026-09-23-branch-divergence-rev-list](../docs/concepts/version-control-concepts/snippets/2026-09-23-branch-divergence-rev-list.py)
- [2026-08-08-conventional-changelog-from-git-log](../docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py)
- [2026-09-25-audit-branch-hygiene-stale-branch-cleanup](../docs/concepts/version-control-concepts/scripts/2026-09-25-audit-branch-hygiene-stale-branch-cleanup.py)
- [2026-08-25-merge-conflict-reflog-recovery](../docs/concepts/version-control-concepts/scripts/2026-08-25-merge-conflict-reflog-recovery.sh)
- [branch-management-merge-validation](../docs/concepts/version-control-concepts/scripts/branch-management-merge-validation.sh)
- [2026-08-08-git-feature-branch-rebase-merge-tag](../docs/concepts/version-control-concepts/scripts/2026-08-08-git-feature-branch-rebase-merge-tag.sh)
- [terraform-modules-environment-promotion](../docs/concepts/version-control-concepts/docs/terraform-modules-environment-promotion.md)
- [2026-09-25-trunk-based-delivery-short-lived-branches](../docs/concepts/version-control-concepts/2026-09-25-trunk-based-delivery-short-lived-branches.md)
- _…and 64 more under `docs/concepts/` — browse the folder._

## docs (kit notes) · 4 files

- [2026-07-21-kubernetes-readme-tree-update](../docs/2026-07-21-kubernetes-readme-tree-update.md)
- [2026-07-19-audit-004-check](../docs/2026-07-19-audit-004-check.md)
- [2026-07-19-ansible-notebooks-readme-verified](../docs/2026-07-19-ansible-notebooks-readme-verified.md)
- [2026-07-11-removed-dead-general-references](../docs/2026-07-11-removed-dead-general-references.md)

## Learn · 15 files

- [05-compose-app-db](../learn/04-containers/05-compose-app-db.md)
- [07-trivy-scan-image](../learn/04-containers/07-trivy-scan-image.md)
- [04-docker-multistage](../learn/04-containers/04-docker-multistage.md)
- [03-gha-build-test](../learn/05-ci-cd/03-gha-build-test.md)
- [03-docker-first-image](../learn/04-containers/03-docker-first-image.md)
- [04-git-branch-merge-rebase](../learn/03-version-control/04-git-branch-merge-rebase.md)
- _…and 9 more under `learn/` — browse the folder._

## docs/audit · 7 files

- [2026-10-21-repo-audit-014](../docs/audit/2026-10-21-repo-audit-014.md)
- [2026-09-07-audit-012-docker-dockerfile-count](../docs/audit/2026-09-07-audit-012-docker-dockerfile-count.md)
- [2026-08-20-audit-009-github-readme](../docs/audit/2026-08-20-audit-009-github-readme.md)
- [MANIFEST](../docs/audit/MANIFEST.json)
- [2026-10-10-repo-audit-013](../docs/audit/2026-10-10-repo-audit-013.md)
- [2026-08-20-audit-011-opentofu-readme](../docs/audit/2026-08-20-audit-011-opentofu-readme.md)
- _…and 1 more under `docs/audit/` — browse the folder._
