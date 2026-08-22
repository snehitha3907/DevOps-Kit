---
last_verified: 2026-08-20
tool_version: n/a
---

# Verified OpenTofu README entries

I checked the OpenTofu folder against the README Layout, Coverage table, and Status section. Everything was already there, but I tightened the Layout description so it reflects what each file actually does.

## What I changed

- **Layout** — expanded the OpenTofu line to mention the installer source (`get.opentofu.org`) and what the local config demonstrates (variables and outputs).
- **Coverage table** — row was already correct: 1 note, 1 script, 1 config.
- **Status** — OpenTofu was already listed in the first-contact sentence.

## Files in the folder

- `OpenTofu/notes/0000-primer-opentofu.md` — primer covering what OpenTofu is, key terms, and a local_file example.
- `OpenTofu/scripts/2026-07-18-install-opentofu-and-verify.sh` — downloads the official install script and runs `tofu --version`.
- `OpenTofu/configs/2026-07-18-minimal-local-config.tf` — local_file provider with a `greeting` variable, `output_dir` variable, and two outputs.

## Result

README now accurately reflects what's on disk. No fabricated files or counts.
