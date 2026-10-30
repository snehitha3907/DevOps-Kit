# last_verified: 2026-09-19 · pulumi n/a
# I tried the smallest Pulumi Python program: one bucket, one output.
# Not sure yet how outputs feed other resources, but this ran preview clean.
import pulumi
import pulumi_aws as aws

# TODO: try a second stack with a different name and compare
bucket = aws.s3.Bucket("demo-bucket")
pulumi.export("bucket_name", bucket.id)
