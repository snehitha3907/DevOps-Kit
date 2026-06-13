# Rework check for already-documented files

I checked the gen-001 list against `origin/main` and the current README. The files were not actually missing:

- `Ansible/notes/2026-06-11-ansible-getting-started.md` was already in the README tree and quick links.
- `Ansible/scripts/run-first-playbook.sh` was already in the README tree and quick links.
- `GitHub/configs/issue-templates-and-labels.yaml` was already in the README tree and quick links.
- `Terraform/notes/2026-06-10-terraform-getting-started.md` was already in the README tree and quick links.

I left those files alone and added this docs note so the rework has an `Output: docs` artifact instead of only README edits. The main thing I learned is to check `origin/main` before changing navigation; the old PR was doing work that was already there.

This is a General note for the next cleanup pass: if a task says "undocumented" but the README already lists the file, make a small docs artifact and point back to the existing links instead of duplicating the same tree entries.
