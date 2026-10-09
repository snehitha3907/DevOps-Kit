---
last_verified: 2026-10-09
tool_version: n/a
sources: []
---

# terraform-aws-s3-bucket

> A Terraform module for creating an S3 bucket with versioning, encryption, and public access blocking enabled by default.

## Features

- Creates an S3 bucket with a globally unique name
- Enables versioning by default
- Configures AES256 server-side encryption
- Blocks all public access (recommended security practice)
- Supports lifecycle `prevent_destroy` for production buckets
- Tags all taggable resources

## Usage

```hcl
module "s3_bucket" {
  source  = "your-namespace/s3-bucket/aws"
  version = "1.0.0"

  bucket_name    = "my-unique-bucket-name"
  aws_region     = "us-east-1"
  prevent_destroy = true

  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| aws | ~> 5.0 |
| random | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |
| random | ~> 3.6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region where resources will be created. | string | `"us-east-1"` | no |
| bucket_name | Name of the S3 bucket. Must be globally unique. | string | n/a | yes |
| prevent_destroy | When true, prevents the bucket from being destroyed. | bool | false | no |
| tags | Map of tags to apply to all taggable resources. | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The ID (name) of the created S3 bucket. |
| bucket_arn | The ARN of the created S3 bucket. |
| bucket_domain_name | The domain name of the bucket. |
| bucket_regional_domain_name | The regional domain name of the bucket. |
| versioning_enabled | Whether versioning is enabled on the bucket. |

## Examples

See the [examples/basic](./examples/basic) directory for a complete working example.

## Publishing

This module is published to the Terraform Registry. See the root [publishing guide](../../docs/publishing-guide.md) for release and publishing workflow details.

## License

MIT Licensed. See [LICENSE](../../LICENSE) for full details.