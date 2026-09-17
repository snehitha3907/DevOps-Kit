---
last_verified: 2026-09-17
tool_version: n/a
sources: []
---

# Git coverage correction (git-021 rework)

Final verification of Git folder counts against on-disk files.

| Category | Count | Verified |
|----------|-------|----------|
| Notes | 8 | `Git/notes/` — 8 `.md` files |
| Docs | 13 | `Git/docs/` — 13 files including subdirectories |
| Scripts | 9 | `Git/scripts/` — 9 files |
| Snippets | 1 | `Git/snippets/` — 1 file |
| Notebooks | 1 | `Git/notebooks/` — 1 `.ipynb` |
| Templates | 22 | `Git/templates/` — 22 files across git-hooks, repo-scaffold, repository-skeleton |
| **Total** | **54** | — |

These counts match `00_index/topics.md` and `README.md` Coverage table (updated for this correction). The `Git/` directory name (uppercase) is canonical; lowercase `git/` references in historical CHANGELOG entries are incorrect but not modified here.