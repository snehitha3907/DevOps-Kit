---
last_verified: 2026-11-20
tool_version: 2.2.2
sources:
  - https://developer.hashicorp.com/vault/docs/concepts/dev-server
  - https://developer.hashicorp.com/vault/docs/commands/kv
  - https://developer.hashicorp.com/vault/docs/secrets/kv/kv-v2/setup
  - https://developer.hashicorp.com/vault/docs/concepts/policies
  - https://developer.hashicorp.com/vault/docs/concepts/tokens
  - https://developer.hashicorp.com/vault/docs/get-started/developer-qs
  - https://github.com/hashicorp/vault/releases/tag/v2.2.2
---

# Store and read secrets with Vault

In the previous lesson you injected a database password into a pod as a Kubernetes Secret, which keeps the value out of your image but still leaves it sitting in the cluster. This lesson moves that secret into Vault, where it lives in one place, is versioned, and is handed out to an app only through a token whose policy permits reading exactly that secret. Vault then becomes the single source of truth instead of a YAML file on disk.

## What you'll learn

- Start Vault in dev mode and confirm the CLI can reach it.
- Write, read, and version a secret in the KV v2 secrets engine.
- Write a policy that grants read access to one app's secret path and issue a token bound to it, so a leaked token exposes only that secret.

## Before you start

- [Configuration, secrets and ingress](../07-kubernetes/03-k8s-config-and-ingress.md) — how a database password currently reaches the sample app as a Kubernetes Secret; this lesson replaces that static secret with a Vault-backed one.
- Vault installed; confirm with `vault version` (this lesson was written against 2.2.2).
- Two terminals (or a tmux split): one to run the dev server, one to run commands.
- A working directory for the policy file; the reference copy lives at [`Vault/configs/app-read-only-policy.hcl`](../../Vault/configs/app-read-only-policy.hcl).

## Walkthrough

### 1. Start a dev server and point the CLI at it

Dev mode runs Vault entirely in memory: it is already initialized and unsealed, the root token is printed on startup, and a v2 KV engine is mounted at `secret/`. Nothing survives a restart, which is exactly what you want for learning.

In terminal 1:

```bash
vault server -dev -dev-root-token-id=root
```

You should see a line like `Root Token: root` and `Vault server started!`. Leave this terminal running.

In terminal 2, tell the CLI where the server is and authenticate:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root
vault status
```

You should see `Sealed: false` and `Storage Type: inmem`. From here on every command in this lesson assumes those two environment variables are set in the shell you are typing in.

### 2. Write and read a KV v2 secret

Store the database credentials under `myapp/config`:

```bash
vault kv put -mount=secret myapp/config username=admin password=s3cret
```

You should see `Success! Data written to: secret/data/myapp/config`, which confirms the KV v2 data path is `secret/data/...`.

Read it back:

```bash
vault kv get -mount=secret myapp/config
```

You should see the two keys with their values, plus `Metadata` showing `Version: 1`.

Because KV v2 is versioned, every `put` creates a new version rather than overwriting. Put a new password and check the version:

```bash
vault kv put -mount=secret myapp/config username=admin password=newer
vault kv get -mount=secret myapp/config
vault kv get -mount=secret -version=1 myapp/config
```

The first read shows `Version: 2` with `newer`; the last read shows the original `s3cret` from version 1. Use `vault kv patch -mount=secret myapp/config password=patched` when you only want to change one key without resending the rest.

### 3. Write a read-only policy for the app

A policy is a written rule about which paths a token may touch. For KV v2 the data path is `secret/data/<path>`, so a policy that lets an app read only its own secrets looks like this (also saved as the companion file above):

```hcl
path "secret/data/myapp/*" {
  capabilities = ["read"]
}
```

Save that as `app-read-only-policy.hcl`, then load it into Vault:

```bash
vault policy write myapp-read app-read-only-policy.hcl
vault policy read myapp-read
```

You should see the policy echoed back. Capability names you will use most: `create`, `read`, `update`, `patch`, `delete`, `list`, and `deny`. An explicit `deny` on a sub-path overrides a broader grant, which is how you carve exceptions out of a wildcard.

Tip: run `vault kv get -output-policy -mount=secret myapp/config` to have Vault print the minimal policy for that exact operation, then tighten it by hand.

### 4. Issue a scoped token and prove the boundary

Create a token bound to the policy:

```bash
vault token create -policy=myapp-read
```

You should see a `token` field (something like `hvs....`). Save it, then open a fresh shell and use only that token:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=<the-token-from-above>
vault kv get -mount=secret myapp/config
```

That read succeeds because the policy allows `secret/data/myapp/*`. Now try a path outside the grant:

```bash
vault kv put -mount=secret otherapp/config password=nope
```

You should see `permission denied`, because the token has no `create` capability and no access to `otherapp`. That is the point of the policy: a leaked app token exposes only `myapp`, not the whole store.

Two things to remember. Policies are attached to a token at issue time, so if you change `myapp-read` later you must issue a new token and re-authenticate — the old token keeps its original policy set. And root tokens grant full access; use them only for bootstrap and emergency work, and create scoped tokens with `vault token create -policy=...` for everything else, including the ones your applications run with.

## Exercise

1. Start a dev server and store two secrets: `myapp/config` with `username=admin password=s3cret`, and `otherapp/config` with `password=other`.
2. Write a policy `myapp-read` that grants `read` on `secret/data/myapp/*` only, load it, and issue a token bound to it.
3. Using only that token, read `myapp/config` successfully and confirm that reading `otherapp/config` is denied. Then use the root token to read both, and note the difference.

No solution is provided here; the walkthrough above contains every command you need.

## Check your work

With the scoped token exported:

```bash
VAULT_TOKEN=<scoped-token> vault kv get -mount=secret myapp/config
```

Expected: the secret's keys and values print, with `Version: 1` (or higher if you re-ran the puts).

```bash
VAULT_TOKEN=<scoped-token> vault kv get -mount=secret otherapp/config
```

Expected: `Error making API request: ... Code: 403; permission denied` (or equivalent `permission denied`), proving the policy boundary holds. If instead the secret prints, your policy path is too broad or the token predates the policy — re-issue the token.

## Common mistakes

- `connection refused` or the CLI cannot reach Vault: `VAULT_ADDR` is unset in this shell, or the dev server is not running. Export `VAULT_ADDR='http://127.0.0.1:8200'` and restart the dev server. The token changes on restart unless you pass `-dev-root-token-id`.
- `permission denied` on `vault kv put/get` with a scoped token: the policy path does not match the KV v2 data path (`secret/data/...`), or the token was issued before the policy change. Fix the path and re-authenticate.
- `vault kv put` creates version 2 instead of overwriting: KV v2 is versioned by design. Read a specific version with `-version=N`, or use `vault kv patch` for partial updates.
- `invalid path` / `no handler for route`: the policy or API call uses the v1 form (`secret/<key>`) against a v2 mount. Use `secret/data/<key>` (or the `-mount` flag).
- Root token leaked or dev server restarted with a new token: pass `-dev-root-token-id` to keep a stable token across restarts. Never use dev mode or root tokens outside learning.

## Next

[Remove static secrets from the cluster](03-vault-secrets-in-kubernetes.md)
