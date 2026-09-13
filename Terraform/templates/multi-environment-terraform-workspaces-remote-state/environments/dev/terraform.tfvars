# last_verified: 2026-09-13 · Terraform · n/a
# Dev environment values. These are merged with variables.tf defaults at
# apply time.

aws_region   = "us-east-1"
environment = "dev"
instance_type = "t3.micro"
dynamodb_table = "tf-state-lock"