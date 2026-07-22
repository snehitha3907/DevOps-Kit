# Glossary

## Ansible

- **Control node** — The machine where Ansible is installed and from which commands and playbooks are run.
- **Inventory** — A file listing managed hosts and their groupings.
- **Playbook** — A YAML file defining a set of tasks to run on managed hosts.
- **Module** — A reusable unit of work Ansible executes (e.g., `apt`, `copy`, `service`).
- **Ad-hoc command** — A one-off Ansible command run directly without a playbook.
- **ansible-lint** — A linting tool that checks Ansible playbooks for syntax errors, best-practice violations, and idempotency risks.
- **Jinja2 template** — A templated file (often with the `.j2` extension) rendered by Ansible using the `template` module to produce config files on managed hosts.
- **Idempotency** — The property that running a task repeatedly produces the same end state, so Ansible can safely re-apply a playbook without unintended side effects.

## AWS

- **Region** — A geographic area containing multiple isolated availability zones where AWS services are hosted.
- **Availability Zone (AZ)** — An isolated location within a region, providing fault tolerance and high availability.
- **Named profile** — A credential configuration stored in the AWS CLI `config` and `credentials` files that lets you switch between accounts or roles without re-entering keys.
- **AWS CLI** — The official command-line interface for interacting with AWS services, supporting both v1 and v2.
- **CloudFormation** — AWS's native IaC service that provisions and manages resources using JSON or YAML templates.
- **`--output`** — Controls how results are printed: `json` (default), `text`, `table`, or `yaml`.
- **`--dry-run`** — A flag on some commands that checks whether you *could* perform the action without actually doing it.
- **`aws sts get-caller-identity`** — The "who am I?" command. It prints the account number, ARN, and user ID the current credentials resolve to.
- **`~/.aws/config`** — The INI-style file that holds profile settings (region, output format). Distinct from `~/.aws/credentials` which holds the secret keys.
- **`~/.aws/credentials`** — The file that stores access key pairs. Sensitive — should never be committed to git.

## Azure

- **Resource group** — A logical container that holds related Azure resources for an application or solution, enabling lifecycle management as a group.
- **Azure CLI** — The official cross-platform command-line tool for managing Azure resources and subscriptions.
- **Region** — A geographic location containing one or more datacentres where Azure services are deployed.
- **Subscription** — A billing and access-control boundary in Azure that defines how resources are paid for and who can manage them.
- **ARM template** — A JSON-based IaC template used to declaratively define Azure resources and their dependencies.
- **`--output` / `-o`** — Controls output format: `json` (default), `table`, `tsv`, `yaml`.
- **`--query`** — JMESPath filter to pick specific fields from JSON output.
- **Service principal** — A non-human identity for automation, used instead of a user account in CI/CD.
- **ARM (Azure Resource Manager)** — The underlying REST API that `az` wraps. Every CLI command maps to an ARM API call.

## Containerization Concepts

- **Image** — A read-only template containing an application and its dependencies. Example: `nginx:1.25` is an official image with the Nginx web server and everything it needs.
- **Container** — A running instance of an image. Example: `docker run -d -p 80:80 nginx:1.25` starts one container from that image.
- **Dockerfile** — A text file that defines how to build an image, layer by layer. Example: `FROM python:3.12`, `COPY requirements.txt`, `RUN pip install`, `COPY .`, `CMD ["python", "app.py"]`.
- **Layer** — A read-only filesystem delta in an image. Each instruction in a Dockerfile creates a new layer. Example: the `COPY` layer holds my app code; the `RUN pip install` layer holds installed packages.
- **Volume** — A persistent storage location that survives container restarts and deletions. Example: a PostgreSQL container mounts a volume so database files aren't lost when the container exits.
- **Network** — An isolated communication channel between containers. Example: a `frontend` network lets my web container talk to my API container on `api:5000` without exposing the API to the host.
- **Registry** — A storage and distribution system for images. Example: Docker Hub, AWS ECR, or a private registry I run inside the cluster.
- **Multi-stage build** — A Dockerfile that uses multiple `FROM` lines to produce a smaller final image by copying only artifacts from a builder stage. Example: compile a Go binary in a `golang:1.22` stage, then copy just the binary into a `scratch` or `alpine` stage.
- **Base image** — The starting point for building an image. Example: `python:3.12-slim` is a small base with Python pre-installed; `alpine` is even smaller but less compatible.
- **Entrypoint** — The default command or executable that runs when a container starts. Example: `ENTRYPOINT ["python"]` with `CMD ["app.py"]` means the container runs `python app.py`.

