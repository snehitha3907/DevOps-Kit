# Glossary

## Ansible

- **Control node** — The machine where Ansible is installed and from which commands and playbooks are run.
- **Inventory** — A file listing managed hosts and their groupings.
- **Playbook** — A YAML file defining a set of tasks to run on managed hosts.
- **Module** — A reusable unit of work Ansible executes (e.g., `apt`, `copy`, `service`).
- **Ad-hoc command** — A one-off Ansible command run directly without a playbook.
- **ansible-lint** — A linting tool that checks Ansible playbooks for syntax errors, best-practice violations, and idempotency risks.

## AWS

- **Region** — A geographic area containing multiple isolated availability zones where AWS services are hosted.
- **Availability Zone (AZ)** — An isolated location within a region, providing fault tolerance and high availability.
- **Named profile** — A credential configuration stored in the AWS CLI `config` and `credentials` files that lets you switch between accounts or roles without re-entering keys.
- **AWS CLI** — The official command-line interface for interacting with AWS services, supporting both v1 and v2.
- **CloudFormation** — AWS's native IaC service that provisions and manages resources using JSON or YAML templates.

## Azure

- **Resource group** — A logical container that holds related Azure resources for an application or solution, enabling lifecycle management as a group.
- **Azure CLI** — The official cross-platform command-line tool for managing Azure resources and subscriptions.
- **Region** — A geographic location containing one or more datacentres where Azure services are deployed.
- **Subscription** — A billing and access-control boundary in Azure that defines how resources are paid for and who can manage them.
- **ARM template** — A JSON-based IaC template used to declaratively define Azure resources and their dependencies.

## Docker

- **Health check** — A Docker Compose directive that tests container readiness (e.g., via HTTP endpoint) before dependent services are started.- **Image** — A read-only snapshot of a filesystem used as a template for creating containers.
- **Container** — A running instance of an image; encapsulates an app and its dependencies in an isolated environment.
- **Dockerfile** — A text file containing instructions to build a Docker image.
- **Layer** — A cached build step in a Docker image that enables incremental builds.
- **Registry** — A storage and distribution system for Docker images (e.g., Docker Hub).
- **Volume** — Persistent storage that survives container restarts.
- **Port mapping** — A Docker networking feature mapping a host port to a container port.
- **Compose** — A tool for defining and running multi-container applications using a YAML file.
- **Build context** — The directory path passed to `docker build` that the Docker daemon uses as the source for copying files during image creation.
- **BuildKit** — Docker's modern build backend that enables faster, more efficient image builds with features like cache mounts and parallel execution.
- **--mount** — A BuildKit-specific `RUN` instruction modifier that mounts cache, secret, or SSH resources into a Docker build step.
- **docker buildx** — Docker's CLI plugin for extended build capabilities, including BuildKit, multi-platform images, and advanced caching strategies.

## GCP

- **Google Cloud SDK** — Google's set of command-line tools for managing GCP resources, bundling `gcloud`, `gsutil`, and `bq`.
- **gcloud** — The primary CLI for creating, inspecting, and managing Google Cloud resources such as VMs, networks, and IAM policies.
- **gsutil** — A command-line tool for interacting with Cloud Storage buckets and objects.
- **Project** — The top-level container in GCP that groups resources, billing, permissions, and APIs for a given workload.
- **Compute Engine** — GCP's infrastructure-as-a-service offering for running virtual machine instances.
- **Cloud Storage (GCS)** — GCP's object storage service, organised into buckets that hold files and blobs.

## Git

- **Repository (repo)** — A directory Git watches, containing all tracked files and their full change history.
- **Commit** — A snapshot of files at a point in time, identified by a unique hash.
- **Stage (index)** — An intermediate area where changes are prepared before committing.
- **Branch** — A separate line of development; the default branch is named `main`.
- **Clone** — Copying a remote repository to the local machine.
- **Push** — Sending local commits to a remote repository.
- **Pull** — Fetching and integrating changes from a remote repository.
- **Merge** — Combining changes from one branch into another.
- **Diff** — A view showing what changed between two commits or between working files and the last commit.
- **Remote** — A URL pointing to another copy of the repository, typically hosted remotely.
- **HEAD** — A pointer to the commit currently checked out.
- **Rebase** — Rewriting commit history by applying commits from one branch onto another.
- **Git worktree** — A mechanism that allows multiple working directories to be associated with a single repository, enabling parallel work on different branches without stashing or switching.
- **Hook** — A script Git executes before or after a specific event (e.g., pre-commit, commit-msg, post-checkout).
- **Pre-commit hook** — A Git hook that runs before a commit is finalised, used to check for issues like trailing whitespace, conflict markers, or debug statements.
- **Commit-msg hook** — A Git hook that validates the format of a commit message, often enforcing conventional commit standards.
- **Post-checkout hook** — A Git hook that runs after a branch switch, used to maintain hooks, suggest cleanup, or display context.
- **Conventional commit** — A commit message format that follows a structured prefix (`feat:`, `fix:`, `chore:`, etc.) enabling automated changelog generation and semantic versioning.

## GitHub

