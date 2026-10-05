---
last_verified: 2026-10-04
tool_version: n/a
sources: []
---

# microservice-chart — a reusable Helm chart for an HTTP microservice

## Purpose

A starting point for teams that keep writing the same microservice chart: a Deployment behind a Service, fed from a ConfigMap, optionally fronted by an Ingress and an autoscaler, and wired to a PostgreSQL subchart for anything that is not yet talking to a managed database. The value is in the seams rather than in any one template — the naming helpers, the switch that turns the datastore subchart off, the guards that reject a values file the cluster would refuse, and the schema that catches a mistyped key before `helm install` does.

This is one reasonable shape, not the only one. Teams that do not want a subchart in the release can start from the same chart with `database.enabled=false` and set `config.dbHost` to a managed endpoint.

## What is in the box

```
microservice-chart/
├── Chart.yaml                  chart metadata, kubeVersion floor, the dependency declaration
├── values.yaml                 every knob, with the reason it exists
├── values.schema.json          JSON Schema Helm validates on lint, template, install and upgrade
├── .helmignore                 keeps docs and scratch values out of the packaged archive
├── README.md                   this file
├── templates/
│   ├── _helpers.tpl            naming, labels, image reference, merged pull secrets
│   ├── NOTES.txt               post-install summary printed by `helm install`
│   ├── configmap.yaml          non-secret config, projected into the container via envFrom
│   ├── deployment.yaml         the workload
│   ├── service.yaml            ClusterIP in front of the Deployment
│   ├── serviceaccount.yaml     created unless serviceAccount.create is false
│   ├── ingress.yaml            networking.k8s.io/v1, gated on ingress.enabled
│   ├── hpa.yaml                autoscaling/v2, gated on autoscaling.enabled
│   ├── pdb.yaml                policy/v1, gated on podDisruptionBudget.enabled
│   ├── migrate-job.yaml        pre-install/pre-upgrade hook Job, gated on migrations.enabled
│   └── tests/
│       └── test-connection.yaml  `helm test` Pod that hits the Service's /ready
└── charts/
    └── postgresql/             vendored subchart: Secret, Service, StatefulSet
```

## The dependency, and why it is vendored

`Chart.yaml` declares one dependency with `repository: "file://charts/postgresql"`, `alias: database`, `condition: database.enabled` and `tags: [datastore]`. Three things follow from that:

- **`alias` decides where the values live.** The subchart's `values.yaml` is reachable as `.Values.database.*`, not `.Values.postgresql.*`, because the alias renames the subchart. Every `{{ .Values.database.* }}` in this chart depends on that one line.
- **`condition` is the switch.** `database.enabled=false` drops the subchart from the render entirely — no StatefulSet, no Secret, no Service — and the `microservice-chart.dbHost` helper falls back to `config.dbHost` so the Deployment still has something to dial.
- **`file://` means no network.** The subchart is already unpacked under `charts/`, so `helm lint`, `helm template` and `helm install` all work with no chart repository configured and no credentials.

The subchart calls `microservice-chart.databaseServiceName` back in the parent rather than defining its own name. Named templates are compiled across a chart and its subcharts as one set, so a subchart can reach a template the parent defines — and the parent is always compiled, whereas a disabled dependency's templates are not something the parent should depend on. One definition means the Service this chart creates and the host the Deployment dials cannot drift apart.

## Steps

Commands assume the current directory is the chart root.

Render the manifests without touching a cluster:

```bash
helm lint .
helm template orders . | less
helm template orders . --output-dir /tmp/rendered
```

--output-dir` additionally writes each rendered manifest to its own file, which makes it easy to diff two value sets:

```bash
helm template orders . --output-dir /tmp/default
helm template orders . -f values-staging.yaml --output-dir /tmp/staging
diff -ru /tmp/default /tmp/staging
```

Either form already catches structural mistakes. Helm splits the rendered output into documents before doing anything else, so a template that produces invalid YAML fails here — not at install time — with the file name and line, e.g. `YAML parse error on microservice-chart/templates/service.yaml`.

Turn features on the way you normally would — a second values file rather than a wall of `--set`:

```bash
cat > values-staging.yaml <<'YAML'
replicaCount: 3
image:
  tag: "2.4.1"
config:
  featureFlags:
    checkout-v2: true
autoscaling:
  enabled: true
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: orders.staging.example.com
      paths:
        - path: /
          pathType: Prefix
YAML

