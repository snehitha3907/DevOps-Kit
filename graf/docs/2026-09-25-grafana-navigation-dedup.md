---
last_verified: 2026-09-25
tool_version: n/a
---

# graf/ navigation dedup note — 2026-09-25

> The README listed `graf/` twice and carried two Coverage rows for the same folder. Scratch notes on the cleanup.

## What I found

I opened the README Layout and `graf/` appears in two bullets — once between GitLab CI and Helm, once down after Trivy. The Coverage table has the same split: a `Grafana` row (notes 2, docs `—`, scripts 1) and a `graf` row (notes 2, docs 1, scripts 1). I counted with `ls`: `graf/notes/` holds 2 files, `graf/docs/` holds 1, `graf/scripts/` holds 1. So the `graf` row was right (before this file) and the `Grafana` row is a stale leftover with an empty docs cell.

## What I changed

I deleted the duplicate Layout bullet (kept the one between GitLab CI and Helm) and removed the stale `Grafana` Coverage row, keeping a single `graf` row: notes 2, docs 2 (this file — docs was 1 before it), scripts 1, Last verified 2026-09-25. I left `00_index/topics.md` alone on purpose — the Maintainer rebuilds it every cycle, so the stale Grafana file count there gets corrected on rebuild, not by my hand-edit.

## Verification

I re-read the README after the edit: one `graf/` Layout bullet, one `graf` Coverage row with notes 2, docs 2, scripts 1, dated 2026-09-25. `ls graf/docs/` shows two files now, so the docs count of 2 resolves to something real.
