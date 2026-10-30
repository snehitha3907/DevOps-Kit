#!/bin/bash
# last_verified: 2026-09-19 · vault n/a
# vlt-002 scratch: install the Vault CLI, then start a dev server.
# I ran each line by hand on a throwaway VM; dev mode keeps everything in memory.

vault --version  # TODO: "command not found" on a fresh box until I add the HashiCorp apt repo

vault server -dev -dev-root-token-id=myroot
export VAULT_ADDR='http://127.0.0.1:8200'
vault status
vault kv put secret/first-run note="hello from dev mode"  # TODO: confirm the kv engine path dev mode enables by default
vault kv get secret/first-run
