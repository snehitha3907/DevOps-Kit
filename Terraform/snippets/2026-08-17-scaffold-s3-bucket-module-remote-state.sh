#!/bin/bash
# last_verified: 2026-08-17 · Terraform
# Scaffolding a reusable S3 bucket module with a remote state backend.
# I'm setting up a module so I don't repeat the same bucket config in every project,
# and a backend so the state file lives in S3 instead of on my laptop.

# 1. The module itself: variables + the bucket resource.
mkdir -p modules/s3-bucket

cat > modules/s3-bucket/variables.tf <<'EOF'
variable "bucket_name" {
  type        = string
  description = "Name for the S3 bucket."
}
EOF

cat > modules/s3-bucket/main.tf <<'EOF'
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}
EOF

# 2. The root module calls the module and points the backend at a state bucket.
cat > main.tf <<'EOF'
terraform {
  backend "s3" {
    bucket = "my-org-tf-state"
    key    = "webapp/terraform.tfstate"
    region = "us-east-1"
  }
}

module "assets" {
  source      = "./modules/s3-bucket"
  bucket_name = "webapp-assets"
}
EOF

# 3. Init wires up the backend; plan shows what apply would create.
terraform init
terraform plan