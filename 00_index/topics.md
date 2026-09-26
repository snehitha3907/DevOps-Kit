# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible  ·  87 files

- **primer:** [0000-primer-ansible.md](../Ansible/notes/0000-primer-ansible.md)
- **notes** (10): most recent → [quickstart trip-ups](../Ansible/notes/2026-09-04-ansible-quickstart-trip-ups.md), [ad-hoc commands](../Ansible/notes/2026-08-23-ansible-ad-hoc-commands.md), [handlers and templates](../Ansible/notes/2026-08-12-ansible-handlers-and-templates-tutorial.md)
- _…and 7 more under `Ansible/notes/` — browse the folder._
- **templates** (48): [production project scaffold](../Ansible/templates/production-ansible-project/README.md) — `ansible.cfg`, inventory, `group_vars`, three roles, playbooks, CI workflow — plus the [role skeleton](../Ansible/templates/ansible-role/roles/myrole/README.md) and [nginx-default.conf.j2](../Ansible/templates/nginx-default.conf.j2)
- _…and 45 more under `Ansible/templates/` — browse the folder._
- **manifests** (8): [multi-server deployment](../Ansible/manifests/multi-server-deployment.yaml), with [roles/](../Ansible/manifests/roles/) (webserver, loadbalancer, dbserver), [inventory/production.ini](../Ansible/manifests/inventory/production.ini), and [group_vars/all.yaml](../Ansible/manifests/group_vars/all.yaml)
- **configs** (8): most recent → [AWX job template and credentials](../Ansible/configs/awx-job-template-and-credential-config.yaml), [first inventory and ping playbook](../Ansible/configs/2026-07-19-first-inventory-and-ping-playbook.yaml), [nginx + PHP-FPM + UFW on Ubuntu](../Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml)
- _…and 5 more under `Ansible/configs/` — browse the folder._
- **scripts** (4): [scan for antipatterns](../Ansible/scripts/scan-ansible-antipatterns.py), [install and explore modules](../Ansible/scripts/2026-07-19-install-ansible-and-explore-modules.sh), [run first playbook](../Ansible/scripts/run-first-playbook.sh)
- _1 more under `Ansible/scripts/` — browse the folder._
- **docs** (4): [Ansible 14 / core 2.21 migration](../Ansible/docs/ansible-14-core-2-21-migration-guide.md), [Ansible over Terraform local-exec](../Ansible/docs/ansible-over-terraform-local-exec.md), [Ansible + Docker CI testing](../Ansible/docs/integrated-ansible-docker-ci-pipeline-testing.md), [wiring ansible-lint](../Ansible/docs/2026-06-15-wiring-ansible-lint.md)
- **snippets** (2): [lint a playbook](../Ansible/snippets/2026-08-12-lint-ansible-playbook.py), [nginx playbook](../Ansible/snippets/nginx-playbook.yaml)
- **notebooks** (2): [variable precedence](../Ansible/notebooks/ansible-variable-precedence.ipynb), [block / rescue / serial execution patterns](../Ansible/notebooks/comparing-execution-patterns-block-rescue-serial.ipynb)
- **dockerfiles** (1): [Ansible control node](../Ansible/dockerfiles/ansible-control-node.Dockerfile)

## ArgoCD  ·  7 files

- **primer:** [0000-primer-argocd.md](../ArgoCD/notes/0000-primer-argocd.md)
- **notes** (3): most recent → [quickstart](../ArgoCD/notes/2026-08-11-argocd-quickstart.md), [install.yaml](../ArgoCD/notes/install.yaml), [0000-primer-argocd.md](../ArgoCD/notes/0000-primer-argocd.md)
- **configs** (2): [first Application manifest](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml), [guestbook ApplicationSet](../ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml)
- **scripts** (1): [install the CLI and reach the UI](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)
- **snippets** (1): [sync an app and verify health](../ArgoCD/snippets/2026-09-09-sync-app-and-verify-health.sh)

## AWS  ·  15 files

