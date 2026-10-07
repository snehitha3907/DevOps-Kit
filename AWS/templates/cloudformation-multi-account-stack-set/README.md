---
last_verified: 2026-10-07
tool_version: n/a
---

# cloudformation-multi-account-stack-set

A CloudFormation StackSet template that deploys a small, safe baseline into multiple AWS accounts.

## What is in the box

- `template.yaml` — the shared CloudFormation template body (S3 bucket, IAM group, SNS topic)
- `examples/deploy.sh` — example CLI commands for creating the StackSet and its instances

## Purpose

A StackSet is a stack that CloudFormation deploys once into a list of target accounts, in one or more regions. This template is the shared, account-agnostic definition; the StackSet itself (its name, the list of accounts, the regions) is created outside this file, either through the console, the CLI, or a Terraform `aws_cloudformation_stack_set` resource. The template deliberately contains no account IDs, region literals, or credentials — those live in the StackSet operation, not here.

## When to use

Reach for this template when a baseline needs to be applied uniformly across a set of AWS accounts — for example, to guarantee that every account has an encrypted S3 bucket for CloudTrail logs, a baseline IAM group, and an operational SNS topic. It is intentionally compute-free, so it is safe to roll out to accounts that are still being set up. Do not use it for per-account resources that differ between accounts; those belong in per-account stacks, not the StackSet.

## Prerequisites

- The AWS CLI configured as an IAM principal in the management (payer) account.
- That principal needs `cloudformation:CreateStackSet` and, for each target account, `cloudformation:CreateStackInstances`.
- The target accounts must accept the StackSet; accounts that are not part of the organization need an invitation.

## Steps

1. Create the StackSet from the template body. Capabilities are `IAM` because the template creates an IAM group:

   ```bash
   aws cloudformation create-stack-set \
     --stack-set-name baseline-multi-account \
     --template-body file://template.yaml \
     --capabilities IAM \
     --parameters ParameterKey=LogBucketName,ParameterValue=baseline-cloudtrail-logs \
                   ParameterKey=SNSTopicName,ParameterValue=baseline-notifications
   ```

2. Deploy the set into the target accounts and regions. Capabilities are repeated per operation because each stack instance needs them:

   ```bash
   aws cloudformation create-stack-instances \
     --stack-set-name baseline-multi-account \
     --regions us-east-1 us-west-2 \
     --accounts 111111111111 222222222222 \
     --operation-preferences RegionConcurrencyOrder=us-east-1,us-west-2 \
                             FailureToleranceCount=1 \
                             MaxConcurrentCount=1
   ```

3. List the stacks the operation created, per account:

   ```bash
   aws cloudformation list-stack-instances \
     --stack-set-name baseline-multi-account \
     --query 'Summaries[*].[Account,Region,StackInstanceStatus]'
   ```

4. Roll the set out to a third account later with the same operation, or delete an instance in one account without touching the others:

   ```bash
   aws cloudformation delete-stack-instances \
     --stack-set-name baseline-multi-account \
     --regions us-east-1 \
     --accounts 111111111111 \
     --retain-stacks false
   ```

`examples/deploy.sh` contains the full sequence as runnable commands.

## Verify

- `aws cloudformation describe-stack-set --stack-set-name baseline-multi-account` shows the set with the expected capabilities and parameters.
- `aws cloudformation list-stack-instances --stack-set-name baseline-multi-account` shows one entry per (account, region) pair, all in `CURRENT` status.
- In one target account, `aws cloudformation describe-stacks --stack-name baseline-multi-account` shows the bucket, group, and topic the template declares.

## Rollback

A StackSet is rolled back per instance, not as a whole. If a bad template change is rolled out, update the StackSet template and run `create-stack-instances` again; CloudFormation updates existing instances in place. To remove an account's instance without deleting the set, use `delete-stack-instances` with `--retain-stacks false`. To remove the set entirely, delete all instances first, then `delete-stack-set`.

## Common errors

- `create-stack-instances` fails with `StackInstanceAlreadyExists` → the account already has an instance from a previous run; describe it before re-running.
- A region/account pair is missing from the list → the set never deployed there; add it with `create-stack-instances`.
- `ValidationError: Capabilities does not specify IAM` → the template creates an IAM resource, so `--capabilities IAM` is required on every operation that touches it.
- A target account rejects the operation → the account is not part of the organization, or the management account lacks the cross-account role; invite the account or grant the role first.

## References

- `template.yaml` — the shared CloudFormation template body.
- `examples/deploy.sh` — the full CLI sequence as runnable commands.
- CloudFormation StackSets: the mechanism that deploys one template to many accounts and regions from a single definition.