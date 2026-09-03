---
last_verified: 2026-09-03
tool_version: n/a
sources:
  - https://www.cncf.io/blog/2026/05/29/building-a-cloud-native-internal-developer-platform-with-kubernetes-gitops-and-supply-chain-security/
  - https://cloudnativenow.com/contributed-content/gitops-in-practice-how-to-design-a-scalable-ci-cd-pipeline-with-gitlab-and-gke/
  - https://thecodeforge.io/devops/docker-kubernetes-ci-cd/
---

# Terraform and Docker integration patterns

> How IaC and containerization fit together in a real deployment pipeline — and where each tool's responsibility starts and stops. Written from notes after walking the 2026 GitOps reference design.

## What I set out to figure out

I wanted a clear answer to "where does Terraform stop and Docker start?" when you stand up a small platform. The IaC primer I already wrote covered Terraform and OpenTofu in isolation; this doc is the seam between Terraform-managed infrastructure and Docker-built / orchestrator-run workloads.

The 2026 CNCF reference design treats the seven-component stack — VCS, CI/CD, container platform, orchestrator, artifact repository, monitoring/logging, IaC — as the canonical shape. Docker packages and runs; Kubernetes (or a Docker host) schedules; Terraform provisions the substrate. That maps cleanly to a few integration patterns.

## Three patterns I have seen work

### Pattern 1 — Terraform owns the substrate, Docker owns the image

The cleanest split. Terraform creates the VM, network, security group, and container registry; Docker builds the image, tags it with the commit SHA, and pushes to the registry Terraform provisioned.

```hcl
# Terraform: provision the registry
resource "aws_ecr_repository" "app" {
  name                 = "app"
  image_tag_mutability = "IMMUTABLE"
}
```

```bash
# CI: build once, tag with SHA, push
SHA="$(git rev-parse --short HEAD)"
docker build -t "${ECR}/app:${SHA}" .
docker push "${ECR}/app:${SHA}"
```

The contract between the two is the image URI. Terraform does not need to know the SHA; the deploy step (Helm, `kubectl set image`, or `docker run`) consumes whatever SHA CI produced. Building the same SHA once and promoting it across environments is what avoids rebuild drift.

### Pattern 2 — Terraform builds and runs the image itself

The `docker_image` and `docker_container` providers let Terraform call `docker build` and `docker run` as resources. Useful for single-node setups where the cluster IS the host. I have used this on a lab VM; for anything multi-node it gets in the way.

```hcl
resource "docker_image" "app" {
  name = "app:latest"
  build {
    context = "${path.module}/../app"
  }
}

resource "docker_container" "app" {
  name  = "app"
  image = docker_image.app.image_id
  ports {
    internal = 8080
    external = 80
  }
}
```

The trade-off: state now depends on a running Docker daemon, and `terraform destroy` removes both host and containers. Fine for a sandbox; not what I want for anything that needs to stay up.

### Pattern 3 — Terraform owns the cluster, an agent owns the workloads

For Kubernetes-shaped deployments, Terraform stops at the cluster boundary: it creates EKS/GKE/AKS, node groups, IAM roles, and the ingress. A separate controller (Argo CD, Flux, or a Helm release from CI) reconciles workload manifests into the cluster. Terraform never references individual image tags — promotion is a commit to a deployment repo that bumps the tag in the staging overlay, then the prod overlay.

The CNCF reference design describes this as the dominant 2026 pattern: CI builds the image once, pushes the SHA, commits the manifest update; the cluster agent reconciles. Rollback is `git revert`. Drift is auto-corrected.

## Where the responsibilities split

This is the table I keep coming back to when I am sketching a new platform:

| Concern | Terraform | Docker / orchestrator |
|---|---|---|
| VMs, networks, IAM, subnets | yes | no |
| Container registry | yes (provision) | no (push only) |
| Cluster lifecycle (EKS, GKE, AKS) | yes | no |
| Application image build | no | yes |
| Application image tag (SHA) | no | yes |
| Workload scheduling / replicas | no | yes |
| Health checks, rollouts, rollbacks | no | yes |

## Steps that have worked for me

1. Pick the pattern that matches the deployment shape (single node → Pattern 2, multi-node cluster → Pattern 3, registry-only → Pattern 1).
2. Provision the registry and any cluster with Terraform, output the registry URI.
3. In CI, build the image once with a SHA tag and push to that registry.
4. Promote the same SHA across environments by editing the manifest, not by rebuilding.
5. Reconcile workloads through an agent (Argo CD, Flux) or a controlled deploy (`kubectl set image`, `helm upgrade --atomic`).

## Verify

- `terraform state list` shows only infrastructure resources — no `docker_container` or `docker_image` mixed in (unless using Pattern 2).
- `docker pull` against the registry returns the SHA, and the SHA in the running container matches the SHA in the deployment manifest.
- `kubectl rollout status` succeeds, and `kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}'` shows the expected SHA, not `latest`.

## Where I have gotten it wrong

- Tagging with `latest` and rebuilding per environment. The same SHA has to move through staging and prod, or the deploy was not tested.
- Letting Terraform reach into the cluster with `kubernetes` provider resources while Argo CD also reconciles the same manifests. One of them wins silently, and it usually is not the one I expected.
- Mixing `docker_container` resources with other Terraform-managed VMs in the same state file; the Docker daemon becomes a single point of failure for `plan`/`apply`.

## What I'd try next

Wire Pattern 3 end to end on a sandbox cluster — Terraform for the EKS cluster + ECR repo, GitHub Actions for the build, Argo CD for the reconcile — and watch where the contracts actually need to be. The IaC state workflow script in `../scripts/` covers the state side; this doc is the deployment side.

## References

- CNCF, "Building a cloud-native internal developer platform with Kubernetes, GitOps, and supply chain security" (2026-05-29).
- Cloud Native Now, "GitOps in practice: how to design a scalable CI/CD pipeline with GitLab and GKE".
- The Codeforge, "Docker + Kubernetes CI/CD" (2026).
