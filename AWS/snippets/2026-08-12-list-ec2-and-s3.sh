#!/bin/bash
# last_verified: 2026-08-12 · AWS CLI
# I wanted to see what EC2 instances and S3 buckets I have running.
# ec2 describe-instances prints everything by default, so I added a --query to keep it short.

aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
  --output table

aws s3 ls
