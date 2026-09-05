---
last_verified: 2026-09-05
tool_version: n/a
sources:
  - https://markaicode.com/integrate/ansible-with-terraform/
  - https://scalr.com/learning-center/ultimate-guide-to-using-terraform-with-ansible
  - https://resources.cloudcops.com/blogs/terraform-and-ansible
---

# Combining scripting with IaC: automation patterns for Terraform and Ansible workflows

> How scripting glues Terraform provisioning and Ansible configuration into a single, repeatable pipeline.

## What this covers

Terraform and Ansible each solve a piece of the infrastructure puzzle — Terraform provisions cloud resources, Ansible configures the software on them. But in practice, you rarely run them in isolation. The handoff between "infrastructure is ready" and "software is configured" is where scripting earns its keep.

This doc walks through the automation patterns that connect the two tools: how Terraform outputs feed Ansible inventory, how wrapper scripts orchestrate the sequential workflow, and how you wire the whole thing into CI/CD without custom glue code falling apart.

## When to use this pattern

The Terraform-provisions-Ansible-configures model works when:

- You need cloud resources (VPCs, instances, load balancers) provisioned first, then configured (packages, services, users).
- Your infrastructure lives in multiple environments (dev/staging/prod) with shared modules but different values.
- You want a single pipeline entry point that runs both tools in sequence, reports failures clearly, and can be triggered from CI/CD.

It breaks down when:

- Configuration and provisioning are deeply entangled (use a single tool instead).
- You only manage configuration on existing infrastructure (Ansible alone suffices).

## Prerequisites

- Terraform installed and a working configuration with at least one output block exposing connection details.
- Ansible installed with the `cloud.terraform.terraform_provider` inventory plugin (available in ansible-core 2.15+).
- Both tools authenticated to your target cloud (AWS, GCP, Azure, etc.).

## Pattern 1: Terraform output → Ansible dynamic inventory

The canonical integration avoids hardcoded IPs entirely. Terraform provisions instances and exposes their details as outputs. Ansible reads those outputs directly via the `cloud.terraform.terraform_provider` inventory plugin.

**Terraform side** — expose outputs for Ansible:

```hcl
output "web_server_ips" {
  value = aws_instance.web[*].public_ip
}

output "db_server_ips" {
  value = aws_instance.db[*].private_ip
}
```

**Ansible side** — consume via the Terraform provider plugin:

```yaml
# ansible.cfg
[inventory]
enable_plugins = cloud.terraform.terraform_provider

# playbook
- hosts: all
  become: yes
  roles:
    - common
    - webserver
```

The plugin reads Terraform state directly and populates the Ansible inventory with the correct hosts, tags, and connection details. No wrapper script needed for the inventory piece — the plugin handles it.

## Pattern 2: Wrapper script for sequential orchestration

When you need a single entry point that runs both tools in order, a bash wrapper script is the simplest approach. The key design choices:

1. Run `terraform apply` first, check exit code, and only proceed to Ansible on success.
2. Capture Terraform output for logging and debugging.
3. Pass environment-specific variables to both tools from a single source.

```bash
#!/usr/bin/env bash
# last_verified: 2026-09-05 · Terraform + Ansible integration
set -euo pipefail

ENVIRONMENT="${1:?Usage: $0 <environment>}"
TF_DIR="infrastructure/terraform/environments/${ENVIRONMENT}"
ANSIBLE_DIR="infrastructure/ansible"

echo "=== Terraform: provisioning ${ENVIRONMENT} ==="
cd "$TF_DIR"
terraform init -upgrade
terraform apply -auto-approve -var="environment=${ENVIRONMENT}"
terraform output -json > "/tmp/tf-output-${ENVIRONMENT}.json"

echo "=== Ansible: configuring ${ENVIRONMENT} ==="
cd "../../ansible"
ansible-playbook -i inventory/"${ENVIRONMENT}" site.yml \
  -e "@/tmp/tf-output-${ENVIRONMENT}.json"

echo "=== Done: ${ENVIRONMENT} provisioned and configured ==="
```

This pattern keeps the Terraform and Ansible directories separate while linking them through a single script. The JSON output file is optional — if you use the `cloud.terraform.terraform_provider` plugin, Ansible reads state directly.

## Pattern 3: Multi-environment directory layout

Production teams typically separate Terraform modules from per-environment values and keep Ansible roles independent:

```
infrastructure/
├── terraform/
│   ├── modules/          # reusable VPC, EC2, RDS modules
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── dev.tfvars
│   │   ├── staging/
│   │   └── prod/
├── ansible/
│   ├── inventory/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   ├── roles/
│   │   ├── common/
│   │   ├── webserver/
│   │   └── database/
│   └── site.yml
```

Terraform outputs per environment feed Ansible inventory via tag-based filtering. The `aws_ec2` dynamic inventory plugin with tag filters (`tag:Environment: production`, `tag:Role: web-server`) eliminates hardcoded IPs and keeps inventory in sync with provisioned infrastructure.

## Pattern 4: CI/CD integration

In a GitHub Actions or GitLab CI pipeline, the two tools run as sequential stages:

```yaml
# GitHub Actions example
stages:
  - provision
  - configure

provision:
  stage: provision
  script:
    - cd infrastructure/terraform/environments/${ENVIRONMENT}
    - terraform init
    - terraform plan -out=tfplan
    - terraform apply tfplan

configure:
  stage: configure
  needs: [provision]
  script:
    - cd infrastructure/ansible
    - ansible-playbook -i inventory/${ENVIRONMENT} site.yml
```

The `needs: [provision]` dependency ensures Ansible only runs after Terraform succeeds. If Terraform fails, the pipeline stops — no half-configured infrastructure.

## Verify

- Run `terraform output` and confirm the outputs expose the values Ansible needs (IPs, tags, connection details).
- Run `ansible-inventory -i inventory/<env> --list` and confirm hosts appear with correct variables from Terraform.
- Test the wrapper script end-to-end in a dev environment: provision → configure → verify services are running.
- Check that `terraform destroy` followed by re-provisioning produces identical inventory (no stale state).

## Common errors

- **Ansible can't find hosts**: The Terraform inventory plugin requires the `cloud.terraform.terraform_provider` collection. Install it with `ansible-galaxy collection install cloud.terraform`.
- **State file mismatch**: If Terraform state is stored remotely (S3, GCS), ensure Ansible has access to the same backend. The plugin reads the local `terraform.tfstate` by default — configure `backend_config` if using remote state.
- **Tag-based inventory returns empty**: AWS EC2 instances must have the expected tags (`Environment`, `Role`) applied by Terraform. Check `aws ec2 describe-instances --filters "tag:Environment=${ENVIRONMENT}"` to confirm.

## References

- [Integrating Ansible with Terraform](https://markaicode.com/integrate/ansible-with-terraform/) — canonical integration pattern using the Terraform provider plugin.
- [Ultimate Guide to Using Terraform with Ansible](https://scalr.com/learning-center/ultimate-guide-to-using-terraform-with-ansible) — multi-environment layout and dynamic inventory patterns.
- [Terraform and Ansible](https://resources.cloudcops.com/blogs/terraform-and-ansible) — performance benchmarks showing 40–60% faster Day 0→1 with combined workflows.
