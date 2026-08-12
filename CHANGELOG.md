# Changelog

## 2026-08-12

- Added AWS EC2 and S3 listing snippet (aws-009) (`AWS/snippets/2026-08-12-list-ec2-and-s3.sh`)
- Added Ansible handlers and templates tutorial trip-up notes (ans-018) (`Ansible/notes/2026-08-12-ansible-handlers-and-templates-tutorial.md`)
- Added Kubernetes tutorial trip-up notes (k8s-011) (`Kubernetes/notes/2026-08-12-kubernetes-tutorial-what-tripped-me-up.md`)
- Added Terraform state management tutorial trip-up notes (tf-015) (`Terraform/notes/2026-08-12-terraform-state-management-tutorial.md`)
- Reworked doc-019 to canonical dir: notes on the official Docker Get Started tutorial and what tripped me up (`Docker/notes/2026-08-12-docker-tutorial-tripups.md`)
- Reworked doc-020 to canonical dir: Python script that builds, runs, then cleans down a Docker container and image (`Docker/snippets/2026-08-12-build-run-and-cleanup.py`)
- Reworked trv-008 to canonical dir: Trivy config with severity filters and scan policies (`Trivy/configs/2026-08-12-trivy-config.yaml`)
- Added Kubernetes Deployment and Service manifest for a Go app with liveness and readiness probes (k8s-012) (`Kubernetes/configs/2026-08-12-deployment-service-go-app-with-probes.yaml`)
- Added Python snippet wrapping ansible-lint to lint playbooks and check best practices (ans-019) (`Ansible/snippets/2026-08-12-lint-ansible-playbook.py`)

## 2026-08-11

- Added notes on the official Git branching tutorial and what tripped me up (git-010) (`git/notes/2026-08-11-git-branching-tutorial.md`)
- Added notebook exercising Bash/Python glue patterns: parsing, looping, error handling (con-046) (`docs/concepts/scripting-automation-bash-python/notebooks/2026-08-11-bash-python-glue-patterns.ipynb`)
- Passed ([x]) con-057 — Linux & System Administration: notebook — Pattern: Linux system performance analysis combining /proc, cgroups, and systemd-cgtop · Level: L3 · 2026-08-11
- Added notebook exercising metrics/logs/traces mental model by scraping a local service's /metrics endpoint with trace_id correlation (con-056) (`docs/concepts/monitoring-observability-concepts/notebooks/2026-08-11-scraping-endpoint-three-pillars.ipynb`)
- Added notebook for Linux system performance analysis combining /proc, cgroups, and systemd-cgtop (con-057) (`docs/concepts/linux-system-administration/notebooks/linux-system-performance-analysis.ipynb`)
- Added declarative guestbook ApplicationSet manifest using a list generator (arg-005) (`ArgoCD/configs/2026-08-11-guestbook-applicationset.yaml`)
- Added ArgoCD quickstart follow-along notes (arg-004) (`ArgoCD/notes/2026-08-11-argocd-quickstart.md`)

## 2026-08-10

- Added docs combining CI/CD with artifact promotion gates and environment-based rollbacks (con-049) (`docs/concepts/ci-cd-concepts/2026-08-10-artifact-promotion-gates-rollbacks.md`)
- Added docs on combining CI/CD concepts with artifact promotion and environment-based rollbacks (con-059) (`docs/concepts/ci-cd-concepts/docs/artifact-promotion-environment-rollbacks.md`)
- Added systemd-managed service with health check and log alerting script (con-060) (`docs/concepts/linux-system-administration/scripts/systemd-health-check-log-alerting.sh`)
- Added notebook tracing a request through DNS resolution, TLS handshake, and load-balanced routing for a service (con-043) (`docs/concepts/networking-fundamentals/notebooks/2026-08-10-dns-tls-load-balancing-visualization.ipynb`)

## 2026-08-09

- Added docs on combining metrics, logs, and traces into a single service observability story, with trace_id correlation and sampling/cardinality gotchas (con-055) (`docs/concepts/monitoring-observability-concepts/docs/2026-08-09-combining-metrics-logs-traces-observability.md`)

