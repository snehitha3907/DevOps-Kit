---
last_verified: 2026-09-04
tool_version: n/a
sources: []
---

# Installing kubectl and minikube — first Pod

I wanted to run a local Kubernetes cluster. Here's what happened.

Installed kubectl and minikube binaries, ran `minikube start`. Cluster came up, `kubectl get nodes` showed one Ready node.

Ran `kubectl run nginx --image=nginx`. Pod showed up but had no external IP. I couldn't reach it from my browser. Turns out I needed to expose it with `kubectl expose deployment nginx --port=80 --type=NodePort` first, then `minikube service nginx` opened it.

Other things that tripped me up:
- `ContainerCreating` status just means the image is downloading — not broken
- `kubectl` and `minikube` are separate tools with different commands
- Pods get internal IPs only; you need a Service to reach them

The sequence that worked: `minikube start` → `kubectl run nginx --image=nginx` → `kubectl expose deployment nginx --port=80 --type=NodePort` → `minikube service nginx`.

Next I want to try deploying from a YAML manifest instead of imperative commands.
