# Topics

> A map of what's here. For a beginner-to-advanced reading order, see [learning-path.md](learning-path.md).

## Ansible  ·  22 files

- **primer:** [0000-primer-ansible.md](../Ansible/notes/0000-primer-ansible.md)
- **configs** (7): most recent → [2026-07-19-first-inventory-and-ping-playbook.yaml](../Ansible/configs/2026-07-19-first-inventory-and-ping-playbook.yaml), [2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml](../Ansible/configs/2026-07-19-nginx-phpfpm-ufw-ubuntu.yaml), [ansible-collection-requirements-and-docker-lifecycle-playbook.yaml](../Ansible/configs/ansible-collection-requirements-and-docker-lifecycle-playbook.yaml)
- _…and 4 more under `Ansible/configs/` — browse the folder._
- **notes** (5): most recent → [2026-06-19-primer-already-exists.md](../Ansible/notes/2026-06-19-primer-already-exists.md), [2026-06-13-ansible-playbook-troubleshooting.md](../Ansible/notes/2026-06-13-ansible-playbook-troubleshooting.md)
- _…and 3 more under `Ansible/notes/` — browse the folder._
- **scripts** (4): [2026-07-19-install-ansible-and-explore-modules.sh](../Ansible/scripts/2026-07-19-install-ansible-and-explore-modules.sh), [install-and-first-adhoc.sh](../Ansible/scripts/install-and-first-adhoc.sh), [run-first-playbook.sh](../Ansible/scripts/run-first-playbook.sh)
- _1 more under `Ansible/scripts/` — browse the folder._
- **docs** (2): [ansible-over-terraform-local-exec.md](../Ansible/docs/ansible-over-terraform-local-exec.md), [2026-06-15-wiring-ansible-lint.md](../Ansible/docs/2026-06-15-wiring-ansible-lint.md)
- **snippets** (1): [nginx-playbook.yaml](../Ansible/snippets/nginx-playbook.yaml)
- **notebooks** (1): [ansible-variable-precedence.ipynb](../Ansible/notebooks/ansible-variable-precedence.ipynb)
- **templates** (1): [nginx-default.conf.j2](../Ansible/templates/nginx-default.conf.j2)
- **dockerfiles** (1): [ansible-control-node.Dockerfile](../Ansible/dockerfiles/ansible-control-node.Dockerfile)

## ArgoCD  ·  3 files

- **primer:** [0000-primer-argocd.md](../ArgoCD/notes/0000-primer-argocd.md)
- **configs** (1): [2026-07-23-first-application-manifest.yaml](../ArgoCD/configs/2026-07-23-first-application-manifest.yaml)
- **scripts** (1): [2026-07-23-install-argocd-and-access-ui.sh](../ArgoCD/scripts/2026-07-23-install-argocd-and-access-ui.sh)

## AWS  ·  6 files

- **primer:** [0000-primer-aws.md](../AWS/notes/0000-primer-aws.md)
- **notes** (2): [2026-07-13-primer-already-exists.md](../AWS/notes/2026-07-13-primer-already-exists.md), [0000-primer-aws.md](../AWS/notes/0000-primer-aws.md)
- **scripts** (2): [2026-07-13-install-aws-cli-v2-and-configure.sh](../AWS/scripts/2026-07-13-install-aws-cli-v2-and-configure.sh), [2026-07-12-install-aws-cli-v2-and-configure.sh](../AWS/scripts/2026-07-12-install-aws-cli-v2-and-configure.sh)
- **configs** (2): [2026-07-13-minimal-aws-config.ini](../AWS/configs/2026-07-13-minimal-aws-config.ini), [2026-07-12-minimal-aws-config.ini](../AWS/configs/2026-07-12-minimal-aws-config.ini)

## Azure  ·  3 files

- **primer:** [0000-primer-azure.md](../Azure/notes/0000-primer-azure.md)
- **scripts** (1): [2026-07-13-install-azure-cli-and-login.sh](../Azure/scripts/2026-07-13-install-azure-cli-and-login.sh)
- **snippets** (1): [2026-07-13-create-resource-group-and-list-regions.sh](../Azure/snippets/2026-07-13-create-resource-group-and-list-regions.sh)

## Docker  ·  32 files