## 2026-08-08

- Added scripted TCP/TLS health probes and latency checks using curl, openssl, and nc (con-044) (`docs/concepts/networking-fundamentals/scripts/2026-08-08-tcp-tls-health-probes.sh`)
- Added Python retry, backoff, and structured-logging helper snippet (con-045) (`docs/concepts/scripting-automation-bash-python/snippets/2026-08-08-retry-backoff-logging.py`)
- Added Git feature-branch workflow sandbox script demonstrating rebase, merge, and tag (con-047) (`docs/concepts/version-control-concepts/scripts/2026-08-08-git-feature-branch-rebase-merge-tag.sh`)
- Added Python snippet that parses git log into a structured changelog from conventional commits (con-048) (`docs/concepts/version-control-concepts/snippets/2026-08-08-conventional-changelog-from-git-log.py`)
- Added parallelized, cached CI stage runner bash snippet with failure reporting (con-050) (`docs/concepts/ci-cd-concepts/snippets/2026-08-08-parallelized-ci-stage-runner.sh`)
- Added docs comparing Terraform and Ansible division of responsibility in a provision-then-configure model (con-051) (`docs/concepts/infrastructure-as-code-concepts/docs/2026-08-08-terraform-ansible-division-of-responsibility.md`)
- Added notebook comparing declarative vs imperative IaC on a local Docker sandbox (con-052) (`docs/concepts/infrastructure-as-code-concepts/notebooks/2026-08-08-declarative-vs-imperative-iac.ipynb`)
- Added docs on combining base-image selection, layer caching, and minimal runtimes for smaller images (con-053) (`docs/concepts/containerization-concepts/docs/2026-08-08-smaller-images-base-caching-runtimes.md`)
- Added Python snippet to inspect Docker image layers and report size by instruction (con-054) (`docs/concepts/containerization-concepts/snippets/2026-08-08-inspect-image-layers.py`)

## 2026-08-07

- Added GitHub Actions quickstart trip-up docs (ga-007) (`GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md`)
- Added GitHub Actions matrix Node.js CI workflow config (ga-008) (`GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml`)
- Added Helm quickstart trip-up notes (hlm-004) (`Helm/notes/2026-08-07-helm-quickstart-tripups.md`)
- Added Networking Fundamentals troubleshooting notes (con-014) (`docs/concepts/networking-fundamentals/notes/2026-08-07-network-troubleshooting-patterns.md`)
- Added Bash scripting exercises script (con-015) (`docs/concepts/scripting-automation-bash-python/scripts/2026-08-07-bash-scripting-exercises.sh`)
- Added Python log parsing and filtering snippet (con-016) (`docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py`)
- Added systemd timers with journald log shipping docs for audit-ready DevOps workflows (con-041) (`docs/concepts/linux-system-administration/docs/systemd-timers-journald-shipping.md`)
- Added systemd-managed watchdog script that restarts failed services and escalates to journald CRITICAL alerts (con-042) (`docs/concepts/linux-system-administration/scripts/systemd-watchdog-restart-and-page.sh`)

## 2026-08-05

- Added Go microservice project scaffold template with multi-stage Dockerfile, Makefile, .dockerignore, go.mod, main.go, and README (doc-015) (`Docker/templates/go-microservice/`)
- Added production-ready Go HTTP server Dockerfile with non-root user, HEALTHCHECK, and layer caching (doc-016) (`Docker/dockerfiles/production-ready-go-http-server.Dockerfile`)

## 2026-08-04

