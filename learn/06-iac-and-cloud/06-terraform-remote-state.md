---
last_verified: 2026-11-15
tool_version: 1.17.2
sources:
  - https://developer.hashicorp.com/terraform/language/settings/backends/s3
  - https://developer.hashicorp.com/terraform/language/state/locking
  - https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/backend.html
  - https://github.com/hashicorp/terraform/releases/tag/v1.17.2
---
# Keep Terraform state remote and locked

The previous lesson ran the plan/apply/destroy cycle against local files, with state sitting in a local `terraform.tfstate`. That works for one person on one machine, but as soon as you collaborate or run Terraform in CI, two applies can overlap and corrupt state. This lesson moves state to a remote S3 backend with native locking turned on, then shows what happens when two people apply at once and how to recover.

## What you'll learn
- Move state to a remote backend with locking — configure a `terraform { backend "s3" { ... } }` block and run `terraform init` / `terraform init -reconfigure`.
- Explain what happens when two people apply at once — Terraform locks state automatically, the second run fails with `Error acquiring the state lock`, and you recover with `terraform force-unlock <LOCK_ID>`.

## Before you start
- [Provision and destroy your first infrastructure](./05-terraform-first-apply.md) — the plan/apply/destroy cycle with the `local` provider; state currently lives in a local `terraform.tfstate` file.
- [Infrastructure as Code Concepts — quick primer](../../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md) — state, drift, and declarative infrastructure.
- Terraform installed; confirm with `terraform --version`.
- AWS credentials available via environment variables or the AWS shared config file (not hardcoded in `-backend-config`), and an S3 bucket you can write to.

## Walkthrough

1. Start from the network configuration you wrote in the previous lesson — a `main.tf` that uses the `local` provider to create a few `local_file` resources. Add a backend block above it:

   ```hcl
   terraform {
     backend "s3" {
       bucket         = "myorg-terraform-state"
       key            = "lab-network/terraform.tfstate"
       region         = "us-east-1"
       use_lockfile   = true
     }
   }
   ```

   `bucket` and `key` identify the state object in S3, and `region` is required. `use_lockfile = true` turns on native S3 state locking (generally available in Terraform 1.11+, defaults to `false`). Terraform writes a lock object at `<key>.tflock` in the same bucket. Do not use the DynamoDB `dynamodb_table` option — it is deprecated and planned for removal. A backend block cannot reference input variables or locals, and a directory holds only one backend block.

2. Initialize so Terraform migrates the existing local state into S3:

   ```bash
   terraform init
   ```

   You should see Terraform detect the backend change and prompt to copy the existing local state to the remote backend — answer `yes`. On a directory that is already initialized, changing `bucket`, `key`, or `region` requires `terraform init -reconfigure`; Terraform refuses to re-initialize an already-configured backend otherwise.

3. Confirm state now reads from the remote backend:

   ```bash
   terraform state list
   ```

   You should see the resources Terraform manages, served from S3 rather than a local file.

4. Apply so Terraform writes state through the locked backend:

   ```bash
   terraform apply -auto-approve
   ```

   Terraform acquires the lock automatically for any operation that could write state and releases it when the run finishes.

5. Watch locking in action. In one terminal, start `terraform apply`. While it runs, start a second `terraform apply` in another terminal against the same state. The second run fails:

   ```
   Error acquiring the state lock
   ```

   with a lock ID (a nonce) printed in the message. That is Terraform protecting state from concurrent writers — not a broken run.

6. Recover the lock. Confirm no apply is still running (`ps aux | grep terraform`, CI history), then release the lock with the ID from the error:

   ```bash
   terraform force-unlock <LOCK_ID>
   ```

   `force-unlock` removes only the lock record; it does not stop a still-running apply, so only use it after verifying the lock-holding process has finished. Never use `-lock=false` as a standing workaround.

## Exercise

1. In an empty folder, write a `main.tf` that uses the `local` provider to define a small network (for example a VPC, a public subnet, and a private subnet as `local_file` resources). Change the names, CIDR blocks, and file names from the walkthrough.
2. Add a `terraform { backend "s3" { bucket, key, region, use_lockfile = true } }` block with your own bucket, key, and region.
3. Run `terraform init`, answer `yes` to migrate local state to S3, then run `terraform plan` and `terraform apply` to confirm state reads and writes remotely.
4. Open a second terminal. Start `terraform apply` in the first terminal, then start a second `terraform apply` against the same state in the second terminal. Capture the `Error acquiring the state lock` message and note the lock ID it prints.
5. Confirm no apply is running, then run `terraform force-unlock <LOCK_ID>` with the ID from the error, and confirm the lock is released.

## Check your work

- `terraform init` reports that the backend is configured and local state was migrated to S3.
- `terraform state list` returns resources read from the remote backend.
- `terraform apply` succeeds after the lock is acquired and released.
- A concurrent second `terraform apply` fails with `Error acquiring the state lock` and prints a lock ID.
- `terraform force-unlock <LOCK_ID>` releases the lock; `-lock=false` is not used as a standing fix.

## Common mistakes

- Changing `bucket`, `key`, or `region` on an initialized backend without `terraform init -reconfigure` — Terraform refuses to re-initialize.
- Hardcoding AWS credentials in `-backend-config` — credentials should come from environment variables or the AWS shared config file.
- Using DynamoDB `dynamodb_table` for locking — deprecated and planned for removal; use `use_lockfile = true` instead.
- Running `terraform force-unlock` while an apply is still running — confirm the lock-holder finished first, or you risk corrupting state.
- Editing `terraform.tfstate` by hand — state is Terraform's record of what it manages.

## Next

[Reusable Terraform modules](../../00_index/learning-path.md)
