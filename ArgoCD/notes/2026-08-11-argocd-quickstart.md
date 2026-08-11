---
last_verified: 2026-08-11
tool_version: 3.5.0
sources:
  - https://argo-cd.readthedocs.io/en/stable/getting_started/
  - https://argo-cd.readthedocs.io/en/stable/faq/
  - https://github.com/argoproj/argo-cd/releases/tag/v3.5.0
---

# ArgoCD quickstart — what tripped me up

I followed the official ArgoCD getting-started guide on a local kind cluster. Here's
what worked, and the spots where I got tripped up along the way.

## Following the quickstart

First I installed the control plane. The docs' default `kubectl apply -f install.yaml`
bit me — the ApplicationSet CRD is huge, and a plain client-side apply choked. The
guide's `kubectl apply -n argocd --server-side --force-conflicts -f <install.yaml>`
worked. I also pinned the manifest to the v3.5.0 release tag instead of leaving
`stable` in the URL, so a later refresh won't silently change what's installed.

Then I grabbed the bootstrap password and logged in:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

That dumped a plaintext admin password, which the docs say to rotate right away. I
kept it for the lab but deleted the initial secret afterward so it stops being a
footgun.

## Got stuck on

**The self-signed cert.** Out of the box the server has a self-signed certificate,
and the CLI/UI immediately warned about it. I hadn't expected that. The docs suggest
trusting the cert or using `--insecure` on CLI ops; I used `argocd login --core` to
skip the server entirely, which fast-forwarded me past the whole cert dance.

**Custom namespace.** I nearly installed into my own namespace, then noticed the
manifest's ClusterRoleBindings reference `argocd` by name. The docs warn that
switching namespaces means editing those references or the install fails. I stayed
on `argocd` for the lab.

**`selfHeal` vs auto-sync.** The primer mentioned both but I didn't get why teams
turn one off. Reading the FAQ: `automated` (auto-sync) applies new commits from Git;
`selfHeal` additionally reverts manual `kubectl edit` changes back to Git. With
`selfHeal` on, my manual tweaks got silently reverted within about a minute, which
was confusing until I realized it wasn't a bug. Mixing manual `kubectl apply` with
GitOps is the beginner trap.

**`prune` danger.** `prune: true` deletes cluster resources that disappear from Git.
The tutorial's caution about a broken generator returning zero resources deleting
everything made me keep pruning conservative in my lab manifests and lean on
ArgoCD's `allowEmpty: false` default rather than trust it alone.

## What I'd try next

A fresh app syncs cleanly once I run `argocd app sync`, but I want to see the
`OutOfSync` → `Synced` cycle from the UI, and then wire the guestbook through an
ApplicationSet like the template one I wrote separately, so one generator manages
several namespaces at once.

Reading the quickstart didn't feel like installing a CI tool at all — ArgoCD is CD
only, it never builds images or runs tests. CI tools build and test; ArgoCD deploys
from Git. Keeping that boundary clear is what most docs examples assume you already know.