Passed ([x]) k8s-010 — Kubernetes: notebook — Comparing Kubernetes workload types: Deployments, StatefulSets, DaemonSets, and Jobs · Level: L3 · 2026-08-04
Passed ([x]) gh-017 — GitHub: notebook — Comparing GitHub API approaches: REST vs GraphQL vs CLI for release automation · Level: L3 · 2026-08-05
- Added notebook comparing GitHub API approaches for release automation: REST, GraphQL, and CLI methods (gh-017) (`GitHub/notebooks/comparing-api-approaches-release-automation.ipynb`)
Passed ([x]) con-009 — CI/CD Concepts: script — Practice: Build a simulated CI/CD pipeline with Bash — build, test, deploy stages · Level: L2 · 2026-08-04
- Added CI/CD common patterns bash snippet demonstrating artifact promotion, rollback triggers, and deployment gates (con-010) (`docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh`)
- Documented `git/` folder in README Layout and Coverage table, noting the merge-strategies notebook and scaffold template (git-013) (`git/docs/2026-08-04-git-folder-readme-coverage.md`)
- Reworked git-008 template: corrected directory case to `git/` (lowercase) to match `git-` prefix convention, removed unverifiable claims (Git version 2.28, release-please-action@v4, @commitlint/config-conventional, release-please schema URL) not backed by research.md (`git/templates/git-repo-scaffold/`)
- Added notebook comparing Kubernetes workload types: Deployments, StatefulSets, DaemonSets, and Jobs (k8s-010) (`Kubernetes/notebooks/comparing-kubernetes-workload-types.ipynb`)
- Added simulated CI/CD pipeline script with build, test, and deploy stages (con-009) (`docs/concepts/ci-cd-concepts/scripts/2026-08-04-simulated-cicd-pipeline.sh`)
- Added multi-stage Go Docker build script with layer caching and .dockerignore (doc-021) (`Docker/scripts/multi-stage-go-dockerfile.sh`)
- Added Python image layer analyzer for Docker optimization (doc-022) (`Docker/snippets/analyze-image-layers.py`)

## 2026-08-03

- Added docs on automating git bisect with scripted regression tests for CI and local development (git-009) (`git/docs/automating-git-bisect-with-scripted-regression-tests.md`)

## 2026-08-02

- Added Git repository scaffold template with conventional commits, hooks, and release-please automation (git-008) (`git/templates/git-repo-scaffold/`)

## 2026-08-01

- Added Git repository scaffold template with conventional commits, hooks, and release-please automation (git-008) (`Git/templates/git-repository-skeleton/`)
- Added Git notebook comparing merge commit, rebase, squash, and cherry-pick strategies across branch topologies (git-007) (`Git/notebooks/comparing-git-merge-strategies.ipynb`)
## 2026-08-01

- Added Git notebook comparing merge commit, rebase, squash, and cherry-pick strategies across branch topologies (git-007) (`git/notebooks/comparing-git-merge-strategies.ipynb`)

## 2026-07-30

- Added Docker-based Ansible control node Dockerfile with version-pinned ansible-core and collections (ans-016) (`Ansible/dockerfiles/ansible-control-node.Dockerfile`)
- Updated git-012 docs front-matter `last_verified` date to 2026-07-30

## 2026-07-28

- Added git hooks template files under `Git/templates/git-hooks/` (pre-push, pre-rebase, post-commit) for git-011

- Added git worktrees docs for parallel feature development setup, workflow, and gotchas (git-012) (`Git/docs/git-worktrees-parallel-feature-development-setup-workflow-gotchas.md`)

Passed ([x]) ans-015 — Ansible: config — Ansible collection requirements and Docker lifecycle playbook · Level: L4 · 2026-07-28

- Reworked ans-015 config(yaml) artifact: expanded Ansible collection requirements and Docker lifecycle playbook configuration with version-pinned collections, environment variables, volumes, networks, and health check settings (`Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml`)

- Fixed ans-015 config(yaml) artifact: removed YAML front-matter from `Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml`, replaced with comment-based front-matter per config artifact standards
- Added Ansible over Terraform local-exec for post-provisioning tasks docs (ans-017) (`Ansible/docs/ansible-over-terraform-local-exec.md`)

## 2026-07-25

- Added Docker-based Ansible control node Dockerfile with version-pinned ansible-core and collections (ans-016) (`Ansible/dockerfiles/ansible-control-node.Dockerfile`)
- Added Ansible collection requirements file and Docker lifecycle management playbook (ans-015) (`Ansible/configs/collection-requirements.yml`, `Ansible/configs/docker-lifecycle-playbook.yml`)

