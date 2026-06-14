# reusable-s3-module — what I built

> L2 notes / config walkthrough. I followed the Terraform module tutorial and
> bundled an S3 bucket into something I can call from another project without
> repeating the same settings everywhere.

## Structure
- `main.tf` — bucket resource, versioning, SSE-S3 encryption, public-access block
- `variables.tf` — inputs I wanted to tweak per project (`bucket_prefix`, `tags`)
- `outputs.tf` — bucket ARN + domain so callers can wire up CloudFront, websites, etc.
- `examples/basic/main.tf` — the smallest call-site that proves it works

## What I learned
- A module is just a folder of `.tf` files with a `source` path in the caller.
- `lifecycle { ignore_changes }` on tags might be needed later if a tool outside
  Terraform touches tags (didn’t add it yet since I haven’t hit that bug).
- Output names should be explicit — `bucket_arn` instead of just `arn` — because
  when I stack modules the flat namespace gets confusing fast.

## How to use it
```hcl
# In caller project
module "uploads_bucket" {
  source      = "../../configs/reusable-s3-module"
  bucket_name = "my-app-uploads-prod"
  environment = "prod"
  tags = {
    ManagedBy = "Terraform"
    Owner     = "team-platform"
  }
}

output "uploads_arn" {
  value = module.uploads_bucket.bucket_arn
}
```