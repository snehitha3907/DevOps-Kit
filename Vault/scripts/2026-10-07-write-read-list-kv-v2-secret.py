#!/usr/bin/env python3
# last_verified: 2026-10-07 · hvac (Vault API client)
# vlt-014 scratch: write a KV v2 secret, read it back, and list its versions.
# I ran this against `vault server -dev -dev-root-token-id=myroot` with
# VAULT_ADDR=http://127.0.0.1:8200 in the shell.
import os
import sys

import hvac

VAULT_ADDR = os.environ.get("VAULT_ADDR", "http://127.0.0.1:8200")
VAULT_TOKEN = os.environ.get("VAULT_TOKEN", "myroot")
PATH = "secret/hello"
DATA = {"user": "alice", "password": "s3cret"}


def main():
    client = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN)
    if not client.is_authenticated():
        print("ERROR: not authenticated", file=sys.stderr)
        sys.exit(1)

    # 1. Write the secret (KV v2 — this creates version 1).
    client.secrets.kv.v2.create_or_update_secret(path=PATH, secret=DATA)
    print(f"wrote {PATH} (version 1)")

    # 2. Read it back.
    read = client.secrets.kv.v2.read_secret_version(path=PATH, version=1)
    print(f"read {PATH} v1:", read["data"]["data"])

    # 3. Write again — KV v2 creates version 2, it does not overwrite.
    client.secrets.kv.v2.create_or_update_secret(path=PATH, secret={"user": "bob"})
    print(f"wrote {PATH} again (version 2)")

    # 4. List the versions that exist for this path.
    versions = client.secrets.kv.v2.list_secrets(path=PATH)
    print("versions at", PATH, ":", versions["data"]["keys"])


if __name__ == "__main__":
    main()