## 2026-07-23

- Added Prometheus install and verify /metrics endpoint script (pro-002) (`Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh`)
- Added minimal Prometheus scrape config (pro-003) (`Prometheus/configs/2026-07-23-minimal-scrape-config.yml`)
- Added Prometheus quick primer (pro-001) (`Prometheus/notes/0000-primer-prometheus.md`)
- Corrected README Coverage table counts and added Prometheus scripts/configs entries (audit-007)
- Passed ([x]) pro-002 — Prometheus: script — Install Prometheus and verify the /metrics endpoint responds · Level: L1 · 2026-07-23
- Passed ([x]) pro-003 — Prometheus: config — Write a minimal prometheus.yml scrape config and start Prometheus · Level: L1 · 2026-07-23
- Passed ([x]) arg-002 — ArgoCD: script — Install ArgoCD on kind/minikube and access the web UI · Level: L1 · 2026-07-23
- Passed ([x]) arg-003 — ArgoCD: config — Create my first Application manifest and sync it via the ArgoCD UI · Level: L1 · 2026-07-23
- Passed ([x]) pro-001 — Prometheus: notes — What is Prometheus? — quick primer · Level: L1 · 2026-07-23

## 2026-07-22

- Verified Helm/ already documented in README Layout and Coverage table (hlm-006) (`Helm/docs/2026-07-22-helm-added-to-readme.md`)
- Reworked hlm-001: removed forbidden Rollback references and trimmed primer to ≤300 words (`Helm/notes/0000-primer-helm.md`)
- Added Helm quick primer (hlm-001) (`Helm/notes/0000-primer-helm.md`)
- Added Kubernetes ingress path-based routing docs (k8s-008) (`Kubernetes/docs/ingress-path-based-routing.md`)
- Added Kubernetes pod troubleshooting shell function snippet (k8s-009) (`Kubernetes/snippets/pod-troubleshoot-shell.sh`)
- Passed ([x]) k8s-008 — Kubernetes: docs — How I wired Kubernetes ingress to expose multiple services with path-based routing · Level: L3 · 2026-07-22
- Passed ([x]) k8s-009 — Kubernetes: snippet — Pod troubleshooting shell function: logs, describe, exec, port-forward in one call · Level: L3 · 2026-07-22

## 2026-07-21

- Added Kubernetes Deployment + Service manifest with probes, limits, and rolling update (k8s-007) (`Kubernetes/manifests/deployment-service-with-probes-limits.yaml`)
- Added Monitoring & Observability Concepts quick primer (con-008) (`docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md`)
- Added undocumented Kubernetes files to README Quick links and corrected Coverage table manifest count (audit-006) (`docs/2026-07-21-kubernetes-readme-tree-update.md`)

## 2026-07-20

- Added Version Control Concepts quick primer (con-004) (`docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md`)
- Added Infrastructure as Code Concepts quick primer (con-006) (`docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md`)
- Added Containerization Concepts quick primer (con-007) (`docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md`)

## 2026-07-19

- Added Python script to scan Ansible playbooks for antipatterns (command/shell overuse, missing become, unquoted vars) (ans-013) (`Ansible/scripts/scan-ansible-antipatterns.py`)
- Verified Ansible notebooks already documented in README Layout and Coverage table (audit-005) (`docs/2026-07-19-ansible-notebooks-readme-verified.md`)
- Added Ansible playbook to provision Nginx, PHP-FPM, and UFW on Ubuntu (ans-012) (`Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml`, `Ansible/templates/nginx-default.conf.j2`)
- Verified README coverage for Ansible/docs/ and General/docs/ target files (audit-004) (`docs/2026-07-19-audit-004-check.md`)
- Added Ansible install and module exploration script (ans-007) (`Ansible/scripts/2026-07-19-install-ansible-and-explore-modules.sh`)
- Added first inventory and ping playbook config (ans-008) (`Ansible/configs/2026-07-19-first-inventory-and-ping-playbook.yaml`)
- Added kubectl version and first Pod from manifest notes (k8s-006) (`Kubernetes/notes/2026-07-19-first-kubectl-version-and-pod-from-manifest.md`)

