---
last_verified: 2026-07-11
tool_version: n/a
---

# Removed dead CHANGELOG references to General/docs/ files

Spotted five lines in the CHANGELOG that pointed to `.md` files under `General/docs/`. That directory no longer exists, so the references were stale — clicking the path would lead nowhere.

I removed these five entries:

1. `2026-06-19` — update-readme-layout-ansible-docker
2. `2026-06-16` — undocumented-files
3. `2026-06-15` — already-documented (rework)
4. `2026-06-14` — already-documented (rework)
5. `2026-06-13` — undocumented (rework)

Each was a single bullet under its date heading. The date headings still had other entries so they stayed. No sections went empty.

Took maybe two minutes — just deleted the lines and re-read the file to make sure nothing else broke.