---
last_verified: 2026-10-05
tool_version: n/a
sources: []
---

# demo-chart

Fixture for the walkthrough in `Helm/docs/values-management-approaches.md`.
Run every command below from `Helm/manifests/` — this is one way to lay the
files out; the docs also show `--set`-only overrides that need no file at all.

## Purpose

A minimal chart (Deployment + Service + optional Ingress) with just enough
values to show the three approaches side by side: `--set` flags,
per-environment files, and the `demo-chart.labels` named template. The
defaults live in `values.yaml`; each environment file carries only its deltas,
and `values-common.yaml` holds the baseline shared by all environments.

## What's inside

- `Chart.yaml`, `values.yaml` — chart metadata and defaults.
- `values-common.yaml` — shared baseline (service, resources, pull policy).
- `values-staging.yaml`, `values-production.yaml` — per-environment deltas.
- `templates/` — `deployment.yaml`, `service.yaml`, `ingress.yaml`
  (rendered only when `ingress.enabled` is true), and `_helpers.tpl` with the
  `demo-chart.labels` helper the docs quote.

## Steps

```bash
helm lint ./demo-chart
helm install web-demo ./demo-chart -f ./demo-chart/values-common.yaml -f ./demo-chart/values-staging.yaml
helm upgrade web-demo ./demo-chart -f ./demo-chart/values-common.yaml -f ./demo-chart/values-production.yaml
helm upgrade web-demo ./demo-chart --set replicaCount=5
```

## Verify

```bash
helm template web-demo ./demo-chart -f ./demo-chart/values-common.yaml -f ./demo-chart/values-staging.yaml | grep "replicas:"
helm template web-demo ./demo-chart --set replicaCount=5 | grep "replicas:"
helm get values web-demo
```

The two `helm template` runs should each show the override landing in the
rendered manifests, and `helm get values` on a live release confirms what a
running release was actually deployed with.
