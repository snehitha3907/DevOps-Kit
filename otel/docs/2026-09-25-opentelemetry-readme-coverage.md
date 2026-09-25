---
last_verified: 2026-09-25
tool_version: n/a
---

# otel/ coverage note — 2026-09-25

> I noticed `otel/` had no README entry at all, so I wired it into the Layout and Coverage table. First-person scratch notes.

## What I found

I opened the README Layout and there is no `otel/` bullet — the list jumps from OpenTofu straight to Prometheus. Same story in the Coverage table: no OpenTelemetry row anywhere. That felt wrong because `otel/notes/0000-primer-opentelemetry.md` has been on disk since the otel-001 merge. I counted with `ls`: `otel/notes/` holds 1 file, and there was no `otel/docs/` yet.

## What I changed

I added an `otel/` Layout bullet between OpenTofu and Prometheus, plus one Coverage-table row for OpenTelemetry: notes 1, docs 1 (this file — docs was 0 before it), everything else `—`, Last verified 2026-09-25. I left `00_index/topics.md` alone on purpose — the Maintainer rebuilds that file from the tree every cycle, so a hand-added OpenTelemetry section would just collide with theirs.

## Verification

I re-read the table after the edit and the OpenTelemetry row sits between OpenTofu and Prometheus with notes 1, docs 1, dated 2026-09-25. `ls otel/docs/` shows this file, so the docs count of 1 resolves to something real.
