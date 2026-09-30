---
last_verified: 2026-09-30
tool_version: n/a
---

# Flux quickstart, and what tripped me up

I followed the Flux quickstart end to end this session: get the CLI on a kind cluster, create a namespace, point Flux at a Git repo, apply something with Kustomize, then let Flux reconcile it. It took maybe half an hour, but two things cost me most of that time and neither was in the quickstart text.

## What worked

The CLI is the whole quickstart. Install it with the script I already saved at `../scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh` (it drops the `flux` binary in place and then runs `flux check --pre`, which tells you whether the cluster has the pieces Flux needs). After that the flow is:

```
flux create ns demo
flux create kustomization demo --source=flux-system --path=./demo --prune=true
```

I ran the create commands and then a `kubectl apply` of the same manifests by hand, so I could see the same objects arriving from two directions. `flux get kustomizations` and `flux get all` are the commands I ended up living in while iterating.

## Got stuck on

- **The namespace and the manifests are not optional.** `flux create ns demo` makes the namespace, but nothing puts anything *in* it. Until I wrote a Deployment and a Service and applied them, the Kustomization just sat there reconciled against a path that had no workloads in it. The Git-side path and the cluster-side objects are two separate halves and both have to exist.
- **`--path` is a path inside the Git repo, not on my laptop.** I pointed it at a local directory first and the sync source came back empty. The moment I pointed it at a path that actually existed in the pushed repo, the source came up.
- **Nothing appears instantly.** After a commit I kept running `kubectl get` before the reconcile interval had elapsed. `flux reconcile kustomization demo --with-source` is what I use now to force the pull-and-apply instead of waiting.
- **Reading the actual diff matters.** `flux diff kustomization demo` showed me the exact change I was about to make. I only started using it after I had already edited the cluster by hand once and the reconciliation quietly undid me.

## What I'd try next

Put the manifests in the repo and stop applying them with `kubectl` at all, so Flux is the only thing writing to the cluster — I want to see what breaks when I remove my own hand. Then try `flux suspend` to prove that commits stop reaching the cluster, since right now I don't really trust that the Git path is the source of truth rather than my habit of running `kubectl apply`.