- **primer:** [0000-primer-docker.md](../Docker/notes/0000-primer-docker.md)
- **dockerfiles** (7): most recent → [production-ready-go-http-server.Dockerfile](../Docker/dockerfiles/production-ready-go-http-server.Dockerfile), [multi-stage-go-http-server.Dockerfile](../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile)
- _…and 5 more under `Docker/dockerfiles/` (incl. the `multi-stage-go-http-server/` source subdir) — browse the folder._
- **manifests** (5): most recent → [go-redis-prometheus-compose.yaml](../Docker/manifests/go-redis-prometheus-compose.yaml), [prometheus.yml](../Docker/manifests/prometheus.yml), [Dockerfile](../Docker/manifests/Dockerfile)
- _…and 2 more under `Docker/manifests/` — browse the folder._
- **templates** (6): [Go microservice scaffold](../Docker/templates/go-microservice/README.md) — multi-stage Dockerfile, Makefile, and `.dockerignore`
- **scripts** (5): [multi-stage-go-dockerfile.sh](../Docker/scripts/multi-stage-go-dockerfile.sh), [docker-health-check-and-cleanup.sh](../Docker/scripts/docker-health-check-and-cleanup.sh), [install-and-run-first-container.sh](../Docker/scripts/install-and-run-first-container.sh)
- _…and 2 more under `Docker/scripts/` — browse the folder._
- **notes** (4): [2026-06-07-docker-compose-quickstart.md](../Docker/notes/2026-06-07-docker-compose-quickstart.md), [2026-06-06-exploring-docker-cli.md](../Docker/notes/2026-06-06-exploring-docker-cli.md)
- _…and 2 more under `Docker/notes/` — browse the folder._
- **docs** (2): [docker-run-vs-compose.md](../Docker/docs/docker-run-vs-compose.md), [docker-build-mount-vs-copy-caching.md](../Docker/docs/docker-build-mount-vs-copy-caching.md)
- **notebooks** (1): [comparing-docker-networking-drivers.ipynb](../Docker/notebooks/comparing-docker-networking-drivers.ipynb)
- **snippets** (1): [analyze-image-layers.py](../Docker/snippets/analyze-image-layers.py)
- **configs** (1): [multi-service-app.yaml](../Docker/configs/multi-service-app.yaml)

## GCP  ·  3 files

- **primer:** [0000-primer-gcp.md](../GCP/notes/0000-primer-gcp.md)
- **scripts** (1): [2026-07-16-install-gcloud-cli-and-configure-creds.sh](../GCP/scripts/2026-07-16-install-gcloud-cli-and-configure-creds.sh)
- **snippets** (1): [2026-07-16-list-compute-and-gcs-with-gcloud.sh](../GCP/snippets/2026-07-16-list-compute-and-gcs-with-gcloud.sh)

## Git  ·  41 files

- **primer:** [0000-primer-git.md](../Git/notes/0000-primer-git.md)
- **scripts** (8): [2026-06-10-merge-conflict-practice.sh](../Git/scripts/2026-06-10-merge-conflict-practice.sh), [conventional-commits-hook.sh](../Git/scripts/conventional-commits-hook.sh), [install-and-first-commit.sh](../Git/scripts/install-and-first-commit.sh)
- _…and 5 more under `Git/scripts/` — browse the folder._
- **templates** (21): [pre-commit](../Git/templates/git-hooks/pre-commit), [commit-msg](../Git/templates/git-hooks/commit-msg), [git-repository-skeleton README](../Git/templates/git-repository-skeleton/README.md)
- _…and 18 more under `Git/templates/` — browse the folder (includes the repository-skeleton scaffold)._
- **notes** (4): most recent → [2026-06-07-git-branching-tutorial.md](../Git/notes/2026-06-07-git-branching-tutorial.md), [2026-06-04-explore-git-cli.md](../Git/notes/2026-06-04-explore-git-cli.md)
- _…and 2 more under `Git/notes/` — browse the folder._
- **docs** (6): most recent → [automating-git-bisect-with-scripted-regression-tests.md](../Git/docs/automating-git-bisect-with-scripted-regression-tests.md), [git-worktrees-parallel-feature-development-setup-workflow-gotchas.md](../Git/docs/git-worktrees-parallel-feature-development-setup-workflow-gotchas.md)
- _…and 4 more under `Git/docs/` — browse the folder._
- **snippets** (1): [first-commit.sh](../Git/snippets/first-commit.sh)
- **notebooks** (1): [comparing-git-merge-strategies.ipynb](../Git/notebooks/comparing-git-merge-strategies.ipynb)

