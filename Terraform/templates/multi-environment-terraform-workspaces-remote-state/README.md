---
last_verified: 2026-09-13
tool_version: n/a
sources: []
---

# Multi-environment Terraform with workspaces and remote state — Project Scaffold

> A reusable scaffold for running one Terraform configuration against multiple
> environments (dev, prod) using workspaces and an S3 + DynamoDB remote state
> backend, so each environment gets its own state namespace without duplicating
> the module tree.

## Layout

```
multi-environment-terraform-workspaces-remote-state/
├── README.md
├── main.tf          # provider + backend block (default)
├── variables.tf    # shared input variables
├── outputs.tf      # shared outputs
├── environments/
│   ├── dev/
│   │   ├── backend.tf     # dev backend override (workspace-specific key prefix)
│   │   └── terraform.tfvars
│   └── prod/
│       ├── backend.tf     # prod backend override
│       └── terraform.tfvars
└── scripts/
    ├── apply.sh           # select workspace, init, apply
    └── destroy.sh         # select workspace, destroy
```

## Usage

```bash
cd multi-environment-terraform-workspaces-remote-state

# first time only — creates the dev and prod workspaces
./scripts/apply.sh dev
./scripts/apply.sh prod

# switch environments and re-apply
./scripts/apply.sh prod
./scripts/destroy.sh prod
```

## How it works

- **Workspaces** — `terraform workspace new/select` switches the state namespace
  inside a single backend, so dev and prod state never collide.
- **Remote state backend** — an S3 bucket (with DynamoDB locking) holds the state
  files instead of a local `terraform.tfstate`.
- The `backend "s3"` block lives in `main.tf` but is **configured** per environment
  by the `backend.tf` in each `environments/<env>/` folder. Terraform merges the
  backend settings from the file that exists in the configuration root, so the
  per-environment `backend.tf` overrides the key prefix while the bucket name
  stays shared.
- The DynamoDB table for state locking must already exist; the table name is
  passed in via `terraform.tfvars`.

## Notes

- Do not run `terraform apply` from outside the `scripts/` wrappers — they handle
  workspace selection first.
- The S3 bucket must already exist and must allow the configured IAM role to
  read/write the per-environment state key.