---
last_verified: 2026-08-17
tool_version: n/a
sources: []
---

# How I wired Terraform output values into a dependent module

## Purpose

Terraform modules are a mechanism for packaging and reusing configuration. A child module can expose computed values — IP addresses, ARNs, endpoint URLs — through `output` blocks, and the parent module consumes them just like any other variable. Without outputs, the parent module has to hard-code values it shouldn't know or re-query resources after apply.

## When to use

Wire outputs into a dependent module when one module creates infrastructure that another module needs to reference. Common cases include:
- A networking module outputs VPC ID and subnet IDs that a compute module consumes.
- A database module outputs the endpoint address and port that an application module uses for its connection string.
- A shared module outputs a resource name or ARN that a monitoring or IAM module references.

## Prerequisites

- Two Terraform modules: a child module that defines outputs, and a parent module that calls it.
- Terraform installed and initialized in the parent module.
- The child module's source is resolvable (local path, registry, or Git URL).

## Steps

### 1. Define outputs in the child module

The child module declares values it wants to expose using `output` blocks. Each output needs a name and an expression that references a resource or module attribute.

```hcl
# modules/networking/outputs.tf
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}
```

Keep outputs focused. Exposing every attribute is tempting, but narrow outputs reduce coupling between modules.

### 2. Reference the child module from the parent

The parent module calls the child with a `module` block. It then references the outputs as attributes on that block.

```hcl
# environments/prod/main.tf
module "networking" {
  source = "../../modules/networking"
  cidr   = "10.0.0.0/16"
}

module "compute" {
  source    = "./compute"
  vpc_id    = module.networking.vpc_id
  subnet_id = module.networking.private_subnet_ids[0]
}
```

The parent doesn't need to know how the VPC was created — only that `module.networking.vpc_id` is available after apply.

### 3. Validate the data flow

Run `terraform plan` from the parent module. If Terraform can't resolve an output reference, it fails during the planning phase with a clear error before any resources are touched.

```bash
terraform -chdir=environments/prod plan
```

If the plan succeeds, the output values are wired correctly.

## Verify

- Run `terraform output` in the child module to confirm each output returns the expected value.
- Run `terraform plan` in the parent module and confirm no undeclared input reference errors appear.
- Inspect the planned changes: the dependent module should receive the actual resource IDs from the child module's outputs, not hard-coded placeholders.

## Common errors

**Output name typo.** Terraform output references are case-sensitive and must match the child module's output block name exactly. A typo like `module.networking.Vpc_id` instead of `module.networking.vpc_id` fails during plan.

**Circular dependency via outputs.** If module A outputs a value that module B needs, and module B outputs a value that module A needs, Terraform detects a cycle during the graph walk. Split the shared value into a third module or move the configuration into a single module.

**Forgetting to run `terraform init` after changing module sources.** If you change the `source` argument in the parent module's `module` block, Terraform doesn't automatically reinitialize. Run `terraform init -upgrade` to refresh the module cache.

**Output type mismatch.** A child module outputs a list but the parent module treats it as a string, or vice versa. Terraform catches type mismatches during plan, but the error can be cryptic if the output is deeply nested. Use `terraform console` to inspect an output's actual type: `> module.networking.private_subnet_ids`.

## References

- Terraform module output documentation
- Terraform module composition guide
