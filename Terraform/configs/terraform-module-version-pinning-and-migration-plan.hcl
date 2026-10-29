# last_verified: 2026-10-29 · terraform n/a
#
# Purpose
#   Pin every Terraform module to an exact version or source ref, and record the
#   migration plan that moves a working configuration from unpinned references to
#   pinned ones without losing state.
#
# When to use
#   - A module source is referenced by a floating tag or by a bare URL and a
#     breaking change in the upstream can silently change what `terraform apply`
#     provisions.
#   - An audit or incident requires a reproducible record of which module version
#     produced the current infrastructure.
#   - A team is preparing to move modules between repositories or from a public
#     registry into an internal mirror.
#
# Prerequisites
#   - `terraform` is installed and the working directory initializes cleanly.
#   - Every module referenced here has a published release or a tag in its source
#     repository.
#   - State is backed by a remote backend so the migration can be re-run safely.
#
# Version pinning rules
#   - Pin to a tag, never to a branch name. A branch moves; a tag is immutable at
#     the moment it is recorded.
#   - Prefer a version constraint over a bare source URL. The constraint is checked
#     against the registry index at `terraform init` time and recorded in
#     `.terraform.lock.hcl`.
#   - When a module moves to an internal mirror, pin by the mirror's tag and keep
#     the original source recorded in a comment so the move is auditable.
#
# Migration plan
#   1. Inventory every `module` block and record its current source and any version
#      constraint.
#   2. Add or tighten a `version` argument on every module that lacks one.
#   3. Run `terraform init -upgrade` to refresh the lock file against the pinned
#      versions.
#   4. Run `terraform plan` and review the diff. If the plan is empty, the pin did
#      not change what would be applied.
#   5. Commit the updated source arguments and the new `.terraform.lock.hcl`.
#   6. If a module source moves, update the `source` argument, re-run init with
#      `-reconfigure`, and run `terraform state list` to confirm every resource is
#      still accounted for before applying.

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --- Module pinning ---------------------------------------------------------

module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"

  name = "prod-network"
  cidr = "10.0.0.0/16"

  azs              = ["us-east-1a", "us-east-1b"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true
  single_nat_gateway  = true
}

module "compute" {
  # Originally referenced by a bare URL. Pinned to the tagged release that was
  # in use at the time of the migration so the change is reviewable in history.
  # Replace the placeholder source below with the real module location.
  source  = "git::https://example.invalid/eks-module.git//modules/managed-node-group?ref=v2.4.0"
  version = "2.4.0"

  cluster_name    = "prod"
  node_group_name = "workers"
  desired_size    = 3
  min_size        = 2
  max_size        = 6
}

# --- Migration checklist ----------------------------------------------------
#
# Before the apply that follows this pin:
#   [ ] Every module block carries an explicit `version` argument.
#   [ ] `.terraform.lock.hcl` is committed and matches `terraform init -upgrade`.
#   [ ] `terraform plan` shows no unexpected resource changes.
#   [ ] The state backend is reachable and the lock is free.
#
# After the apply:
#   [ ] `terraform state list` still reports every resource that existed before.
#   [ ] The CI pipeline runs `terraform plan` on every PR to catch drift early.