## Docker

- **Health check** — A Docker Compose directive that tests container readiness (e.g., via HTTP endpoint) before dependent services are started.
- **Image** — A read-only snapshot of a filesystem used as a template for creating containers.
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
- **`bq`** — CLI tool for BigQuery.
- **Zone / Region** — Where resources live. Zones are sub-divisions of regions.
- **`gcloud config`** — Persistent settings for the CLI (project, region, zone, account).
- **Service account** — A non-human identity for automation. Used instead of a user account in pipelines.
- **Application Default Credentials (ADC)** — A strategy that `gcloud` and GCP client libraries use to find credentials automatically.
- **`--format`** — Controls output: `json`, `yaml`, `table`, `text`, `csv`, `list`.
- **`--filter`** — Server-side filtering of results.

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
- **Pull Request** — A review request to merge one branch into another, with a diff and discussion.
- **.gitignore** — A file that tells Git which files or directories to skip. Example: ignoring `.terraform/` and `*.tfvars` so secrets and generated files aren't committed.

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

## GitHub Actions

- **Workflow** — An automated process defined in YAML that runs one or more jobs when triggered.
- **Job** — A set of steps executed on the same runner.
- **Step** — An individual task within a job, such as running a script or using an action.
- **Action** — A reusable unit of automation that can be shared across workflows.
- **Runner** — A server that listens for workflow jobs and executes them.

## GitLab CI/CD

- **Pipeline** — A collection of jobs split into stages (e.g., build → test → deploy) defined in `.gitlab-ci.yml`.
- **Job** — A single unit of work in a pipeline, with a script, image, and optional rules.
- **Stage** — A group of jobs that run in parallel within the same pipeline stage.
- **Runner** — A process that executes GitLab CI jobs; can be shared (GitLab-provided) or self-hosted.
- **`.gitlab-ci.yml`** — The YAML file at the root of a repository that defines the pipeline configuration.
- **Artifact** — Files produced by a job (e.g., binary, test report) passed to later stages or downloadable from the UI.
- **CI/CD variable** — A key-value pair used for secrets, API tokens, and configuration in GitLab CI/CD.

## Infrastructure as Code Concepts

- **Declarative** — Describing the desired end state without listing the steps to get there. Example: "I want three nginx servers running" instead of "install nginx, start service, wait for port 80."
- **Imperative** — Listing explicit commands to execute in order. Example: a bash script that runs `apt install`, `systemctl start`, and `ufw allow` one after another.
- **State file** — A record of what infrastructure currently exists and its configuration. Example: `terraform.tfstate` tracks every AWS instance, security group, and S3 bucket Terraform has created.
- **Provider** — A plugin that understands how to create and manage resources in a specific platform. Example: the `aws` provider in Terraform knows how to create EC2 instances, S3 buckets, and RDS databases.
- **Resource** — A single piece of infrastructure defined in code. Example: an `aws_instance` resource or an `ansible.builtin.apt` task.
- **Module** — A reusable, self-contained bundle of IaC code that can be shared and composed. Example: a Terraform module for S3 buckets with versioning and encryption that I can drop into multiple projects.
- **Workspace** — An isolated instance of state for the same configuration. Example: Terraform workspaces `dev`, `staging`, and `prod` let me run identical code against separate state files.
- **Drift detection** — Comparing actual infrastructure against the declared state to find unmanaged changes. Example: noticing that someone manually resized an EC2 instance outside of Terraform.
- **Plan** — A preview of what changes IaC will make before applying them. Example: `terraform plan` shows "1 to add, 0 to change, 0 to destroy" so I can verify the impact.
- **Apply** — Executing the planned changes to make real infrastructure match the code. Example: `terraform apply` creates the resources the plan described.

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

