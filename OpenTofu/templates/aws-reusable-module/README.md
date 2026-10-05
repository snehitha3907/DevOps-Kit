---
last_verified: 2026-10-05
tool_version: n/a
sources:
  - https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html
---

# aws-reusable-module — a shared OpenTofu VPC module for AWS

## Purpose

A starting point for teams that keep copy-pasting the same VPC, subnet, gateway, and route-table blocks into every environment. The module builds one VPC with public subnets routed through an internet gateway and private subnets routed through NAT gateways, and exposes every managed ID as an output so callers never reach into module internals. The value is in the seams rather than any single resource: the root/module split that keeps provider configuration out of shared code, the count-gated NAT switch that lets isolated environments skip NAT charges, and the `examples/basic/` caller that shows the minimum wiring a root module needs.

This is one reasonable shape, not the only one. Teams that need transit gateways, VPC endpoints, or flow logs can extend the same skeleton; the layout conventions below still apply.

## What is in the box

```
aws-reusable-module/
├── README.md               this file
├── versions.tf             required_providers only — no provider blocks, no version pins
├── variables.tf            every per-environment knob (names, CIDRs, AZs, NAT switch, tags)
├── main.tf                 VPC, IGW, subnets, EIP/NAT, route tables, routes, associations
├── outputs.tf              a referencing output for every managed resource
└── examples/
    └── basic/
        └── main.tf         minimal root module: provider block plus one module call
```

## When to use

Reach for this template when two or more environments or projects need the same network shape and the current approach is duplicating `.tf` files with small edits. It also fits when a review keeps catching drift between a staging VPC and the production VPC it is supposed to mirror — one module with different inputs removes that class of drift. Do not use it for a single throwaway experiment; a flat root module with no `source` indirection is cheaper there.

## Prerequisites

- OpenTofu installed and on `PATH`.
- AWS credentials the root module can consume (the module itself takes none).
- One CIDR range per environment that does not overlap its peers, plus the availability zones for the target region.

## Steps

Commands assume the current directory is a root module that calls this module, as in `examples/basic/`.

1. Copy the module into the shared location the team publishes from (a registry, a versioned Git reference, or a monorepo path) and point the caller at it:

   ```hcl
   module "network" {
     source               = "../.."
     project_name         = "demo"
     environment          = "dev"
     availability_zones   = ["us-east-1a", "us-east-1b"]
     enable_nat_gateway   = true
   }
   ```

2. Keep provider configuration in the root only. The module declares `required_providers` in `versions.tf` and no `provider` blocks anywhere, so region, credentials, and version pins stay with the caller. The same root can instantiate the module once per environment with different inputs.

3. Plan and apply through the usual cycle:

   ```bash
   tofu init
   tofu plan
   tofu apply
   ```

4. For environments that need no outbound internet from private subnets, set `enable_nat_gateway = false`. No NAT gateways, EIPs, or private route tables are created, and the private subnets stay fully isolated.

## Verify

- `tofu plan` shows one VPC, one internet gateway, the expected subnet count per tier, and NAT resources only when the switch is on.
- `tofu output vpc_id` and the subnet outputs return IDs, and downstream modules accept them as inputs without data-source lookups.
- Rendering the plan for two environments with different `environment` values produces disjoint `Name` tags and no overlapping CIDRs.

## Rollback

The example under `examples/basic/` is disposable infrastructure. From the example directory, `tofu destroy` removes everything the module created, in dependency order. Destroy the development instance first and confirm the plan is empty before touching shared environments.

## Common errors

- `plan` reports that a subnet CIDR is not inside the VPC range → the `public_subnet_cidrs` or `private_subnet_cidrs` entry does not sit within `vpc_cidr`; adjust the lists, not the VPC.
- No route to the internet from a private instance → `enable_nat_gateway` is `false`, or the instance sits in a public subnet without an Elastic IP; check which tier the subnet belongs to via its `Tier` tag.
- `apply` fails on the NAT gateway → the NAT resource waits on the internet gateway through an explicit dependency, so a failure here usually means the EIP quota for the region is exhausted rather than an ordering problem.
- Provider version drift between environments → a pin was added inside the module instead of the root; keep `versions.tf` here pin-free and declare the allowed range once per root module.

## References

- `versions.tf`, `variables.tf`, `main.tf`, `outputs.tf` — the module itself.
- `examples/basic/main.tf` — the minimal caller; start here before adapting.
- The layout follows the root-module versus reusable-module split (root owns `provider` blocks and pins, shared modules declare `required_providers` and ship an `examples/` caller) described in the AWS Terraform provider best-practices structure guide listed in this file's front-matter.
