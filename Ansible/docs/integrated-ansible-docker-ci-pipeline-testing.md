---
last_verified: 2026-08-24
tool_version: n/a
sources:
  - https://markaicode.com/stack/ansible-docker-stack/
  - https://computingforgeeks.com/ansible-kubernetes-cluster/
---

# Integrating Ansible with Docker for CI pipeline testing

## Purpose

When a CI pipeline must provision ephemeral test environments, apply configuration management, and validate the result in a single workflow, combining Ansible with Docker provides reproducible infrastructure and declarative configuration. Docker isolates the runtime environment; Ansible applies the configuration; the CI runner orchestrates both. This pattern is useful when tests need to run against a known-good baseline that changes between commits or when the same playbook must be validated against multiple base images.

## When to use

- The CI pipeline spins up a disposable environment for each test run instead of sharing a long-lived cluster.
- Configuration logic lives in Ansible playbooks and must be exercised against the exact image that will ship to production.
- Tests validate that a Docker image starts correctly and that Ansible can configure it without manual intervention.
- The team already uses Ansible for production configuration management and wants the same playbooks to gate CI.

## Prerequisites

- Ansible installed on the CI runner or available as a Docker image with the required collections.
- Docker Engine or Docker-in-Docker (dind) service available to the CI runner.
- The `community.docker` collection installed for container lifecycle management.
- The `kubernetes.core` collection installed if the pipeline targets Kubernetes nodes.
- Python Kubernetes client injected into Ansible's environment when targeting Kubernetes: `pipx inject ansible kubernetes`.

## Steps

1. **Define the Docker service in the CI configuration.** Most CI systems support a services block that starts a Docker daemon for the job. The Ansible step runs against this daemon to build images, start containers, and execute playbooks inside them.

2. **Build the application image as the first CI stage.** The pipeline builds the Docker image from the repository's Dockerfile and tags it with the commit SHA. This image becomes the target for the Ansible configuration step.

3. **Run the Ansible playbook against the built image.** Use the `community.docker` collection to manage containers as Ansible targets. Start a container from the built image, wait for it to become reachable, and apply the configuration playbook. The playbook should be idempotent so that re-running it against the same image reports `ok` rather than `changed`.

4. **Execute tests inside the configured container.** Once Ansible reports success, the CI job can run the test suite inside the same container. This validates both that the image builds and that the configuration applies cleanly.

5. **Tear down the container after the test run.** The CI job removes the container to avoid leaking resources between pipeline runs. If the Ansible step fails, preserve the container logs for debugging.

## Verify

- After the CI job completes, confirm that the Ansible step reports `ok=` and `changed=0` on a re-run against the same image, proving idempotency.
- Check the CI job logs for container startup failures or Ansible unreachable-host errors before the test stage begins.
- Verify that the image built in stage 1 is the same image the Ansible step configures by comparing the image digest in the job logs.
- Run the pipeline locally against a known-bad configuration to confirm that the Ansible step fails the job when the playbook is broken.

## Common errors

- **kubelet certificate rotation gaps.** When the CI pipeline provisions Kubernetes nodes with Ansible, kubelet certificates do not auto-renew. Add a weekly cron task: `kubeadm certs renew all && systemctl restart kubelet`.
- **SSH ControlMaster memory exhaustion.** At more than 50 parallel nodes, Ansible's SSH multiplexer can exhaust memory. For large test matrices, disable multiplexing or replace Ansible provisioning with a Helm-based deployment and use `ansible-pull` for configuration management.
- **Python client path mismatch.** Installing the Kubernetes Python client with `pip` puts it in a location Ansible cannot see. Use `pipx inject ansible kubernetes` so the client is available in Ansible's runtime environment.

## References

- Ansible + Docker + Kubernetes integration patterns: https://markaicode.com/stack/ansible-docker-stack/
- Ansible kubernetes.core collection setup: https://computingforgeeks.com/ansible-kubernetes-cluster/
