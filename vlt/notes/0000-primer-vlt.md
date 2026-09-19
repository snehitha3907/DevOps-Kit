---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# HashiCorp Vault — quick primer

> First-day notes for someone who's never used Vault. Personal voice, plain language.

## What is it?

I just learned Vault is a place to keep secrets — API keys, database passwords, tokens — so they stop living in env files and chat logs. The analogy that clicked for me: Vault is to app secrets what a password manager is to my logins. One guarded spot holds the real values, and everything else just asks for them when it needs them.

It sits in the secrets-management corner of the world. I already knew config files and environment variables; Vault is the next step after those stop being enough, when more than one person or service needs the same secret and I still want to control who sees what.

## What does it do?

It lets me stash a secret with one command, read it back with another, and hand out short-lived tokens so each app only sees what its policy allows. I can run a throwaway dev server on my own machine that keeps everything in memory, which is how I'm learning it before touching anything shared.

## Why does it exist?

Before tools like this, I kept secrets in `.env` files, deployment scripts, and sometimes straight in version control, which meant anyone with repo access had every password. Rotating one meant editing files on every machine and hoping I found them all. Vault exists so there is one place to store a secret, one place to change it, and a written rule (a policy) for who is allowed to read it. The people I see reaching for it day-to-day are folks running services that need database credentials, API keys, or certificates without baking them into images or repos.

## Key terminology

- **Seal / unseal** — a locked Vault refuses requests until it is unsealed with key shares. Example: `vault operator unseal <key-share>` (dev mode skips this; it starts unsealed).
- **Dev server** — a throwaway in-memory server for learning, nothing is saved to disk. Example: `vault server -dev`.
- **Secrets engine (KV)** — the key-value store where I keep simple secrets. Example: `vault kv put secret/app password=x`.
- **Policy** — a written rule saying which paths a token may read or write. Example: a policy granting read-only on `secret/app`.
- **Token** — the credential I present instead of a password. Example: `vault login <token>` (dev mode prints a root token for me).
- **VAULT_ADDR** — the env var telling the CLI where my server lives. Example: `export VAULT_ADDR='http://127.0.0.1:8200'`.

## A tiny example

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault server -dev -dev-root-token-id=myroot &
vault kv put secret/demo password=s3cret
vault kv get secret/demo
```

Starts a throwaway dev server, stores one secret under `secret/demo`, and reads it back.

## What I'll cover next

Next I want to actually install the CLI on my machine and start that dev server on purpose instead of just reading about it. After that I plan to poke at the CLI itself — writing a secret, reading it back, and seeing what policies and tokens look like from the inside.
