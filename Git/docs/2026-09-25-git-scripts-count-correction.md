---
last_verified: 2026-09-25
tool_version: n/a
---

# Git/ scripts count note — 2026-09-25

> The README said `Git/scripts/` holds 10 scripts, but I count 11 on disk. Scratch notes on what I found and fixed.

## What I found

I ran `ls Git/scripts/` and counted 11 files — the extra one is `bisect-automation-runner.sh`, which landed in the git-019 merge after the last coverage update. The README Coverage table still says Scripts 10, and the Git Last verified date still reads 2026-09-17, so both are behind. The docs column reads 13, and `ls Git/docs/` prints exactly 13 entries (10 markdown files, two small shell companions, and the `scripts/` companion dir), so that number was right — until this note, which makes 14.

## What I changed

I bumped the Git Coverage row: Scripts 10→11, Docs 13→14 (this file, self-counted), Last verified 2026-09-17→2026-09-25. I left `00_index/topics.md` alone on purpose — the Maintainer rebuilds it every cycle, so my hand-edit to the Git scripts count there would just collide (it still reads scripts (10) with "7 more", which the rebuild will correct to 11 with "8 more").

## Verification

I re-read the row after the edit: notes 8, docs 14, snippets 1, scripts 11, dated 2026-09-25. `ls Git/scripts/ | wc -l` prints 11 and `ls Git/docs/` shows this file, so both counts resolve to something real.
