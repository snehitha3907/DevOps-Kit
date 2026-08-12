---
last_verified: 2026-08-12
tool_version: n/a
---

# Following the Terraform state management tutorial — what tripped me up

I followed the official HashiCorp tutorial on managing Terraform state to understand how state files work and how to share state across a team. Here's what I learned and where I got stuck.

## Steps

1. **Created a basic config** — Wrote a simple configuration with a local provider and a resource that writes a file.
2. **Ran init and apply** — Executed the standard workflow and saw the state file get created locally.
3. **Inspected the state** — Used the state inspection commands to see what Terraform had recorded about the resource.
4. **Enabled remote state** — Configured a cloud backend so the state file lives outside the local directory.
5. **Used workspaces** — Created multiple workspaces to separate dev and prod state within the same backend.

## Got stuck on

- **State file location** — I didn't realize the state file is plain JSON by default. I accidentally committed it to version control early on because I didn't know it was being created. The tutorial mentions `.gitignore` patterns, but I read that section too quickly.
- **Forgetting to reinitialize** — After switching from a local backend to a remote backend, I ran `apply` without running `init` first. Terraform tried to migrate state automatically and produced a warning that I ignored. The next run showed drift because the local and remote states had diverged.
- **State locking confusion** — The tutorial mentions that remote backends can lock state during operations, but I didn't understand what that meant in practice. When I ran two `apply` commands in parallel terminals, the second one failed with a lock error. That was actually the correct behavior, but I thought Terraform had broken.
- **Workspace isolation** — I created a workspace called `prod` and changed a variable value, then switched back to the default workspace and was surprised that the resource count was different. I had forgotten that each workspace maintains its own isolated state.
- **`terraform destroy` scope** — I ran destroy in the wrong workspace and deleted resources I meant to keep. The command doesn't ask for confirmation when it knows exactly what will be destroyed. I now see why teams pair destroy with code review.

## What I'd try next

I want to set up a proper remote backend with state locking and experiment with partial state operations. I'd also like to try importing an existing resource into Terraform management so I can adopt infrastructure without rebuilding it.
