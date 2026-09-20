---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# Flux CD: README Coverage table and topics.md update

I went to update the Flux CD row in the README Coverage table and the Flux CD section in 00_index/topics.md after noticing the counts were out of sync with what's on disk.

## What I found

On disk under `FluxCD/`:
- `notes/` has 1 file: `2026-09-19-explore-flux-cli-command-surface.md`
- `scripts/` has 1 file: `2026-09-19-install-flux-cli-and-run-flux-check-pre.sh`
- No `docs/`, `configs/`, `snippets/`, `manifests/`, `notebooks/`, `dockerfiles/`, `templates/` directories yet

README Coverage table currently shows for Flux CD:
| Flux CD | 1 | — | 1 | — | — | — | — | — | — | 2026-09-19 |

That matches what's on disk (Notes=1, Scripts=1). The task description mentioned "new Flux CD/notes + scripts on disk, Layout entry added 2026-09-19; needs Notes/Scripts counts and topic links" — the counts are already correct in the table.

But the topics.md Flux CD section (lines 48-51) shows:
```
## Flux CD  ·  2 files

- **notes** (1): [exploring the Flux CLI command surface](../FluxCD/notes/2026-09-19-explore-flux-cli-command-surface.md) — bootstrap, reconcile, tree, get, and the gotchas that tripped me up.
- **scripts** (1): [install Flux CLI and run flux check --pre](../FluxCD/scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
```

This also matches what's on disk. The header says "2 files" which is correct (1 note + 1 script).

## What I changed

Actually, looking more carefully at the task description: "Add Flux CD to README Coverage table and 00_index/topics.md (new Flux CD/notes + scripts on disk, Layout entry added 2026-09-19; needs Notes/Scripts counts and topic links)"

The Layout entry was already added in the README (line 35: "FluxCD/ — Flux CLI primer, bootstrap, reconcile, and pre-flight cluster checks.") and the Coverage table already has the row. The topics.md section already exists with correct counts and links.

It seems like this task might have been already satisfied by a prior update. Let me verify the README and topics.md are already correct.

## Verification

The README Coverage table Flux CD row shows Notes=1, Scripts=1 which matches disk.
The topics.md Flux CD section shows 2 files with correct links to both files.
The README Layout already has a FluxCD entry.

No changes needed — the coverage is already correct.
