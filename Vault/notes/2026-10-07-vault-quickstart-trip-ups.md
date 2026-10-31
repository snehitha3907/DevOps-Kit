---
last_verified: 2026-10-07
tool_version: n/a
sources: []
---

# Vault dev-mode quickstart — what tripped me up

I followed the official HashiCorp Vault quickstart and wrote down where it broke.

## What I did

Started a dev server, which is the whole quickstart:

```bash
vault server -dev -dev-root-token-id=myroot
```

Then in a second terminal:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault status
vault kv put secret/hello world="hi"
vault kv get secret/hello
```

Dev mode keeps everything in memory, so nothing is persisted — which is exactly what I want while learning. The first thing the quickstart does is print the root token; I saved it in a variable so I didn't have to copy it by hand.

## Got stuck on

**KV v2 is mounted at `secret/` by default, but `kv put` writes versions, not overwrites.**

I ran `vault kv put secret/hello world=hi` twice and expected the second call to replace the value. Instead `vault kv get secret/hello` showed `version: 2` and kept both. KV v2 is versioned by design — every `put` creates a new version, and the old ones stay until you destroy them. That's actually useful (I can roll back), but it surprised me because the quickstart's wording reads like a simple key/value store. If I want to overwrite without bumping the version I need `vault kv delete -versions 1 secret/hello` first, or use a non-versioned path.

**`vault kv get` prints metadata around the value, so parsing it by hand is annoying.**

The output has `key/value` pairs nested under `data`, plus `metadata` with the version and creation timestamp. I tried to eyeball the value at first and got confused by the extra fields. The fix is `-field=data` to pull just the data block, or `-format=json` if I want to pipe it into something.

**The CLI needs `VAULT_ADDR` or it can't find the server.**

I opened a fresh terminal and ran `vault kv get secret/hello` and got a connection refused error, even though the dev server was still running. The quickstart sets `VAULT_ADDR` in the same shell session, and I'd opened a new one. Exporting it again fixed it. Worth remembering that the address is per-shell, not global.

**Dev mode prints the token on startup, but only once.**

I closed the dev server terminal and restarted it, expecting the same root token. It printed a new one. The token is random per launch unless I pass `-dev-root-token-id` myself — which I did on the second run, and that's the version I'll use from now out so my scripts don't break.

## What I'd try next

Write a read-only policy for `secret/hello`, create a token bound to it, and confirm the token can `get` but not `put`. Then wire that up in the `hvac` Python script so I'm authenticating as a limited token instead of root.