---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# Exploring the Flux CLI command surface

I just installed the Flux CLI and read through what it can do. The primer covered what Flux is (a GitOps operator for Kubernetes); this note is about the commands I actually ran.

## bootstrap

`flux bootstrap` installs Flux and wires it to a Git repo in one shot — namespace, CRDs, deployment, deploy-key secret. I ran:

```
flux bootstrap --provider=github --owner=<user> --repository=<repo> --branch=main --path=clusters/my-cluster
```

It handled the OAuth flow, pushed the manifests to the repo, and committed them. After it finished the cluster had Flux pulling from that path. This is the day-one command; everything else builds on it.

## reconcile

`flux reconcile` re-syncs an object now instead of waiting for the next interval. `flux reconcile kustomization <name>` targets one resource, and `--with-source` pulls the Git source down first. I used this a lot while testing — it makes the feedback loop much shorter than editing YAML and waiting.

## tree

`flux tree` prints the dependency graph of Flux-managed resources:

```
Kustomization/my-app
└── HelmRelease/my-app
    └── HelmRepository/my-app
```

Handy when a HelmRepository fetch is failing — the chain is obvious instead of digging through `kubectl get`. It also accepts `-o dot` for Graphviz output.

## What else is there

`flux get kustomizations` and `flux get helmreleases` give compact ready/failed tables. `flux create kustomization` scaffolds a new Kustomization from the CLI instead of hand-writing YAML. `flux uninstall` is the reverse of bootstrap.

## What tripped me up

- `--path` in bootstrap is a directory inside the repo where Flux looks for manifests, not a local filesystem path.
- `flux reconcile` with no arguments reconciles everything, which is slow on a big cluster — target a specific resource when you can.
- `flux get` only shows Flux-managed resources; a plain `kubectl get all` shows far more and can be misleading.

## What I'd try next

Bootstrap Flux onto a second cluster, then use `flux tree` to map out a multi-Kustomization app so I can see how the dependency chain flows. I also want to try `flux create kustomization` to generate manifests instead of writing them by hand.