helm template orders . -f values-staging.yaml --output-dir /tmp/rendered
```

The features are independent, so any subset works: `autoscaling`, `ingress`, `podDisruptionBudget`, `migrations` and `database` each gate only their own template. Setting `database.enabled=false` while `migrations.enabled=true` is a normal combination — migrations run against the managed database the operator points `config.dbHost` at.

Install and check:

```bash
helm upgrade --install orders . -f values-staging.yaml --namespace orders --create-namespace
helm test orders --namespace orders
kubectl --namespace orders get all,ingress,hpa,pdb
```

## Verify

- `helm lint .` reports `0 chart(s) failed`. With `--strict` it is still clean; the only message is an `[INFO]` that `icon` is recommended.
- `helm template orders . | grep '^kind:'` prints eight manifests: `ConfigMap`, `Deployment`, `ServiceAccount`, two `Service`s (the chart's own and the subchart's), `Secret` and `StatefulSet` from the subchart, and `Pod` from the `helm test` hook. Turning on `autoscaling`, `ingress`, `podDisruptionBudget` and `migrations` adds `HorizontalPodAutoscaler`, `Ingress`, `PodDisruptionBudget` and `Job`.
- The names line up. With release name `orders`, the Deployment, Service and ConfigMap are `orders-microservice-chart`, the subchart's Service and Secret are `orders-postgresql`, and the ConfigMap's `dbHost` reads `orders-postgresql` — derived from the same helper, not a second hardcoded string.
- `helm test` runs the connection Pod against `<service>:<service.port>/ready` and deletes it on success.
- The guards fire when the values cannot work: enabling `autoscaling` with both utilisation targets at zero, setting `minReplicas` above `maxReplicas`, enabling `podDisruptionBudget` with neither or both of `minAvailable` and `maxUnavailable`, or enabling `ingress` with no `className` and no annotations. Each aborts the render with a message naming the offending key.

## Common errors

**`helm dependency update` leaves a `.tgz` behind.** The dependency's source and its destination are the same directory, so the command saves `charts/postgresql-0.1.0.tgz` next to the unpacked `charts/postgresql/`. The chart still lints and renders — this is verified, not theoretical — but the archive is a build artefact. Delete it and commit only the unpacked directory. `helm dependency list` reports the vendored copy as `unpacked`, which is the status to expect.

**The migration Job runs before the database exists on a first install.** Hooks are created before the release's ordinary resources, so `migrations.enabled=true` with `database.enabled=true` puts the pre-install Job ahead of the subchart's StatefulSet and the Job has nothing to connect to. On upgrades this does not bite, because the StatefulSet is already there — which makes it the kind of failure that passes every test until someone builds a fresh environment. Move the annotation to `post-install,pre-upgrade` and raise `helm.sh/hook-weight` above `-5` when the chart owns the datastore.

**The generated database password rotates on every upgrade.** With `database.auth.password` empty the subchart generates one at render time, so a re-render — any `helm upgrade`, even one that changes nothing — writes a new value into the Secret. The StatefulSet reads it through `secretKeyRef` and only picks it up on restart. Set `database.auth.password` from a secret manager for anything that is not a throwaway cluster.

**`helm template` will not show you NOTES.txt.** It is excluded from the rendered manifest set, so `helm template | grep` never finds it and `--show-only templates/NOTES.txt` errors with `could not find template`. Read it after an install with `helm get notes`, or from a `helm install --dry-run` against a reachable cluster.

**A values file is rejected before any cluster call.** `values.schema.json` runs on `helm lint`, `helm template`, `helm install` and `helm upgrade`, so a typo fails with the key path rather than an API error:

```
Error: values don't meet the specifications of the schema(s) in the following chart(s):
microservice-chart:
- image.pullPolicy: image.pullPolicy must be one of the following: "Always", "IfNotPresent", "Never"
```

## Adopting it for a service

1. Copy the directory and rename it after the service.
2. Set `name`, `description`, `maintainers` and `annotations` in `Chart.yaml`; set `image.repository` to the service's own image and `appVersion` to the tag it ships.
3. Rename the template prefix in `_helpers.tpl` — `microservice-chart.*` to the new chart name — so the helpers cannot be confused with a sibling chart's.
4. Keep the `{{/* ... */}}` comments at the top of `_helpers.tpl`. Each one records a decision that is easy to undo by accident.
5. Point `values.schema.json`'s `title` at the new chart and re-run the Verify section above.
