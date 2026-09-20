---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# Document plm/ in README Layout + Coverage table

I went to link the Pulumi folder from the README and found it was invisible: no Layout bullet and no Coverage row, even though `plm/` has three files on disk since 2026-09-19.

## What I found

- **README Layout**: bullets run Prometheus straight to Terraform with nothing for `plm/`.
- **Coverage table**: rows run Prometheus straight to Terraform with no Pulumi row.
- **On disk**: `notes/0000-primer-plm.md`, `scripts/2026-09-19-install-pulumi-cli-and-init-project.sh`, `snippets/2026-09-19-minimal-bucket-with-pulumi-python.py`.

## What I changed

1. **Layout** — added a `plm/` bullet naming the primer, the install-and-init script, and the bucket snippet.
2. **Coverage** — added a Pulumi row: Notes=1, Docs=1 (this note), Scripts=1, Snippets=1, Last verified 2026-09-20. I counted this note itself in Docs so the row matches the folder after merge.

## What's in plm/

- `notes/0000-primer-plm.md` — what Pulumi is and the tiny bucket example.
- `scripts/2026-09-19-install-pulumi-cli-and-init-project.sh` — check the CLI, scaffold a Python project, init a dev stack, and preview.
- `snippets/2026-09-19-minimal-bucket-with-pulumi-python.py` — one bucket with its name kept as a stack output.

I left `00_index/topics.md` alone on purpose — the Maintainer regenerates the index from the file tree each cycle, so a Pulumi section gets picked up there without me hand-editing it.
