#!/bin/bash
# last_verified: 2026-09-30 · vault n/a
# vlt-009 scratch: install Vault and run my first secrets-engine command.
# I ran each line by hand; dev server keeps everything in memory.

vault --version  # TODO: fresh box says "command not found" until I add the HashiCorp apt repo

vault server -dev -dev-root-token-id=myroot
export VAULT_ADDR='http://127.0.0.1:8200'
vault secrets enable -path=my-secrets kv-v2  # TODO: not sure dev mode already mounts kv at secret/ — wanted my own path to learn enable
vault kv put my-secrets/first note="hello from my own engine"
vault kv get my-secrets/first
