---
last_verified: 2026-09-28
tool_version: n/a
sources: []
---

# GCP/ coverage note — 2026-09-28

> A review pass flagged that the README GCP row was behind — Scripts 1→2, Snippets 1→2. I recounted against disk and most of that had already landed on its own. Scratch notes on what was actually stale.

## What I counted

I ran `find GCP -type f` and got 11 files across five folders: notes 2, docs 0, snippets 2, scripts 4, configs 3. The README row already read notes 2, snippets 2, scripts 4, configs 3. The two numbers the task named are correct now — later work added the VM-launch script and the GCS/IAM script on top of the two `install-gcloud` scripts — so the only real gap was Docs, which printed `—` for a folder that did not exist yet.

## What I changed

I edited the GCP Coverage row: Docs `—`→1 (this file, self-counted) and Last verified 2026-09-20→2026-09-28. Nothing else in the table moved, and I touched no other tool's row.

## What I left alone

`00_index/topics.md` lists the GCP folder too. I did not hand-edit anything under `00_index/` — the kit maintainer rebuilds that navigation from the file tree on each pass, and two people editing it at once is how the merge conflicts happen. Its GCP section already reads scripts (4), configs (3), snippets (2); the rebuild just needs to pick up the new `GCP/docs/` folder.

## Check

`ls GCP/notes/`, `ls GCP/snippets/`, `ls GCP/scripts/`, and `ls GCP/configs/` print 2, 2, 4, and 3; `ls GCP/docs/` prints this one note. Every number in the row now points at files that exist.
