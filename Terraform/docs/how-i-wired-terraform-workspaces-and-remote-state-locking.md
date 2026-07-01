# How I wired Terraform workspaces and remote state locking with S3 + DynamoDB

## Purpose

State is the backbone of any Terraform setup — it maps real-world resources to your config. By default Terraform writes state to a local `terraform.tfstate` file, which works for a single engineer on one machine. As soon as you collaborate or run Terraform in CI, you need a remote backend that stores state centrally and locks it during operations so two people don't clobber each other's changes.

I wanted to wire S3 as the state store with DynamoDB for locking, then layer workspaces on top so the same config can manage dev, staging, and prod without duplicating directories. This doc covers what I set up and the assumptions I made along the way — it's one approach; the docs also suggest alternatives like using `-backend-config` for dynamic values.

## Prerequisites

- Terraform ≥ 1.0
- AWS credentials with permissions for S3 and DynamoDB
- `aws` CLI configured

## Steps

### 1. Create the S3 bucket

The bucket holds the actual state files. Enable versioning so state history isn't lost on a bad apply.

```hcl
resource "aws_s3_bucket" "state" {
  bucket = "myorg-terraform-state"
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

I ran this separately from the main config since the backend block needs to reference the bucket before Terraform can init — chicken-and-egg problem. The docs also suggest creating the bucket outside Terraform entirely (via AWS CLI or console) to keep the bootstrap simple.

### 2. Create the DynamoDB table

DynamoDB handles locking. Terraform writes a row when a plan/apply starts and deletes it when it finishes. If a second process tries to lock the same state, it waits until the lock clears.

```hcl
resource "aws_dynamodb_table" "state_lock" {
  name         = "myorg-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### 3. Configure the backend

With the bucket and DynamoDB table created, I added a `backend` block to the Terraform config. One thing that tripped me up: no interpolation is allowed in `backend` blocks — values must be literal strings or passed via `-backend-config` on init.

```hcl
terraform {
  backend "s3" {
    bucket         = "myorg-terraform-state"
    key            = "project-name/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "myorg-terraform-state-lock"
  }
}
```

Re-run:

```bash
terraform init -reconfigure
```

Terraform migrates the local state to S3 and activates locking via DynamoDB.

### 4. Set up workspaces

Workspaces let one config manage multiple environments by suffixing the state key. Instead of `project-name/terraform.tfstate`, the dev workspace stores at `project-name/env:/dev/terraform.tfstate`. I found this naming convention a bit confusing at first — the `env:/` prefix is automatic and you don't configure it yourself.

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

Switch between them:

```bash
terraform workspace select dev
terraform plan
```

Each workspace has its own state file under the same S3 key prefix, all protected by the same DynamoDB lock table.

### 5. Use the workspace name in config

Reference the current workspace to vary resource settings per environment:

```hcl
locals {
  environment = terraform.workspace
  instance_type = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }[terraform.workspace]
}
```

### 6. Apply and verify

Run from each workspace and confirm the state landed in S3:

```bash
terraform workspace select dev && terraform apply -auto-approve
aws s3 ls s3://myorg-terraform-state/project-name/env:/dev/
```

## Verify

- **State location**: `aws s3 ls s3://myorg-terraform-state/` shows state files per workspace under `env:/<name>/`. It took me a minute to notice the `env:/` prefix — easy to miss if you're browsing the bucket.
- **Locking**: I tested this by opening two terminals and running `terraform apply` on the same workspace in both. The second one waits with a "locking" message until the first finishes. Good enough confirmation that DynamoDB is doing its job.
- **State history**: S3 bucket versioning lets you recover a previous state version if you need to roll back. I haven't needed this yet, but it's reassuring to have.

## Common errors I hit

- **`terraform init` fails with "bucket does not exist"**: I hit this first time because I wrote the backend config before creating the bucket. Bootstrap the bucket with a minimal Terraform config or create it manually first, then reconfigure the backend.
- **`terraform apply` hangs on acquiring state lock**: This happened when I interrupted an apply with Ctrl-C and tried again immediately. Force-unlock with `terraform force-unlock <LOCK_ID>` after verifying no other process is running. The lock ID is printed in the error message.
- **Workspace state files hidden by S3 eventual consistency**: New workspaces don't appear in `aws s3 ls` right away. I spent a few minutes thinking I'd misconfigured something before realizing it's just S3 being eventually consistent. Use `terraform workspace list` instead — it reads from the Terraform API.
- **`terraform init` errors on invalid backend key format**: The state key must not start with `/` and should use forward slashes as separators. Terraform's workspace key is `env:/<name>/<path>` — do not include `env:` yourself. I had a key like `/project/state` which failed until I dropped the leading slash.
