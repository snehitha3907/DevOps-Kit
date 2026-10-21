---
last_verified: 2026-10-21
tool_version: n/a
sources:
  - https://helm.sh/docs/helm/helm_lint/
---

# Helm chart testing strategies

## Purpose

Chart authoring is only half the work; the other half is proving a chart renders correctly and installs cleanly across environments. This doc collects the three layers of chart testing used in practice: `helm lint`/`helm template` for static checks, `helm-unittest` for logic assertions, and JSON schema validation for values.

## When to use

- Before merging a chart change in a PR.
- When a chart grows templates with conditionals (`if`, `range`, `with`) that are easy to break.
- When downstream consumers supply arbitrary values and you want to reject bad input early.

## Prerequisites

- Helm 3 installed.
- Optional: `helm-unittest` plugin (`helm plugin install https://github.com/helm-unittest/helm-unittest`).
- Optional: `kubeval`/`kubeconform` for rendered-manifest validation.

## Strategies

### 1. Static lint and render

Run the built-in linter and a local render before any extra tooling:

```bash
helm lint ./chart
helm template release-name ./chart -f values.yaml
```

`helm lint` reports chart-syntax and values problems; `helm template` renders manifests without touching a cluster, confirming templates expand against `values.yaml`.

### 2. Unit tests with helm-unittest

helm-unittest lets you assert on rendered output using YAML test specs under `tests/`:

```yaml
suite: deployment tests
templates:
  - deployment.yaml
tests:
  - it: should set replicas from values
    set:
      replicaCount: 3
    asserts:
      - equal:
          path: spec.replicas
          value: 3
```

Run with `helm unittest ./chart`. Keep specs next to the templates they exercise.

### 3. Schema validation

Add `values.schema.json` at the chart root to validate input values at install time. Helm validates against it during `helm install`/`helm upgrade` and `helm lint`.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "replicaCount": { "type": "integer", "minimum": 1 }
  },
  "required": ["replicaCount"]
}
```

### 4. Rendered-manifest validation

Pipe `helm template` output through `kubeconform` to catch invalid Kubernetes API objects:

```bash
helm template release-name ./chart | kubeconform -strict -summary
```

## Verify

- `helm lint ./chart` exits 0.
- `helm unittest ./chart` reports all suites passing.
- `helm template` output validates with `kubeconform`.

## Common errors

- **Schema rejects valid values**: schema `type` too narrow (e.g. integer vs number). Relax or add `oneOf`.
- **Unit test path mismatch**: `path` uses JSON-pointer-ish segments; check rendered YAML keys exactly.
- **kubeconform complains about CRDs**: pass `-skip` for CRD kinds or supply schemas.

## References

- Helm lint docs: https://helm.sh/docs/helm/helm_lint/
