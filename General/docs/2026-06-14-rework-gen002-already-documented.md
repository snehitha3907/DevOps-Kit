# Rework check — gen-002: already-documented files

I checked the gen-002 list against what's in the README on `origin/main`. Turns out none of the target files were actually missing:

- `GitHub/notes/2026-06-11-following-github-cli-quickstart.md` — already listed in the README tree and quick-links as "GitHub CLI quickstart follow-up."
- `GitHub/snippets/list-repos-with-python.py` — already listed in the README tree and quick-links as "GitHub list repos snippet."
- `Terraform/configs/reusable-s3-module/` — already listed in the README tree and quick-links as "Terraform reusable S3 module."

The old PR tried to add these as if they were undocumented, but they were there the whole time. Same pattern as the gen-001 rework. Lesson for next time: diff against `origin/main` first, not the working branch, before deciding something is missing.

I'm leaving the README as-is and filing this docs note so the rework produces an `Output: docs` artifact.
