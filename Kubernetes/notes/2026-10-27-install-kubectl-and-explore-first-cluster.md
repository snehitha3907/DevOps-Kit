---
last_verified: 2026-10-27
tool_version: "n/a"
sources: []
---

# Kubernetes — Install kubectl and explore my first cluster (L1 notes)

> First-day scratch notes. Just getting oriented.

## What I did
I started by installing `kubectl` (the Kubernetes CLI). On most setups, I can check my cluster access with `kubectl cluster-info` and `kubectl get nodes`. If the cluster isn't running locally yet, common ways are `minikube`, `kind`, or using a managed cluster.

## Quick checks
```bash
# Check kubectl version
kubectl version --client

# Check cluster info (if connected)
kubectl cluster-info

# See nodes
kubectl get nodes
```

## What I learned
- **Cluster**: a set of machines (nodes) running Kubernetes control plane + workers.
- **kubectl**: talks to the API server; uses kubeconfig (`~/.kube/config`) for auth/context.
- **Namespace**: a way to group resources (starts with `default`, `kube-system`).
- **Pods**: smallest deployable unit — containers run inside pods.

## Got stuck on
Sometimes `kubectl get nodes` returns "connection refused" if no cluster is running. Need to start a local cluster first or set up kubeconfig.

## What I'll try next
I'll create my first Pod with `kubectl run` or a manifest, and look at logs with `kubectl logs`.
