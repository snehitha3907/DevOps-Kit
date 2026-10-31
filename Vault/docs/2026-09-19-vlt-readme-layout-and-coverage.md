---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# Document vlt/ in README Layout + Coverage table and topics.md

I went to add the HashiCorp Vault folder to the README and found it was already half-there: the Layout entry and the Coverage row both mention `vlt/`, but neither said what was actually inside the folder, and `00_index/topics.md` had no Vault section at all.

## What I found

- **README Layout** (line 47): `- **vlt/** — HashiCorp Vault primer, dev server setup, and KV engine examples (added per changelog vlt-001, vlt-002).`
- **Coverage table** (line 75): `| HashiCorp Vault | 1 | — | 1 | — | — | — | — | — | — | — |`
- **topics.md**: no Vault section existed — the folder was invisible in the topic map.

## What I changed

1. **README Layout** — left the existing `vlt/` bullet as-is; it already names the primer and dev-server script, which is what's actually on disk.
2. **README Coverage table** — corrected the HashiCorp Vault row to Notes=2, Scripts=1, matching `vlt/notes/` (the primer plus the exploration note) and `vlt/scripts/` (the install-and-start-dev-server script). Added `Last verified` as `2026-09-19` so the row stops being the only one in the table without a date.
3. **00_index/topics.md** — added a `HashiCorp Vault · 3 files` section with a primer link and a notes (2) / scripts (1) breakdown, so the topic map finally points at the folder.

## What's in vlt/

- `notes/0000-primer-vlt.md` — what Vault is, seal/unseal, dev server, KV engine, policies, tokens, VAULT_ADDR.
- `notes/2026-09-19-explore-vault-cli-secrets-policies.md` — first CLI run: `vault status`, `kv put`/`kv get`, and where policies sit next.
- `scripts/2026-09-19-install-vault-cli-and-start-dev-server.sh` — install the CLI, start a dev server, write and read one KV secret.

The Coverage row now matches the three files on disk, and topics.md has a Vault section linking to all of them.