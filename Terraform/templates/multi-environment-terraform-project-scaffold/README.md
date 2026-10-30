---
last_verified: 2026-10-27
tool_version: n/a
---

# Multi-environment Terraform project scaffold

Reference scaffold for a Terraform project split across dev, staging, and prod environments with a shared network module and remote state backend.

## Layout

- `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `providers.tf` — root module
- `modules/network` — reusable VPC/subnet module
- `environments/{dev,staging,prod}` — per-environment backend and var files
- `scripts/` — apply and destroy helpers

## Usage

```bash
./scripts/apply.sh dev
./scripts/apply.sh prod
```
