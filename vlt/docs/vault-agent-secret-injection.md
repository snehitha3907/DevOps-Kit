---
last_verified: 2026-10-25
tool_version: n/a
sources: []
---

# Wiring Vault Agent into a containerized app for secret injection

## Purpose
Run a Vault Agent sidecar next to an app container so the app reads secrets from a shared volume instead of calling the Vault API directly. The Agent authenticates to Vault, renders secrets through its template engine, and the app consumes them as plain files. I wrote this up after wiring it into a small containerized app; it is one way to do it, and the Vault docs describe the alternatives.

## Prerequisites
- A running Vault cluster reachable from the cluster (VAULT_ADDR).
- An auth method enabled: Kubernetes auth for a cluster workload, or AppRole with a role_id/secret_id pair.
- A Vault policy that grants read access only to the secret paths the app needs.
- Permission to run a sidecar container and mount an emptyDir volume shared with the app.

## Steps
1. Write a least-privilege policy covering only the app's secret path, e.g. `secret/data/app/*` with `read` and `list` capabilities.
2. Enable the auth method and create a role: a Kubernetes auth role bound to a service account, or an AppRole role bound to the policy above.
3. Add a Vault Agent sidecar to the pod spec: the `hashicorp/vault-agent` image, the agent config mounted as a ConfigMap, and an emptyDir volume shared with the app container.
4. Configure the Agent's `auto_auth` and `template` blocks: sink type `file`, with the template source and destination inside the shared volume.
5. Point the app at the rendered secret file and restart it to confirm it picks up the injected secret.

## Verify
- `kubectl exec` into the app container and `cat` the rendered secret file — it should contain the secret value, not the template placeholder.
- `vault token lookup` with a token issued by the role confirms the attached policy.
- Delete and recreate the pod; the rendered file should reappear on Agent startup.

I have not tested this against a production cluster, and I have not measured the Agent's restart behaviour when Vault is unreachable, so treat timing and retry settings as things to tune rather than settled guidance.