## OpenTofu

- **Provider** — A plugin that lets OpenTofu manage a specific infrastructure platform (e.g., AWS, local).
- **State** — A snapshot of real-world infrastructure stored in `terraform.tfstate` that OpenTofu uses to track what it manages.
- **Plan** — A dry-run diff showing what resources will be created, changed, or destroyed.
- **Apply** — The command that executes the planned infrastructure changes.
- **Module** — A self-contained package of `.tf` configurations that manages a group of related resources.
- **Variable** — An input value that keeps configurations flexible across environments.
- **Output** — A value exposed by a module or root configuration after apply.
- **Backend** — The configuration that defines where state is stored (local by default, or remote for teams).
- **`tofu`** — The OpenTofu CLI binary, the drop-in replacement for `terraform`.

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

## Trivy

- **Vulnerability scanner** — A tool that identifies security vulnerabilities in software dependencies and container images.
- **Image scanning** — The process of inspecting a container image for known vulnerabilities in the base OS packages and application dependencies.
- **SARIF** — Static Analysis Results Interchange Format, a standard JSON-based format for sharing analysis results.
- **CVSS** — Common Vulnerability Scoring System, a framework for rating the severity of security vulnerabilities.
- **Severity filtering** — The ability to filter scan results by severity level (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN).
- **SBOM** — Software Bill of Materials, a list of all components and dependencies in a piece of software.

## Monitoring & Observability

- **Metric** — A numeric measurement collected over time, like `http_requests_total` or `process_cpu_seconds`. Metrics are cheap to store and fast to query, which makes them perfect for dashboards and alerts.
- **Log** — A timestamped text record of an event, usually structured as JSON with fields like `level`, `service`, and `message`. Logs tell the story of what happened in detail.
- **Trace** — A record of a single request's path through multiple services, showing each hop's duration and metadata. Distributed tracing lets me see where time was lost across service boundaries.
- **Dashboard** — A visual panel that graphs metrics and logs for at-a-glance system health. A good dashboard answers "is everything okay?" in under ten seconds.
- **Alert** — A notification triggered when a metric crosses a threshold or a condition is met. Good alerts are actionable and low-noise; bad alerts train on-call engineers to ignore them.
- **Service Level Indicator (SLI)** — A specific measurable attribute of a service, such as request latency or availability percentage. SLIs are the raw numbers behind service level agreements.
- **Service Level Objective (SLO)** — A target value for an SLI, like "99.9% of requests return in under 200ms". SLOs give teams a shared language for reliability instead of vague "make it faster" goals.

## CI/CD Concepts

- **Continuous Integration (CI)** — The practice of automatically building and testing every code change.
- **Continuous Deployment (CD)** — The practice of automatically deploying every change that passes CI.
- **Continuous Delivery** — An extension of CI where every change is deployable but may require manual approval to deploy.

## Version Control Concepts

- **Repository** — A folder tracked by version control that contains the project and its full history.
- **Commit** — A snapshot of changes at a point in time, with a message explaining why the change was made.
- **Branch** — A parallel line of development that lets me work on changes without disturbing the main line.
- **Merge** — Combining changes from one branch into another.
- **Pull Request** — A review request to merge one branch into another, with a diff and discussion.
- **Clone** — Copying a remote repository to my local machine so I can work on it.
- **Remote** — A version of the repository hosted on a server (like GitHub) that I can push to and pull from.
- **.gitignore** — A file that tells Git which files or directories to skip.
- **Conflict** — When two branches change the same line of code and Git can't auto-merge them.
- **HEAD** — A pointer to the current commit I'm looking at, usually the tip of the current branch.
