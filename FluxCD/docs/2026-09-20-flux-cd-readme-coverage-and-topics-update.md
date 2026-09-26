---
last_verified: 2026-09-22
tool_version: n/a
sources: []
---

# Flux CD: README Coverage table and topics.md update

I went to update the Flux CD row in the README Coverage table and the Flux CD section in 00_index/topics.md after noticing the counts were out of sync with what's on disk.

## What I found

On disk under `FluxCD/`:
- `notes/` has 1 file: `2026-09-19-explore-flux-cli-command-surface.md`
- `scripts/` has 1 file: `2026-09-19-install-flux-cli-and-run-flux-check-pre.sh`
- `docs/` has 1 file: `2026-09-20-flux-cd-readme-coverage-and-topics-update.md` (this file)
- No `configs/`, `snippets/`, `manifests/`, `notebooks/`, `dockerfiles/`, `templates/` directories yet

README Coverage table currently shows for Flux CD:
| Flux CD | 1 | — | 1 | — | — | — | — | — | — | 2026-09-19 |

That matches what's on disk (Notes=1, Scripts=1). The task description mentioned "new Flux CD/notes + scripts on disk, Layout entry added 2026-09-19; needs Notes/Scripts counts and topic links" — the counts are already correct in the table.

But the topics.md Flux CD section (lines 48-52) shows:
```
## Flux CD  ·  3 files

- **notes** (1): [exploring the Flux CLI command surface](../notes/2026-09-19-explore-flux-cli-command-surface.md) — bootstrap, reconcile, tree, get, and the gotchas that tripped me up.
- **scripts** (1): [install Flux CLI and run flux check --pre](../scripts/2026-09-19-install-flux-cli-and-run-flux-check-pre.sh)
- **docs** (1): [Flux CD coverage correction](./2026-09-20-flux-cd-readme-coverage-and-topics-update.md) — verified README Coverage table and topics.md counts against disk
```

> **Note:** The above excerpt is quoted from `00_index/topics.md` where the relative links resolve correctly from the repo root. Links here are adjusted to resolve from this file's location.

This matches what's on disk (3 files total: 1 note + 1 script + 1 doc).

## What I changed

Actually, looking more carefully at the task description: "Add Flux CD to README Coverage table and 00_index/topics.md (new Flux CD/notes + scripts on disk, Layout entry added 2026-09-19; needs Notes/Scripts counts and topic links)"

The Layout entry was already added in the README (line 35: "FluxCD/ — Flux CLI primer, bootstrap, reconcile, and pre-flight cluster checks.") and the Coverage table already has the row. The topics.md section already exists with correct counts and links.

It seems like this task might have been already satisfied by a prior update. Let me verify the README and topics.md are already correct.

## Verification

The README Coverage table Flux CD row shows Notes=1, Scripts=1 which matches disk.
The topics.md Flux CD section shows 3 files with correct links to all three files.
The README Layout already has a FluxCD entry.

No changes needed — the coverage is already correct.
