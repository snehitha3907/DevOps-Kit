---
last_verified: 2026-08-07
tool_version: n/a
sources: []
---

# Helm quickstart — what tripped me up

I followed the official Helm quickstart to install my first chart and see how releases work. Here is what actually happened versus what I expected, and the parts that slowed me down.

## Step 1: Adding the Bitnami repo and installing PostgreSQL

The guide says to add the Bitnami repo and install PostgreSQL with one command. I ran `helm repo add bitnami <repo-url>` and then installed the chart with a password set via `--set`. The install completed in a few seconds and `helm list` showed the release.

```bash
helm repo add bitnami <repo-url>
helm install my-db bitnami/postgresql \
  --set auth.postgresPassword=secret \
  --set primary.persistence.size=10Gi
helm list
```

## Step 2: Exploring the release

I ran `helm status my-db` to see the deployed revision and `helm get all my-db` to inspect the rendered manifests. I also tried `helm upgrade my-db bitnami/postgresql --set replicaCount=2` to see how Helm tracks changes. The revision went from 1 to 2 and the old pods stuck around briefly while the new ones came up.

## Got stuck on

**1. `helm install` fails if the release name already exists.** I tried reinstalling with the same name after a failed first attempt. Helm treats the release name as a unique identifier in the namespace. I had to run `helm uninstall my-db` before I could install again. That is obvious in hindsight, but the quickstart does not mention it.

**2. Values override syntax is easy to typo.** I used `--set primary.persistence.size=10Gi` correctly, but at one point I wrote `--set primary.persistence.size=10gi` (lowercase) and the chart accepted it without error, then the PersistentVolumeClaim requested an invalid size. The chart did not validate my input. I had to check the generated manifest with `helm get manifest my-db` to spot the lowercase issue.

**3. Repo updates do not happen automatically.** After installing, I later ran `helm search repo postgresql` and got an older version than what was on Bitnami. The quickstart mentions `helm repo update` in passing, but I missed it. I had to run `helm repo update` manually before `helm upgrade` would see the newer chart version.

## What I'd try next

I want to create my own chart with `helm create` and inspect the template rendering with `helm template`. I also want to understand `values.yaml` overrides by passing a custom file instead of inline `--set` flags, because that is easier to version control. Finally, I want to try `helm rollback` to undo a bad upgrade.