## GitHub  ·  26 files

- **primer:** [0000-primer-github.md](../GitHub/notes/0000-primer-github.md)
- **notes** (10): most recent → [2026-06-19-primer-already-exists.md](../GitHub/notes/2026-06-19-primer-already-exists.md), [2026-06-15-hello-world-guide-and-github-flow.md](../GitHub/notes/2026-06-15-hello-world-guide-and-github-flow.md)
- _…and 8 more under `GitHub/notes/` — browse the folder._
- **scripts** (6): [provision-repo-with-api.py](../GitHub/scripts/provision-repo-with-api.py), [2026-06-12-create-repo-and-pr.sh](../GitHub/scripts/2026-06-12-create-repo-and-pr.sh)
- _…and 4 more under `GitHub/scripts/` — browse the folder._
- **configs** (6): [dot-github-repository/](../GitHub/configs/dot-github-repository/) (issue forms, labels, stale rules), [issue-templates-and-labels.yaml](../GitHub/configs/issue-templates-and-labels.yaml)
- _…and 4 more under `GitHub/configs/` — browse the folder._
- **snippets** (2): [github-issues-api.py](../GitHub/snippets/github-issues-api.py), [list-repos-with-python.py](../GitHub/snippets/list-repos-with-python.py)
- **docs** (1): [how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md](../GitHub/docs/how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md)
- **notebooks** (1): [comparing-api-approaches-release-automation.ipynb](../GitHub/notebooks/comparing-api-approaches-release-automation.ipynb)

## GitHub Actions  ·  10 files

- **primer:** [0000-primer-github-actions.md](../GitHub Actions/notes/0000-primer-github-actions.md)
- **configs** (4): most recent → [2026-08-07-matrix-node-workflow.yaml](../GitHub Actions/configs/2026-08-07-matrix-node-workflow.yaml), [2026-07-13-hello-workflow.yaml](../GitHub Actions/configs/2026-07-13-hello-workflow.yaml), [2026-07-11-first-ci-workflow-hello.yaml](../GitHub Actions/configs/2026-07-11-first-ci-workflow-hello.yaml)
- _…and 1 more under `GitHub Actions/configs/` — browse the folder._
- **notes** (4): most recent → [2026-07-13-primer-already-exists.md](../GitHub Actions/notes/2026-07-13-primer-already-exists.md), [2026-06-23-following-github-actions-quickstart.md](../GitHub Actions/notes/2026-06-23-following-github-actions-quickstart.md)
- _…and 2 more under `GitHub Actions/notes/` — browse the folder._
- **scripts** (2): [2026-07-13-install-gh-actions-extension.sh](../GitHub Actions/scripts/2026-07-13-install-gh-actions-extension.sh), [2026-07-11-install-gh-extension-and-list-runs.sh](../GitHub Actions/scripts/2026-07-11-install-gh-extension-and-list-runs.sh)
- **docs** (1): [2026-08-07-github-actions-quickstart-tripups.md](../GitHub Actions/docs/2026-08-07-github-actions-quickstart-tripups.md)

## GitLab CI  ·  5 files

