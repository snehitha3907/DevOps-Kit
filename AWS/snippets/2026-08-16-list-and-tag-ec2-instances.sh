#!/bin/bash
# last_verified: 2026-08-16 · AWS CLI v2
# I wanted to see what EC2 instances I have running and practice tagging them with the AWS CLI.

# List all EC2 instances in the current region with their state, AZ, and Name tag.
# I used --query to pull out just the fields I care about so the output stays readable.
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Placement.AvailabilityZone,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# Tag an instance with a Name and Environment tag.
# Replace i-1234567890abcdef0 with your actual instance ID.
INSTANCE_ID="i-1234567890abcdef0"
aws ec2 create-tags \
  --resources "$INSTANCE_ID" \
  --tags Key=Name,Value=my-web-server Key=Environment,Value=dev
