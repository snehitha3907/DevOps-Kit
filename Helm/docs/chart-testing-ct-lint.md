---
last_verified: 2026-10-05
tool_version: n/a
---

# Helm chart testing with chart-testing and `ct lint`

## Purpose

`helm lint` and `helm template` catch problems in a single chart, but they say nothing about which charts changed in a pull request or whether a chart still follows the repository's layout conventions. chart-testing (`ct`) fills that gap: it detects the charts a branch touched and runs a repeatable lint-and-install sequence over just those charts. This is one way to wire it up; smaller repositories sometimes get by with `helm lint` alone, and the steps below pair well with either approach.

The walkthrough below runs against the chart already in this kit at `Helm/manifests/redis-chart/` (`Chart.yaml`, `values.yaml`, `templates/deployment.yaml`, `templates/service.yaml`). All commands assume the repository root as the working directory.

## Steps

### 1. Lint the chart with Helm itself first

Run the built-in linter and a local render before involving any extra tooling, so basic templating mistakes surface early:

```bash
helm lint ./Helm/manifests/redis-chart
helm template release-name ./Helm/manifests/redis-chart | head -n 40
```

`helm lint` reports chart-syntax and values problems; `helm template` renders the manifests without touching a cluster, which confirms the templates in `templates/` actually expand against `values.yaml`.

### 2. Scope the run to changed charts

In a repository with more than one chart, linting everything on every change is slow and noisy. chart-testing compares the current branch against a base branch and lists only what moved:

```bash
ct list-changed
```

When only `Helm/manifests/redis-chart/` changed, only that chart proceeds to the next step. When nothing changed, there is nothing to lint and the run stops here.

### 3. Lint the changed charts with `ct lint`

`ct lint` combines chart-level checks (chart metadata, values, maintainers layout) with `helm lint` underneath:

```bash
ct lint
```

A minimal `ct.yaml` in the repository root keeps the invocation stable across machines and CI runners:

```yaml
chart-dirs:
  - Helm/manifests
target-branch: main
```

`chart-dirs` tells the tool where charts live (this kit keeps its example under `Helm/manifests/`), and `target-branch` sets the comparison base for the changed-chart detection in step 2. Keeping these two settings in a file rather than on the command line means local runs and pipeline runs behave the same way.

### 4. Exercise the install path

Linting proves the chart renders; installing proves it runs. Against a throwaway cluster, validate the install and then clean up:

```bash
ct install
```

`ct install` installs each changed chart, waits for readiness, and uninstalls afterwards, so a template that renders fine but references a missing value or an unmountable port fails here rather than after merge. For a quick local check without the full sequence, `helm install --dry-run` against the same chart previews what the cluster would receive.

## Verify

Confirm the whole sequence passes end to end on the example chart:

```bash
helm lint ./Helm/manifests/redis-chart
helm template release-name ./Helm/manifests/redis-chart > /tmp/rendered.yaml && grep -c "kind:" /tmp/rendered.yaml
ct lint
ct install
```

The first two commands confirm the chart lints and renders to non-empty manifests; `ct lint` confirms it passes the repository-level checks; `ct install` confirms it actually deploys and cleans up. If `ct list-changed` reports no changed charts on an unrelated branch, that empty result is itself the expected outcome — the tool correctly scoped the run down to nothing.
