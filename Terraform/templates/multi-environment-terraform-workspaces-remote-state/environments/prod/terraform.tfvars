# last_verified: 2026-09-13 · Terraform · n/a
# Prod environment values. Deliberately stricter than dev: a larger instance
# type and (in a real scaffold) a flag to enable drain-on-destroy hooks.

aws_region   = "us-east-1"
environment = "prod"
instance_type = "t3.small"
dynamodb_table = "tf-state-lock"