---
last_verified: 2026-09-25
tool_version: n/a
sources: []
---

# graf/ coverage note — 2026-09-25

> I noticed `graf/` was missing from the README Coverage table, so I added the row and wrote down the counts. First-person scratch notes.

## What I found

I opened the README Coverage table and `graf/` had no row at all — the table jumps from Trivy to HashiCorp Vault. That felt wrong because `graf/` has been on disk for a bit now: a primer, a UI walkthrough note, and a Docker install script. The Layout bullet for `graf/` already exists, so only the table was behind. I counted the files with `ls` instead of trusting my memory: `graf/notes/` holds 2 files, `graf/scripts/` holds 1, and there was no `graf/docs/` yet.

## What I changed

I added one Coverage-table row for `graf/`: notes 2, docs 1 (this file — docs was 0 before it), scripts 1, everything else `—`, Last verified 2026-09-25. I also created this note under `graf/docs/` so the docs column is honest. I left `00_index/topics.md` alone on purpose — the Maintainer rebuilds that file from the tree every cycle, so my hand-edit would just collide with theirs.

## Verification

I re-read the table after the edit and the `graf` row sits after Pulumi with notes 2, docs 1, scripts 1, dated 2026-09-25. `ls graf/docs/` shows this file, so the docs count of 1 resolves to something real.
