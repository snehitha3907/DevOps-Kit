---
last_verified: 2026-09-18
tool_version: n/a
sources: []
---

# Wiring OpenTofu remote state to an S3 backend with workspace isolation

## Purpose

When two people run `apply` from their own laptops against local state files, the second apply has no idea what the first one did. The fix I settled on: keep one shared state file per environment in an S3 bucket, with locking so concurrent applies queue instead of clobbering each other, and use workspaces so `dev` and `prod` stop sharing a single state file. This is one way to do it; the docs also show a single workspace with per-environment directories, which fits smaller setups — I picked workspaces because the config stays identical and only the state pointer changes.

The companion bootstrap script (`../scripts/s3-dynamodb-remote-state-bootstrap.sh`) provisions the bucket, the lock table, and a scoped IAM user; this doc covers what I did after that existed.

## Steps

**1. Point the project at the shared backend.** I added a backend block next to the rest of the config:

```hcl
terraform {
  backend "s3" {
    bucket = "my-team-state-bucket"
    key    = "project/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "my-team-state-locks"
    encrypt        = true
  }
}
```

**2. Migrate the existing local state.** Re-running init with the backend block present prompts to copy the local state up into the bucket. I answered yes, then confirmed with `tofu state list` that the same resource addresses were now served from the remote backend.

**3. Split environments with workspaces.** With the backend in place, I created one workspace per environment:

```console
$ tofu workspace new dev
$ tofu workspace new prod
$ tofu workspace select dev
```

Each workspace keeps its own state object under a workspace-prefixed key in the same bucket, so `dev` applies can never rewrite `prod` state. Before every stateful command I now run `tofu workspace show` — a habit I adopted after applying to the wrong workspace once (see below).

**4. Give each teammate the same pointer.** Every teammate clones the repo, configures credentials for the scoped state user, and runs `tofu init`. Init pulls the backend settings from the committed config, so everyone converges on the same bucket and lock table with no manual state-file copying.

## Verify

- `tofu workspace show` prints the environment I think I'm in.
- `tofu state list` returns the same addresses for every teammate on the same workspace.
- Listing the bucket prefix shows one state object per workspace instead of a single shared file.
- Running `apply` from two terminals at once makes the second one wait on the lock rather than failing halfway through with a half-written state.

## Got stuck on

- **Applied to the wrong workspace.** I created `dev` and `prod`, then ran an apply while still sitting on the default workspace — the resources landed in a third, unintended state file. The fix was `tofu workspace select dev`, re-apply, and delete the stray default state. Now `workspace show` is muscle memory before any apply.
- **Teammate saw stale resources.** A colleague ran `plan` and saw resources I had already created. Cause: they had never re-run `init` after I added the backend block, so their CLI was still reading a local state file. One `tofu init` later, their plan matched mine.

## Common errors

- `plan` shows creates for resources that already exist → you are reading a different state than the team (wrong workspace selected, or backend block never initialized with `init`).
- Apply hangs before doing anything → someone else holds the state lock; wait for their run to finish rather than interrupting it.

## What I'd try next

Next I want to watch the lock actually held during a long apply, and try importing a hand-created bucket into the shared state so nothing has to be recreated. After that, per-environment backend keys instead of workspaces, to compare which split is easier to reason about when the team grows.
