---
last_verified: 2026-07-23
tool_version: n/a
---

# ArgoCD — quick primer

> First-day notes for someone who's never used ArgoCD. Personal voice, plain language.

## What is it?

A GitOps tool for Kubernetes. It watches a Git repo and keeps the cluster matching the YAML files there. Change a Deployment in the repo, and it syncs.

## What does it do?

It connects to a Git repo with Kubernetes manifests, compares them to what's running in the cluster, and syncs any drift. The web UI and CLI let me see app status, roll back, and approve syncs.

## Why does it exist?

Before GitOps, deploying meant running `kubectl apply` by hand or keeping config spreadsheets. Teams needed one source of truth — the repo. Platform engineers and SREs use it daily.

## Key terminology

- **Application** — a set of K8s resources ArgoCD manages from a Git path. Example: pointing at `github.com/me/manifests/wordpress/`.
- **GitOps** — Git as the source of truth for cluster state. Example: I merge a PR to change an image tag and ArgoCD applies it.
- **Sync** — making the cluster match the repo. Example: `argocd app sync my-app`.
- **Sync status** — `Synced`, `OutOfSync`, or error.
- **Health** — `Healthy`, `Degraded`, `Progressing`. Example: a Pod pulling an image is `Progressing`.
- **App of Apps** — one Application deploys others, managing the whole cluster from one repo.

## A tiny example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
spec:
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps
    path: guestbook
  destination:
    namespace: guestbook
    server: https://kubernetes.default.svc
```

This Application syncs the guestbook example from the official repo into the `guestbook` namespace.

## What I'll cover next

I want to install ArgoCD on a local cluster and push an Application through the UI and CLI to see the sync cycle in action.
