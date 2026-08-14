#!/bin/bash
# last_verified: 2026-08-14 · AWS CLI

# I followed the AWS CLI quickstart. Here's what tripped me up.

# 1. `aws sts get-caller-identity` is the recommended sanity check, but it
#    only works after `aws configure` has real credentials. I ran it first
#    with the example keys from the docs and got a cryptic auth error.
# 2. `aws s3 ls` returns empty output when no buckets exist — not an error.
#    Easy to misread as "broken" when you're new to the CLI.
# 3. `aws s3 mb` needs a globally unique bucket name. `my-first-bucket`
#    usually fails because it's already taken. Appending a timestamp works
#    around that for a quick experiment.

aws sts get-caller-identity
aws s3 ls
aws s3 mb "s3://my-first-bucket-$(date +%s)"
aws s3 ls