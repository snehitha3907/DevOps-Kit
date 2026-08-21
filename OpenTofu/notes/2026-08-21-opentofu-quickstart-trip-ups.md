---
last_verified: 2026-08-21
tool_version: n/a
sources: []
---

# Following the official OpenTofu quickstart — what tripped me up

I followed the official OpenTofu quickstart to see how it compares to Terraform and where the experience diverges. Here's what worked, what confused me, and what I'd do differently next time.

## Steps

1. **Installed OpenTofu** — Downloaded the binary and added it to my PATH. The install process felt familiar if you've used Terraform before.
2. **Wrote a minimal config** — Created a simple `.tf` file with a local resource to test the basic workflow.
3. **Ran init and apply** — Executed the standard IaC cycle: initialize the working directory, preview changes, then apply.
4. **Inspected the state** — Looked at the state file to understand what OpenTofu had recorded about my resource.
5. **Tore everything down** — Used the destroy command to clean up and verify the full lifecycle worked.

## Got stuck on

- **State file format** — I assumed OpenTofu would use a different state format than Terraform, but it turns out the state file is still plain JSON. I spent time looking for a migration tool that doesn't exist. The state is compatible, which is the point of the fork.
- **Provider source configuration** — The quickstart uses the `terraform` namespace for providers (like `hashicorp/local`), not an `opentofu` namespace. I kept second-guessing whether I needed to change the source field in my config. Turns out you don't — the providers are the same.
- **Command naming** — I kept typing `terraform` out of muscle memory. The CLI is `tofu`, not `open tofu` or `terraform`. Simple, but it broke my flow for the first ten minutes.
- **Binary naming vs CLI naming** — The download is called `opentofu` but the binary you run is `tofu`. I initially extracted the archive and then couldn't figure out why `opentofu init` wasn't working.
- **No migration wizard** — I expected a `tofu migrate` command to convert an existing Terraform project. There isn't one because you don't need one — just swap the binary and run `tofu init`. The state file and configs are the same. I wasted time looking for a migration tool.

## What I'd try next

I want to try a multi-provider setup with a cloud backend to see if there are any differences in how remote state locking works. I'd also like to experiment with the OpenTofu-specific features like the `removed` block and encrypted state to see what Terraform doesn't offer.