- **Deploy key** — An SSH public key registered on a single GitHub repository, granting read-only or read-write access for unattended operations like CI cloning.
- **Fine-grained PAT** — A personal access token scoped to specific repositories and granular permissions, used for HTTPS-based authentication and API access in CI/CD pipelines.
- **Machine user** — A GitHub account used exclusively for automation tasks, not tied to an individual team member, ensuring CI tokens remain valid regardless of personnel changes.
- **Repository** — A project container with code, issues, pull requests, and wiki.
- **Pull Request (PR)** — A proposed change that can be reviewed and merged.
- **Issue** — A discussion thread for bugs, features, or tasks.
- **Fork** — A personal copy of a repository for contributing changes.
- **Wiki** — A built-in documentation space for a repository.
- **Projects** — A kanban-style project management board for tracking work.
- **Insights** — Analytics and metrics for a repository, including traffic, contributors, and dependency graph.
- **GitHub flow** — A lightweight branching workflow where feature branches are created from `main`, changes are committed, a pull request is opened, and the branch is merged and deleted after review.
- **Issue form** — A structured YAML template for GitHub issues that provides input fields, dropdowns, checkboxes, and validations, defined under `.github/ISSUE_TEMPLATE/` or `.github/issue-forms/`.
- **Blank issues** — A repository setting that controls whether users can open issues without selecting a template; disabling it enforces template use.
- **Contact link** — A link shown in the new-issue interface that directs users to external resources such as community discussions or security policies.
- **Stale workflow** — A scheduled automation (often `.github/stale.yml` or an Actions workflow) that labels and closes issues and PRs after a period of inactivity.

## GitLab CI

- **Pipeline** — A collection of jobs split into stages (e.g., build → test → deploy) defined in `.gitlab-ci.yml`.
- **Job** — A single unit of work in a pipeline, with a script, image, and optional rules.
- **Stage** — A group of jobs that run in parallel within the same pipeline stage.
- **Runner** — A process that executes GitLab CI jobs; can be shared (GitLab-provided) or self-hosted.
- **`.gitlab-ci.yml`** — The YAML file at the root of a repository that defines the pipeline configuration.
- **Artifact** — Files produced by a job (e.g., binary, test report) passed to later stages or downloadable from the UI.
- **CI/CD variable** — A key-value pair used for secrets, API tokens, and configuration in GitLab CI/CD.

## Kubernetes

- **Pod** — The smallest deployable unit in Kubernetes; one or more containers sharing storage and network.
- **Deployment** — A controller that manages a set of identical pods, handling scaling and rolling updates.
- **Service** — A stable network endpoint for accessing a set of pods.
- **Manifest** — A YAML or JSON file defining a Kubernetes resource.
- **kubectl** — The Kubernetes CLI tool for interacting with clusters.
- **kind** — A tool for running local Kubernetes clusters using Docker containers as nodes.
- **Minikube** — A tool that runs a single-node Kubernetes cluster locally for development and testing.
- **NodePort** — A Kubernetes Service type that exposes the service on a static port on each node's IP address.
- **ReplicaSet** — A Kubernetes controller that ensures a specified number of pod replicas are running at any given time.
- **Rolling update** — A deployment strategy that gradually replaces old pod instances with new ones, minimizing downtime.
- **ConfigMap** — A Kubernetes resource for storing non-sensitive configuration data as key-value pairs that can be consumed by pods.
- **Secret** — A Kubernetes resource for storing sensitive data such as passwords or API keys, encoded as base64.

## Terraform

- **Backend** — A configuration that defines how Terraform stores and loads state (e.g., local, S3, AzureRM).
- **Provider** — A plugin that lets Terraform manage a specific infrastructure platform (e.g., AWS, local).
- **State** — A file that maps real-world resources to your Terraform configuration.
- **Plan** — A dry-run that shows what changes Terraform will make.
- **Apply** — The command that executes the changes shown in a plan.
- **Resource** — A declarative description of an infrastructure component (e.g., `local_file`).
- **Module** — A self-contained package of Terraform configurations that manages a group of related resources.
- **Output** — A value exposed by a Terraform module or root configuration after apply.
- **State locking** — A mechanism (often using DynamoDB) that prevents concurrent Terraform operations from modifying the same state file simultaneously.
- **Workspace** — A separate state instance within a single Terraform configuration, typically used to manage multiple environments like dev, staging, and prod.
- **for_each** — A meta-argument that creates multiple resource instances from a map or set of strings; preferred over `count` when resources are non-identical.
- **count** — A meta-argument that creates a given number of identical resource instances; uses `count.index` to differentiate each instance.

## GitHub Actions

- **Workflow** — An automated process defined in YAML that runs one or more jobs when triggered.
- **Job** — A set of steps executed on the same runner.
- **Step** — An individual task within a job, such as running a script or using an action.
- **Action** — A reusable unit of automation that can be shared across workflows.
- **Runner** — A server that listens for workflow jobs and executes them.

## GitLab CI/CD

- **Pipeline** — A collection of jobs split into stages, defined in `.gitlab-ci.yml`.
- **Stage** — A logical grouping of jobs that run in parallel within the same stage.
- **Runner** — A process that picks up and executes CI/CD jobs.
- **Job** — A single unit of work defined in a pipeline, specified by a job name in the config.

## Trivy

- **Vulnerability scanner** — A tool that identifies security vulnerabilities in software dependencies and container images.
- **Image scanning** — The process of inspecting a container image for known vulnerabilities in the base OS packages and application dependencies.
- **SARIF** — Static Analysis Results Interchange Format, a standard JSON-based format for sharing analysis results.
- **CVSS** — Common Vulnerability Scoring System, a framework for rating the severity of security vulnerabilities.
- **Severity filtering** — The ability to filter scan results by severity level (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN).
- **SBOM** — Software Bill of Materials, a list of all components and dependencies in a piece of software.

## CI/CD Concepts

- **Continuous Integration (CI)** — The practice of automatically building and testing every code change.
- **Continuous Deployment (CD)** — The practice of automatically deploying every change that passes CI.
- **Continuous Delivery** — An extension of CI where every change is deployable but may require manual approval to deploy.
