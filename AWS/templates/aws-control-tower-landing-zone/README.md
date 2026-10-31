---
last_verified: 2026-10-26
tool_version: n/a
---

# aws-control-tower-landing-zone

Terraform module scaffold for AWS Control Tower landing zone.

## What is it?

This module provides the foundational organizational structure for an AWS Control Tower landing zone. It sets up the AWS Organization root, organizational units (OUs) for account grouping, and baseline security configuration scaffolding. This is the starting point before adding specific security controls, account factories, and workload-specific configurations.

## Purpose

Use this scaffold when you need to quickly establish a multi-account landing zone with Control Tower best practices. The module creates:

- **AWS Organization** with all features enabled
- **Organizational Units** for categorizing accounts by function (security, production, non-production, analytics)
- **Baseline variable configuration** for GuardDuty, Security Hub, and Inspector2
- **Outputs** referencing OU IDs for downstream modules

## When to use

- You are starting a new multi-account strategy and need a baseline landing zone.
- You want to standardize OU structure across projects.
- You are integrating or extending an existing Control Tower setup with custom account factories.
- You need a starting point for adding security controls (GuardDuty, Security Hub, Inspector2).

## Prerequisites

- AWS CLI configured with an IAM principal that has `organizations:` permissions to create the root and OUs.
- Terraform `>= 1.5.0` with the `hashicorp/aws` provider.
- The management account must be the organization's root account.

## Steps

1. Initialize Terraform and review the planned changes:

   ```bash
   terraform init
   terraform plan
   ```

2. Apply the scaffold to create the organizational foundation:

   ```bash
   terraform apply
   ```

3. The following outputs will be available for use in downstream modules:

   - `organization_id` — the AWS Organization root ID
   - `security_ou_id` — organizational unit for security-dedicated accounts
   - `production_ou_id` — organizational unit for production workloads
   - `non_production_ou_id` — organizational unit for dev/test/stage accounts
   - `analytics_ou_id` — organizational unit for data and analytics workloads

4. Enable additional security controls by adjusting the `enable_guardduty`, `enable_securityhub`, and `enable_inspector2` variables, or by adding the corresponding AWS resource modules.

## Rollback

To remove the organization and OUs, run:

```bash
terraform destroy
```

Note: Removing the organization root is a destructive operation that requires all member accounts to be disassociated first. Use caution in production environments.

## Common errors

- `Organization already exists` — the management account already has an organization. Use an existing organization or select a different management account.
- `Parent ID not found` — the specified parent OU ID does not exist or is not in the correct hierarchy.
- `Required permissions missing` — the IAM principal lacks `organizations:CreateOrganization` or `organizations:CreateOrganizationalUnit` permissions.

## References

- [AWS Control Tower Documentation](https://docs.aws.amazon.com/controltower/)
- [AWS Organization Documentation](https://docs.aws.amazon.com/orgs/latest/userguide/orgs-organizations-create.html)
- [Terraform AWS Provider - Organization Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organization)