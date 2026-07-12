---
last_verified: 2026-07-12
tool_version: n/a
---
# AWS CLI — quick primer

> First-day notes for someone who's never used the AWS CLI. Personal voice, plain language.

## What is it?

The AWS CLI (Command-Line Interface) is the official tool for talking to Amazon Web Services from your terminal. It's what `gcloud` is to GCP or `az` is to Azure — a single binary that turns REST API calls into shell commands. You type `aws s3 ls` instead of writing HTTP requests against the S3 API.

## What does it do?

It lets you create, list, update, and delete AWS resources — EC2 instances, S3 buckets, IAM users, Lambda functions, everything — all from the command line. You can pipe output through `jq` or `grep`, wire it into shell scripts, or use it in CI/CD pipelines. Most of what the web console does, the CLI can do faster.

## Why does it exist?

Before the CLI, managing AWS meant either clicking through the web console (slow, error-prone, impossible to automate) or writing raw API clients in Python/boto3 or similar SDKs. The CLI gives you a middle ground: scriptable, repeatable, and much lower friction than writing code for one-off tasks. Sysadmins, DevOps engineers, and CI/CD pipelines all use it daily.

## Key terminology

- **Profile** — A named set of credentials and region settings you can switch between. Example: `aws s3 ls --profile dev` uses the "dev" profile's keys.
- **Region** — The AWS data-center location your commands target (e.g. `us-east-1`, `eu-west-2`). Every command implicitly or explicitly targets one.
- **`aws configure`** — The interactive setup command that writes your access key, secret key, default region, and output format to `~/.aws/credentials` and `~/.aws/config`.
- **Access Key ID + Secret Access Key** — The long-lived credential pair the CLI uses to authenticate API calls. You generate these from the IAM console.
- **`--output`** — Controls how results are printed: `json` (default), `text`, `table`, or `yaml`. I mostly use `json` and pipe through `jq`.
- **`--dry-run`** — A flag on some commands that checks whether you *could* perform the action without actually doing it. Good for validation before destructive operations.
- **`aws sts get-caller-identity`** — The "who am I?" command. It prints the account number, ARN, and user ID the current credentials resolve to. First thing I run after configuring.
- **`~/.aws/config`** — The INI-style file that holds profile settings (region, output format). Distinct from `~/.aws/credentials` which holds the secret keys.
- **`~/.aws/credentials`** — The file that stores access key pairs. Sensitive — should never be committed to git.

## A tiny example

```bash
# Configure a profile interactively
aws configure

# Verify who you're authenticated as
aws sts get-caller-identity

# List all S3 buckets in the default region
aws s3 ls
```

This sets up credentials for the first time, confirms the auth worked, and lists your buckets. Three commands, no web browser needed.

## What I'll cover next

I want to try creating and managing actual resources — spinning up an EC2 instance from the CLI, setting up IAM roles, and automating S3 bucket operations in a script. After that I'll explore more advanced features like SSM session manager and CloudFormation deployments.
