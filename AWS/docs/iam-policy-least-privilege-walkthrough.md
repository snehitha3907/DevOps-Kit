---
last_verified: 2026-09-23
tool_version: n/a
sources:
  - https://builder.aws.com/content/3JMln2R0G7HvTyR7udlBirMvh25/7-mistakes-i-wish-i-avoided-when-starting-aws
  - https://builder.aws.com/content/3CoFyKDlRNd8UpwogwkNaStPrul/aws-for-students-start-from-zero
---

# IAM policy walkthrough: scoping least-privilege for a small app stack

## Purpose

A small app stack with S3, DynamoDB, and Lambda needs IAM policies that grant only the permissions each component actually requires. Over-permissive policies are the most common IAM mistake — a Lambda function does not automatically have permission to access AWS services, and "Access Denied" errors are usually about the Lambda execution role rather than the code itself. This walkthrough shows how to scope policies for each layer and verify them with the IAM policy simulator before they reach a real principal.

The approach here works for a stack with one S3 bucket, one DynamoDB table, and one Lambda function. Larger stacks may need additional scoping patterns; this is one way to start, and the principle — grant the minimum that works — stays the same.

## Steps

### 1. Identify the actions each component needs

List the IAM actions each resource will actually call:

- **S3** — the Lambda needs `s3:GetObject` and `s3:PutObject` on the bucket; the app may need `s3:ListBucket` for browsing.
- **DynamoDB** — the Lambda needs `dynamodb:GetItem`, `dynamodb:PutItem`, `dynamodb:Query`, and `dynamodb:Scan` on the table.
- **Lambda** — the function itself needs `logs:CreateLogGroup`, `logs:CreateLogStream`, and `logs:PutLogEvents` for CloudWatch logging.

Write each action as an explicit allow rather than relying on wildcards. If a resource only reads, do not add write actions.

### 2. Scope each policy by resource

Attach policies to the Lambda execution role (not to the user or role that invokes the function). Scope every statement to the specific ARN of the resource the function touches, using path-based conditions where multiple environments share a prefix:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-app-bucket/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:123456789012:table/my-app-table"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/my-app-function:*"
    }
  ]
}
```

One statement per service keeps the policy readable and makes trimming unnecessary actions straightforward. Separate the S3 bucket-level action (like `s3:ListBucket`) into its own statement scoped to the bucket ARN, not the `/*` resource pattern.

### 3. Verify with the IAM policy simulator

Before attaching the role, run the IAM policy simulator (`iam-policy-simulator`) against each policy document. Simulate the Lambda's expected operations — read and write to the S3 bucket, get and put items in DynamoDB — and confirm every one returns `allowed`. Then simulate operations the function should NOT be able to perform (for example, `s3:DeleteBucket` or `dynamodb:DeleteTable`) and confirm they return `denied`.

If the simulator flags an action as implicitly denied, check whether the policy scope is too narrow (a common issue when the ARN misses a required resource path) or whether the action genuinely should not be granted.

## Verify

Confirm the scoping is correct by checking three things. First, every action in the policy maps to a real need identified in step 1 — if an action is present without justification, remove it. Second, the IAM policy simulator reports all expected operations as allowed and all restricted operations as denied. Third, the Lambda function runs end-to-end against the real S3 bucket and DynamoDB table with no `Access Denied` errors, which confirms the simulator results match live behaviour. If any expected operation fails at runtime, compare the error message against the simulated result to find the mismatch — the simulator and live IAM evaluation should agree on every action.
