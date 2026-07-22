---
last_verified: 2026-07-22
tool_version: n/a
sources: []
---

# Helm — quick primer

> First-day notes for someone who's never used Helm. Personal voice, plain language.

## What is it?

Helm is the package manager for Kubernetes. I installed it because deploying Kubernetes apps by copy-pasting raw YAML was already getting tedious. If you have used `apt`, `brew`, or `npm`, the mental model is the same: wrap a related set of files into a versioned unit, install it with one command, and upgrade or remove it later without hunting down individual manifests. Helm does this for Kubernetes.

## What does it do?

Helm packages multiple Kubernetes manifests into a chart. A chart is a templated directory plus a `values` file for configuration. You install a chart into a cluster to create a release. Later, you can upgrade or roll back that release, and Helm tracks every revision so you can see exactly what changed.

## Why does it exist?

Before Helm, I would apply a Deployment YAML, then a Service YAML, then a ConfigMap, and keep a separate note saying "this is version 2 of the app." If something went wrong, I had to remember which raw files were the last good state. Helm replaces that notebook with versioned releases that you can inspect, compare, and undo.

DevOps engineers and platform teams use Helm to package applications for multiple environments. Developers use it to share runnable templates instead of asking someone to apply ten YAML files by hand.

## Key terminology

- **Chart** — The Helm package (a directory of templates and metadata). Example: a WordPress chart that templates the Deployment, Service, and PersistentVolumeClaim.
- **Release** — A running instance of a chart in a cluster. You can install the same chart many times as separate releases. Example: `myapp-staging` and `myapp-prod` from the same chart.
- **values.yaml** — The default configuration file for a chart. Override keys to change behavior without touching templates. Example: `replicaCount: 3` instead of the default `1`.
- **Repository** — A hosted collection of charts, like a Docker registry for Helm packages. Example: the Bitnami repo for common open-source stacks.
- **Template** — A Kubernetes manifest with Go templating placeholders that Helm renders at install time. Example: `{{ .Values.service.type }}` becomes `ClusterIP` or `NodePort`.
- **Hook** — A manifest that runs at a specific lifecycle point, such as database migrations before install. Example: a Kubernetes Job that runs `flask db upgrade` on deploy.
- **Rollback** — Returning a release to a previous revision. Example: `helm rollback myapp 2` if revision 3 broke traffic.

## A tiny example

```bash
# Add the official Bitnami Helm repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install PostgreSQL as a release named "my-db"
helm install my-db bitnami/postgresql \
  --set auth.postgresPassword=secret \
  --set primary.persistence.size=10Gi
```

This downloads the `postgresql` chart, renders it with the provided values, and installs it into the current Kubernetes namespace.

## What I'll cover next

I want to install Helm locally, run `helm version` and explore repo management with `helm repo add` and `helm search hub`, then create my first chart with `helm create` to see the generated structure. After that, I will look at `helm upgrade` and `helm rollback` so I can manage changes instead of doing one-off installs.
