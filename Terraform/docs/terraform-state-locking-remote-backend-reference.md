---
last_verified: 2026-10-27
tool_version: n/a
sources: []
---

# Terraform State Locking and Remote Backend Reference

## Purpose

Reference for configuring a remote backend with state locking so concurrent `terraform apply` runs cannot corrupt state.

## When to use

- Teams sharing a single Terraform state file.
- CI pipelines running Terraform against the same workspace.
- Any environment where two apply runs could overlap.

## Prerequisites

- A Terraform working directory with `terraform` initialized.
- A backend that supports locking (S3 + DynamoDB, GCS, Azure Blob, or Terraform Cloud).

## Steps

1. Choose a backend. Common options: AWS S3 with a DynamoDB lock table, Google Cloud Storage, Azure Blob Storage, or Terraform Cloud.
2. Configure the `backend` block in `terraform` configuration:

   ```hcl
   terraform {
     backend "s3" {
       bucket         = "my-tf-state"
       key            = "prod/terraform.tfstate"
       region         = "us-east-1"
       dynamodb_table = "tf-state-locks"
       encrypt        = true
     }
   }
   ```

3. Create the lock table (for S3/DynamoDB) with a primary key named `LockID` of type string.
4. Run `terraform init` to migrate local state into the backend.
5. Run `terraform plan` to confirm state reads work.
6. Run `terraform apply`; the backend acquires a lock automatically and releases it on completion.

## Verify

- `terraform state list` returns resources from the remote backend.
- Concurrent applies fail with a lock error rather than corrupting state.

## Rollback

- If a lock is stuck, release it with `terraform force-unlock <LOCK_ID>` only after confirming no apply is running.
- Revert backend config by removing the `backend` block and re-running `terraform init -migrate-state`.

## Common errors

- `Error acquiring the state lock`: another apply is running or a previous run crashed. Inspect the lock table; force-unlock only when safe.
- `AccessDenied` on the backend bucket: IAM permissions missing for state read/write.
- `ResourceAlreadyExists` when creating the lock table: table already present; skip creation.

## References

- Terraform backend documentation.
- Backend-specific locking behavior varies; consult the chosen backend's docs.
