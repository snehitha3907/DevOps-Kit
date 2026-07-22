---
last_verified: 2026-07-22
tool_version: n/a
sources: []
---

# Helm — quick primer

> First-day notes for someone who's never used Helm. Personal voice, plain language.

## What is it?

Helm is the package manager for Kubernetes. If you have used `apt` or `brew`, the mental model is the same: wrap related files into a versioned unit, install with one command. I got into Helm because editing raw YAML was getting tedious.

## What does it do?

Helm packages Kubernetes manifests into a chart — a templated directory plus a `values` file. You install a chart to create a release, then upgrade it later. Helm tracks every revision so you can see what changed.

## Why does it exist?

Before Helm, I applied a Deployment YAML, then a Service, then a ConfigMap, with a note for each version. Helm replaces that notebook with versioned releases you can inspect and compare.

## Key terminology

- **Chart** — The Helm package (templates + metadata). Example: a WordPress chart packaging Deployment and Service.
- **Release** — A running instance of a chart. Example: `myapp-staging` and `myapp-prod`.
- **values.yaml** — Default configuration for a chart. Override keys to change behavior. Example: `replicaCount: 3`.
- **Repository** — A hosted collection of charts. Example: the Bitnami repo.
- **Template** — A Kubernetes manifest with Go templating placeholders Helm renders at install. Example: `{{ .Values.service.type }}` becomes `ClusterIP`.

## A tiny example

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-db bitnami/postgresql \
  --set auth.postgresPassword=secret \
  --set primary.persistence.size=10Gi
```

This downloads the chart and installs it into the current namespace.

## What I'll cover next

I want to install Helm locally, run `helm version`, and explore repo management. Then I will create my first chart with `helm create` to see the structure, and try `helm upgrade`.
