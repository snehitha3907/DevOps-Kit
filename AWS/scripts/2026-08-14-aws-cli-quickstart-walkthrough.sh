#!/bin/bash
# last_verified: 2026-08-14 · AWS CLI v2

# AWS CLI quickstart walkthrough. First trip-up: aws configure is interactive,
# so I set the keys non-interactively to keep this script running unattended.
aws configure set aws_access_key_id AKIAIOSFODNN7EXAMPLE
aws configure set aws_secret_access_key wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
aws configure set default.region us-east-1
# Second trip-up: I ran commands before verifying auth and got NoCredential.
# sts get-caller-identity is the quickstart's "did auth actually work" check.
aws sts get-caller-identity
# Third trip-up: long output opens in a pager and hangs. --no-cli-pager avoids it.
aws ec2 describe-regions --no-cli-pager --query 'Regions[].RegionName' --output text