- **primer:** [0000-primer-aws.md](../AWS/notes/0000-primer-aws.md)
- **scripts** (6): most recent → [VPC + EC2 + RDS stack builder](../AWS/scripts/build-vpc-ec2-rds-stack.py) — public/private subnets, SSM-reachable instance, RDS with its own security group — plus [deploy a static website to S3](../AWS/scripts/2026-08-15-deploy-static-website-to-s3.sh), [CLI quickstart walkthrough](../AWS/scripts/2026-08-14-aws-cli-quickstart-walkthrough.sh)
- _…and 3 more under `AWS/scripts/` — browse the folder._
- **docs** (1): [IAM least-privilege walkthrough](../AWS/docs/iam-policy-least-privilege-walkthrough.md) — scoping policies for a Lambda + S3 + DynamoDB stack, checked with the policy simulator
- **notebooks** (1): [boto3 vs CloudFormation vs CDK](../AWS/notebooks/comparing-deployment-approaches-boto3-cloudformation-cdk.ipynb) — the same small versioned-bucket stack built three ways
- **configs** (2): [minimal config with named profiles](../AWS/configs/2026-07-13-minimal-aws-config.ini), [minimal config](../AWS/configs/2026-07-12-minimal-aws-config.ini)
- **snippets** (3): most recent → [create an S3 bucket and upload an object](../AWS/snippets/2026-09-21-create-s3-bucket-and-upload-object.py), [list and tag EC2 instances](../AWS/snippets/2026-08-16-list-and-tag-ec2-instances.sh), [list EC2 and S3](../AWS/snippets/2026-08-12-list-ec2-and-s3.sh)
- **notes** (2): [0000-primer-aws.md](../AWS/notes/0000-primer-aws.md), [primer-already-exists check](../AWS/notes/2026-07-13-primer-already-exists.md)

## Azure  ·  12 files

- **primer:** [0000-primer-azure.md](../Azure/notes/0000-primer-azure.md)
- **notes** (4): most recent → [first login and resource list](../Azure/notes/2026-09-18-first-login-and-resource-list.md), [quickstart trip-ups](../Azure/notes/2026-08-23-azure-quickstart-trip-ups.md), [CLI quickstart trip-ups](../Azure/notes/2026-08-16-azure-cli-quickstart-trip-ups.md)
- _1 more under `Azure/notes/` — browse the folder._
- **scripts** (3): most recent → [VM scale set with load balancer and autoscaling](../Azure/scripts/azure-vm-scale-set-autoscaling.sh), [provision a resource group and storage account](../Azure/scripts/2026-08-17-provision-resource-group-and-storage-account.sh), [install the CLI and log in](../Azure/scripts/2026-07-13-install-azure-cli-and-login.sh)
- **snippets** (3): most recent → [create a VNet, NSG, and Linux VM](../Azure/snippets/2026-09-16-create-vnet-nsg-and-linux-vm.sh), [create a resource group and list regions](../Azure/snippets/2026-08-23-create-resource-group-and-list-regions.sh), [earlier pass](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)
- **docs** (1): [CLI vs Bicep vs Python SDK](../Azure/docs/comparing-azure-cli-bicep-python-sdk.md) — which interface fits each stage of provisioning a small app stack
- **manifests** (1): [production AKS cluster](../Azure/manifests/production-aks-cluster.bicep)

## Docker  ·  43 files

