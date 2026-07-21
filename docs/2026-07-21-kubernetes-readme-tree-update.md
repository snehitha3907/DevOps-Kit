---
last_verified: 2026-07-21
tool_version: n/a
---

# Kubernetes files added to README tree

I checked the Kubernetes directory against the README and found two files on disk that were not referenced.

## Findings

- `Kubernetes/notes/2026-06-15-following-kubernetes-basics-tutorial.md` — L2 notes documenting the official Kubernetes Basics tutorial walkthrough using Minikube. The Coverage table counted it in the 5 notes, but it was missing from Quick links.
- `Kubernetes/manifests/2026-06-15-configmap-secret-mounted-pod.yaml` — A Pod manifest that mounts a ConfigMap and a Secret via `envFrom` and `secretKeyRef`. The Coverage table only showed 2 manifests, but 3 exist on disk.

## Changes

- Added both files to the README Quick links so they are discoverable without browsing the directory tree.
- Corrected the Coverage table: Kubernetes Manifests 2 → 3.
- Updated the README last-updated date to 2026-07-21.
