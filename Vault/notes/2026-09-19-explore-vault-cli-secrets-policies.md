---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# Exploring the vault CLI — secrets, policies, and what's there

I started the dev server from my install script and poked at the CLI to see what's actually there. Everything below ran against `vault server -dev` with `VAULT_ADDR` pointed at it, so nothing left my machine.

## status told me it's alive

First thing I ran was `vault status`. It printed that the server is unsealed with a local key setup — dev mode skips the whole unseal ceremony from the primer, which was a relief. If `VAULT_ADDR` is wrong this just errors, so that export line in my script is doing real work.

## kv put and get just work

Then I stored something and read it back:

```
vault kv put secret/first-run note="hello from dev mode"
vault kv get secret/first-run
```

The put wrote one key under `secret/`, and get printed it back with some extra metadata around it. So the path after `secret/` is mine to choose, and each path holds a little bag of keys. That matches the primer's secrets-engine idea — now I've actually touched it.

## Policies are still just an idea to me

I know from the primer that a policy is the written rule for who can read which path, and that apps log in with tokens instead of passwords. But I haven't written a policy file or tried `vault login` with anything except the dev root token yet, so I'm not going to pretend I know that flow.

## What I'd try next

Write a tiny read-only policy for `secret/first-run`, make a token for it, and confirm the token can get but not put. That'll turn the policy paragraph from the primer into something I've actually run.