- **primer:** [0000-primer-docker.md](../Docker/notes/0000-primer-docker.md)
- **notes** (6): most recent → [tutorial trip-ups](../Docker/notes/2026-08-12-docker-tutorial-tripups.md), [Compose quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md), [exploring the CLI](../Docker/notes/2026-06-06-exploring-docker-cli.md)
- _…and 3 more under `Docker/notes/` — browse the folder._
- **dockerfiles** (9): most recent → [production Python web service](../Docker/dockerfiles/production-python-web-service.Dockerfile), [production-ready Go HTTP server](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile), [multi-stage Go HTTP server](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
- _…and 6 more under `Docker/dockerfiles/` — browse the folder._
- **templates** (6): [Go microservice scaffold](../Docker/templates/go-microservice/README.md) — multi-stage Dockerfile, Makefile, `.dockerignore`, sample `main.go`
- **manifests** (6): most recent → [production Swarm stack](../Docker/manifests/production-swarm-stack.yaml), [production Compose stack](../Docker/manifests/production-compose-stack.yaml), [Go + Redis + Prometheus Compose stack](../Docker/manifests/go-redis-prometheus-compose.yaml)
- _…and 3 more under `Docker/manifests/` — browse the folder._
- **scripts** (5): most recent → [multi-stage Go build](../Docker/scripts/multi-stage-go-dockerfile.sh), [health check and cleanup](../Docker/scripts/docker-health-check-and-cleanup.sh), [install and run a first container](../Docker/scripts/install-and-run-first-container.sh)
- _…and 2 more under `Docker/scripts/` — browse the folder._
- **docs** (6): [build cache and multi-stage layering](../Docker/docs/docker-build-cache-and-multi-stage-layering.md), [build mount vs COPY caching](../Docker/docs/docker-build-mount-vs-copy-caching.md), [health check patterns](../Docker/docs/docker-health-check-patterns.md), [docker run vs compose](../Docker/docs/docker-run-vs-compose.md), [compose.yml reference](../Docker/docs/docker-compose.yml), [package.json reference](../Docker/docs/package.json)
- **notebooks** (2): [Compose vs Swarm vs Kubernetes](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb) — the same demo app in three formats — plus [networking drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
- **snippets** (2): [build, run, and clean up](../Docker/snippets/2026-08-12-build-run-and-cleanup.py), [image layer analyzer](../Docker/snippets/analyze-image-layers.py)
- **configs** (1): [multi-service app config](../Docker/configs/multi-service-app.yaml)

## FluxCD  ·  3 files

- **notes** (1): [exploring the Flux CLI command surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md) — bootstrap, reconcile, tree, get, and the gotchas that tripped me up
- **scripts** (1): [install the CLI and run `flux check --pre`](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- **docs** (1): [Flux CD coverage and topics note](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md) — how this folder maps into the README coverage table and topic map

## GCP  ·  11 files

- **primer:** [0000-primer-gcp.md](../GCP/notes/0000-primer-gcp.md)
- **notes** (2): most recent → [gcloud SDK quickstart trip-ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md), [0000-primer-gcp.md](../GCP/notes/0000-primer-gcp.md)
- **scripts** (4): most recent → [launch a VM, firewall rule, and SSH in](../GCP/scripts/2026-09-21-launch-vm-firewall-and-ssh.sh), [create a GCS bucket and set up IAM](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh), [install and configure credentials](../GCP/scripts/2026-08-23-install-gcloud-cli-and-configure-creds.sh)
- _1 more under `GCP/scripts/` — browse the folder._
- **configs** (3): most recent → [instance template with startup script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml), [minimal config and startup script](../GCP/configs/2026-08-14-minimal-gcloud-config-and-startup-script.yaml), [service account and IAM](../GCP/configs/service-account-and-iam-config.yaml)
- **snippets** (2): most recent → [list Compute and GCS](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh), [earlier pass](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)

## Git  ·  58 files

- **primer:** [0000-primer-git.md](../Git/notes/0000-primer-git.md)
- **templates** (22): [git-repository-skeleton README](../Git/templates/git-repository-skeleton/README.md) — commitlint, pinned `.githooks`, release-please — plus [pre-commit hook](../Git/templates/git-hooks/pre-commit) and [commit-msg hook](../Git/templates/git-hooks/commit-msg)
- _…and 19 more under `Git/templates/` — browse the folder._
- **docs** (15): most recent → [worktree workflows for parallel branches](../Git/docs/worktree-workflows-parallel-branches.md), [scripts count note](../Git/docs/2026-09-25-git-scripts-count-correction.md), [worktree setup gotchas](../Git/docs/git-worktrees-parallel-feature-development-setup-workflow-gotchas.md)
- _…and 12 more under `Git/docs/` — browse the folder._
- **scripts** (11): [bisect automation runner](../Git/scripts/bisect-automation-runner.sh) — drives `git bisect run` end to end against a scripted regression test — plus [gitattributes filters and merge drivers](../Git/scripts/setup-gitattributes-filters-and-merge.sh), [branch management and tagging](../Git/scripts/branch-management-and-tag-creation.sh), [merge conflict practice](../Git/scripts/2026-06-10-merge-conflict-practice.sh)
- _…and 7 more under `Git/scripts/` — browse the folder._
- **notes** (8): most recent → [branching tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md), [earlier branching pass](../Git/notes/2026-06-07-git-branching-tutorial.md), [explore the CLI](../Git/notes/2026-06-04-explore-git-cli.md)
- _…and 5 more under `Git/notes/` — browse the folder._
- **snippets** (1): [first commit](../Git/snippets/first-commit.sh)
- **notebooks** (1): [comparing merge strategies](../Git/notebooks/comparing-git-merge-strategies.ipynb)

## GitHub  ·  44 files

- **primer:** [0000-primer-github.md](../GitHub/notes/0000-primer-github.md)
- **notes** (11): most recent → [gh CLI quickstart trip-ups](../GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md), [hello-world guide and GitHub flow](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md), [platform features](../GitHub/notes/2026-06-10-github-platform-features.md)
- _…and 8 more under `GitHub/notes/` — browse the folder._
- **scripts** (6): most recent → [create a repo and open a PR](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh), [auth and explore the profile](../GitHub/scripts/2026-06-10-auth-and-explore-profile.sh), [provision a repo with the API](../GitHub/scripts/provision-repo-with-api.py)
- _…and 3 more under `GitHub/scripts/` — browse the folder._
- **configs** (7): [dot-github-repository/](../GitHub/configs/dot-github-repository/) (issue forms, labels, stale rules), [issue templates and labels](../GitHub/configs/issue-templates-and-labels.yaml), [PR checker workflow](../GitHub/configs/2026-08-22-pr-checker-workflow.yaml)
- _…and 4 more under `GitHub/configs/` — browse the folder._
- **templates** (8): [production repo scaffold](../GitHub/templates/github-repo-scaffold/README.md) — branch protection script, CODEOWNERS, issue and PR templates, Dependabot
- **docs** (6): most recent → [release automation end to end](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md), [deploy keys vs fine-grained PATs for CI/CD](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md), [branch protection and required reviews](../GitHub/docs/branch-protection-and-required-reviews-for-ci.md)
- _…and 3 more under `GitHub/docs/` — browse the folder._
- **snippets** (3): [issues API](../GitHub/snippets/github-issues-api.py), [list repos with Python](../GitHub/snippets/list-repos-with-python.py), [open a PR and wait for CI](../GitHub/snippets/open-pr-and-wait-for-ci.sh)
- **manifests** (1): [Environments deployment protection](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **notebooks** (1): [comparing API approaches to release automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb)
- **dockerfiles** (1): [self-hosted runner](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)

## GitHub Actions  ·  20 files

- **primer:** [0000-primer-github-actions.md](../GitHub Actions/notes/0000-primer-github-actions.md)
- **notes** (6): most recent → [following the quickstart](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md), [primer-already-exists check](../GitHub Actions/notes/2026-07-13-primer-already-exists.md), [ci.yml reference](../GitHub Actions/notes/ci.yml)
- _…and 3 more under `GitHub Actions/notes/` — browse the folder._
- **configs** (5): most recent → [reusable deployment workflow with environment gates](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml), [matrix node workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml), [hello workflow](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)
- _…and 2 more under `GitHub Actions/configs/` — browse the folder._
- **docs** (5): [composite actions vs reusable workflows](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md), [quickstart trip-ups](../GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md), [ci.yml reference](../GitHub Actions/docs/ci.yml), [test.yml reference](../GitHub Actions/docs/test.yml)
- _1 more under `GitHub Actions/docs/` — browse the folder._
- **scripts** (3): [self-hosted runner registration and cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh), [install the gh extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh), [list runs](../GitHub Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh)
- **snippets** (1): [trigger a `workflow_dispatch` and poll status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)

## GitLab CI  ·  11 files

- **primer:** [0000-primer-gitlab-ci-cd.md](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **notes** (4): most recent → [runner setup, variables, and artifacts trip-ups](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md), [following the quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md), [`.gitlab-ci.yml` reference](../GitLab CI/notes/.gitlab-ci.yml)
- _1 more under `GitLab CI/notes/` — browse the folder._
- **configs** (3): most recent → [multi-project pipeline with a downstream trigger](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml), [stages, cache, and artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml), [first pipeline](../GitLab CI/configs/2026-06-22-first-pipeline.yaml)
- **scripts** (3): [local pipeline validator](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh), [install a runner and register](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh), [run a first local pipeline](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh)
- **snippets** (1): [trigger a pipeline via the API and poll jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)

## Grafana  ·  5 files

Folder on disk is `graf/`.

- **primer:** [0000-primer-grafana.md](../graf/notes/0000-primer-grafana.md)
- **notes** (2): [poking around the UI](../graf/notes/2026-09-25-explore-grafana-ui.md) — data sources, panels, dashboards, and the localhost-in-Docker gotcha — plus [0000-primer-grafana.md](../graf/notes/0000-primer-grafana.md)
- **scripts** (1): [install Grafana with Docker](../graf/scripts/2026-09-25-install-grafana-with-docker.sh) — runs `grafana/grafana` on port 3000 and waits for the login page
- **docs** (2): [navigation dedup note](../graf/docs/2026-09-25-grafana-navigation-dedup.md), [coverage and topics note](../graf/docs/2026-09-25-grafana-coverage-and-topics.md)

## HashiCorp Vault  ·  4 files

Folder on disk is `vlt/`.

- **primer:** [0000-primer-vlt.md](../vlt/notes/0000-primer-vlt.md)
- **notes** (2): [exploring the Vault CLI](../vlt/notes/2026-09-19-explore-vault-cli-secrets-policies.md) — secrets, policies, and what is already there — plus [0000-primer-vlt.md](../vlt/notes/0000-primer-vlt.md)
- **scripts** (1): [install the CLI and start a dev server](../vlt/scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh)
- **docs** (1): [how `vlt/` is reflected in the README and topic map](../vlt/docs/2026-09-19-vlt-readme-layout-and-coverage.md)

## Helm  ·  20 files

- **primer:** [0000-primer-helm.md](../Helm/notes/0000-primer-helm.md)
- **manifests** (4): a minimal [redis chart](../Helm/manifests/redis-chart/Chart.yaml) with [deployment](../Helm/manifests/redis-chart/templates/deployment.yaml) and [service](../Helm/manifests/redis-chart/templates/service.yaml) templates, plus [values](../Helm/manifests/redis-chart/values.yaml)
- **docs** (4): most recent → [values management approaches](../Helm/docs/values-management-approaches.md) — `--set` vs per-environment files vs named templates — plus [adding Helm to the README](../Helm/docs/2026-07-25-add-helm-to-readme-layout-and-coverage.md) and [already documented](../Helm/docs/2026-07-25-helm-readme-already-documented.md)
- _1 more under `Helm/docs/` — browse the folder._
- **notes** (3): most recent → [quickstart trip-ups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [0000-primer-helm.md](../Helm/notes/0000-primer-helm.md), [values.yaml reference](../Helm/notes/values.yaml)
- **configs** (4): most recent → [live-release values](../Helm/configs/2026-09-02-live-release-values.yaml), [production-deployment values](../Helm/configs/2026-08-30-production-deployment-values.yaml), [live values](../Helm/configs/2026-08-29-live-values.yaml)
- _1 more under `Helm/configs/` — browse the folder._
- **scripts** (3): [demo web service chart](../Helm/scripts/demo-web-service-chart.sh) — scaffold, lint, render, install, verify — plus [install and explore the CLI](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh) and [a scratch test](../Helm/scripts/dummy-test.sh)
- **snippets** (1): [nginx chart with custom values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **notebooks** (1): [release lifecycle drill](../Helm/notebooks/release-lifecycle-drill.ipynb)

## Kubernetes  ·  36 files

- **primer:** [0000-primer-kubernetes.md](../Kubernetes/notes/0000-primer-kubernetes.md)
- **templates** (10): [Helm chart + Kustomize overlay scaffold](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/Chart.yaml) — a chart (`Chart.yaml`, `values.yaml`, `templates/`) with `kustomize/base/` and `overlays/dev|prod/`
- **notes** (9): most recent → [kubectl and minikube, first pod](../Kubernetes/notes/2026-09-04-kubectl-minikube-first-pod.md), [what tripped me up](../Kubernetes/notes/2026-08-12-kubernetes-tutorial-what-tripped-me-up.md), [first pod from a manifest](../Kubernetes/notes/2026-07-19-first-kubectl-version-and-pod-from-manifest.md)
- _…and 6 more under `Kubernetes/notes/` — browse the folder._
- **manifests** (5): most recent → [production deployment with HPA, PDB, and NetworkPolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml), [Go service with probes and an HPA](../Kubernetes/manifests/go-service-deployment-with-probes-hpa.yaml), [stateless app](../Kubernetes/manifests/stateless-app.yaml)
- _…and 2 more under `Kubernetes/manifests/` — browse the folder._
- **docs** (4): most recent → [integrating with Prometheus](../Kubernetes/docs/integrating-kubernetes-with-prometheus.md), [ingress path-based routing](../Kubernetes/docs/ingress-path-based-routing.md), [prometheus.yml reference](../Kubernetes/docs/prometheus.yml)
- _1 more under `Kubernetes/docs/` — browse the folder._
- **scripts** (3): [rollout status and pod readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh), [install kind and create a first cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh), [pod lifecycle](../Kubernetes/scripts/pod-lifecycle.sh)
- **notebooks** (2): [comparing workload types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb), [workload types, newer pass](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)
- **snippets** (2): [first pod and service with kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh), [pod troubleshooting shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
- **configs** (1): [Deployment and Service for a Go app with probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)

## OpenTelemetry  ·  4 files

Folder on disk is `otel/`.

- **primer:** [0000-primer-opentelemetry.md](../otel/notes/0000-primer-opentelemetry.md) — traces, spans, context propagation, exporters, and where the collector sits
- **scripts** (1): [install a collector and run the OTLP pipeline](../otel/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh) — brings up `otel/opentelemetry-collector-contrib` on 4317/4318, emits one span, and tails the collector log
- **snippets** (1): [first trace span](../otel/snippets/2026-09-26-first-trace-span.py) — a tracer provider, a span with an attribute, and an OTLP exporter aimed at `localhost:4317`
- **docs** (1): [how `otel/` is reflected in the README and topic map](../otel/docs/2026-09-25-opentelemetry-readme-coverage.md)

## OpenTofu  ·  10 files

- **primer:** [0000-primer-opentofu.md](../OpenTofu/notes/0000-primer-opentofu.md)
- **docs** (3): most recent → [S3 backend with workspace isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md) — shared state per environment with locking — plus [state management tutorial notes](../OpenTofu/docs/2026-08-25-state-management-tutorial-notes.md) covering `state list/mv/pull` and backend migration
- **notes** (2): most recent → [quickstart trip-ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md), [0000-primer-opentofu.md](../OpenTofu/notes/0000-primer-opentofu.md)
- **scripts** (2): [S3 + DynamoDB remote-state bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh) — bucket, lock table, scoped IAM user, state migration — plus [install and verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- **configs** (2): [minimal local config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf), [minimal local backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl)
- **notebooks** (1): [OpenTofu vs Terraform for AWS provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)

## Prometheus  ·  6 files

- **primer:** [0000-primer-prometheus.md](../Prometheus/notes/0000-primer-prometheus.md)
- **notes** (2): most recent → [getting-started trip-ups](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md), [0000-primer-prometheus.md](../Prometheus/notes/0000-primer-prometheus.md)
- **configs** (2): [container monitoring config](../Prometheus/configs/2026-09-05-minimal-container-monitoring-config.yml), [minimal scrape config](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml)
- **scripts** (1): [install and verify the metrics endpoint](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh)
- **snippets** (1): [PromQL target health check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)

## Pulumi  ·  4 files

Folder on disk is `plm/`.

- **primer:** [0000-primer-plm.md](../plm/notes/0000-primer-plm.md)
- **scripts** (1): [install the CLI and init a project](../plm/scripts/2026-09-19-install-pulumi-cli-and-init-project.sh)
- **snippets** (1): [minimal bucket with Pulumi Python](../plm/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)
- **docs** (1): [how `plm/` is reflected in the README and topic map](../plm/docs/2026-09-20-plm-readme-layout-and-coverage.md)

## Terraform  ·  38 files

- **primer:** [0000-primer-terraform.md](../Terraform/notes/0000-primer-terraform.md)
- **templates** (10): [multi-environment workspaces + remote state scaffold](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/README.md) — one configuration for dev and prod with workspace-scoped S3 and DynamoDB backends, plus `apply.sh` / `destroy.sh` helpers
- **configs** (8): [reusable S3 module](../Terraform/configs/reusable-s3-module/README.md), [local_file plus random_pet across two providers](../Terraform/configs/2026-09-19-local-file-random-provider.hcl), [local_file resource](../Terraform/configs/local-file.tf)
- _…and 5 more under `Terraform/configs/` — browse the folder._
- **notes** (6): most recent → [install and a first local file](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md), [state management tutorial](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md), [following the provider tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md)
- _…and 3 more under `Terraform/notes/` — browse the folder._
- **docs** (4): most recent → [wiring outputs into dependent modules](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md), [workspaces and remote state locking](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md), [the earlier pass](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md)
- _1 more under `Terraform/docs/` — browse the folder._
- **scripts** (3): [generate an Ansible inventory from Terraform state](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py), [bootstrap a project scaffold](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh), [install and init](../Terraform/scripts/install-and-init.sh)
- **snippets** (3): most recent → [explore the CLI](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [scaffold an S3 module with remote state](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh), [for_each and validation pattern](../Terraform/snippets/reusable-module-for-each-validation.hcl)
- **notebooks** (2): [Terraform vs OpenTofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb), [for_each vs count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **manifests** (2): [reusable VPC module](../Terraform/manifests/reusable-vpc-module.hcl) — public and private subnets across AZs, IGW, optional NAT gateways — plus [simple EC2 app](../Terraform/manifests/simple-ec2-app.tf)

## Trivy  ·  14 files

- **primer:** [0000-primer-trivy.md](../Trivy/notes/0000-primer-trivy.md)
- **notes** (5): most recent → [quickstart follow-along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md), [quickstart trip-ups (latest)](../Trivy/notes/2026-08-29-trivy-quickstart-trip-ups.md), [quickstart trip-ups](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)
- _…and 2 more under `Trivy/notes/` — browse the folder._
- **scripts** (4): [repo scan workflow with SARIF output](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh), [install and scan a filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh), [first container image scan](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh), [batch image scanning](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)
- **snippets** (2): most recent → [scan an image and fail on critical CVEs](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py), [a Python wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)
- **configs** (2): most recent → [config with scan policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [config with severity filtering](../Trivy/configs/2026-08-12-trivy-config.yaml)
- **docs** (1): [choosing scan modes and pipeline wiring](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md) — image vs fs vs repo vs sbom, and blocking a bad artifact in CI

## Foundational Concepts  ·  77 files

- **CI/CD Concepts** — [primer](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md): pipelines, gates, rollbacks, artifact promotion.
  - **docs** (3): [preview environments with gated promotion](../docs/concepts/ci-cd-concepts/docs/ephemeral-preview-environments-gated-promotion.md), [artifact promotion, environments, rollbacks](../docs/concepts/ci-cd-concepts/docs/artifact-promotion-environment-rollbacks.md), [multi-environment gates workflow](../docs/concepts/ci-cd-concepts/docs/multi-environment-cicd-gates-workflow.md)
  - **scripts** (2): [simulated pipeline](../docs/concepts/ci-cd-concepts/scripts/2026-08-04-simulated-cicd-pipeline.sh), [artifact promotion and rollback](../docs/concepts/ci-cd-concepts/scripts/artifact-promotion-rollback.sh)
  - **snippets** (2): [common patterns](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh), [parallelized stage runner](../docs/concepts/ci-cd-concepts/snippets/2026-08-08-parallelized-ci-stage-runner.sh)
  - **notes** (1): [artifact promotion gates and rollbacks](../docs/concepts/ci-cd-concepts/2026-08-10-artifact-promotion-gates-rollbacks.md)
- **Containerization Concepts** — [primer](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md): image layers, runtimes, caching, signing.
  - **docs** (2): [smaller images, base caching, runtimes](../docs/concepts/containerization-concepts/docs/2026-08-08-smaller-images-base-caching-runtimes.md), [image scanning and signing](../docs/concepts/containerization-concepts/docs/image-scanning-and-signing-in-a-build-pipeline.md)
  - **scripts** (2): [build, tag, and run lifecycle](../docs/concepts/containerization-concepts/scripts/2026-09-06-docker-build-tag-run-lifecycle.sh), [build and push workflow](../docs/concepts/containerization-concepts/scripts/build-and-push-pipeline.py)
  - **snippets** (2): [inspect image layers](../docs/concepts/containerization-concepts/snippets/2026-08-08-inspect-image-layers.py), [inspect layers with the Docker SDK](../docs/concepts/containerization-concepts/snippets/2026-09-24-inspect-image-layers-with-docker-sdk.py)
  - **notebooks** (1): [container network topology and service discovery](../docs/concepts/containerization-concepts/notebooks/container-network-topology-service-discovery.ipynb)
- **Infrastructure as Code Concepts** — [primer](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md): declarative vs imperative, Terraform and Ansible roles, state workflows.
  - **docs** (2): [Terraform / Ansible division of responsibility](../docs/concepts/infrastructure-as-code-concepts/docs/2026-08-08-terraform-ansible-division-of-responsibility.md), [Terraform and Docker integration patterns](../docs/concepts/infrastructure-as-code-concepts/docs/terraform-docker-integration-patterns.md)
  - **notebooks** (2): [declarative vs imperative IaC](../docs/concepts/infrastructure-as-code-concepts/notebooks/2026-08-08-declarative-vs-imperative-iac.ipynb), [Terraform vs Ansible for container infra](../docs/concepts/infrastructure-as-code-concepts/notebooks/terraform-vs-ansible-container-infra.ipynb)
  - **scripts** (1): [IaC state workflow sandbox](../docs/concepts/infrastructure-as-code-concepts/scripts/2026-08-25-iac-state-workflow.sh)
  - **snippets** (1): [parse and validate Terraform state](../docs/concepts/infrastructure-as-code-concepts/snippets/2026-09-06-parse-and-validate-terraform-state.py)
- **Linux & System Administration** — [primer](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md): processes, permissions, systemd, journald.
  - **scripts** (4): most recent → [systemd health check, log alerting](../docs/concepts/linux-system-administration/scripts/systemd-health-check-log-alerting.sh), [watchdog restart and page](../docs/concepts/linux-system-administration/scripts/systemd-watchdog-restart-and-page.sh), [health check and log rotation](../docs/concepts/linux-system-administration/scripts/systemd-health-check-and-log-rotation.sh)
- _1 more under `docs/concepts/linux-system-administration/scripts/` — browse the folder._
  - **notes** (1): [process and permission patterns in DevOps](../docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md)
  - **docs** (1): [systemd timers and journald shipping](../docs/concepts/linux-system-administration/docs/systemd-timers-journald-shipping.md)
  - **notebooks** (1): [Linux system performance analysis](../docs/concepts/linux-system-administration/notebooks/linux-system-performance-analysis.ipynb)
- **Monitoring & Observability** — [primer](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md): metrics, logs, traces, scraping.
  - **docs** (2): [combining metrics, logs, and traces](../docs/concepts/monitoring-observability-concepts/docs/2026-08-09-combining-metrics-logs-traces-observability.md), [delivery telemetry, DORA metrics, and deployment markers](../docs/concepts/monitoring-observability-concepts/docs/cicd-pipeline-health-telemetry-dora-deployment-markers.md)
  - **scripts** (3): most recent → [metrics exporter and structured logger](../docs/concepts/monitoring-observability-concepts/scripts/2026-09-08-metrics-exporter-structured-logger.py), [scripted health gate with correlated logs](../docs/concepts/monitoring-observability-concepts/scripts/scripted-health-gate-with-correlated-logs.py), [health checks and log correlation](../docs/concepts/monitoring-observability-concepts/scripts/health-checks-and-log-correlation.py)
  - **notebooks** (2): [scraping an endpoint, the three pillars](../docs/concepts/monitoring-observability-concepts/notebooks/2026-08-11-scraping-endpoint-three-pillars.ipynb), [tracing containerized service dependencies](../docs/concepts/monitoring-observability-concepts/notebooks/tracing-containerized-service-dependencies.ipynb)
- **Networking Fundamentals** — [primer](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md): DNS, TLS, TCP probes, load balancing.
  - **scripts** (6): most recent → [TCP port reachability and DNS resolution](../docs/concepts/networking-fundamentals/scripts/2026-09-25-testing-tcp-port-reachability-dns-resolution.py), [TCP/TLS probes with latency](../docs/concepts/networking-fundamentals/scripts/tcp-tls-health-probes-with-latency.sh), [health-check automation with JSON output](../docs/concepts/networking-fundamentals/scripts/health-check-automation-with-json-output.sh)
- _…and 3 more under `docs/concepts/networking-fundamentals/scripts/` — browse the folder._
  - **snippets** (1): [TCP port and DNS checks with sockets](../docs/concepts/networking-fundamentals/snippets/2026-09-24-tcp-port-and-dns-sockets.py)
  - **notebooks** (2): [DNS, TLS, and load-balancing visualization](../docs/concepts/networking-fundamentals/notebooks/2026-08-10-dns-tls-load-balancing-visualization.ipynb), [network health telemetry visualization](../docs/concepts/networking-fundamentals/notebooks/network-health-telemetry-visualization.ipynb)
  - **notes** (1): [network troubleshooting patterns](../docs/concepts/networking-fundamentals/notes/2026-08-07-network-troubleshooting-patterns.md)
- **Scripting & Automation (Bash/Python)** — [primer](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md): glue scripts, `jq`, retry and backoff.
  - **scripts** (4): most recent → [parallel tasks with logging](../docs/concepts/scripting-automation-bash-python/scripts/2026-09-23-parallel-tasks-with-logging.sh), [config parsing with `jq` and retry](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-23-config-parsing-jq-retry.sh), [bash scripting exercises](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-07-bash-scripting-exercises.sh)
- _1 more under `docs/concepts/scripting-automation-bash-python/scripts/` — browse the folder._
  - **docs** (2): [combining scripting with IaC automation patterns](../docs/concepts/scripting-automation-bash-python/docs/combining-scripting-with-iac-automation-patterns.md), [a small `site.yml` playbook reference](../docs/concepts/scripting-automation-bash-python/docs/site.yml) used by the exercises
  - **snippets** (2): [log parsing and filtering](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py), [retry, backoff, and logging](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-08-retry-backoff-logging.py)
  - **notebooks** (1): [bash / python glue patterns](../docs/concepts/scripting-automation-bash-python/notebooks/2026-08-11-bash-python-glue-patterns.ipynb)
- **Version Control Concepts** — [primer](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md): branching, merge strategies, release automation.
  - **notes** (1): [trunk-based delivery with short-lived branches](../docs/concepts/version-control-concepts/2026-09-25-trunk-based-delivery-short-lived-branches.md) — branch protection, merge queues, and CODEOWNERS on `main`
  - **docs** (2): [branch protection, merge strategies, release automation](../docs/concepts/version-control-concepts/docs/branch-protection-merge-strategies-release-automation.md), [Terraform modules and environment promotion](../docs/concepts/version-control-concepts/docs/terraform-modules-environment-promotion.md)
  - **scripts** (4): most recent → [audit branch hygiene and clean up stale branches](../docs/concepts/version-control-concepts/scripts/2026-09-25-audit-branch-hygiene-stale-branch-cleanup.py), [merge conflict and reflog recovery sandbox](../docs/concepts/version-control-concepts/scripts/2026-08-25-merge-conflict-reflog-recovery.sh), [feature branch rebase, merge, and tag](../docs/concepts/version-control-concepts/scripts/2026-08-08-git-feature-branch-rebase-merge-tag.sh)
- _1 more under `docs/concepts/version-control-concepts/scripts/` — browse the folder._
  - **snippets** (2): [branch divergence check](../docs/concepts/version-control-concepts/snippets/2026-09-23-branch-divergence-rev-list.py), [conventional changelog from `git log`](../docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py)

## docs (kit notes)  ·  4 files

Notes about the kit itself, kept alongside the content they refer to. Browse `docs/`.

- [Kubernetes README tree update](../docs/2026-07-21-kubernetes-readme-tree-update.md)
- [Ansible notebooks verified](../docs/2026-07-19-ansible-notebooks-readme-verified.md)
- [audit-004 check](../docs/2026-07-19-audit-004-check.md)
- [removed dead `general/` references](../docs/2026-07-11-removed-dead-general-references.md)

## docs/audit  ·  12 files

Checks that keep the README and index files aligned with what is actually on disk. Browse `docs/audit/`.

- [audit-012: Docker Dockerfile count](../docs/audit/2026-09-07-audit-012-docker-dockerfile-count.md)
- [audit-011: OpenTofu README](../docs/audit/2026-08-20-audit-011-opentofu-readme.md)
- [audit-009: GitHub README](../docs/audit/2026-08-20-audit-009-github-readme.md)
- _…and 9 more under `docs/audit/` — browse the folder._
