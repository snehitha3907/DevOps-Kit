# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## AWS · 21 files
- **primer:** [notes/0000-primer-aws.md](../AWS/notes/0000-primer-aws.md)
- _…browse the folder._

## Ansible · 88 files
- **primer:** [notes/0000-primer-ansible.md](../Ansible/notes/0000-primer-ansible.md)
- _…browse the folder._

## Docker · 52 files
- _…browse the folder._

## Kubernetes · 61 files
- _…browse the folder._

## Terraform · 56 files
- _…browse the folder._

## Git · 56 files
- _…browse the folder._

## Helm · 55 files
- _…browse the folder._

## GitHub · 56 files
- _…browse the folder._

## Docker  ·  52 files

- **primer:** [0000-primer-docker.md](../Docker/notes/0000-primer-docker.md)
- **notes** (6): most recent → [tutorial trip-ups](../Docker/notes/2026-08-12-docker-tutorial-tripups.md), [Compose quickstart](../Docker/notes/2026-06-07-docker-compose-quickstart.md), [exploring the CLI](../Docker/notes/2026-06-06-exploring-docker-cli.md)
- _…and 3 more under `Docker/notes/` — browse the folder._
- **dockerfiles** (9): most recent → [production Python web service](../Docker/dockerfiles/production-python-web-service.Dockerfile), [production-ready Go HTTP server](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile), [multi-stage Go HTTP server](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
- _…and 6 more under `Docker/dockerfiles/` — browse the folder._
- **templates** (12): two ready-to-copy scaffolds — [multi-service Compose with health checks](../Docker/templates/multi-service-compose-with-healthchecks/README.md) (app + Postgres + Redis, `service_healthy` startup order, `.env.example`) and the [Go microservice](../Docker/templates/go-microservice/README.md) (multi-stage Dockerfile, Makefile, `.dockerignore`, sample `main.go`)
- **notebooks** (3): most recent → [BuildKit vs classic vs Buildx](../Docker/notebooks/comparing-docker-build-strategies.ipynb) — the three build engines with a feature matrix, plus [Compose vs Swarm vs Kubernetes](../Docker/notebooks/comparing-compose-swarm-kubernetes-local-orchestration.ipynb) and [networking drivers](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
- **manifests** (6): most recent → [production Swarm stack](../Docker/manifests/production-swarm-stack.yaml), [production Compose stack](../Docker/manifests/production-compose-stack.yaml), [Go + Redis + Prometheus Compose stack](../Docker/manifests/go-redis-prometheus-compose.yaml)
- _…and 3 more under `Docker/manifests/` — browse the folder._
- **scripts** (5): most recent → [multi-stage Go build](../Docker/scripts/multi-stage-go-dockerfile.sh), [health check and cleanup](../Docker/scripts/docker-health-check-and-cleanup.sh), [install and run a first container](../Docker/scripts/install-and-run-first-container.sh)
- _…and 2 more under `Docker/scripts/` — browse the folder._
- **docs** (8): most recent → [BuildKit cache mounts and secrets](../Docker/docs/docker-buildkit-cache-mounts-secrets.md), [Docker-to-Kubernetes handoff](../Docker/docs/integrating-docker-with-kubernetes.md) — immutable tags, pull secrets, probe translation, requests/limits, rollout and rollback — plus [build cache and multi-stage layering](../Docker/docs/docker-build-cache-and-multi-stage-layering.md), [health check patterns](../Docker/docs/docker-health-check-patterns.md)
- _…and 5 more under `Docker/docs/` — browse the folder._
- **snippets** (2): [build, run, and clean up](../Docker/snippets/2026-08-12-build-run-and-cleanup.py), [image layer analyzer](../Docker/snippets/analyze-image-layers.py)
- **configs** (1): [multi-service app config](../Docker/configs/multi-service-app.yaml)

## FluxCD  ·  7 files

- **notes** (2): most recent → [quickstart trip-ups](../FluxCD/notes/2026-09-30-flux-quickstart-trip-ups.md) — the Git-side path and the cluster-side objects are two separate halves, and both have to exist — plus [exploring the Flux CLI command surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md)
- **configs** (2): most recent → [HelmRelease with image automation](../FluxCD/configs/helmrelease-image-automation.yaml) — a HelmRelease that watches the container registry and rolls out new image tags without a Git commit — plus [minimal GitRepository and Kustomization](../FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml)
- **scripts** (2): most recent → [bootstrap Flux on kind](../FluxCD/scripts/bootstrap-flux-on-kind.sh) — installs Flux, creates a GitRepository and Kustomization, and waits for readiness; idempotent and safe to re-run — plus [install the CLI and run `flux check --pre`](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- **docs** (1): [Flux CD coverage and topics note](../FluxCD/docs/2026-09-20-flux-cd-readme-coverage-and-topics-update.md) — how this folder maps into the README coverage table and topic map

## GCP  ·  13 files

- **primer:** [0000-primer-gcp.md](../GCP/notes/0000-primer-gcp.md)
- **notes** (2): most recent → [gcloud SDK quickstart trip-ups](../GCP/notes/2026-09-20-gcloud-sdk-quickstart-trip-ups.md), [0000-primer-gcp.md](../GCP/notes/0000-primer-gcp.md)
- **scripts** (6): most recent → [build a Cloud Run service with generated Terraform](../GCP/scripts/build-cloud-run-service-terraform.py) — writes a minimal `.tf`, runs `init`/`plan`/`apply`, prints the service URL — plus [launch a VM, firewall rule, and SSH in](../GCP/scripts/2026-09-21-launch-vm-firewall-and-ssh.sh), [create a GCS bucket and set up IAM](../GCP/scripts/create-gcs-bucket-and-setup-iam.sh)
- _…and 2 more under `GCP/scripts/` — browse the folder._
- **configs** (3): most recent → [instance template with startup script](../GCP/configs/2026-09-21-instance-template-with-startup-script.yaml), [minimal config and startup script](../GCP/configs/2026-08-14-minimal-gcloud-config-and-startup-script.yaml), [service account and IAM](../GCP/configs/service-account-and-iam-config.yaml)
- **snippets** (2): most recent → [list Compute and GCS](../GCP/snippets/2026-08-23-list-compute-and-gcs-with-gcloud.sh), [earlier pass](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)
- **docs** (1): [GCP coverage note](../GCP/docs/2026-09-28-gcp-readme-coverage-and-topics.md) — how `GCP/` maps into the README coverage table and topic map

## Git  ·  56 files

- **primer:** [0000-primer-git.md](../Git/notes/0000-primer-git.md)
- **templates** (22): [git-repository-skeleton README](../Git/templates/git-repository-skeleton/README.md) — commitlint, pinned `.githooks`, release-please — plus [pre-commit hook](../Git/templates/git-hooks/pre-commit) and [commit-msg hook](../Git/templates/git-hooks/commit-msg)
- _…and 19 more under `Git/templates/` — browse the folder._
- **docs** (14): most recent → [worktree workflows for parallel branches](../Git/docs/worktree-workflows-parallel-branches.md), [scripts count note](../Git/docs/2026-09-25-git-scripts-count-correction.md), [worktree setup gotchas](../Git/docs/git-worktrees-parallel-feature-development-setup-workflow-gotchas.md)
- _…and 11 more under `Git/docs/` — browse the folder._
- **scripts** (12): [regression test probe for `git bisect run`](../Git/scripts/regression-test.sh) — deterministic 0/1/125 exit codes with TEST_CMD/PRE_CMD knobs, companion to the scripted-bisect guide — plus [bisect automation runner](../Git/scripts/bisect-automation-runner.sh), [gitattributes filters and merge drivers](../Git/scripts/setup-gitattributes-filters-and-merge.sh), [branch management and tagging](../Git/scripts/branch-management-and-tag-creation.sh)
- _…and 8 more under `Git/scripts/` — browse the folder._
- **notes** (6): most recent → [branching tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md), [earlier branching pass](../Git/notes/2026-06-07-git-branching-tutorial.md), [explore the CLI](../Git/notes/2026-06-04-explore-git-cli.md)
- _…and 3 more under `Git/notes/` — browse the folder._
- **snippets** (1): [first commit](../Git/snippets/first-commit.sh)
- **notebooks** (2): most recent → [merge, rebase, and squash comparison notebook](../Git/notebooks/merge-rebase-squash-comparison.ipynb) — Visual comparison of the three merge strategies with commit graphs and history outcomes., [branching tutorial](../Git/notes/2026-08-11-git-branching-tutorial.md)

## GitHub  ·  56 files

- **primer:** [0000-primer-github.md](../GitHub/notes/0000-primer-github.md)
- **notes** (11): most recent → [gh CLI quickstart trip-ups](../GitHub/notes/2026-09-19-gh-cli-quickstart-trip-ups.md), [hello-world guide and GitHub flow](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md), [platform features](../GitHub/notes/2026-06-10-github-platform-features.md)
- _…and 8 more under `GitHub/notes/` — browse the folder._
- **scripts** (7): most recent → [merge Dependabot PRs that pass CI](../GitHub/scripts/dependabot-merge-automation.py) — lists Dependabot PRs, checks commit check-runs, squash-merges only the green ones — plus [create a repo and open a PR](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh), [auth and explore the profile](../GitHub/scripts/2026-06-10-auth-and-explore-profile.sh), [provision a repo with the API](../GitHub/scripts/provision-repo-with-api.py)
- _…and 3 more under `GitHub/scripts/` — browse the folder._
- **configs** (7): [dot-github-repository/](../GitHub/configs/dot-github-repository/) (issue forms, labels, stale rules), [issue templates and labels](../GitHub/configs/issue-templates-and-labels.yaml), [PR checker workflow](../GitHub/configs/2026-08-22-pr-checker-workflow.yaml)
- _…and 4 more under `GitHub/configs/` — browse the folder._
- **templates** (17): [production repo scaffold](../GitHub/templates/github-repo-scaffold/README.md) — branch protection script, CODEOWNERS, issue and PR templates, Dependabot, and a split CI workflow (build / lint / test) — plus the [security and compliance template](../GitHub/templates/github-security-compliance/README.md) — SECURITY.md vulnerability disclosure policy, Dependabot security-update config with security-team reviewers, CODEOWNERS for security-sensitive paths, a security-focused PR template, and a COMPLIANCE.md audit checklist
- **docs** (7): most recent → [GitHub Apps vs OAuth Apps](../GitHub/docs/github-apps-vs-oauth-apps.md) — actor-first comparison of which registration fits unattended automation, event-driven workflows, and user-facing tooling — plus [release automation end to end](../GitHub/docs/release-automation-tags-milestones-and-releases-end-to-end.md), [deploy keys vs fine-grained PATs for CI/CD](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md), [branch protection and required reviews](../GitHub/docs/branch-protection-and-required-reviews-for-ci.md)
  - _…and 4 more under `GitHub/docs/` — browse the folder._
- **snippets** (3): [issues API](../GitHub/snippets/github-issues-api.py), [list repos with Python](../GitHub/snippets/list-repos-with-python.py), [open a PR and wait for CI](../GitHub/snippets/open-pr-and-wait-for-ci.sh)
- **manifests** (1): [Environments deployment protection](../GitHub/manifests/github-environments-deployment-protection.yaml)
- **notebooks** (2): [org-wide Actions usage audit](../GitHub/notebooks/analyzing-github-actions-usage-across-org-repos.ipynb) — inventory repos, collect runs, summarise volume, failure rate, and repeat-failure jobs — plus [comparing API approaches to release automation](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb)
- **dockerfiles** (1): [self-hosted runner](../GitHub/dockerfiles/self-hosted-runner.Dockerfile)

## GitHub Actions  ·  25 files

- **primer:** [0000-primer-github-actions.md](../GitHub Actions/notes/0000-primer-github-actions.md)
- **notes** (5): most recent → [following the quickstart](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md), [primer-already-exists check](../GitHub Actions/notes/2026-07-13-primer-already-exists.md), [ci.yml reference](../GitHub Actions/notes/ci.yml)
  - _…and 2 more under `GitHub Actions/notes/` — browse the folder._
- **templates** (3): [multi-environment deploy](../GitHub Actions/templates/multi-env-deploy/README.md) — a caller workflow that builds once and promotes the same artifact through dev, staging, and production via a reusable deploy workflow — with [deploy-caller.yml](../GitHub Actions/templates/multi-env-deploy/deploy-caller.yml) and [reusable-deploy.yml](../GitHub Actions/templates/multi-env-deploy/reusable-deploy.yml)
- **configs** (5): most recent → [reusable deployment workflow with environment gates](../GitHub Actions/configs/reusable-deployment-workflow-environment-gates-approval.yaml), [matrix node workflow](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml), [hello workflow](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml)
  - _…and 2 more under `GitHub Actions/configs/` — browse the folder._
- **docs** (6): [OIDC with AWS](../GitHub Actions/docs/github-actions-oidc-with-aws.md) — short-lived workload identity instead of stored access keys — plus [composite actions vs reusable workflows](../GitHub Actions/docs/composite-actions-vs-reusable-workflows.md), [quickstart trip-ups](../GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md), [ci.yml reference](../GitHub Actions/docs/ci.yml), [test.yml reference](../GitHub Actions/docs/test.yml)
  - _…and 1 more under `GitHub Actions/docs/` — browse the folder._
- **scripts** (4): [manage Actions secrets across a repo fleet](../GitHub Actions/scripts/manage-secrets-across-repos.py) — `sync`, `list`, or `delete` repository-level secrets across a named set of repos, sealing every value against each repo's own public key and printing the whole plan before it writes — plus [self-hosted runner registration and cleanup](../GitHub Actions/scripts/self-hosted-runner-registration-cleanup.sh), [install the gh extension](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh), [list runs](../GitHub Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh)
- **dockerfiles** (1): [minimal custom runner image](../GitHub Actions/dockerfiles/custom-runner.Dockerfile) — pinned runner release downloaded at build time, registration from environment at container start
- **snippets** (1): [trigger a `workflow_dispatch` and poll status](../GitHub Actions/snippets/2026-08-15-trigger-workflow-dispatch-poll-status.py)

## GitLab CI  ·  14 files

- **primer:** [0000-primer-gitlab-ci-cd.md](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **notes** (4): most recent → [runner setup, variables, and artifacts trip-ups](../GitLab CI/notes/2026-09-19-gitlab-ci-runner-variables-artifacts.md), [following the quickstart](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md), [`.gitlab-ci.yml` reference](../GitLab CI/notes/.gitlab-ci.yml)
  - _1 more under `GitLab CI/notes/` — browse the folder._
- **configs** (4): most recent → [build → push → deploy with a digest-pinned rollout](../GitLab CI/configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml) — three stages, a `when: manual` production gate, and a deploy job that verifies health then rolls back — plus [multi-project pipeline with a downstream trigger](../GitLab CI/configs/2026-09-22-multi-project-pipeline-with-triggers.yaml), [stages, cache, and artifacts](../GitLab CI/configs/2026-09-20-minimal-pipeline-stages-cache-artifacts.yaml)
  - _1 more under `GitLab CI/configs/` — browse the folder._
- **docs** (1): [GitLab CI/CD with Kubernetes, end to end](../GitLab CI/docs/gitlab-ci-cd-with-kubernetes.md) — the setup around the deploy pipeline: a runner that can reach the cluster, the variable that hands the job a kubeconfig, and the gate that blocks an unapproved rollout
- **scripts** (5): [dynamic child pipeline scaffold](../GitLab CI/scripts/dynamic-child-pipeline.sh) — a parent pipeline that writes its child config at job time, hands it forward as an artifact, then triggers it — plus [local pipeline validator](../GitLab CI/scripts/2026-09-21-local-ci-pipeline-validator.sh), [install a runner and register](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh), [run a first local pipeline](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh), [gitlab pipeline helper](../GitLab CI/scripts/gitlab-pipeline-helper.py)
- **snippets** (1): [trigger a pipeline via the API and poll jobs](../GitLab CI/snippets/2026-09-20-trigger-pipeline-and-poll-jobs.sh)
- **dockerfiles** (1): [GitLab Runner with Docker-in-Docker and Kaniko](../GitLab CI/dockerfiles/gitlab-runner-dind-kaniko.Dockerfile) — Runner image that can build containers inside containers using Kaniko for rootless builds

## Grafana  ·  8 files

Folder on disk is `graf/`.

- **primer:** [0000-primer-grafana.md](../Grafana/notes/0000-primer-grafana.md)
- **notes** (4): most recent → [quickstart trip-ups, second pass](../Grafana/notes/2026-10-13-grafana-quickstart-trip-ups.md) — Docker localhost gotcha, legacy alerting page, first-evaluation delay — plus [quickstart trip-ups](../Grafana/notes/2026-09-29-grafana-quickstart-trip-ups.md) and [poking around the UI](../Grafana/notes/2026-09-25-explore-grafana-ui.md)
- **configs** (1): [minimal datasource and dashboard provisioning](../Grafana/configs/2026-10-13-minimal-datasource-dashboard-provisioning.yaml) — one Prometheus datasource plus one graph panel as files, picked up on start
- **scripts** (1): [install Grafana with Docker](../Grafana/scripts/2026-09-25-install-grafana-with-docker.sh) — runs `grafana/grafana` on port 3000 and waits for the login page
- **docs** (2): [navigation dedup note](../Grafana/docs/2026-09-25-grafana-navigation-dedup.md), [coverage and topics note](../Grafana/docs/2026-09-25-grafana-coverage-and-topics.md)

## Grafana Cloud  ·  6 files

Folder on disk is `grafc/`. First contact only — no primer yet.

- **notes** (2): most recent → [quickstart trip-ups](../Grafana%20Cloud/notes/2026-10-13-grafana-cloud-quickstart-trip-ups.md) — where the stack endpoint and agent token live, scrape interval ownership, remote-write path — plus [first hosted dashboard](../Grafana%20Cloud/notes/2026-09-30-first-hosted-dashboard.md)
- **configs** (2): most recent → [Prometheus remote-write config for Grafana Cloud](../Grafana%20Cloud/configs/2026-10-19-prometheus-remote-write-grafana-cloud.yaml) — minimal scrape config with a pass-through relabel rule forwarding metrics to Grafana Cloud via remote_write — plus [minimal metrics scrape config](../Grafana%20Cloud/configs/2026-09-30-minimal-metrics-scrape-config.yaml)
- **scripts** (1): [create Grafana Cloud stack and send metrics](../Grafana%20Cloud/scripts/2026-10-19-create-stack-and-send-metrics.py) — scripts the stack creation, grabs the endpoint and token, writes the agent config, and verifies metrics arrive
- **snippets** (1): [create a dashboard over the HTTP API](../Grafana%20Cloud/snippets/2026-09-30-first-dashboard-over-http.js) — posts a minimal dashboard JSON with a bearer token so a dashboard is defined as data rather than clicks
- _Remote write wiring, alerting rules, and a stack config in version control are ⏳._

## HashiCorp Vault  ·  8 files

Folder on disk is `vlt/`.

- **primer:** [0000-primer-vlt.md](../Vault/notes/0000-primer-vlt.md)
- **notes** (3): most recent → [dev-mode quickstart trip-ups](../Vault/notes/2026-10-07-vault-quickstart-trip-ups.md) — KV v2 versions instead of overwriting, `kv get` metadata wrapping, per-shell `VAULT_ADDR` — plus [exploring the Vault CLI](../Vault/notes/2026-09-19-explore-vault-cli-secrets-policies.md) and [0000-primer-vlt.md](../Vault/notes/0000-primer-vlt.md)
- **scripts** (4): most recent → [KV v2 write/read/list round-trip](../Vault/scripts/2026-10-07-write-read-list-kv-v2-secret.py) — hvac against a dev server, version 1 read back, version 2 created, versions listed — plus [install Vault and mount a first secrets engine](../Vault/scripts/2026-09-30-install-vault-and-first-secrets-engine.sh) and [install the CLI and start a dev server](../Vault/scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh), [dynamic database credentials with Vault engine](../Vault/scripts/dynamic-database-credentials.py)
- **configs** (1): [least-privilege read-only policy bound to a group](../Vault/configs/2026-10-07-minimal-read-only-policy-bound-to-group.hcl) — `read` on one KV v2 path and its metadata, with the group binding for token issuance
- **docs** (1): [how `vlt/` is reflected in the README and topic map](../Vault/docs/2026-09-19-vlt-readme-layout-and-coverage.md)

## Helm  ·  55 files

- **primer:** [0000-primer-helm.md](../Helm/notes/0000-primer-helm.md)
- **templates** (22): [reusable microservice chart](../Helm/templates/microservice-chart/README.md) — Deployment + Service + ConfigMap, optional Ingress/HPA/PDB, migration Job hook, `values.schema.json` guard, vendored PostgreSQL subchart — with [defaults](../Helm/templates/microservice-chart/values.yaml) and [chart metadata](../Helm/templates/microservice-chart/Chart.yaml)
- **scripts** (4): [validate values across envs](../Helm/scripts/validate-chart-values-across-environments.sh) — key checks plus a per-env render diff before promotion — plus [demo web service chart](../Helm/scripts/demo-web-service-chart.sh) and [install and explore the CLI](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh)
- _1 more under `Helm/scripts/` — browse the folder._
- **manifests** (14): a runnable [`demo-chart` fixture](../Helm/manifests/demo-chart/README.md) for the values-management walkthrough — Deployment + Service + optional Ingress with `values-common.yaml` baseline and staging/production overlays — plus a minimal [redis chart](../Helm/manifests/redis-chart/Chart.yaml) with [deployment](../Helm/manifests/redis-chart/templates/deployment.yaml) and [service](../Helm/manifests/redis-chart/templates/service.yaml) templates, plus [values](../Helm/manifests/redis-chart/values.yaml)
- **docs** (5): most recent → [chart testing with `ct lint`](../Helm/docs/chart-testing-ct-lint.md) — lint and install only the charts a branch touched, against the redis-chart example — plus [values management approaches](../Helm/docs/values-management-approaches.md) (`--set` vs per-environment files vs named templates), [adding Helm to the README](../Helm/docs/2026-07-25-add-helm-to-readme-layout-and-coverage.md) and [already documented](../Helm/docs/2026-07-25-helm-readme-already-documented.md)
- _1 more under `Helm/docs/` — browse the folder._
- **notes** (3): most recent → [quickstart trip-ups](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [0000-primer-helm.md](../Helm/notes/0000-primer-helm.md), [values.yaml reference](../Helm/notes/values.yaml)
- **configs** (5): most recent → [shared base values for multi-cluster GitOps](../Helm/configs/multi-cluster-gitops-values.yaml) — every setting identical on all clusters; per-cluster overlays supply `clusterName` and deltas — plus [live-release values](../Helm/configs/2026-09-02-live-release-values.yaml), [production-deployment values](../Helm/configs/2026-08-30-production-deployment-values.yaml)
- _…and 2 more under `Helm/configs/` — browse the folder._
- **snippets** (1): [nginx chart with custom values](../Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh)
- **notebooks** (1): [release lifecycle drill](../Helm/notebooks/release-lifecycle-drill.ipynb)

## Kubernetes  ·  61 files

- **primer:** [0000-primer-kubernetes.md](../Kubernetes/notes/0000-primer-kubernetes.md)
- **templates** (32): [Kubebuilder operator scaffold](../Kubernetes/templates/kubebuilder-operator-scaffold/README.md) — API types, controller, CRD bases, RBAC, manager and samples — plus [Helm chart + Kustomize overlay scaffold](../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/helm/Chart.yaml) — a chart (`Chart.yaml`, `values.yaml`, `templates/`) with `kustomize/base/` and `overlays/dev|prod/`
- **notes** (9): most recent → [kubectl and minikube, first pod](../Kubernetes/notes/2026-09-04-kubectl-minikube-first-pod.md), [what tripped me up](../Kubernetes/notes/2026-08-12-kubernetes-tutorial-what-tripped-me-up.md), [first pod from a manifest](../Kubernetes/notes/2026-07-19-first-kubectl-version-and-pod-from-manifest.md)
- _…and 6 more under `Kubernetes/notes/` — browse the folder._
- **manifests** (6): most recent → [Cluster API bootstrap](../Kubernetes/manifests/cluster-api-bootstrap.yaml) — namespace, DockerCluster, Cluster, and KubeadmControlPlane with a two-replica worker MachineDeployment — plus [production deployment with HPA, PDB, and NetworkPolicies](../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml), [Go service with probes and an HPA](../Kubernetes/manifests/go-service-deployment-with-probes-hpa.yaml), [stateless app](../Kubernetes/manifests/stateless-app.yaml)
- _…and 2 more under `Kubernetes/manifests/` — browse the folder._
- **docs** (5): most recent → [Gateway API migration from Ingress](../Kubernetes/docs/gateway-api-migration-from-ingress.md) — one path-based Ingress moved to a Gateway plus HTTPRoute pair, platform-owned listeners split from app-owned routes — plus [integrating with Prometheus](../Kubernetes/docs/integrating-kubernetes-with-prometheus.md), [ingress path-based routing](../Kubernetes/docs/ingress-path-based-routing.md)
- _…and 2 more under `Kubernetes/docs/` — browse the folder._
- **scripts** (4): most recent → [custom-resource reconciliation core](../Kubernetes/scripts/custom-resource-reconciliation-controller.go) — idempotent applies toward desired state with finalizer cleanup on delete, plus a runnable demo — plus [rollout status and pod readiness](../Kubernetes/scripts/rollout-status-and-pod-readiness.sh), [install kind and create a first cluster](../Kubernetes/scripts/install-kind-and-first-cluster.sh)
- _1 more under `Kubernetes/scripts/` — browse the folder._
- **notebooks** (2): [comparing workload types](../Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb), [workload types, newer pass](../Kubernetes/notebooks/2026-09-07-comparing-kubernetes-workload-types.ipynb)
- **snippets** (2): [first pod and service with kubectl](../Kubernetes/snippets/2026-09-18-first-pod-and-service-with-kubectl.sh), [pod troubleshooting shell](../Kubernetes/snippets/pod-troubleshoot-shell.sh)
- **configs** (1): [Deployment and Service for a Go app with probes](../Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml)

## OpenTelemetry  ·  10 files

Folder on disk is `otel/`.

- **primer:** [0000-primer-opentelemetry.md](../OpenTelemetry/notes/0000-primer-opentelemetry.md) — traces, spans, context propagation, exporters, and where the collector sits
- **notes** (2): [quickstart trip-ups](../OpenTelemetry/notes/2026-09-30-quickstart-trip-ups.md) — the 4317-vs-4318 mix-up, pipeline order, reading the noisy log output — plus [0000-primer-opentelemetry.md](../OpenTelemetry/notes/0000-primer-opentelemetry.md)
- **docs** (2): most recent → [context propagation: W3C tracecontext vs B3](../OpenTelemetry/docs/context-propagation-w3c-vs-b3.md) — what breaks when the format is mismatched or dropped between hops — plus [how `otel/` is reflected in the README and topic map](../OpenTelemetry/docs/2026-09-25-opentelemetry-readme-coverage.md)
- **configs** (2): most recent → [real Collector pipeline](../OpenTelemetry/configs/collector-otlp-real-pipeline.yaml) — OTLP in, memory_limiter and batch processors, Prometheus and OTLP out — plus [minimal OTLP export config](../OpenTelemetry/configs/2026-09-30-collector-otlp-export.yaml) — OTLP in, one batch step, log out
- **scripts** (2): most recent → [custom span processor and resource detector](../OpenTelemetry/scripts/custom-span-processor-resource-detector.py) — stamps app attributes onto every span and batch-exports to an OTLP endpoint — plus [install a collector and run the OTLP pipeline](../OpenTelemetry/scripts/2026-09-26-install-collector-and-run-otlp-pipeline.sh) — brings up `otel/opentelemetry-collector-contrib` on 4317/4318, emits one span, and tails the collector log
- **snippets** (2): [instrumented Go HTTP server](../OpenTelemetry/snippets/2026-09-30-instrumented-http-server.go) — one span per request plus a per-path counter — plus [first trace span](../OpenTelemetry/snippets/2026-09-26-first-trace-span.py)

## OpenTofu  ·  19 files

- **primer:** [0000-primer-opentofu.md](../OpenTofu/notes/0000-primer-opentofu.md)
- **templates** (6): [reusable AWS VPC module](../OpenTofu/templates/aws-reusable-module/README.md) — VPC with public/private subnets, internet gateway, count-gated NAT gateways, referencing outputs, and an [`examples/basic/` caller](../OpenTofu/templates/aws-reusable-module/examples/basic/main.tf)
- **docs** (4): most recent → [custom provider development](../OpenTofu/docs/opentofu-provider-development-custom-provider.md) — scaffold with the plugin framework, provider schema, resources, data sources, build and test — plus [S3 backend with workspace isolation](../OpenTofu/docs/remote-state-s3-backend-workspace-isolation.md) — shared state per environment with locking — plus [state management tutorial notes](../OpenTofu/docs/2026-08-25-state-management-tutorial-notes.md) covering `state list/mv/pull` and backend migration
- **notes** (2): most recent → [quickstart trip-ups](../OpenTofu/notes/2026-08-21-opentofu-quickstart-trip-ups.md), [0000-primer-opentofu.md](../OpenTofu/notes/0000-primer-opentofu.md)
- **scripts** (3): [plan/apply wrapper with policy checks](../OpenTofu/scripts/tofu-plan-apply-with-policy-checks.sh) — init, validate, plan, policy gate, then apply — plus [S3 + DynamoDB remote-state bootstrap](../OpenTofu/scripts/s3-dynamodb-remote-state-bootstrap.sh) and [install and verify](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- **configs** (2): [minimal local config](../OpenTofu/configs/2026-07-18-minimal-local-config.tf), [minimal local backend](../OpenTofu/configs/2026-08-25-minimal-local-backend.hcl)
- **notebooks** (2): [state management with OpenTofu and Terraform](../OpenTofu/notebooks/comparing-opentofu-and-terraform-state-management.ipynb) — local/remote schema parity, S3 backend equivalence, copy-and-replan migration — plus [OpenTofu vs Terraform for AWS provisioning](../OpenTofu/notebooks/comparing-opentofu-and-terraform-aws-provisioning.ipynb)

## Prometheus  ·  23 files

- **primer:** [0000-primer-prometheus.md](../Prometheus/notes/0000-primer-prometheus.md)
- **notes** (2): most recent → [getting-started trip-ups](../Prometheus/notes/2026-09-05-prometheus-getting-started-trip-ups.md), [0000-primer-prometheus.md](../Prometheus/notes/0000-primer-prometheus.md)
- **configs** (4): most recent → [production Prometheus config](../Prometheus/configs/production-prometheus.yml) — full scrape, rule, and alerting setup — plus [recording rules vs alerting rules](../Prometheus/configs/recording-vs-alerting-rules.yaml), [container monitoring config](../Prometheus/configs/2026-09-05-minimal-container-monitoring-config.yml), [minimal scrape config](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml)
- **docs** (2): most recent → [Prometheus + Kubernetes integration](../Prometheus/docs/prometheus-kubernetes-integration.md) — service discovery, RBAC, and workload annotations so Prometheus automatically tracks cluster targets — plus [Alertmanager wired to PagerDuty](../Prometheus/docs/alertmanager-pagerduty-oncall-rotations.md)
- **scripts** (4): most recent → [custom metrics collector (Go)](../Prometheus/scripts/custom-app-metrics-collector.go) — a `/metrics` endpoint with counter, gauge, and histogram built from the standard library — plus [custom application exporter (Python)](../Prometheus/scripts/custom-app-exporter.py), [custom metrics service (Python)](../Prometheus/scripts/custom-metrics-service.py), [install and verify metrics endpoint](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh)
- **snippets** (1): [PromQL target health check](../Prometheus/snippets/2026-09-05-promql-target-health-check.sh)
- **templates** (1): [Prometheus + Alertmanager + Grafana stack](../Prometheus/templates/prometheus-alertmanager-grafana-stack/README.md) — docker-compose stack with preconfigured datasources, dashboards, alerting and recording rules, and a default notification template

## Pulumi  ·  10 files

Folder on disk is `plm/`.

- **primer:** [0000-primer-plm.md](../Pulumi/notes/0000-primer-plm.md)
- **notes** (2): [quickstart trip-ups](../Pulumi/notes/2026-09-30-pulumi-quickstart-trip-ups.md) — provider plugins, stack config files, local state defaults, and destroy semantics — plus [0000-primer-plm.md](../Pulumi/notes/0000-primer-plm.md)
- **docs** (2): most recent → [multi-stack project structure](../Pulumi/docs/multi-stack-project-structure.md) — dev/staging/prod stacks under `stacks/`, a shared Network component, and cross-stack wiring with StackReference — plus [how `plm/` is reflected in the README and topic map](../Pulumi/docs/2026-09-20-plm-readme-layout-and-coverage.md)
- **configs** (2): most recent → [minimal project and stack config](../Pulumi/configs/minimal-project-and-stack-config.yaml) — the `Pulumi.yaml` shape plus dev and prod stack configs with config namespaces and an encrypted secret — plus [minimal project and dev stack config](../Pulumi/configs/2026-09-30-minimal-pulumi-project-and-stack-config.yaml) — the `Pulumi.yaml` shape plus a `Pulumi.dev.yaml` with region and bucket name
- **scripts** (3): most recent → [reusable Network component](../Pulumi/scripts/network-component-vpc-subnets.py) — a VPC with public and private subnets, an Internet Gateway, and a NAT Gateway, exported as a runnable Python stack — plus [create an S3 bucket with Pulumi Python](../Pulumi/scripts/2026-09-30-create-s3-bucket-with-pulumi.py) — the runnable one-bucket program with name and ARN exports — plus [install the CLI and init a project](../Pulumi/scripts/2026-09-19-install-pulumi-cli-and-init-project.sh)
- **snippets** (1): [minimal bucket with Pulumi Python](../Pulumi/snippets/2026-09-19-minimal-bucket-with-pulumi-python.py)

## Terraform  ·  56 files

- **primer:** [0000-primer-terraform.md](../Terraform/notes/0000-primer-terraform.md)
- **templates** (25): [multi-environment workspaces + remote state scaffold](../Terraform/templates/multi-environment-terraform-workspaces-remote-state/README.md) — one configuration for dev and prod with workspace-scoped S3 and DynamoDB backends — plus [module registry publishing workflow](../Terraform/templates/terraform-module-registry-publishing/README.md) — complete module structure with CI/CD pipeline that validates, tests, and publishes on version tags
  - _…and 22 more under `Terraform/templates/` — browse the folder._
- **configs** (9): [provider schema contract](../Terraform/configs/provider-schema-contract.json) — required arguments and attributes declared as JSON for the validation CLI — plus [reusable S3 module](../Terraform/configs/reusable-s3-module/README.md), [local_file plus random_pet](../Terraform/configs/2026-09-19-local-file-random-provider.hcl), [local_file resource](../Terraform/configs/local-file.tf)
  - _…and 5 more under `Terraform/configs/` — browse the folder._
- **notes** (6): most recent → [install and a first local file](../Terraform/notes/2026-09-03-install-terraform-and-first-local-file.md), [state management tutorial](../Terraform/notes/2026-08-12-terraform-state-management-tutorial.md), [following the provider tutorial](../Terraform/notes/2026-06-24-following-provider-tutorial.md)
- _…and 3 more under `Terraform/notes/` — browse the folder._
- **docs** (6): most recent → [testing strategies with tflint and Terratest](../Terraform/docs/terraform-testing-strategies-tflint-terratest.md) — five layers from `fmt`/`validate` through tflint, native `.tftest.hcl` contracts, and Terratest to plan-artifact checks in CI — plus [1.9 migration guide](../Terraform/docs/terraform-1-9-migration-guide.md) — one environment at a time, plan diff as changelog, state backup behind every step — plus [wiring outputs into dependent modules](../Terraform/docs/wiring-terraform-outputs-into-dependent-modules.md), [workspaces and remote state locking](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md), [the earlier pass](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md)
- _1 more under `Terraform/docs/` — browse the folder._
- **scripts** (4): [validate a provider schema against a contract](../Terraform/scripts/validate-provider-schema.go) — Go CLI that checks `terraform providers schema -json` against the hand-written contract — plus [generate an Ansible inventory from Terraform state](../Terraform/scripts/generate-ansible-inventory-from-terraform-state.py), [bootstrap a project scaffold](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh), [install and init](../Terraform/scripts/install-and-init.sh)
- **snippets** (3): most recent → [explore the CLI](../Terraform/snippets/2026-09-04-terraform-cli-exploration.sh), [scaffold an S3 module with remote state](../Terraform/snippets/2026-08-17-scaffold-s3-bucket-module-remote-state.sh), [for_each and validation pattern](../Terraform/snippets/reusable-module-for-each-validation.hcl)
- **notebooks** (2): [Terraform vs OpenTofu](../Terraform/notebooks/comparing-terraform-vs-opentofu.ipynb), [for_each vs count](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **manifests** (2): [reusable VPC module](../Terraform/manifests/reusable-vpc-module.hcl) — public and private subnets across AZs, IGW, optional NAT gateways — plus [simple EC2 app](../Terraform/manifests/simple-ec2-app.tf)

## Trivy  ·  17 files

- **primer:** [0000-primer-trivy.md](../Trivy/notes/0000-primer-trivy.md)
- **notes** (5): most recent → [quickstart follow-along](../Trivy/notes/2026-09-02-trivy-quickstart-follow-along.md), [quickstart trip-ups (latest)](../Trivy/notes/2026-08-29-trivy-quickstart-trip-ups.md), [quickstart trip-ups](../Trivy/notes/2026-08-14-trivy-quickstart-trip-ups.md)
- _…and 2 more under `Trivy/notes/` — browse the folder._
- **scripts** (5): most recent → [policy-as-code with OPA/Rego](../Trivy/scripts/trivy-policy-as-code-opa-rego.sh) — write custom Rego policies, bundle them, and scan images and manifests against them with a severity-filtered summary — plus [repo scan workflow with SARIF output](../Trivy/scripts/trivy-fs-repo-scan-workflow.sh), [install and scan a filesystem](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh), [first container image scan](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh), [batch image scanning](../Trivy/scripts/scan-images-from-file-consolidated-sarif.sh)
- **snippets** (2): most recent → [scan an image and fail on critical CVEs](../Trivy/snippets/2026-08-16-scan-image-fail-critical-cves.py), [a Python wrapper](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)
- **configs** (3): most recent → [admission control configuration](../Trivy/configs/trivy-operator-admission-control.yaml) — configure the Trivy Operator to block or warn on vulnerabilities and misconfigurations — plus [config with scan policies](../Trivy/configs/2026-08-27-trivy-config-with-scan-policies.yaml), [config with severity filtering](../Trivy/configs/2026-08-12-trivy-config.yaml)
- **docs** (2): most recent → [SBOM generation and vulnerability reporting](../Trivy/docs/trivy-sbom-generation-and-vulnerability-reporting.md) — generate CycloneDX/SPDX SBOMs and machine-readable vulnerability reports — plus [choosing scan modes and pipeline wiring](../Trivy/docs/choosing-scan-modes-and-pipeline-wiring.md) — image vs fs vs repo vs sbom, and blocking a bad artifact in CI

## Jenkins  ·  1 file

Folder on disk is `jnk/`.

- **primer:** [0000-primer-jenkins.md](../Jenkins/notes/0000-primer-jenkins.md) — core concepts, pipeline syntax, agents, and common patterns

## Foundational Concepts  ·  71 files

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

## docs/audit  ·  6 files

Coverage and README audits that keep the index files honest against what is on disk. Browse `docs/audit/`.

- [audit-013: repo audit — counts, links, dates](../docs/audit/2026-10-10-repo-audit-013.md)
- [audit-012: Docker Dockerfile count](../docs/audit/2026-09-07-audit-012-docker-dockerfile-count.md)
- [audit-011: OpenTofu README](../docs/audit/2026-08-20-audit-011-opentofu-readme.md)
- [audit-009: GitHub README](../docs/audit/2026-08-20-audit-009-github-readme.md)
- [coverage-table audit](../docs/audit/2026-08-18-coverage-table-audit.md)
