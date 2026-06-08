# Glossary

## Docker

- **Image** — A read-only snapshot of a filesystem used as a template for creating containers.
- **Container** — A running instance of an image; encapsulates an app and its dependencies in an isolated environment.
- **Dockerfile** — A text file containing instructions to build a Docker image.
- **Layer** — A cached build step in a Docker image that enables incremental builds.
- **Registry** — A storage and distribution system for Docker images (e.g., Docker Hub).
- **Volume** — Persistent storage that survives container restarts.
- **Port mapping** — A Docker networking feature mapping a host port to a container port.

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

## GitHub

- **Pull request** — Proposed changes you want merged into a target branch; opens a discussion and runs CI checks.
- **Issue** — A ticket for bugs, features, or tasks, tracked in the repo's issue tracker.
- **Fork** — A personal copy of someone else's repository, used for contributing upstream changes.

## Kubernetes

- **Pod** — The smallest deployable unit in Kubernetes; typically wraps a single container.
- **Node** — A worker machine in the cluster that runs pods.
- **Deployment** — A resource that manages desired replica counts and rolling updates for pods.
- **Service** — A stable network endpoint that routes traffic to a set of pods.
- **kubectl** — The Kubernetes CLI used to interact with the cluster.
- **Cluster** — The full set of nodes plus the control plane that orchestrates them.
- **YAML manifest** — A declarative configuration file applied with `kubectl apply -f`.

## Ansible

- **Control node** — The machine running Ansible where playbooks are authored and executed.
- **Managed node** — A remote server managed by Ansible via SSH.
- **Inventory** — A file listing managed nodes and their groups (INI or YAML format).
- **Playbook** — A YAML file describing tasks to run on managed hosts.
- **Module** — A reusable action unit (e.g., `apt`, `copy`, `service`) that Ansible executes.
- **Task** — A single step in a playbook that calls one module.
- **Role** — A packaged collection of playbooks, variables, files, and templates for reuse.
- **Idempotent** — A property where running the same operation multiple times produces the same result.

## Terraform

- **Provider** — A plugin that connects Terraform to a platform (e.g., AWS, Azure, GCP).
- **Resource** — A infrastructure component declared in `.tf` files (e.g., `aws_instance`).
- **State** — A snapshot of real infrastructure stored in `terraform.tfstate`.
- **Plan** — A diff showing what Terraform will create, change, or destroy before applying.
- **Apply** — The command that executes the planned changes against the infrastructure.
- **Destroy** — The command that tears down all resources managed by Terraform.
- **Module** — A reusable group of related resources encapsulated in a directory.
- **Variable** — An input value that keeps Terraform configurations flexible and parameterised.
- **Output** — A value exposed after apply (e.g., an IP address) via `output` blocks.
- **Backend** — The storage backend for Terraform state (local, S3, Terraform Cloud, etc.).

## Docker Compose

- **Compose file** — A YAML file (`docker-compose.yml`) defining multi-container applications.
- **Service** — A container definition within a Compose file (e.g., `web`, `redis`).
- **`depends_on`** — A Compose key that orders service startup; does not wait for readiness.
