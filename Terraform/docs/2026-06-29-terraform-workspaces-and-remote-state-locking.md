# How I wired Terraform workspaces and remote state locking with S3 + DynamoDB

This guide walks through setting up a Terraform S3 backend with state locking via DynamoDB and using workspaces to manage multiple environments. I've been using this setup for personal infrastructure and wanted to document what actually worked and where I hit edge cases.

## Purpose

A local `terraform.tfstate` file works for solo exploration but breaks down once you share state across machines or need environment separation (dev/staging/prod). An S3 backend stores state remotely and, combined with DynamoDB locking, prevents concurrent `apply` operations from corrupting the state file.

## Prerequisites

- Terraform installed (tested with v1.5+)
- An AWS account with credentials configured (`AWS_PROFILE` or `~/.aws/credentials`)
- Permissions to create S3 buckets, DynamoDB tables, and IAM policies

## Steps

### 1. Create the S3 bucket for state storage

I created a bucket with versioning enabled so I can recover from accidental state deletion. The bucket name must be globally unique.

```hcl
# backend-setup/main.tf
resource "aws_s3_bucket" "state" {
  bucket = "my-terraform-state-20260629"
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
```

### 2. Create the DynamoDB table for state locking

DynamoDB is used for optimistic concurrency control. Terraform writes a lock ID into the table before applying and removes it after. If another process tries to apply at the same time, it gets a clear error instead of silently corrupting state.

```hcl
# backend-setup/main.tf (continued)
resource "aws_dynamodb_table" "lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

The only required attribute is `LockID` of type `S` (string). Terraform manages this key internally.

### 3. Apply the backend infrastructure

```bash
terraform -chdir=backend-setup init
terraform -chdir=backend-setup apply -auto-approve
```

### 4. Configure the backend in your main Terraform project

After the bucket and table exist, point your Terraform root module at them:

```hcl
# main-project/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-20260629"
    key            = "project-a/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

Run `terraform init` again. Terraform asks whether to copy existing state into the new backend. Answer `yes`.

### 5. Introduce workspaces for environment separation

Instead of duplicating entire directories for dev/staging/prod, workspaces share the same root module but store state under different keys.

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
terraform workspace select dev
```

With the S3 backend, each workspace stores state at `{key}/env:/{workspace_name}/terraform.tfstate`. So `project-a/terraform.tfstate` becomes `project-a/env:/dev/terraform.tfstate` for the dev workspace.

I typically structure environment-specific variables like this:

```hcl
# main-project/variables.tf
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type per environment"
  type        = map(string)
  default = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }
}
```

The workspace name is accessible at `${terraform.workspace}`, so I can wire environment-specific values from the workspace selection.

### 6. Apply per environment

```bash
terraform workspace select dev
terraform apply -auto-approve

terraform workspace select staging
terraform apply -auto-approve

terraform workspace select prod
terraform apply -auto-approve
```

## Verify

- Check the S3 bucket for state files: `aws s3 ls s3://my-terraform-state-20260629/project-a/`
- Check the DynamoDB table for lock entries: `aws dynamodb scan --table-name terraform-state-lock`
- While one shell is running `terraform apply`, run it in another — it should print an error about being unable to acquire the lock

## Common errors

**Lock acquisition failure with no other process running.** I ran into this when I had a stale `.terraform/` directory pointing at a local backend while the config had been switched to S3. Solution: delete `.terraform/` and re-run `terraform init`.

**DynamoDB table doesn't exist.** Terraform doesn't create the lock table automatically. You must create it before configuring the backend. The error message mentions a missing DynamoDB table but doesn't say which one — I had to check the bucket's DynamoDB configuration.

**Invalid bucket name.** S3 bucket names must be globally unique and DNS-compliant (no underscores, 3–63 characters). I got a misleading `InvalidBucketName` error that took me a minute to decode.

**State file drift across workspaces.** If you modify resources in the prod workspace while selected on staging, nothing happens since each workspace is isolated. But it's easy to forget to switch workspaces and think you're modifying staging when you're actually hitting default. I now put `terraform.workspace` into resource names to make the environment visible in the console.

## References

- Terraform S3 backend docs: https://developer.hashicorp.com/terraform/language/settings/backends/s3
- DynamoDB state locking explanation: https://developer.hashicorp.com/terraform/language/settings/backends/s3#dynamodb-table
- Workspace documentation: https://developer.hashicorp.com/terraform/language/state/workspaces