## 2026-07-18

- Added OpenTofu quick primer (ot-001) (`OpenTofu/notes/0000-primer-opentofu.md`)
- Added OpenTofu install and verify script (ot-002) (`OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh`)
- Added minimal OpenTofu local-provider config with variables and outputs (ot-003) (`OpenTofu/configs/2026-07-18-minimal-local-config.tf`)
- Added Linux filesystem permissions and process management practice script (con-011) (`docs/concepts/linux-system-administration/2026-07-18-filesystem-permissions-and-process-management.sh`)
- Added Linux process and file permission patterns in DevOps notes (con-012) (`docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md`)
- Added network connectivity and port testing practice script with curl and netcat (con-013) (`docs/concepts/networking-fundamentals/2026-07-18-netcat-and-curl-connectivity.sh`)

## 2026-07-17

- Reworked GCP primer: rewrote in personal learner voice with experiential framing (gcp-001 rework-3) (`GCP/notes/0000-primer-gcp.md`)

## 2026-07-14

- Added Google Cloud SDK quick primer (gcp-001) (`GCP/notes/0000-primer-gcp.md`)
- Reworked gcp-001: removed forbidden "production" term from primer (rework-1) (`GCP/notes/0000-primer-gcp.md`)
- Added gcloud CLI install and ADC configuration script (gcp-002) (`GCP/scripts/2026-07-16-install-gcloud-cli-and-configure-creds.sh`)
- Added GCE instances and GCS buckets listing snippet (gcp-003) (`GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh`)

## 2026-07-16

- Reworked GCP primer: rewrote in L1 first-person scratchy voice (gcp-001 rework-2) (`GCP/notes/0000-primer-gcp.md`)

## 2026-07-13

- Added Azure CLI quick primer (az-001) (`Azure/notes/0000-primer-azure.md`)
- Added Azure CLI install and login script (az-002) (`Azure/scripts/2026-07-13-install-azure-cli-and-login.sh`)
- Added Azure CLI resource group and region snippet (az-003) (`Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh`)
- Flagged GitHub Actions primer already exists (ga-001) (`GitHub Actions/notes/2026-07-13-primer-already-exists.md`)
- Added gh Actions extension install and workflow listing script (ga-002) (`GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh`)
- Added first CI workflow that prints "Hello from Actions" on push (ga-003) (`GitHub Actions/configs/2026-07-13-hello-workflow.yaml`)
- Flagged AWS primer already exists (aws-001) (`AWS/notes/2026-07-13-primer-already-exists.md`)
- Added AWS CLI v2 install and configure script (aws-002) (`AWS/scripts/2026-07-13-install-aws-cli-v2-and-configure.sh`)
- Added minimal AWS config with named profiles (aws-003) (`AWS/configs/2026-07-13-minimal-aws-config.ini`)

## 2026-07-12

- Added Linux & System Administration concept primer (con-001) (`docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md`)
- Added Networking Fundamentals concept primer (con-002) (`docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md`)
- Added Scripting & Automation (Bash/Python) concept primer (con-003) (`docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md`)
- Added Trivy quick primer (trv-001) (`Trivy/notes/0000-primer-trivy.md`)
- Added Trivy install and filesystem scan script (trv-002) (`Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh`)
- Added Python wrapper that runs Trivy and parses JSON output (trv-003) (`Trivy/snippets/2026-07-12-trivy-python-wrapper.py`)
- Added AWS CLI quick primer (aws-001) (`AWS/notes/0000-primer-aws.md`)
- Added AWS CLI v2 install and configure script (aws-002) (`AWS/scripts/2026-07-12-install-aws-cli-v2-and-configure.sh`)
- Added minimal AWS config with named profiles (aws-003) (`AWS/configs/2026-07-12-minimal-aws-config.ini`)

## 2026-07-11