- **primer:** [0000-primer-gitlab-ci-cd.md](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **notes** (2): [2026-06-24-following-gitlab-ci-quickstart.md](../GitLab CI/notes/2026-06-24-following-gitlab-ci-quickstart.md), [0000-primer-gitlab-ci-cd.md](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
- **scripts** (2): [2026-06-22-install-runner-and-register.sh](../GitLab CI/scripts/2026-06-22-install-runner-and-register.sh), [2026-06-24-run-first-local-pipeline.sh](../GitLab CI/scripts/2026-06-24-run-first-local-pipeline.sh)
- **configs** (1): [2026-06-22-first-pipeline.yaml](../GitLab CI/configs/2026-06-22-first-pipeline.yaml)

## Helm  ·  7 files

- **primer:** [0000-primer-helm.md](../Helm/notes/0000-primer-helm.md)
- **notes** (2): most recent → [2026-08-07-helm-quickstart-tripups.md](../Helm/notes/2026-08-07-helm-quickstart-tripups.md), [0000-primer-helm.md](../Helm/notes/0000-primer-helm.md)
- **docs** (3): [2026-07-25-add-helm-to-readme-layout-and-coverage.md](../Helm/docs/2026-07-25-add-helm-to-readme-layout-and-coverage.md), [2026-07-25-helm-readme-already-documented.md](../Helm/docs/2026-07-25-helm-readme-already-documented.md)
- _1 more under `Helm/docs/` — browse the folder._
- **scripts** (1): [2026-07-23-install-helm-and-explore-cli.sh](../Helm/scripts/2026-07-23-install-helm-and-explore-cli.sh)
- **configs** (1): [2026-07-23-first-helm-chart-inspection.yaml](../Helm/configs/2026-07-23-first-helm-chart-inspection.yaml)

## Kubernetes  ·  12 files

- **primer:** [0000-primer-kubernetes.md](../Kubernetes/notes/0000-primer-kubernetes.md)
- **notes** (5): most recent → [2026-07-19-first-kubectl-version-and-pod-from-manifest.md](../Kubernetes/notes/2026-07-19-first-kubectl-version-and-pod-from-manifest.md), [2026-06-15-following-kubernetes-basics-tutorial.md](../Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md)
- _…and 3 more under `Kubernetes/notes/` — browse the folder._
- **manifests** (3): [stateless-app.yaml](../Kubernetes/manifests/stateless-app.yaml), [deployment-service-with-probes-limits.yaml](../Kubernetes/manifests/deployment-service-with-probes-limits.yaml), [2026-06-15-configmap-secret-mounted-pod.yaml](../Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml)
- **scripts** (2): [install-kind-and-first-cluster.sh](../Kubernetes/scripts/install-kind-and-first-cluster.sh), [pod-lifecycle.sh](../Kubernetes/scripts/pod-lifecycle.sh)
- **docs** (1): [ingress-path-based-routing.md](../Kubernetes/docs/ingress-path-based-routing.md)
- **snippets** (1): [pod-troubleshoot-shell.sh](../Kubernetes/snippets/pod-troubleshoot-shell.sh)

## OpenTofu  ·  3 files

- **primer:** [0000-primer-opentofu.md](../OpenTofu/notes/0000-primer-opentofu.md)
- **scripts** (1): [2026-07-18-install-opentofu-and-verify.sh](../OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh)
- **configs** (1): [2026-07-18-minimal-local-config.tf](../OpenTofu/configs/2026-07-18-minimal-local-config.tf)

## Prometheus  ·  3 files

- **primer:** [0000-primer-prometheus.md](../Prometheus/notes/0000-primer-prometheus.md)
- **scripts** (1): [2026-07-23-install-prometheus-and-verify-metrics.sh](../Prometheus/scripts/2026-07-23-install-prometheus-and-verify-metrics.sh)
- **configs** (1): [2026-07-23-minimal-scrape-config.yml](../Prometheus/configs/2026-07-23-minimal-scrape-config.yml)

## Terraform  ·  17 files

- **primer:** [0000-primer-terraform.md](../Terraform/notes/0000-primer-terraform.md)
- **configs** (7): [local-file.tf](../Terraform/configs/local-file.tf), [2026-06-12-tried-local-with-vars.tf](../Terraform/configs/2026-06-12-tried-local-with-vars.tf) — plus the [reusable-s3-module/](../Terraform/configs/reusable-s3-module/) folder (5 files)
- _…and 1 more under `Terraform/configs/` — browse the folder._
- **notes** (4): most recent → [2026-06-24-following-provider-tutorial.md](../Terraform/notes/2026-06-24-following-provider-tutorial.md), [2026-06-10-terraform-getting-started.md](../Terraform/notes/2026-06-10-terraform-getting-started.md)
- _…and 2 more under `Terraform/notes/` — browse the folder._
- **docs** (2): [how-i-wired-terraform-workspaces-and-remote-state-locking.md](../Terraform/docs/how-i-wired-terraform-workspaces-and-remote-state-locking.md), [2026-06-29-terraform-workspaces-and-remote-state-locking.md](../Terraform/docs/2026-06-29-terraform-workspaces-and-remote-state-locking.md)
- **scripts** (2): [install-and-init.sh](../Terraform/scripts/install-and-init.sh), [2026-06-12-bootstrap-terraform-project.sh](../Terraform/scripts/2026-06-12-bootstrap-terraform-project.sh)
- **notebooks** (1): [2026-07-02-comparing-for-each-vs-count.ipynb](../Terraform/notebooks/2026-07-02-comparing-for-each-vs-count.ipynb)
- **manifests** (1): [simple-ec2-app.tf](../Terraform/manifests/simple-ec2-app.tf)

## Trivy  ·  5 files

- **primer:** [0000-primer-trivy.md](../Trivy/notes/0000-primer-trivy.md)
- **notes** (2): most recent → [2026-06-25-exploring-trivy-cli.md](../Trivy/notes/2026-06-25-exploring-trivy-cli.md), [0000-primer-trivy.md](../Trivy/notes/0000-primer-trivy.md)
- **scripts** (2): [2026-07-12-install-trivy-and-scan-filesystem.sh](../Trivy/scripts/2026-07-12-install-trivy-and-scan-filesystem.sh), [2026-06-26-scanned-first-container-image.sh](../Trivy/scripts/2026-06-26-scanned-first-container-image.sh)
- **snippets** (1): [2026-07-12-trivy-python-wrapper.py](../Trivy/snippets/2026-07-12-trivy-python-wrapper.py)

## git  ·  11 files

A companion lowercase directory that mirrors a subset of `Git/` (bisect notes, a merge-strategies notebook, and a second repo-scaffold template). Prefer `Git/` for the main toolkit.

- **docs** (3): [automating-git-bisect with a scripted regression test](../git/docs/automating-git-bisect-with-scripted-regression-tests.md), [git-folder-readme-coverage](../git/docs/2026-08-04-git-folder-readme-coverage.md)
- **notebooks** (1): [comparing-git-merge-strategies.ipynb](../git/notebooks/comparing-git-merge-strategies.ipynb) — identical to the `Git/notebooks` copy above
- **templates** (7): [git-repo-scaffold/README.md](../git/templates/git-repo-scaffold/README.md) — a second repo-scaffold starter (hooks/ folder, release-please manifest)
- _…and 4 more under `git/templates/` — browse the folder._

## Foundational Concepts  ·  14 files

- **CI/CD Concepts:** [0000-primer-ci-cd-concepts.md](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
  - **scripts** (1): [simulated-cicd-pipeline.sh](../docs/concepts/ci-cd-concepts/scripts/2026-08-04-simulated-cicd-pipeline.sh)
  - **snippets** (1): [cicd-common-patterns.sh](../docs/concepts/ci-cd-concepts/snippets/2026-08-04-cicd-common-patterns.sh)
- **Containerization Concepts:** [0000-primer-containerization-concepts.md](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
- **Infrastructure as Code Concepts:** [0000-primer-infrastructure-as-code-concepts.md](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
- **Linux & System Administration** (3): [0000-primer-linux-system-administration.md](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md), [process and permission patterns in devops](../docs/concepts/linux-system-administration/2026-07-18-process-and-permission-patterns-in-devops.md), [filesystem permissions and process management script](../docs/concepts/linux-system-administration/2026-07-18-filesystem-permissions-and-process-management.sh)
- **Monitoring & Observability:** [0000-primer-monitoring-observability-concepts.md](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
- **Networking Fundamentals** (3): [0000-primer-networking-fundamentals.md](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md), [netcat and curl connectivity script](../docs/concepts/networking-fundamentals/2026-07-18-netcat-and-curl-connectivity.sh), [network troubleshooting patterns](../docs/concepts/networking-fundamentals/notes/2026-08-07-network-troubleshooting-patterns.md)
- **Scripting & Automation (Bash/Python)** (3): [0000-primer-scripting-automation-bash-python.md](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md), [bash scripting exercises](../docs/concepts/scripting-automation-bash-python/scripts/2026-08-07-bash-scripting-exercises.sh), [log parsing and filtering](../docs/concepts/scripting-automation-bash-python/snippets/2026-08-07-log-parsing-filtering.py)
- **Version Control Concepts:** [0000-primer-version-control-concepts.md](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)

## docs (kit notes)  ·  4 files

Operational and audit notes kept by the kit. Browse the `docs/` folder.

- [2026-07-21-kubernetes-readme-tree-update.md](../docs/2026-07-21-kubernetes-readme-tree-update.md)
- [2026-07-19-ansible-notebooks-readme-verified.md](../docs/2026-07-19-ansible-notebooks-readme-verified.md)
- [2026-07-19-audit-004-check.md](../docs/2026-07-19-audit-004-check.md)
- [2026-07-11-removed-dead-general-references.md](../docs/2026-07-11-removed-dead-general-references.md)
