# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## AWS  ·  25 files
- **primer:** [0000-primer-aws.md](../AWS/notes/0000-primer-aws.md)
- **notes** (2): [2026-07-13-primer-already-exists](../AWS/notes/2026-07-13-primer-already-exists.md), [0000-primer-aws](../AWS/notes/0000-primer-aws.md)
- **docs** (2): [iam-policy-least-privilege-walkthrough](../AWS/docs/iam-policy-least-privilege-walkthrough.md), [iam-cross-account-roles-least-privilege](../AWS/docs/iam-cross-account-roles-least-privilege.md)
- **snippets** (3): [2026-09-21-create-s3-bucket-and-upload-object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py), [2026-08-16-list-and-tag-ec2-instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [2026-08-12-list-ec2-and-s3](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)
- **scripts** (7): most recent → [vpc-with-private-endpoints](../AWS/scripts/vpc-with-private-endpoints.py), [build-vpc-ec2-rds-stack](../AWS/scripts/build-vpc-ec2-rds-stack.py), [2026-08-15-deploy-static-website-to-s3](../AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh)
  - _…and 4 more under `AWS/scripts/` — browse the folder._
- **configs** (3): [ecs-service-deployment-blue-green](../AWS/configs/ecs-service-deployment-blue-green.yaml), [2026-07-13-minimal-aws-config](../AWS/configs/2026-07-13-minimal-aws-config.ini), [2026-07-12-minimal-aws-config](../AWS/configs/2026-07-12-minimal-aws-config.ini)
- **notebooks** (1): [comparing-deployment-approaches-boto3-cloudformation-cdk](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb)
- **templates** (7): most recent → [variables](../aws/templates/aws-control-tower-landing-zone/variables.tf), [outputs](../aws/templates/aws-control-tower-landing-zone/outputs.tf), [main](../aws/templates/aws-control-tower-landing-zone/main.tf)
  - _…and 4 more under `aws/templates/aws-control-tower-landing-zone/` — browse the folder._

## Ansible  ·  112 files
- **primer:** [0000-primer-ansible.md](../Ansible/notes/0000-primer-ansible.md)
- **notes** (10): most recent → [all](../Ansible/notes/group_vars/all.yml), [ansible](../Ansible/notes/ansible.cfg), [2026-09-04-ansible-quickstart-trip-ups](../Ansible/notes/2026-09-04-ansible-quickstart-trip-ups.md)
  - _…and 7 more under `Ansible/notes/group_vars/` — browse the folder._
- **docs** (7): most recent → [integrating-ansible-with-network-devices](../Ansible/docs/integrating-ansible-with-network-devices.md), [integrated-ansible-docker-ci-pipeline-testing](../Ansible/docs/integrated-ansible-docker-ci-pipeline-testing.md), [ansible-upgrade-playbook-and-preflight-checks](../Ansible/docs/ansible-upgrade-playbook-and-preflight-checks.md)
  - _…and 4 more under `Ansible/docs/` — browse the folder._
- **snippets** (2): [nginx-playbook](../Ansible/snippets/nginx-playbook.yaml), [2026-08-12-lint-ansible-playbook](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py)
- **scripts** (4): most recent → [scan-ansible-antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py), [run-first-playbook](../Ansible/scripts/run-first-playbook.sh), [install-and-first-adhoc](../Ansible/scripts/install-and-first-adhoc.sh)
  - _…and 1 more under `Ansible/scripts/` — browse the folder._
- **configs** (8): most recent → [nginx-webserver](../Ansible/configs/nginx-webserver.yaml), [docker-python-setup](../Ansible/configs/docker-python-setup.yaml), [docker-lifecycle-playbook](../Ansible/configs/docker-lifecycle-playbook.yml)
  - _…and 5 more under `Ansible/configs/` — browse the folder._
- **manifests** (10): most recent → [playbook-migration](../ans/manifests/playbook-migration.yaml), [main](../Ansible/manifests/roles/webserver/tasks/main.yaml), [main](../Ansible/manifests/roles/webserver/handlers/main.yaml)
  - _…and 7 more under `ans/manifests/` — browse the folder._
- **notebooks** (2): [comparing-execution-patterns-block-rescue-serial](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb), [ansible-variable-precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb)
- **dockerfiles** (1): [ansible-control-node](../Ansible/dockerfiles/ansible-control-node.Dockerfile)
- **templates** (68): most recent → [main](../Ansible/templates/production-ansible-project/roles/webserver/vars/main.yml), [site.conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/site.conf.j2), [nginx.conf](../Ansible/templates/production-ansible-project/roles/webserver/templates/nginx.conf.j2)
  - _…and 65 more under `Ansible/templates/production-ansible-project/roles/webserver/vars/` — browse the folder._

## ArgoCD  ·  27 files
- **primer:** [0000-primer-argocd.md](../ArgoCD/notes/0000-primer-argocd.md)
- **notes** (3): [install](../ArgoCD/notes/install.yaml), [2026-08-11-argocd-quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md), [0000-primer-argocd](../ArgoCD/notes/0000-primer-argocd.md)
- **docs** (2): [how-i-wired-argocd-with-github-for-gitops-deployment](../ArgoCD/docs/how-i-wired-argocd-with-github-for-gitops-deployment.md), [argocd-vault-external-secrets](../ArgoCD/docs/argocd-vault-external-secrets.md)
- **snippets** (1): [2026-09-09-sync-app-and-verify-health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)
- **scripts** (3): [build-argocd-application-from-scratch](../ArgoCD/scripts/build-argocd-application-from-scratch.sh), [argocd-application-helper](../ArgoCD/scripts/argocd-application-helper.py), [2026-07-23-install-argocd-and-access-ui](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)
- **configs** (3): [guestbook-applicationset-multi-cluster](../ArgoCD/configs/guestbook-applicationset-multi-cluster.yaml), [2026-08-11-guestbook-applicationset](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml), [2026-07-23-first-application-manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- **manifests** (2): [multi-cluster-fleet-applicationset](../ArgoCD/manifests/multi-cluster-fleet-applicationset.yaml), [deployment](../ArgoCD/manifests/guestbook/deployment.yaml)
- **templates** (13): most recent → [values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/values.yaml), [kustomization](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/kustomization.yaml), [values](../ArgoCD/templates/multi-cluster-gitops-repo/overlays/prod/values.yaml)
  - _…and 10 more under `ArgoCD/templates/multi-cluster-gitops-repo/overlays/staging/` — browse the folder._

## Azure  ·  28 files
- **primer:** [0000-primer-azure.md](../Azure/notes/0000-primer-azure.md)
- **notes** (4): most recent → [2026-09-18-first-login-and-resource-list](../Azure/notes/2026-09-18-first-login-and-resource-list.md), [2026-08-23-azure-quickstart-trip-ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md), [2026-08-16-azure-cli-quickstart-trip-ups](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md)
  - _…and 1 more under `Azure/notes/` — browse the folder._
- **docs** (2): [comparing-azure-cli-bicep-python-sdk](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md), [azure-devops-pipeline-bicep-integration](../Azure/docs/azure-devops-pipeline-bicep-integration.md)
- **snippets** (3): [2026-09-16-create-vnet-nsg-and-linux-vm](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh), [2026-08-23-create-resource-group-and-list-regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [2026-07-13-create-resource-group-and-list-regions](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)
- **scripts** (5): most recent → [resource-group-cleanup](../Azure/scripts/resource-group-cleanup.sh), [cleanup-resource-groups](../Azure/scripts/cleanup-resource-groups.sh), [azure-vm-scale-set-autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh)
  - _…and 2 more under `Azure/scripts/` — browse the folder._
- **configs** (2): [azure-key-vault-access-policy](../az/configs/azure-key-vault-access-policy.json), [container-apps-microservices](../Azure/configs/container-apps-microservices.yaml)
- **manifests** (2): [container-apps-multi-service-deployment](../az/manifests/container-apps-multi-service-deployment.yaml), [production-aks-cluster](../Azure/manifests/production-aks-cluster.bicep)
- **templates** (10): most recent → [aks-cluster](../Azure/templates/aks-cluster-with-addons/modules/aks-cluster.bicep), [policy](../Azure/templates/aks-cluster-with-addons/modules/addons/policy.bicep), [network-policy](../Azure/templates/aks-cluster-with-addons/modules/addons/network-policy.bicep)
  - _…and 7 more under `Azure/templates/aks-cluster-with-addons/modules/` — browse the folder._

## CI/CD Concepts  ·  9 files
- **primer:** [0000-primer-ci-cd-concepts.md](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
- **docs** (5): most recent → [multi-environment-cicd-gates-workflow](../docs/concepts/ci-cd-concepts/docs/multi-environment-cicd-gates-workflow.md), [ephemeral-preview-environments-gated-promotion](../docs/concepts/ci-cd-concepts/docs/ephemeral-preview-environments-gated-promotion.md), [artifact-promotion-environment-rollbacks](../docs/concepts/ci-cd-concepts/docs/artifact-promotion-environment-rollbacks.md)
  - _…and 2 more under `docs/concepts/ci-cd-concepts/docs/` — browse the folder._
- **snippets** (2): [2026-08-08-parallelized-ci-stage-runner](../docs/concepts/ci-cd-concepts/snippets/2026-08-08-parallelized-ci-stage-runner.sh), [2026-08-04-cicd-common-patterns](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh)
- **scripts** (2): [artifact-promotion-rollback](../docs/concepts/ci-cd-concepts/scripts/artifact-promotion-rollback.sh), [2026-08-04-simulated-cicd-pipeline](../docs/concepts/ci-cd-concepts/scripts/2026-08-04-simulated-cicd-pipeline.sh)

## Containerization Concepts  ·  8 files
- **primer:** [0000-primer-containerization-concepts.md](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
- **docs** (3): [image-scanning-and-signing-in-a-build-pipeline](../docs/concepts/containerization-concepts/docs/image-scanning-and-signing-in-a-build-pipeline.md), [2026-08-08-smaller-images-base-caching-runtimes](../docs/concepts/containerization-concepts/docs/2026-08-08-smaller-images-base-caching-runtimes.md), [0000-primer-containerization-concepts](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
- **snippets** (2): [2026-09-24-inspect-image-layers-with-docker-sdk](../docs/concepts/containerization-concepts/snippets/2026-09-24-inspect-image-layers-with-docker-sdk.py), [2026-08-08-inspect-image-layers](../docs/concepts/containerization-concepts/snippets/2026-08-08-inspect-image-layers.py)
- **scripts** (2): [build-and-push-pipeline](../docs/concepts/containerization-concepts/scripts/build-and-push-pipeline.py), [2026-09-06-docker-build-tag-run-lifecycle](../docs/concepts/containerization-concepts/scripts/2026-09-06-docker-build-tag-run-lifecycle.sh)
- **notebooks** (1): [container-network-topology-service-discovery](../docs/concepts/containerization-concepts/notebooks/container-network-topology-service-discovery.ipynb)

## Docker  ·  57 files
- **primer:** [0000-primer-docker.md](../Docker/notes/0000-primer-docker.md)
- **notes** (6): most recent → [compose](../Docker/notes/compose.yaml), [2026-08-12-docker-tutorial-tripups](../Docker/notes/2026-08-12-docker-tutorial-tripups.md), [2026-06-07-docker-compose-quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md)
  - _…and 3 more under `Docker/notes/` — browse the folder._
- **docs** (11): most recent → [docker-production-hardening-runbook](../docker/docs/docker-production-hardening-runbook.md), [package](../Docker/docs/package.json), [integrating-docker-with-kubernetes](../Docker/docs/integrating-docker-with-kubernetes.md)
  - _…and 8 more under `docker/docs/` — browse the folder._
- **snippets** (2): [analyze-image-layers](../Docker/snippets/analyze-image-layers.py), [2026-08-12-build-run-and-cleanup](../Docker/snippets/2026-08-12-build-run-and-cleanup.py)
- **scripts** (5): most recent → [multi-stage-go-dockerfile](../Docker/scripts/multi-stage-go-dockerfile.sh), [install-and-run-first-container](../Docker/scripts/install-and-run-first-container.sh), [install-and-run-container](../Docker/scripts/install-and-run-container.sh)
  - _…and 2 more under `Docker/scripts/` — browse the folder._
- **configs** (1): [multi-service-app](../Docker/configs/multi-service-app.yaml)
- **manifests** (8): most recent → [production-docker-deployment-with-ha](../docker/manifests/production-docker-deployment-with-ha.yaml), [docker-compose-multi-stage](../docker/manifests/docker-compose-multi-stage.yaml), [prometheus](../Docker/manifests/prometheus.yml)
  - _…and 5 more under `docker/manifests/` — browse the folder._
- **notebooks** (3): [comparing-docker-networking-drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb), [comparing-docker-build-strategies](../Docker/notebooks/comparing-docker-build-strategies.ipynb), [comparing-compose-swarm-kubernetes-local-orchestration](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb)
- **dockerfiles** (9): most recent → [tried-building-first-image](../Docker/dockerfiles/tried-building-first-image.Dockerfile), [simple-go-server](../Docker/dockerfiles/simple-go-server.Dockerfile), [production-ready-go-http-server](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile)
  - _…and 6 more under `Docker/dockerfiles/` — browse the folder._
- **templates** (12): most recent → [compose](../Docker/templates/multi-service-compose-with-healthchecks/compose.yaml), [app](../Docker/templates/multi-service-compose-with-healthchecks/app/app.py), [Dockerfile](../Docker/templates/multi-service-compose-with-healthchecks/app/Dockerfile)
  - _…and 9 more under `Docker/templates/multi-service-compose-with-healthchecks/` — browse the folder._

## Flux CD  ·  8 files
- **notes** (2): [2026-09-30-flux-quickstart-trip-ups](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md), [2026-09-19-explore-flux-cli-command-surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)
- **docs** (2): [how-i-wired-flux-cd-with-github-for-gitops-deployment](../FluxCD/docs/how-i-wired-flux-cd-with-github-for-gitops-deployment.md), [2026-09-20-flux-cd-readme-coverage-and-topics-update](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md)
- **scripts** (2): [bootstrap-flux-on-kind](../FluxCD/scripts/bootstrap-flux-on-kind.sh), [2026-09-19-install-flux-cli-and-run-flux-check-pre](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- **configs** (2): [helmrelease-image-automation](../FluxCD/configs/helmrelease-image-automation.yaml), [2026-09-30-minimal-gitrepository-and-kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)

## GCP  ·  15 files
- **primer:** [0000-primer-gcp.md](../GCP/notes/0000-primer-gcp.md)
- **notes** (2): [2026-09-20-gcloud-sdk-quickstart-trip-ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md), [0000-primer-gcp](../GCP/notes/0000-primer-gcp.md)
- **docs** (1): [2026-09-28-gcp-readme-coverage-and-topics](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md)
- **snippets** (2): [2026-08-23-list-compute-and-gcs-with-gcloud](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh), [2026-07-16-list-compute-and-gcs-with-gcloud](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)
- **scripts** (6): most recent → [cloud-run-terraform-from-scratch](../gcp/scripts/cloud-run-terraform-from-scratch.py), [create-gcs-bucket-and-setup-iam](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh), [build-cloud-run-service-terraform](../GCP/scripts/build-cloud-run-service-terraform.py)
  - _…and 3 more under `gcp/scripts/` — browse the folder._
- **configs** (4): most recent → [gcloud-iam-config](../gcp/configs/gcloud-iam-config.yaml), [service-account-and-iam-config](../GCP/configs/service-account-and-iam-config.yaml), [2026-09-21-instance-template-with-startup-script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml)
  - _…and 1 more under `gcp/configs/` — browse the folder._

## Git  ·  85 files
- **primer:** [0000-primer-git.md](../Git/notes/0000-primer-git.md)
- **notes** (6): most recent → [README](../Git/notes/README.md), [2026-08-11-git-branching-tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md), [2026-06-07-git-branching-tutorial](../Git/notes/2026-06-07-git-branching-tutorial.md)
  - _…and 3 more under `Git/notes/` — browse the folder._
- **docs** (13): most recent → [git-production-rollback-and-recovery-runbook](../git/docs/git-production-rollback-and-recovery-runbook.md), [worktree-workflows-parallel-branches](../Git/docs/worktree-workflows-parallel-branches.md), [wiring-git-hooks-into-pre-commit-workflow](../Git/docs/wiring-git-hooks-into-pre-commit-workflow.md)
  - _…and 10 more under `git/docs/` — browse the folder._
- **snippets** (1): [first-commit](../Git/snippets/first-commit.sh)
- **scripts** (20): most recent → [pre-receive-hook-integrity-and-quota-enforcement](../git/scripts/pre-receive-hook-integrity-and-quota-enforcement.sh), [setup-workflow](../Git/templates/git-workflow-automation/scripts/setup-workflow.sh), [semantic-version](../Git/templates/git-workflow-automation/scripts/semantic-version.sh)
  - _…and 17 more under `git/scripts/` — browse the folder._
- **notebooks** (3): [merge-rebase-squash-comparison](../git/notebooks/merge-rebase-squash-comparison.ipynb), [merge-rebase-squash-comparison](../Git/notebooks/merge-rebase-squash-comparison.ipynb), [comparing-git-merge-strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb)
- **templates** (42): most recent → [prepare-commit-msg](../Git/templates/git-workflow-automation/hooks/prepare-commit-msg), [pre-rebase](../Git/templates/git-workflow-automation/hooks/pre-rebase), [pre-push](../Git/templates/git-workflow-automation/hooks/pre-push)
  - _…and 39 more under `Git/templates/git-workflow-automation/hooks/` — browse the folder._

## GitHub  ·  56 files
- **primer:** [0000-primer-github.md](../GitHub/notes/0000-primer-github.md)
- **notes** (11): most recent → [2026-09-19-gh-cli-quickstart-trip-ups](../GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md), [2026-06-19-primer-already-exists](../GitHub/notes/2026-06-19-primer-already-exists.md), [2026-06-15-hello-world-guide-and-github-flow](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md)
  - _…and 8 more under `GitHub/notes/` — browse the folder._
- **docs** (7): most recent → [release-automation-tags-milestones-and-releases-end-to-end](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md), [protection](../GitHub/docs/protection.json), [how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)
  - _…and 4 more under `GitHub/docs/` — browse the folder._
- **snippets** (3): [open-pr-and-wait-for-ci](../GitHub/snippets/open-pr-and-wait-for-ci.sh), [list-repos-with-python](../GitHub/snippets/list-repos-with-python.py), [github-issues-api](../GitHub/snippets/github-issues-api.py)
- **scripts** (7): most recent → [tried-commenting-on-first-issue](../GitHub/scripts/tried-commenting-on-first-issue.sh), [tried-auth-and-profile](../GitHub/scripts/tried-auth-and-profile.sh), [provision-repo-with-api](../GitHub/scripts/provision-repo-with-api.py)
  - _…and 4 more under `GitHub/scripts/` — browse the folder._
- **configs** (7): most recent → [issue-templates-and-labels](../GitHub/configs/issue-templates-and-labels.yaml), [stale](../GitHub/configs/dot-github-repository/stale.yml), [labels](../GitHub/configs/dot-github-repository/labels.yaml)
  - _…and 4 more under `GitHub/configs/` — browse the folder._
- **manifests** (1): [github-environments-deployment-protection](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **notebooks** (2): [comparing-api-approaches-release-automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb), [analyzing-github-actions-usage-across-org-repos](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb)
- **dockerfiles** (1): [self-hosted-runner](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)
- **templates** (17): most recent → [SECURITY](../GitHub/templates/github-security-compliance/SECURITY.md), [README](../GitHub/templates/github-security-compliance/README.md), [COMPLIANCE](../GitHub/templates/github-security-compliance/COMPLIANCE.md)
  - _…and 14 more under `GitHub/templates/github-security-compliance/` — browse the folder._

## GitHub Actions  ·  26 files
- **primer:** [0000-primer-github-actions.md](../GitHub Actions/notes/0000-primer-github-actions.md)
- **notes** (5): most recent → [test](../GitHub Actions/notes/test.yml), [ci](../GitHub Actions/notes/ci.yml), [2026-07-13-primer-already-exists](../GitHub Actions/notes/2026-07-13-primer-already-exists.md)
  - _…and 2 more under `GitHub Actions/notes/` — browse the folder._
- **docs** (7): most recent → [test](../GitHub Actions/docs/test.yml), [github-actions-oidc-with-aws](../GitHub Actions/docs/github-actions-oidc-with-aws.md), [composite-actions-vs-reusable-workflows](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md)
  - _…and 4 more under `GitHub Actions/docs/` — browse the folder._
- **snippets** (1): [2026-08-15-trigger-workflow-dispatch-poll-status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)
- **scripts** (4): most recent → [self-hosted-runner-registration-cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh), [manage-secrets-across-repos](../GitHub Actions/scripts/manage-secrets-across-repos.py), [2026-07-13-install-gh-actions-extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh)
  - _…and 1 more under `GitHub Actions/scripts/` — browse the folder._
- **configs** (5): most recent → [reusable-deployment-workflow-environment-gates-approval](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml), [2026-08-07-matrix-node-workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml), [2026-07-13-hello-workflow](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)
  - _…and 2 more under `GitHub Actions/configs/` — browse the folder._
- **dockerfiles** (1): [custom-runner](../GitHub Actions/dockerfiles/custom-runner.Dockerfile)
- **templates** (3): [reusable-deploy](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml), [deploy-caller](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml), [README](../GitHub Actions/templates/multi-env-deploy/README.md)

## GitLab CI  ·  25 files
- **primer:** [0000-primer-gitlab-ci-cd.md](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **notes** (4): most recent → [2026-09-19-gitlab-ci-runner-variables-artifacts](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md), [2026-06-24-following-gitlab-ci-quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md), [0000-primer-gitlab-ci-cd](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
  - _…and 1 more under `GitLab CI/notes/` — browse the folder._
- **docs** (2): [gitlab-ci-cd-with-kubernetes](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md), [gitlab-ci-cd-pipeline-library-patterns](../GitLab CI/docs/gitlab-ci-cd-pipeline-library-patterns.md)
- **snippets** (1): [2026-09-20-trigger-pipeline-and-poll-jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- **scripts** (6): most recent → [kind-runner-bootstrap](../GitLab CI/templates/modular-pipeline-repo/scripts/kind-runner-bootstrap.sh), [gitlab-pipeline-helper](../GitLab CI/scripts/gitlab-pipeline-helper.py), [dynamic-child-pipeline](../GitLab CI/scripts/dynamic-child-pipeline.sh)
  - _…and 3 more under `GitLab CI/templates/modular-pipeline-repo/scripts/` — browse the folder._
- **configs** (4): most recent → [minimal-gitlab-ci-docker-build-deploy-kubernetes](../GitLab CI/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml), [2026-09-22-multi-project-pipeline-with-triggers](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml), [2026-09-20-minimal-pipeline-stages-cache-artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
  - _…and 1 more under `GitLab CI/configs/` — browse the folder._
- **dockerfiles** (1): [gitlab-runner-dind-kaniko](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile)
- **templates** (7): most recent → [README](../GitLab CI/templates/modular-pipeline-repo/README.md), [test](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/test.yml), [lib](../GitLab CI/templates/modular-pipeline-repo/.gitlab/ci/lib.yml)
  - _…and 4 more under `GitLab CI/templates/modular-pipeline-repo/` — browse the folder._

## Grafana  ·  10 files
- **primer:** [0000-primer-grafana.md](../graf/notes/0000-primer-grafana.md)
- **notes** (4): most recent → [2026-10-13-grafana-quickstart-trip-ups](../graf/notes/2026-10-13-grafana-quickstart-trip-ups.md), [2026-09-29-grafana-quickstart-trip-ups](../graf/notes/2026-09-29-grafana-quickstart-trip-ups.md), [2026-09-25-explore-grafana-ui](../graf/notes/2026-09-25-explore-grafana-ui.md)
  - _…and 1 more under `graf/notes/` — browse the folder._
- **docs** (3): [how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility](../graf/docs/how-i-wired-grafana-into-prometheus-and-alertmanager-for-unified-metrics-and-alert-visibility.md), [2026-09-25-grafana-navigation-dedup](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [2026-09-25-grafana-coverage-and-topics](../graf/docs/2026-09-25-grafana-coverage-and-topics.md)
- **scripts** (2): [build-multi-panel-service-dashboard-via-http-api](../graf/scripts/build-multi-panel-service-dashboard-via-http-api.py), [2026-09-25-install-grafana-with-docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh)
- **configs** (1): [2026-10-13-minimal-datasource-dashboard-provisioning](../graf/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml)

## Grafana Cloud  ·  6 files
- **notes** (2): [2026-10-13-grafana-cloud-quickstart-trip-ups](../grafc/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md), [2026-09-30-first-hosted-dashboard](../grafc/notes/2026-09-30-first-hosted-dashboard.md)
- **snippets** (1): [2026-09-30-first-dashboard-over-http](../grafc/snippets/2026-09-30-first-dashboard-over-http.js)
- **scripts** (1): [2026-10-19-create-stack-and-send-metrics](../grafc/scripts/2026-10-19-create-stack-and-send-metrics.py)
- **configs** (2): [2026-10-19-prometheus-remote-write-grafana-cloud](../grafc/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml), [2026-09-30-minimal-metrics-scrape-config](../grafc/configs/2026-09-30-minimal-metrics-scrape-config.yaml)

## HashiCorp Vault  ·  11 files
- **primer:** [0000-primer-vlt.md](../vlt/notes/0000-primer-vlt.md)
- **notes** (3): [2026-10-07-vault-quickstart-trip-ups](../vlt/notes/2026-10-07-vault-quickstart-trip-ups.md), [2026-09-19-explore-vault-cli-secrets-policies](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md), [0000-primer-vlt](../vlt/notes/0000-primer-vlt.md)
- **docs** (2): [vault-agent-secret-injection](../vlt/docs/vault-agent-secret-injection.md), [2026-09-19-vlt-readme-layout-and-coverage](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md)
- **scripts** (4): most recent → [dynamic-database-credentials](../vlt/scripts/dynamic-database-credentials.py), [2026-10-07-write-read-list-kv-v2-secret](../vlt/scripts/2026-10-07-write-read-list-kv-v2-secret.py), [2026-09-30-install-vault-and-first-secrets-engine](../vlt/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh)
  - _…and 1 more under `vlt/scripts/` — browse the folder._
- **configs** (2): [vault-approle](../vlt/configs/vault-approle.hcl), [2026-10-07-minimal-read-only-policy-bound-to-group](../vlt/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl)

## Helm  ·  63 files
- **primer:** [0000-primer-helm.md](../Helm/notes/0000-primer-helm.md)
- **notes** (3): [values](../Helm/notes/values.yaml), [2026-08-07-helm-quickstart-tripups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [0000-primer-helm](../Helm/notes/0000-primer-helm.md)
- **docs** (6): most recent → [values-management-approaches](../Helm/docs/values-management-approaches.md), [helm-chart-testing-strategies](../Helm/docs/helm-chart-testing-strategies.md), [chart-testing-ct-lint](../Helm/docs/chart-testing-ct-lint.md)
  - _…and 3 more under `Helm/docs/` — browse the folder._
- **snippets** (1): [2026-08-11-nginx-helm-chart-custom-values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **scripts** (5): most recent → [validate-chart-values-across-environments](../Helm/scripts/validate-chart-values-across-environments.sh), [helm-dep-validate](../Helm/scripts/helm-dep-validate.go), [dummy-test](../Helm/scripts/dummy-test.sh)
  - _…and 2 more under `Helm/scripts/` — browse the folder._
- **configs** (5): most recent → [multi-cluster-gitops-values](../Helm/configs/multi-cluster-gitops-values.yaml), [2026-09-02-live-release-values](../Helm/configs/2026-09-02-live-release-values.yaml), [2026-08-30-production-deployment-values](../Helm/configs/2026-08-30-production-deployment-values.yaml)
  - _…and 2 more under `Helm/configs/` — browse the folder._
- **manifests** (9): most recent → [values](../Helm/manifests/redis-chart/values.yaml), [Chart](../Helm/manifests/redis-chart/Chart.yaml), [flux-helmrelease-and-helmchart](../Helm/manifests/flux-helmrelease-and-helmchart.yaml)
  - _…and 6 more under `Helm/manifests/redis-chart/` — browse the folder._
- **notebooks** (1): [release-lifecycle-drill](../Helm/notebooks/release-lifecycle-drill.ipynb)
- **templates** (33): most recent → [values](../Helm/templates/microservice-chart/values.yaml), [values.schema](../Helm/templates/microservice-chart/values.schema.json), [test-connection](../Helm/templates/microservice-chart/templates/tests/test-connection.yaml)
  - _…and 30 more under `Helm/templates/microservice-chart/` — browse the folder._

## Infrastructure as Code Concepts  ·  7 files
- **primer:** [0000-primer-infrastructure-as-code-concepts.md](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
- **docs** (3): [terraform-docker-integration-patterns](../docs/concepts/infrastructure-as-code-concepts/docs/terraform-docker-integration-patterns.md), [2026-08-08-terraform-ansible-division-of-responsibility](../docs/concepts/infrastructure-as-code-concepts/docs/2026-08-08-terraform-ansible-division-of-responsibility.md), [0000-primer-infrastructure-as-code-concepts](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
- **snippets** (1): [2026-09-06-parse-and-validate-terraform-state](../docs/concepts/infrastructure-as-code-concepts/snippets/2026-09-06-parse-and-validate-terraform-state.py)
- **scripts** (1): [2026-08-25-iac-state-workflow](../docs/concepts/infrastructure-as-code-concepts/scripts/2026-08-25-iac-state-workflow.sh)
- **notebooks** (2): [terraform-vs-ansible-container-infra](../docs/concepts/infrastructure-as-code-concepts/notebooks/terraform-vs-ansible-container-infra.ipynb), [2026-08-08-declarative-vs-imperative-iac](../docs/concepts/infrastructure-as-code-concepts/notebooks/2026-08-08-declarative-vs-imperative-iac.ipynb)

## Jenkins  ·  3 files
- **primer:** [0000-primer-jenkins.md](../jnk/notes/0000-primer-jenkins.md)
- **notes** (2): [2026-10-27-install-jenkins-and-run-first-cli-command](../jnk/notes/2026-10-27-install-jenkins-and-run-first-cli-command.md), [0000-primer-jenkins](../jnk/notes/0000-primer-jenkins.md)
- **scripts** (1): [2026-10-27-trigger-first-jenkins-job-via-cli](../jnk/scripts/2026-10-27-trigger-first-jenkins-job-via-cli.sh)

## Kubernetes  ·  102 files
- **primer:** [0000-primer-kubernetes.md](../Kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (10): most recent → [2026-10-27-install-kubectl-and-explore-first-cluster](../k8s/notes/2026-10-27-install-kubectl-and-explore-first-cluster.md), [my-first-pod](../Kubernetes/notes/my-first-pod.yaml), [deployment](../Kubernetes/notes/deployment.yaml)
  - _…and 7 more under `k8s/notes/` — browse the folder._
- **docs** (7): most recent → [operations-guide](../k8s/templates/docs/operations-guide.md), [kubernetes-service-mesh-comparison](../k8s/docs/kubernetes-service-mesh-comparison.md), [prometheus](../Kubernetes/docs/prometheus.yml)
  - _…and 4 more under `k8s/templates/docs/` — browse the folder._
- **snippets** (2): [pod-troubleshoot-shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh), [2026-09-18-first-pod-and-service-with-kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh)
- **scripts** (4): most recent → [rollout-status-and-pod-readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh), [pod-lifecycle](../Kubernetes/scripts/pod-lifecycle.sh), [install-kind-and-first-cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
  - _…and 1 more under `Kubernetes/scripts/` — browse the folder._
- **configs** (1): [2026-08-12-deployment-service-go-app-with-probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)
- **manifests** (7): most recent → [2026-10-27-deploy-my-first-nginx-pod-with-kubectl](../k8s/manifests/2026-10-27-deploy-my-first-nginx-pod-with-kubectl.yaml), [stateless-app](../Kubernetes/manifests/stateless-app.yaml), [production-deployment-hpa-pdb-networkpolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml)
  - _…and 4 more under `k8s/manifests/` — browse the folder._
- **notebooks** (2): [comparing-kubernetes-workload-types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb), [2026-09-07-comparing-kubernetes-workload-types](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)
- **templates** (69): most recent → [security-falco-kyverno](../k8s/templates/workload-clusters/cluster-resource-sets/security-falco-kyverno.yaml), [monitoring-prometheus](../k8s/templates/workload-clusters/cluster-resource-sets/monitoring-prometheus.yaml), [logging-loki](../k8s/templates/workload-clusters/cluster-resource-sets/logging-loki.yaml)
  - _…and 66 more under `k8s/templates/workload-clusters/cluster-resource-sets/` — browse the folder._

## Linux & System Administration  ·  8 files
- **primer:** [0000-primer-linux-system-administration.md](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
- **docs** (3): [systemd-timers-journald-shipping](../docs/concepts/linux-system-administration/docs/systemd-timers-journald-shipping.md), [2026-07-18-process-and-permission-patterns-in-devops](../docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md), [0000-primer-linux-system-administration](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
- **scripts** (4): most recent → [systemd-watchdog-restart-and-page](../docs/concepts/linux-system-administration/scripts/systemd-watchdog-restart-and-page.sh), [systemd-health-check-log-alerting](../docs/concepts/linux-system-administration/scripts/systemd-health-check-log-alerting.sh), [systemd-health-check-and-log-rotation](../docs/concepts/linux-system-administration/scripts/systemd-health-check-and-log-rotation.sh)
  - _…and 1 more under `docs/concepts/linux-system-administration/scripts/` — browse the folder._
- **notebooks** (1): [linux-system-performance-analysis](../docs/concepts/linux-system-administration/notebooks/linux-system-performance-analysis.ipynb)

## Monitoring & Observability Concepts  ·  8 files
- **primer:** [0000-primer-monitoring-observability-concepts.md](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
- **docs** (3): [cicd-pipeline-health-telemetry-dora-deployment-markers](../docs/concepts/monitoring-observability-concepts/docs/cicd-pipeline-health-telemetry-dora-deployment-markers.md), [2026-08-09-combining-metrics-logs-traces-observability](../docs/concepts/monitoring-observability-concepts/docs/2026-08-09-combining-metrics-logs-traces-observability.md), [0000-primer-monitoring-observability-concepts](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
- **scripts** (3): [scripted-health-gate-with-correlated-logs](../docs/concepts/monitoring-observability-concepts/scripts/scripted-health-gate-with-correlated-logs.py), [health-checks-and-log-correlation](../docs/concepts/monitoring-observability-concepts/scripts/health-checks-and-log-correlation.py), [2026-09-08-metrics-exporter-structured-logger](../docs/concepts/monitoring-observability-concepts/scripts/2026-09-08-metrics-exporter-structured-logger.py)
- **notebooks** (2): [tracing-containerized-service-dependencies](../docs/concepts/monitoring-observability-concepts/notebooks/tracing-containerized-service-dependencies.ipynb), [2026-08-11-scraping-endpoint-three-pillars](../docs/concepts/monitoring-observability-concepts/notebooks/2026-08-11-scraping-endpoint-three-pillars.ipynb)

## Networking Fundamentals  ·  11 files
- **primer:** [0000-primer-networking-fundamentals.md](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
- **notes** (1): [2026-08-07-network-troubleshooting-patterns](../docs/concepts/networking-fundamentals/notes/2026-08-07-network-troubleshooting-patterns.md)
- **docs** (1): [0000-primer-networking-fundamentals](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
- **snippets** (1): [2026-09-24-tcp-port-and-dns-sockets](../docs/concepts/networking-fundamentals/snippets/2026-09-24-tcp-port-and-dns-sockets.py)
- **scripts** (6): most recent → [tcp-tls-health-probes-with-latency](../docs/concepts/networking-fundamentals/scripts/tcp-tls-health-probes-with-latency.sh), [sample-health-check-targets](../docs/concepts/networking-fundamentals/scripts/sample-health-check-targets.json), [health-check-automation-with-json-output](../docs/concepts/networking-fundamentals/scripts/health-check-automation-with-json-output.sh)
  - _…and 3 more under `docs/concepts/networking-fundamentals/scripts/` — browse the folder._
- **notebooks** (2): [network-health-telemetry-visualization](../docs/concepts/networking-fundamentals/notebooks/network-health-telemetry-visualization.ipynb), [2026-08-10-dns-tls-load-balancing-visualization](../docs/concepts/networking-fundamentals/notebooks/2026-08-10-dns-tls-load-balancing-visualization.ipynb)

## OpenTelemetry  ·  10 files
- **primer:** [0000-primer-opentelemetry.md](../otel/notes/0000-primer-opentelemetry.md)
- **notes** (2): [2026-09-30-quickstart-trip-ups](../otel/notes/2026-09-30-quickstart-trip-ups.md), [0000-primer-opentelemetry](../otel/notes/0000-primer-opentelemetry.md)
- **docs** (2): [context-propagation-w3c-vs-b3](../otel/docs/context-propagation-w3c-vs-b3.md), [2026-09-25-opentelemetry-readme-coverage](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md)
- **snippets** (2): [2026-09-30-instrumented-http-server](../otel/snippets/2026-09-30-instrumented-http-server.go), [2026-09-26-first-trace-span](../otel/snippets/2026-09-26-first-trace-span.py)
- **scripts** (2): [custom-span-processor-resource-detector](../otel/scripts/custom-span-processor-resource-detector.py), [2026-09-26-install-collector-and-run-otlp-pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh)
- **configs** (2): [collector-otlp-real-pipeline](../otel/configs/collector-otlp-real-pipeline.yaml), [2026-09-30-collector-otlp-export](../otel/configs/2026-09-30-collector-otlp-export.yaml)

## OpenTofu  ·  19 files
- **primer:** [0000-primer-opentofu.md](../OpenTofu/notes/0000-primer-opentofu.md)
- **notes** (2): [2026-08-21-opentofu-quickstart-trip-ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md), [0000-primer-opentofu](../OpenTofu/notes/0000-primer-opentofu.md)
- **docs** (4): most recent → [remote-state-s3-backend-workspace-isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md), [opentofu-provider-development-custom-provider](../OpenTofu/docs/opentofu-provider-development-custom-provider.md), [backup](../OpenTofu/docs/backup.json)
  - _…and 1 more under `OpenTofu/docs/` — browse the folder._
- **scripts** (3): [tofu-plan-apply-with-policy-checks](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh), [s3-dynamodb-remote-state-bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh), [2026-07-18-install-opentofu-and-verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- **configs** (2): [2026-08-25-minimal-local-backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl), [2026-07-18-minimal-local-config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)
- **notebooks** (2): [comparing-opentofu-and-terraform-state-management](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb), [comparing-opentofu-and-terraform-aws-provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)
- **templates** (6): most recent → [versions](../OpenTofu/templates/aws-reusable-module/versions.tf), [variables](../OpenTofu/templates/aws-reusable-module/variables.tf), [outputs](../OpenTofu/templates/aws-reusable-module/outputs.tf)
  - _…and 3 more under `OpenTofu/templates/aws-reusable-module/` — browse the folder._

## Prometheus  ·  40 files
- **primer:** [0000-primer-prometheus.md](../Prometheus/notes/0000-primer-prometheus.md)
- **notes** (2): [2026-09-05-prometheus-getting-started-trip-ups](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md), [0000-primer-prometheus](../Prometheus/notes/0000-primer-prometheus.md)
- **docs** (4): most recent → [integrating-prometheus-with-related-tools](../pro/docs/integrating-prometheus-with-related-tools.md), [prometheus-recording-rules-and-alert-reference](../Prometheus/docs/prometheus-recording-rules-and-alert-reference.md), [prometheus-kubernetes-integration](../Prometheus/docs/prometheus-kubernetes-integration.md)
  - _…and 1 more under `pro/docs/` — browse the folder._
- **snippets** (1): [2026-09-05-promql-target-health-check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)
- **scripts** (8): most recent → [2026-10-29-prometheus-alerting-rule-validation](../pro/scripts/2026-10-29-prometheus-alerting-rule-validation.sh), [validate-rules](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-rules.sh), [validate-config](../Prometheus/templates/prometheus-project-scaffold/scripts/validate-config.sh)
  - _…and 5 more under `pro/scripts/` — browse the folder._
- **configs** (5): most recent → [recording-vs-alerting-rules](../Prometheus/configs/recording-vs-alerting-rules.yaml), [prometheus-scrape-config-and-remote-write-tuning](../Prometheus/configs/prometheus-scrape-config-and-remote-write-tuning.yaml), [production-prometheus](../Prometheus/configs/production-prometheus.yml)
  - _…and 2 more under `Prometheus/configs/` — browse the folder._
- **manifests** (3): [prometheus-grafana-stack-deployment](../pro/manifests/prometheus-grafana-stack-deployment.yaml), [production-prometheus-ha](../pro/manifests/production-prometheus-ha.yaml), [production-prometheus-ha](../Prometheus/manifests/production-prometheus-ha.yaml)
- **notebooks** (1): [querying-prometheus-with-promql-step-through](../Prometheus/notebooks/querying-prometheus-with-promql-step-through.ipynb)
- **templates** (16): most recent → [recording](../Prometheus/templates/prometheus-project-scaffold/rules/recording.yml), [alerts](../Prometheus/templates/prometheus-project-scaffold/rules/alerts.yml), [README](../Prometheus/templates/prometheus-project-scaffold/dashboards/README.md)
  - _…and 13 more under `Prometheus/templates/prometheus-project-scaffold/rules/` — browse the folder._

## Pulumi  ·  25 files
- **primer:** [0000-primer-plm.md](../plm/notes/0000-primer-plm.md)
- **notes** (2): [2026-09-30-pulumi-quickstart-trip-ups](../plm/notes/2026-09-30-pulumi-quickstart-trip-ups.md), [0000-primer-plm](../plm/notes/0000-primer-plm.md)
- **docs** (2): [multi-stack-project-structure](../plm/docs/multi-stack-project-structure.md), [2026-09-20-plm-readme-layout-and-coverage](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md)
- **snippets** (1): [2026-09-19-minimal-bucket-with-pulumi-python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)
- **scripts** (4): most recent → [provision-s3-bucket-with-pulumi-ts](../plm/scripts/provision-s3-bucket-with-pulumi-ts.ts), [network-component-vpc-subnets](../plm/scripts/network-component-vpc-subnets.py), [2026-09-30-create-s3-bucket-with-pulumi](../plm/scripts/2026-09-30-create-s3-bucket-with-pulumi.py)
  - _…and 1 more under `plm/scripts/` — browse the folder._
- **configs** (3): [pulumi-yaml-and-stack-config-reference](../plm/configs/pulumi-yaml-and-stack-config-reference.yaml), [minimal-project-and-stack-config](../plm/configs/minimal-project-and-stack-config.yaml), [2026-09-30-minimal-pulumi-project-and-stack-config](../plm/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml)
- **templates** (13): most recent → [tsconfig](../plm/templates/pulumi-typescript-project-scaffold/tsconfig.json), [package](../plm/templates/pulumi-typescript-project-scaffold/package.json), [index](../plm/templates/pulumi-typescript-project-scaffold/index.ts)
  - _…and 10 more under `plm/templates/pulumi-typescript-project-scaffold/` — browse the folder._

## Scripting & Automation (Bash/Python)  ·  10 files
- **primer:** [0000-primer-scripting-automation-bash-python.md](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
- **docs** (3): [site](../docs/concepts/scripting-automation-bash-python/docs/site.yml), [combining-scripting-with-iac-automation-patterns](../docs/concepts/scripting-automation-bash-python/docs/combining-scripting-with-iac-automation-patterns.md), [0000-primer-scripting-automation-bash-python](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
- **snippets** (2): [2026-08-08-retry-backoff-logging](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-08-retry-backoff-logging.py), [2026-08-07-log-parsing-filtering](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py)
- **scripts** (4): most recent → [docker-container-health-automation](../docs/concepts/scripting-automation-bash-python/scripts/docker-container-health-automation.sh), [2026-09-23-parallel-tasks-with-logging](../docs/concepts/scripting-automation-bash-python/scripts/2026-09-23-parallel-tasks-with-logging.sh), [2026-08-23-config-parsing-jq-retry](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-23-config-parsing-jq-retry.sh)
  - _…and 1 more under `docs/concepts/scripting-automation-bash-python/scripts/` — browse the folder._
- **notebooks** (1): [2026-08-11-bash-python-glue-patterns](../docs/concepts/scripting-automation-bash-python/notebooks/2026-08-11-bash-python-glue-patterns.ipynb)

## Terraform  ·  74 files
- **primer:** [0000-primer-terraform.md](../Terraform/notes/0000-primer-terraform.md)
- **notes** (6): most recent → [2026-09-03-install-terraform-and-first-local-file](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md), [2026-08-12-terraform-state-management-tutorial](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md), [2026-06-24-following-provider-tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md)
  - _…and 3 more under `Terraform/notes/` — browse the folder._
- **docs** (8): most recent → [terraform-vs-opentofu-migration-guide](../tf/docs/terraform-vs-opentofu-migration-guide.md), [wiring-terraform-outputs-into-dependent-modules](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md), [terraform-testing-strategies-tflint-terratest](../Terraform/docs/terraform-testing-strategies-tflint-terratest.md)
  - _…and 5 more under `tf/docs/` — browse the folder._
- **snippets** (3): [reusable-module-for-each-validation](../Terraform/snippets/reusable-module-for-each-validation.hcl), [2026-09-04-terraform-cli-exploration](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [2026-08-17-scaffold-s3-bucket-module-remote-state](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh)
- **scripts** (8): most recent → [destroy](../tf/templates/multi-environment-terraform-project-scaffold/scripts/destroy.sh), [apply](../tf/templates/multi-environment-terraform-project-scaffold/scripts/apply.sh), [destroy](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/scripts/destroy.sh)
  - _…and 5 more under `tf/templates/multi-environment-terraform-project-scaffold/scripts/` — browse the folder._
- **configs** (10): most recent → [terraform-module-version-pinning-and-migration-plan](../Terraform/configs/terraform-module-version-pinning-and-migration-plan.hcl), [variables](../Terraform/configs/reusable-s3-module/variables.tf), [outputs](../Terraform/configs/reusable-s3-module/outputs.tf)
  - _…and 7 more under `Terraform/configs/` — browse the folder._
- **manifests** (2): [simple-ec2-app](../Terraform/manifests/simple-ec2-app.tf), [reusable-vpc-module](../Terraform/manifests/reusable-vpc-module.hcl)
- **notebooks** (2): [comparing-terraform-vs-opentofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb), [2026-07-02-comparing-for-each-vs-count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **templates** (35): most recent → [versions](../tf/templates/multi-environment-terraform-project-scaffold/versions.tf), [variables](../tf/templates/multi-environment-terraform-project-scaffold/variables.tf), [providers](../tf/templates/multi-environment-terraform-project-scaffold/providers.tf)
  - _…and 32 more under `tf/templates/multi-environment-terraform-project-scaffold/` — browse the folder._

## Trivy  ·  17 files
- **primer:** [0000-primer-trivy.md](../Trivy/notes/0000-primer-trivy.md)
- **notes** (5): most recent → [2026-09-02-trivy-quickstart-follow-along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md), [2026-08-29-trivy-quickstart-trip-ups](../Trivy/notes/2026-08-29-trivy-quickstart-trip-ups.md), [2026-08-14-trivy-quickstart-trip-ups](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)
  - _…and 2 more under `Trivy/notes/` — browse the folder._
- **docs** (2): [trivy-sbom-generation-and-vulnerability-reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md), [choosing-scan-modes-and-pipeline-wiring](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md)
- **snippets** (2): [2026-08-16-scan-image-fail-critical-cves](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py), [2026-07-12-trivy-python-wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)
- **scripts** (5): most recent → [trivy-policy-as-code-opa-rego](../Trivy/scripts/trivy-policy-as-code-opa-rego.sh), [trivy-fs-repo-scan-workflow](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh), [scan-images-from-file-consolidated-sarif](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)
  - _…and 2 more under `Trivy/scripts/` — browse the folder._
- **configs** (3): [trivy-operator-admission-control](../Trivy/configs/trivy-operator-admission-control.yaml), [2026-08-27-trivy-config-with-scan-policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [2026-08-12-trivy-config](../Trivy/configs/2026-08-12-trivy-config.yaml)

## Version Control Concepts  ·  10 files
- **primer:** [0000-primer-version-control-concepts.md](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
- **docs** (4): most recent → [terraform-modules-environment-promotion](../docs/concepts/version-control-concepts/docs/terraform-modules-environment-promotion.md), [branch-protection-merge-strategies-release-automation](../docs/concepts/version-control-concepts/docs/branch-protection-merge-strategies-release-automation.md), [2026-09-25-trunk-based-delivery-short-lived-branches](../docs/concepts/version-control-concepts/2026-09-25-trunk-based-delivery-short-lived-branches.md)
  - _…and 1 more under `docs/concepts/version-control-concepts/docs/` — browse the folder._
- **snippets** (2): [2026-09-23-branch-divergence-rev-list](../docs/concepts/version-control-concepts/snippets/2026-09-23-branch-divergence-rev-list.py), [2026-08-08-conventional-changelog-from-git-log](../docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py)
- **scripts** (4): most recent → [branch-management-merge-validation](../docs/concepts/version-control-concepts/scripts/branch-management-merge-validation.sh), [2026-09-25-audit-branch-hygiene-stale-branch-cleanup](../docs/concepts/version-control-concepts/scripts/2026-09-25-audit-branch-hygiene-stale-branch-cleanup.py), [2026-08-25-merge-conflict-reflog-recovery](../docs/concepts/version-control-concepts/scripts/2026-08-25-merge-conflict-reflog-recovery.sh)
  - _…and 1 more under `docs/concepts/version-control-concepts/scripts/` — browse the folder._
