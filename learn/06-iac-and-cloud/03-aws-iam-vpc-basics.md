---
last_verified: 2026-11-13
tool_version: n/a
sources:
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
  - https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
  - https://docs.aws.amazon.com/vpc/latest/userguide/subnet-route-tables.html
  - https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-troubleshooting.html
  - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html
---
# AWS identity and networking basics

You set up the AWS CLI in the primer and confirmed who you are with `aws sts get-caller-identity`. Before you launch anything that costs money, this lesson shows you how to create a least-privilege IAM role, build a VPC with public and private subnets, and set a billing alarm so you're notified of spend before it surprises you.

## What you'll learn
- Create a least-privilege IAM role and explain each permission in its trust and permissions policies.
- Describe a VPC with public and private subnets and how traffic leaves each one.
- Set a CloudWatch billing alarm before creating any other AWS resource.

## Before you start
- [AWS — quick primer](../../AWS/notes/0000-primer-aws.md) — the AWS CLI is installed and configured, and you can run `aws sts get-caller-identity` to confirm your identity.
- [Probe HTTP and TLS endpoints](../02-networking/03-http-tls-probes.md) — you're comfortable reading command output and verifying endpoints.
- The AWS CLI installed; confirm with `aws --version`.

## Walkthrough

1. Create a least-privilege IAM role.

   An IAM role is an assumable identity with no long-term credentials of its own. It is defined by two policies: a trust policy that states *who* may assume the role (the principal who may assume, Action: `sts:AssumeRole`), and a permissions policy that states *what* the assumed session may touch (actions and resources).

   Write the trust policy to a file:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Service": "ec2.amazonaws.com"
         },
         "Action": "sts:AssumeRole"
       }
     ]
   }
   ```

   Create the role:

   ```bash
   aws iam create-role --role-name lab-ec2-readonly --assume-role-policy-document file://ec2-trust-policy.json
   ```

   You should see the role's ARN and the trust policy echoed back.

   Now attach a least-privilege permissions policy. Grant only the actions the task needs, on specific ARNs — never `*`:

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
         "Resource": "arn:aws:s3:::my-lab-bucket/*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "logs:CreateLogGroup",
           "logs:CreateLogStream",
           "logs:PutLogEvents"
         ],
         "Resource": "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/my-lab-function:*"
       }
     ]
   }
   ```

   Save this as `ec2-readonly-permissions.json` and attach it:

   ```bash
   aws iam put-role-policy --role-name lab-ec2-readonly --policy-name EC2ReadOnlyS3Logs --policy-document file://ec2-readonly-permissions.json
   ```

   Explain each permission: `s3:GetObject`/`s3:PutObject` let the role read and write objects in `my-lab-bucket` only; the `logs:*` actions let it write CloudWatch logs under `my-lab-function` only. Nothing else is permitted.

2. Describe a VPC with public and private subnets.

   A VPC is a logically isolated virtual network. Subnets are IP ranges that live in a single Availability Zone, and route tables direct traffic. In a public/private split:

   - Public subnet: its route table sends `0.0.0.0/0` to an internet gateway (`igw-id`), so instances there can reach the internet and be reached from it.
   - Private subnet: its route table sends `0.0.0.0/0` to a NAT gateway. The NAT gateway lives in a public subnet, has an Elastic IP, and routes out through the VPC's internet gateway. Instances in the private subnet can reach the internet for updates but cannot be reached directly from the internet.

   You can inspect an existing VPC's subnets and routes:

   ```bash
   aws ec2 describe-vpcs --vpc-ids vpc-0123456789abcdef0
   aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-0123456789abcdef0
   ```

   You should see route entries with `GatewayId` set to an internet gateway for the public route table, and `NatGatewayId` set for the private route table.

   Reference: the VPC stack at `AWS/scripts/build-vpc-ec2-rds-stack.py` builds this exact public/private layout with an internet gateway and a NAT gateway in the public subnet.

3. Set a billing alarm before creating anything else.

   Billing alerts must be enabled in the Billing console first; metric data becomes available after about 15 minutes. Then, in CloudWatch — in the US East (N. Virginia / `us-east-1`) region, where worldwide billing data is stored — create an alarm on the metric `Billing > Total Estimated Charge > EstimatedCharges`, statistic `Maximum`, period 6 hours, static threshold greater than your chosen USD value, with an SNS topic for notification.

   ```bash
   aws cloudwatch put-metric-alarm \
     --alarm-name lab-billing-alarm \
     --alarm-description "Alert when estimated charges exceed threshold" \
     --metric-name EstimatedCharges \
     --namespace AWS/Billing \
     --statistic Maximum \
     --period 21600 \
     --threshold 10.0 \
     --comparison-operator GreaterThanThreshold \
     --evaluation-periods 1 \
     --alarm-actions arn:aws:sns:us-east-1:123456789012:lab-billing-alerts \
     --region us-east-1
   ```

   The alarm fires only when current billing exceeds the threshold, not on projections. `21600` seconds is the 6-hour period.

## Exercise

1. Write a trust policy JSON file for a role that an EC2 instance may assume, then create the role with `aws iam create-role --assume-role-policy-document file://<your-file>.json`.
2. Write a least-privilege permissions policy that grants exactly two actions on one specific resource ARN, attach it with `aws iam put-role-policy`, and explain each permission in one sentence.
3. Sketch (in comments or a text file) the route-table entries for a public subnet and a private subnet, naming the internet gateway and NAT gateway targets respectively.
4. Write the `aws cloudwatch put-metric-alarm` command for a billing alarm, naming the metric, namespace, statistic, period, threshold, and SNS action.

## Check your work

- `aws iam get-role --role-name lab-ec2-readonly` prints the role ARN and its trust policy shows `Service: ec2.amazonaws.com` with `Action: sts:AssumeRole`.
- `aws iam get-role-policy --role-name lab-ec2-readonly --policy-name EC2ReadOnlyS3Logs` lists only `s3:GetObject`, `s3:PutObject`, and the three `logs:*` actions, each scoped to specific ARNs — no `*`.
- Your route-table sketch shows `0.0.0.0/0 -> igw-...` for public and `0.0.0.0/0 -> nat-...` for private.
- Your billing-alarm command uses namespace `AWS/Billing`, metric `EstimatedCharges`, statistic `Maximum`, period `21600`, region `us-east-1`, and an SNS alarm action.

## Common mistakes

- Using `*` as the Principal in a trust policy — a wildcard principal ARN is not allowed; name the exact service or account role instead.
- Attaching a broad AWS managed policy instead of a customer managed policy scoped to the actions you actually need — start managed, then tighten.
- Placing the NAT gateway in the private subnet — it must live in a public subnet with a route to the internet gateway and an Elastic IP, or private instances cannot reach the internet.
- Creating the billing alarm in the wrong region — CloudWatch billing metrics live in `us-east-1` only.

## Next

[Terraform — quick primer](../../Terraform/notes/0000-primer-terraform.md)
