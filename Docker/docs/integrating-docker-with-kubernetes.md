---
last_verified: 2026-09-29
tool_version: n/a
---

# Integrating Docker with Kubernetes for production workloads

## Purpose

Docker produces portable container images; Kubernetes schedules and operates those images across a fleet of machines. This doc describes the handoff between the two: how to build an image with Docker so that it behaves well under Kubernetes, how to reference that image from a workload manifest, and how to roll changes out and back safely.

## When to use

- Use this pattern when a service that already runs via `docker run` or Compose needs multi-replica scheduling, self-healing restarts, or rolling updates.
- Use it when separate teams own image builds (CI) and cluster operations — the image reference plus tag convention is the contract between them.
- Do not use it for single-host experiments or throwaway debugging; plain `docker run` is simpler and avoids manifest overhead.

## Prerequisites

- A working Docker setup that can build the service image locally.
- Access to a container registry the cluster can pull from, plus pull credentials if the registry is private.
- A Kubernetes manifest for the workload (a Deployment is the usual starting point).
- The health-check endpoint or probe command the service exposes (see `./docker-health-check-patterns.md`).

## Steps

### 1. Build a small, runnable image

Keep the final image minimal: multi-stage builds so compilers and caches stay in the builder stage, and only the binary plus runtime assets ship. A smaller image pulls faster on every node, which shortens rollout time. Layer-caching details are covered in `./docker-build-cache-and-multi-stage-layering.md`.

```dockerfile
FROM builder AS build
COPY . /src
RUN make -C /src build

FROM minimal-base
COPY --from=build /src/bin/service /usr/local/bin/service
ENTRYPOINT ["/usr/local/bin/service"]
```

### 2. Tag immutably and push

Tag each build with something unique per commit (commit SHA or CI build number) in addition to a moving tag, then push both:

```bash
docker build -t registry.example.com/team/service:abc1234 .
docker tag registry.example.com/team/service:abc1234 registry.example.com/team/service:stable
docker push registry.example.com/team/service:abc1234
docker push registry.example.com/team/service:stable
```

Deploy the immutable tag, never the moving one: re-pushing `stable` does not change what already-running Pods use, so redeploying `stable` is ambiguous about which build is actually live.

### 3. Reference the image from the workload

Point the Pod template at the immutable tag and state the pull policy explicitly:

```yaml
spec:
  containers:
    - name: service
      image: registry.example.com/team/service:abc1234
      imagePullPolicy: IfNotPresent
```

For a private registry, attach pull credentials via a Secret referenced by `imagePullSecrets` on the Pod spec. Create the Secret once per namespace; every Deployment in that namespace can reuse it.

### 4. Translate the Docker health check into Kubernetes probes

A Dockerfile `HEALTHCHECK` is ignored by the kubelet — it only affects `docker ps` output. Declare equivalent liveness and readiness probes in the manifest instead:

- **Readiness** gates traffic: a Pod that fails readiness is removed from Service endpoints but not restarted.
- **Liveness** gates restarts: a Pod that fails liveness is killed and recreated.

Reuse the same endpoint or command the Docker health check used, so local (`docker run`) and cluster behavior agree. Keep probes lightweight; a probe that calls a downstream database turns a database outage into cascading Pod restarts.

### 5. Set resource requests and limits

Give each container a CPU/memory `request` (used for scheduling) and a `limit` (used for enforcement). Without requests, the scheduler cannot place Pods sensibly; without limits, one misbehaving container can starve its neighbors on the same node. Start from observed local usage, then adjust after watching real cluster metrics.

### 6. Roll out and confirm

Apply the manifest, then watch the rollout rather than assuming it succeeded:

```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment/service
kubectl get pods -l app=service
```

A new ReplicaSet scales up alongside the old one; only Pods that pass readiness receive traffic, and the old ReplicaSet scales down as the new one becomes ready.

## Verify

- `kubectl rollout status` reports the rollout completed.
- `kubectl get pods` shows all new Pods in `Running` with the expected number of restarts (zero on a clean rollout).
- `kubectl describe deployment service` shows the Pod template carrying the immutable tag from Step 2.
- Hitting the Service endpoint returns healthy responses, confirming readiness probes pass under real traffic.

## Rollback

If the new image misbehaves, revert to the previous ReplicaSet without rebuilding anything:

```bash
kubectl rollout undo deployment/service
kubectl rollout status deployment/service
```

Because each build keeps its immutable tag, rollback is a pointer move back to a known-good image. If the bad rollout also changed the manifest (env vars, probes, limits), review the rollout history first and roll back to the specific revision that was last healthy.

## Common errors

- **Cluster pulls a stale image** — deploying a moving tag with the default pull policy means nodes reuse their cached copy. Always deploy the immutable tag, or force a pull explicitly.
- **`ImagePullBackOff` on private registries** — the image name is right but the cluster has no credentials. Check that the `imagePullSecrets` Secret exists in the same namespace as the workload and is spelled correctly in the Pod spec.
- **CrashLoopBackOff right after migration** — usually a command or port mismatch: the Dockerfile `EXPOSE`d one port while the manifest probes or Service target another, or the container expects env vars / mounted files that `docker run` provided via flags nobody copied into the manifest. Compare the working `docker run` invocation flag-by-flag against the Pod spec.
- **Probes kill healthy Pods** — a liveness probe sharing a slow endpoint with readiness, or missing initial-delay/startup grace on slow-starting apps, restarts containers that would have become healthy. Give slow starters a startup probe or generous initial delay, and keep liveness checks cheaper than readiness checks.
- **OOMKilled under load** — the memory limit was sized from idle local usage. Raise the limit after checking actual peak usage, and treat repeated OOM kills as a sizing signal, not a one-off.

## References

- `./docker-health-check-patterns.md` — probe commands and endpoint conventions reused in Step 4.
- `./docker-build-cache-and-multi-stage-layering.md` — keeping the Step 1 image small and rebuilds fast.
