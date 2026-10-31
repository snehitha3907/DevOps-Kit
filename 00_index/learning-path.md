# Learning path — devops

Work through the stages in order. Each lesson says what it expects you to know already, ends with an exercise you can check, and links to the next lesson.

## Stage 1: Orientation, Linux and scripting

1. [Linux and system administration — the basics](../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md)
2. [Find your way around the lab shell](../learn/01-orientation/02-shell-navigation.md) · needs: Linux and system administration — the basics
3. Manage processes and services with systemd — *not written yet* · needs: Find your way around the lab shell
4. [Scripting and automation — the basics](../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
5. Read and write YAML that validates — *not written yet* · needs: Find your way around the lab shell
6. Write a safe Bash health-check script — *not written yet* · needs: Manage processes and services with systemd, Scripting and automation — the basics

## Stage 2: Networking

1. [Networking fundamentals](../docs/concepts/networking-fundamentals/0000-primer-networking-fundamentals.md)
2. Diagnose "I can't reach it" — IPs, ports and DNS — *not written yet* · needs: Networking fundamentals, Find your way around the lab shell
3. Probe HTTP and TLS endpoints — *not written yet* · needs: Diagnose "I can't reach it" — IPs, ports and DNS, Write a safe Bash health-check script

## Stage 3: Version control

1. [Version control concepts](../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md)
2. [Git — quick primer](../Git/notes/0000-primer-git.md)
3. Put the sample app under version control — *not written yet* · needs: Git — quick primer, Version control concepts, Find your way around the lab shell
4. Branch, merge and rebase — *not written yet* · needs: Put the sample app under version control
5. Undo mistakes and recover lost work — *not written yet* · needs: Branch, merge and rebase
6. Pull requests and branch protection on GitHub — *not written yet* · needs: Branch, merge and rebase

## Stage 4: Containers

1. [Containerization concepts](../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)
2. [Docker — quick primer](../Docker/notes/0000-primer-docker.md)
3. Package the sample app as an image — *not written yet* · needs: Docker — quick primer, Containerization concepts, Put the sample app under version control, Diagnose "I can't reach it" — IPs, ports and DNS
4. Smaller, faster images with multi-stage builds — *not written yet* · needs: Package the sample app as an image
5. Run the app and Postgres with Docker Compose — *not written yet* · needs: Smaller, faster images with multi-stage builds, Read and write YAML that validates
6. [Trivy — quick primer](../Trivy/notes/0000-primer-trivy.md)
7. Scan the sample app image with Trivy — *not written yet* · needs: Trivy — quick primer, Smaller, faster images with multi-stage builds

## Stage 5: Continuous integration and delivery

1. [CI/CD concepts](../docs/concepts/ci-cd-concepts/0000-primer-ci-cd-concepts.md)
2. [GitHub Actions — quick primer](../GitHub Actions/notes/0000-primer-github-actions.md)
3. Build and test the sample app on every pull request — *not written yet* · needs: GitHub Actions — quick primer, CI/CD concepts, Pull requests and branch protection on GitHub, Run the app and Postgres with Docker Compose
4. Scan and publish the image from CI — *not written yet* · needs: Build and test the sample app on every pull request, Scan the sample app image with Trivy
5. Reuse pipeline steps across repositories — *not written yet* · needs: Scan and publish the image from CI

## Stage 6: Infrastructure as code and cloud

1. [Infrastructure as code concepts](../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md)
2. [AWS — quick primer](../AWS/notes/0000-primer-aws.md)
3. AWS identity and networking basics — *not written yet* · needs: AWS — quick primer, Probe HTTP and TLS endpoints
4. [Terraform — quick primer](../Terraform/notes/0000-primer-terraform.md)
5. Provision and destroy your first infrastructure — *not written yet* · needs: Terraform — quick primer, Infrastructure as code concepts, AWS identity and networking basics
6. Keep Terraform state remote and locked — *not written yet* · needs: Provision and destroy your first infrastructure
7. Reusable Terraform modules — *not written yet* · needs: Keep Terraform state remote and locked
8. Plan and apply Terraform from CI with OIDC — *not written yet* · needs: Reusable Terraform modules, Reuse pipeline steps across repositories
9. [Ansible — quick primer](../Ansible/notes/0000-primer-ansible.md)
10. Configure a host with an Ansible playbook — *not written yet* · needs: Ansible — quick primer, Manage processes and services with systemd, Read and write YAML that validates

## Stage 7: Kubernetes

1. [Kubernetes — quick primer](../Kubernetes/notes/0000-primer-kubernetes.md)
2. Run the sample app on a local cluster — *not written yet* · needs: Kubernetes — quick primer, Run the app and Postgres with Docker Compose
3. Configuration, secrets and ingress — *not written yet* · needs: Run the sample app on a local cluster
4. Probes, resource limits and autoscaling — *not written yet* · needs: Configuration, secrets and ingress
5. [Helm — quick primer](../Helm/notes/0000-primer-helm.md)
6. Package the sample app as a Helm chart — *not written yet* · needs: Helm — quick primer, Probes, resource limits and autoscaling

## Stage 8: GitOps

1. [ArgoCD — quick primer](../ArgoCD/notes/0000-primer-argocd.md)
2. Deploy from Git with ArgoCD and roll back — *not written yet* · needs: ArgoCD — quick primer, Package the sample app as a Helm chart, Undo mistakes and recover lost work

## Stage 9: Observability

1. [Monitoring and observability concepts](../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)
2. [Prometheus — quick primer](../Prometheus/notes/0000-primer-prometheus.md)
3. Scrape the sample app and alert on errors — *not written yet* · needs: Prometheus — quick primer, Monitoring and observability concepts, Probes, resource limits and autoscaling
4. A Grafana dashboard kept in Git — *not written yet* · needs: Scrape the sample app and alert on errors
5. Define an SLO and alert on its burn rate — *not written yet* · needs: A Grafana dashboard kept in Git
6. Trace one request with OpenTelemetry — *not written yet* · needs: Scrape the sample app and alert on errors

## Stage 10: Security and secrets

1. SBOMs and image policy in the pipeline — *not written yet* · needs: Scan and publish the image from CI, Deploy from Git with ArgoCD and roll back
2. Store and read secrets with Vault — *not written yet* · needs: Configuration, secrets and ingress
3. Remove static secrets from the cluster — *not written yet* · needs: Store and read secrets with Vault, Deploy from Git with ArgoCD and roll back

## Stage 11: Operations and capstone

1. Run an incident drill with a runbook — *not written yet* · needs: Define an SLO and alert on its burn rate, Remove static secrets from the cluster
2. Capstone: ship the sample app end to end — *not written yet* · needs: Run an incident drill with a runbook, Plan and apply Terraform from CI with OIDC, SBOMs and image policy in the pipeline, Trace one request with OpenTelemetry

## Stage 12: Electives

1. [Azure — quick primer](../Azure/notes/0000-primer-azure.md)
2. [GCP — quick primer](../GCP/notes/0000-primer-gcp.md)
3. [GitLab CI — quick primer](../GitLab CI/notes/0000-primer-gitlab-ci-cd.md)
4. Rebuild the sample app pipeline in GitLab CI — *not written yet* · needs: GitLab CI — quick primer, Scan and publish the image from CI
5. Rebuild the sample app pipeline in Jenkins — *not written yet* · needs: Scan and publish the image from CI
6. [OpenTofu — quick primer](../OpenTofu/notes/0000-primer-opentofu.md)
7. The network module again, in Pulumi — *not written yet* · needs: Reusable Terraform modules
8. The GitOps setup again, with Flux — *not written yet* · needs: Deploy from Git with ArgoCD and roll back
9. Ship metrics to Grafana Cloud — *not written yet* · needs: A Grafana dashboard kept in Git

## Reference shelf

Background material per tool, for looking things up after the lesson.

| Tool | Folder |
|---|---|
| Linux & System Administration | [docs/concepts/linux-system-administration/](../docs/concepts/linux-system-administration/) |
| Scripting & Automation (Bash/Python) | [docs/concepts/scripting-automation-bash-python/](../docs/concepts/scripting-automation-bash-python/) |
| Networking Fundamentals | [docs/concepts/networking-fundamentals/](../docs/concepts/networking-fundamentals/) |
| Version Control Concepts | [docs/concepts/version-control-concepts/](../docs/concepts/version-control-concepts/) |
| Containerization Concepts | [docs/concepts/containerization-concepts/](../docs/concepts/containerization-concepts/) |
| CI/CD Concepts | [docs/concepts/ci-cd-concepts/](../docs/concepts/ci-cd-concepts/) |
| Infrastructure as Code Concepts | [docs/concepts/infrastructure-as-code-concepts/](../docs/concepts/infrastructure-as-code-concepts/) |
| Monitoring & Observability Concepts | [docs/concepts/monitoring-observability-concepts/](../docs/concepts/monitoring-observability-concepts/) |
| Git | [Git/](../Git/) |
| GitHub | [GitHub/](../GitHub/) |
| Docker | [Docker/](../Docker/) |
| Trivy | [Trivy/](../Trivy/) |
| GitHub Actions | [GitHub Actions/](../GitHub Actions/) |
| AWS | [AWS/](../AWS/) |
| Terraform | [Terraform/](../Terraform/) |
| Ansible | [Ansible/](../Ansible/) |
| Kubernetes | [Kubernetes/](../Kubernetes/) |
| Helm | [Helm/](../Helm/) |
| ArgoCD | [ArgoCD/](../ArgoCD/) |
| Prometheus | [Prometheus/](../Prometheus/) |
| Azure | [Azure/](../Azure/) |
| GCP | [GCP/](../GCP/) |
| GitLab CI | [GitLab CI/](../GitLab CI/) |
| OpenTofu | [OpenTofu/](../OpenTofu/) |
| Pulumi | [Pulumi/](../Pulumi/) |
| Flux CD | [FluxCD/](../FluxCD/) |