- Added GitHub Actions primer (ga-001) (`GitHub Actions/notes/0000-primer-github-actions.md`)
- Added gh Actions extension install and run listing script (ga-002) (`GitHub Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh`)
- Added first CI workflow that prints "Hello from Actions" on push (ga-003) (`GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml`)
- Removed dead CHANGELOG references to `General/docs/*.md` files that no longer exist (audit-008) (`docs/2026-07-11-removed-dead-general-references.md`)

## 2026-07-08

- Added stale issue/PR automation config for .github repository (gh-012) (`GitHub/configs/dot-github-repository/stale.yml`)

## 2026-07-06

- Fixed gh-011 docs artifact: added YAML front-matter, removed non-backed citation URLs (`GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md`)

## 2026-07-04

- Added GitHub issue forms and label automation configs for .github repository (gh-012) (`GitHub/configs/dot-github-repository/`)

## 2026-07-01

- Added Terraform workspaces and remote state locking with S3 + DynamoDB docs (tf-013) (`Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md`)

## 2026-07-02

- Added Terraform notebook comparing for_each vs count for conditional resource creation (tf-014) (`Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb`)

## 2026-06-29

- Added Terraform workspaces + remote state locking with S3 and DynamoDB docs (tf-013) (`Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md`)
- Added Go HTTP server + Redis docker-compose manifest with health checks and custom networks (doc-012) (`Docker/manifests/2026-06-28-go-redis-compose-healthchecks.yaml`)

## 2026-06-28

- Added lifecycle rules to reusable S3 module (tf-012) — expiration, transition, noncurrent version handling, multipart upload cleanup (`Terraform/configs/reusable-s3-module/`)
- Added repo provisioning script with branch protection and collaborator management (gh-010) (`GitHub/scripts/provision-repo-with-api.py`)
- Added deploy keys vs fine-grained PATs for CI/CD access docs (gh-011) (`GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md`)
## 2026-06-27

- Reworked Docker build --mount vs COPY docs with L3 transitional voice (doc-011 rework) (`Docker/docs/docker-build-mount-vs-copy-caching.md`)

## 2026-06-26

- Added Trivy container image scan with JSON parsing script (trv-005) (`Trivy/scripts/2026-06-26-scanned-first-container-image.sh`)
- Added Docker build --mount vs COPY for dependency caching docs (doc-011) (`Docker/docs/docker-build-mount-vs-copy-caching.md`)

## 2026-06-25

- Added Trivy CLI exploration notes (trv-004) (`Trivy/notes/2026-06-25-exploring-trivy-cli.md`)

## 2026-06-24

- Added multi-stage Go HTTP server Dockerfile (doc-010) (`Docker/dockerfiles/multi-stage-go-http-server.Dockerfile`)
- Added run-first-local-pipeline script (gl-005) (`GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh`)
- Added following the providers tutorial notes (tf-010) (`Terraform/notes/2026-06-24-following-provider-tutorial.md`)
- Added following the GitLab CI/CD quickstart notes (gl-004) (`GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md`)

## 2026-06-23

- Added following GitHub Actions quickstart notes (ga-004) (`GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md`)
- Added CI/CD Concepts primer (con-005) (`docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md`)
- Added first CI workflow with env vars and secrets (ga-005) (`GitHub Actions/configs/2026-06-23-first-ci-workflow-with-env-and-secrets.yaml`)

## 2026-06-22

- Added GitLab CI/CD primer (gl-001) (`GitLab CI/notes/0000-primer-gitlab-ci-cd.md`)
- Added GitLab Runner install and register script (gl-002) (`GitLab CI/scripts/2026-06-22-install-runner-and-register.sh`)
- Added first .gitlab-ci.yml pipeline config (gl-003) (`GitLab CI/configs/2026-06-22-first-pipeline.yaml`)

## 2026-06-19

- Flagged GitHub primer already exists (gh-001) (`GitHub/notes/2026-06-19-primer-already-exists.md`)
- Flagged Ansible primer already exists (ans-001) (`Ansible/notes/2026-06-19-primer-already-exists.md`)

## 2026-06-18

- Added changelog generator from conventional commits script (git-004) (`Git/scripts/changelog-from-conventional-commits.py`)

