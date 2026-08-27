---
last_verified: 2026-08-25
tool_version: n/a
sources: []
---

# What I learned doing the OpenTofu state management tutorial

Spent today working through state management with `tofu`, following up on the quickstart notes I wrote last week. The quickstart taught me to run `init` / `plan` / `apply`; this session was about everything that happens *after* apply — the state file, what lives in it, and how to fix mistakes without tearing infrastructure down.

## What actually clicked

**The state file is the bridge between code and reality.** After my first apply I opened `terraform.tfstate` and found plain JSON: every resource with its real IDs and attribute values. That's the moment it made sense why `plan` can show a diff — it compares my `.tf` files against this cached reality, not against live cloud APIs (mostly).

**Inspecting before touching.** `tofu state list` gives a flat list of every resource address in state. I ran it constantly — like `ls` for managed infrastructure.

**Renaming without destroying.** This was the big one. I renamed a resource block in my code (`aws_instance.app` → `aws_instance.web`) and `plan` wanted to *destroy and recreate* it. Renaming the block means nothing to state — old address gone, new address appeared. The fix:

```console
$ tofu state mv aws_instance.app aws_instance.web
```

After that, `plan` showed no changes. State addresses follow the code, they just need to be told explicitly.

**Backup first.** Before any state surgery: `tofu state pull > backup.json`. It dumps the whole state to a file, so a botched `state mv` is recoverable.

## Got stuck on

- **Hand-editing `terraform.tfstate` is a trap.** It's readable JSON, so I assumed I could tweak a value directly. Every guide says don't — the file has version metadata that the CLI maintains, and a careless edit corrupts it silently. The `tofu state ...` subcommands exist precisely so I never edit it raw.
- **There is no `tofu migrate`.** I went looking for a command to move state to a different backend and it doesn't exist. The actual flow: change the `backend` block in the `terraform` settings, re-run `tofu init`, and it asks whether to copy the existing state to the new location. Answer yes, verify with `state list` against the new backend.
- **Secrets sit in state in plaintext.** My test resource had nothing sensitive, but the tutorial called out that anything marked sensitive in code still lands as plain JSON in state. That changes how carefully I'd treat the backend storage and who gets read access to it.
- **Workspace confusion.** `tofu workspace new dev` / `workspace select dev` keeps separate state copies under the same config. I kept forgetting which workspace was selected — `workspace show` became part of my habit before any stateful command.

## What I'd try next

Next session I want to wire up a remote backend properly and watch state locking in action — two terminals running `apply` against the same state should be impossible, and I want to see the lock actually held. After that, `tofu import` to adopt something that already exists outside of Terraform, and the `removed` block for deleting resources deliberately in code instead of reaching for `state rm`.
