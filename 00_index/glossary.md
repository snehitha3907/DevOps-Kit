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

- **Repository** — A project container with code, issues, pull requests, and wiki.
- **Pull Request (PR)** — A proposed change that can be reviewed and merged.
- **Issue** — A discussion thread for bugs, features, or tasks.
- **Fork** — A personal copy of a repository for contributing changes.
- **Branch** — Independent line of development; `main` is the default.
- **Remote** — The GitHub URL your local repo connects to, usually called "origin".
- **Merge** — Combining changes from one branch into another.

## Ansible

- **Control node** — The machine where Ansible is installed and playbooks are executed.
- **Managed node** — A server managed by Ansible via SSH.
- **Inventory** — A file listing managed nodes and their connection details.
- **Playbook** — A YAML file describing tasks to run on hosts.
- **Module** — A reusable action unit (e.g. `apt`, `copy`, `service`).
- **Task** — A single step in a playbook that calls one module.
- **Role** — A packaged collection of playbooks, variables, and templates.
- **Idempotent** — Running the same playbook twice yields the same result as running it once.

## Kubernetes

- **Pod** — The smallest deployable unit, typically one container.
- **Node** — A worker machine in the cluster.
- **Deployment** — A resource that manages desired replica counts and rolling updates.
- **Service** — A stable network endpoint that routes traffic to pods.
- **kubectl** — The Kubernetes CLI.
- **Cluster** — All nodes plus the control plane.
- **YAML manifest** — A declarative configuration file applied with `kubectl apply`.

## Terraform

- **Provider** — A plugin for a cloud or service platform (e.g. AWS, Azure).
- **Resource** — A declared infrastructure component to create or manage.
- **State** — A snapshot of real-world infrastructure stored in `terraform.tfstate`.
- **Plan** — A diff showing what will be created, changed, or destroyed.
- **Apply** — Executes the plan and makes the necessary API calls.
- **Destroy** — Tears down all managed resources.
- **Module** — A reusable group of resource definitions.
- **Variable** — An input value that keeps configurations flexible.
- **Output** — An exposed value from a resource (e.g. a public IP).
- **Backend** — The storage location for state (local, S3, Terraform Cloud).