## 2026-06-17

- Added Git hooks project scaffold template (git-003) (`Git/templates/git-hooks/`)
- Added Git workflows comparison doc (git-001) (`Git/docs/git-workflows-comparison.md`)
- Added batch git operations across multiple repos script (git-002) (`Git/scripts/batch-git-ops.sh`)

## 2026-06-16

- Added Docker container health-check and dangling resource cleanup script (doc-013) (`Docker/scripts/docker-health-check-and-cleanup.sh`)
- Reworked GitHub web UI exploration notes with L1 scratchy voice (gh-013) (`GitHub/notes/2026-06-15-explore-github-web-ui.md`)
- Added interactive rebase automation script for squashing WIP commits before PR (git-003) (`Git/scripts/squash-wip-commits.sh`)
- Added git worktrees docs for parallel feature development (git-002) (`Git/docs/git-worktrees-parallel-feature-development.md`)
- Added conventional commit message hook script (git-001) (`Git/scripts/commit-msg-conventional-commit.sh`)

## 2026-06-15

- Added Ansible variable precedence comparison notebook (`Ansible/notebooks/ansible-variable-precedence.ipynb`)
- Added Ansible-lint workflow docs (`Ansible/docs/2026-06-15-wiring-ansible-lint.md`)
- Added Hello World guide and GitHub flow notes (gh-014 rework) (`GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md`)
- Added following Kubernetes Basics tutorial notes (`Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md`)
- Added ConfigMap and Secret mounted Pod manifest (`Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml`)

## 2026-06-14

- Added Nginx web server Ansible config with idempotency checks (`Ansible/configs/nginx-webserver.yaml`)
- Added following the official GitHub quickstart (CLI + web UI) notes (`GitHub/notes/2026-06-13-github-quickstart-cli-and-web.md`)

## 2026-06-13

- Added Docker web app and database compose manifest (`Docker/manifests/2026-06-13-web-db-compose.yaml`)
- Added Ansible playbook troubleshooting notes (`Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md`)
- Added Docker and Python setup Ansible config (`Ansible/configs/docker-python-setup.yaml`)

## 2026-06-12

- Added Terraform bootstrap project script with variables and outputs (`Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh`)
- Added Terraform local provider config with variables and outputs (`Terraform/configs/reusable-s3-module/`)
- Added following GitHub CLI quickstart notes (`GitHub/notes/2026-06-11-following-github-cli-quickstart.md`)
- Added Docker compose multi-service stack script (`Docker/scripts/2026-06-12-compose-multi-service.sh`)
- Added GitHub create repo and open PR script (`GitHub/scripts/2026-06-12-create-repo-and-pr.sh`)
- Added GitHub issues API snippet (`GitHub/snippets/github-issues-api.py`)
- Added Ansible nginx playbook snippet (`Ansible/snippets/nginx-playbook.yaml`)

## 2026-06-11

- Added following GitHub CLI quickstart notes (`GitHub/notes/2026-06-11-following-github-cli-quickstart.md`)
- Added reusable S3 Terraform module with variables and outputs (`Terraform/configs/reusable-s3-module/`)
- Added GitHub list-repos REST API snippet (`GitHub/snippets/list-repos-with-python.py`)
- Added Ansible first playbook script (`Ansible/scripts/run-first-playbook.sh`)
- Added Ansible getting started notes (`Ansible/notes/2026-06-11-ansible-getting-started.md`)
- Added Terraform EC2 + security group manifest (`Terraform/manifests/simple-ec2-app.tf`)

## 2026-06-10

- Added Git merge conflict practice script (`Git/scripts/2026-06-10-merge-conflict-practice.sh`)
- Added GitHub platform features notes — wiki, projects, insights (`GitHub/notes/2026-06-10-github-platform-features.md`)
- Added first Docker image build Dockerfile (`Docker/dockerfiles/tried-building-first-image.Dockerfile`)
- Added GitHub auth + profile exploration script (`GitHub/scripts/tried-auth-and-profile.sh`)
- Added GitHub repos, issues, and PRs exploration notes (`GitHub/notes/2026-06-10-exploring-github-repos-issues-prs.md`)
- Added Terraform getting-started tutorial notes — Docker provider walkthrough (`Terraform/notes/2026-06-10-terraform-getting-started.md`)
- Added GitHub issue templates and labels config (`GitHub/configs/issue-templates-and-labels.yaml`)

