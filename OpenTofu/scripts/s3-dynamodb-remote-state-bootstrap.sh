#!/bin/bash
# last_verified: 2026-09-18 · OpenTofu n/a
# ot-007: scaffold a small OpenTofu project that provisions its own remote-state
# backend — one S3 bucket, one DynamoDB lock table, and one IAM user scoped to
# just that bucket and table — then migrate the local state into the backend.
#
# Purpose: give a team a repeatable starting point for shared OpenTofu state
# instead of everyone keeping a local tfstate file.
# Flow: write bootstrap config -> init/apply locally -> write backend block ->
# re-init with state migration -> verify the state lives in S3.
# This is one way to do it; the docs also show importing an existing bucket
# rather than creating a fresh one, which fits when the account already has
# a state bucket in place.

set -euo pipefail

# --- Inputs (override via environment) ---
PROJECT_DIR="${PROJECT_DIR:-./ot-remote-state-demo}"
AWS_REGION="${AWS_REGION:-us-east-1}"
STATE_BUCKET="${STATE_BUCKET:-ot-remote-state-demo-bucket}"
LOCK_TABLE="${LOCK_TABLE:-ot-remote-state-locks}"
STATE_USER="${STATE_USER:-ot-state-manager}"

mkdir -p "$PROJECT_DIR/bootstrap"
cd "$PROJECT_DIR"

# --- Step 1: bootstrap config (bucket + lock table + IAM user) ---
cat > bootstrap/main.tofu <<'EOF'
resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket
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

resource "aws_dynamodb_table" "locks" {
  name         = var.lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_user" "state_manager" {
  name = var.state_user
}

resource "aws_iam_user_policy" "state_access" {
  name = "remote-state-access"
  user = aws_iam_user.state_manager.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.state.arn,
          "${aws_s3_bucket.state.arn}/*",
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
        Resource = aws_dynamodb_table.locks.arn
      },
    ]
  })
}
EOF

cat > bootstrap/variables.tofu <<'EOF'
variable "state_bucket" {
  type        = string
  description = "Name of the S3 bucket holding remote state."
}

variable "lock_table" {
  type        = string
  description = "Name of the DynamoDB table used for state locking."
}

variable "state_user" {
  type        = string
  description = "IAM user allowed to read/write the remote state."
}
EOF

cat > bootstrap/terraform.tfvars <<EOF
state_bucket = "$STATE_BUCKET"
lock_table   = "$LOCK_TABLE"
state_user   = "$STATE_USER"
EOF

# --- Step 2: create the backend resources with local state ---
tofu -chdir=bootstrap init
tofu -chdir=bootstrap apply -auto-approve

# --- Step 3: point the project at the new backend and migrate ---
cat > backend.tofu <<EOF
terraform {
  backend "s3" {
    bucket         = "$STATE_BUCKET"
    key            = "demo/project.tfstate"
    region         = "$AWS_REGION"
    dynamodb_table = "$LOCK_TABLE"
    encrypt        = true
  }
}
EOF

tofu init -migrate-state -force

# --- Verify: state file is tracked remotely, lock table is reachable ---
tofu state list
aws s3 ls "s3://$STATE_BUCKET/demo/" --region "$AWS_REGION"
aws dynamodb describe-table --table-name "$LOCK_TABLE" \
  --region "$AWS_REGION" --query 'Table.TableStatus'
echo "Remote state is live: edits from here on read/write s3://$STATE_BUCKET/demo/project.tfstate"
