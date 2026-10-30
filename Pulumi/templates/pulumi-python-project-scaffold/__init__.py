# last_verified: 2026-10-30 · Pulumi n/a
import pulumi
import pulumi_aws as aws

# One bucket. Bucket names are globally unique, so pick a name that will not
# collide with another account's bucket if this stack is ever reused.
bucket = aws.s3.Bucket("my-first-pulumi-bucket")

# Hand the real, assigned name and ARN back to the stack so another resource
# (or an app config) can reference them without guessing.
pulumi.export("bucket_name", bucket.id)
pulumi.export("bucket_arn", bucket.arn)