## 2026-06-09

- Added Kubernetes stateless app manifest (`Kubernetes/manifests/stateless-app.yaml`)
- Added Kubernetes pod lifecycle script (`Kubernetes/scripts/pod-lifecycle.sh`)
- Added Terraform local file config (`Terraform/configs/local-file.tf`)

## 2026-06-08

- Added Kubernetes interactive tutorial walkthrough notes (`Kubernetes/notes/2026-06-08-kubernetes-interactive-tutorial.md`)
- Added GitHub CLI first issue comment script (`GitHub/scripts/tried-commenting-on-first-issue.sh`)
- Added docker run vs compose docs (`Docker/docs/docker-run-vs-compose.md`)

## 2026-06-07

- Added Docker Compose quickstart notes (`Docker/notes/2026-06-07-docker-compose-quickstart.md`)
- Added multi-service app Docker Compose config (`Docker/configs/multi-service-app.yaml`)
- Added Git branching tutorial notes (`Git/notes/2026-06-07-git-branching-tutorial.md`)
- Added minimal branching workflow script (`Git/scripts/minimal-branching-workflow.sh`)
- Added first Dockerfile (`Docker/dockerfiles/first-docker-image.Dockerfile`)
- Added GitHub auth + profile script (`GitHub/scripts/auth-and-profile.sh`)
- Added GitHub web UI + CLI exploration notes (`GitHub/notes/2026-06-07-explore-github-web-and-cli.md`)

## 2026-06-06

- Added Terraform CLI exploration notes (`Terraform/notes/2026-06-06-exploring-terraform-cli.md`)
- Added Ansible install + first ad-hoc script (`Ansible/scripts/install-and-first-adhoc.sh`)
- Added Ansible CLI exploration notes (`Ansible/notes/2026-06-06-exploring-ansible-cli.md`)
- Added Ansible primer (`Ansible/notes/0000-primer-ansible.md`)
- Added GitHub primer (`GitHub/notes/0000-primer-github.md`)
- Added Terraform install + init script (`Terraform/scripts/install-and-init.sh`)
- Added Docker install + first container script (`Docker/scripts/install-and-run-first-container.sh`)
- Added Docker CLI exploration notes (`Docker/notes/2026-06-06-exploring-docker-cli.md`)
- Added Kubernetes primer (`Kubernetes/notes/0000-primer-kubernetes.md`)
- Added kind install + first cluster script (`Kubernetes/scripts/install-kind-and-first-cluster.sh`)
- Added kubectl exploration notes (`Kubernetes/notes/2026-06-06-exploring-kubectl.md`)
- Added Terraform primer (`Terraform/notes/0000-primer-terraform.md`)

## 2026-06-05

- Added Docker install + run container script (`Docker/scripts/install-and-run-container.sh`)
- Added Docker CLI exploration notes (`Docker/notes/2026-06-05-explore-docker-cli.md`)
- Added Docker primer (`Docker/notes/0000-primer-docker.md`)

## 2026-06-04

- Added Git primer (`Git/notes/0000-primer-git.md`)
- Added Git install notes (`Git/notes/2026-06-04-install-git.md`)
- Added Git first-commit snippet (`Git/snippets/first-commit.sh`)
- Added Git install + first-commit script (`Git/scripts/install-and-first-commit.sh`)
- Added Git CLI exploration notes (`Git/notes/2026-06-04-explore-git-cli.md`)
- Added Helm README verification note (Helm/docs/2026-07-25-helm-readme-already-documented.md)

## 2026-08-11

- Added Docker health check patterns docs (`Docker/docs/docker-health-check-patterns.md`)
- Added Helm nginx chart with custom values snippet (`Helm/snippets/2026-08-11-nginx-helm-chart-custom-values.sh`)
