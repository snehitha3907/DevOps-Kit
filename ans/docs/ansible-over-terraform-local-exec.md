---
last_verified: 2026-07-27
tool_version: n/a
---

# Ansible over Terraform local-exec for post-provisioning tasks

## Purpose

When Terraform provisions infrastructure and needs to configure it immediately afterward, the `local-exec` provisioner can invoke an Ansible playbook on the machine running Terraform. This decouples the provisioning step from the configuration step while keeping both in a single deployment workflow. The pattern is useful when the provisioner does not support remote execution natively and Ansible must run against the newly created resources from the local workstation.

## When to use

- The Terraform resource type does not support a built-in configuration management provider (e.g., `remote-exec` is unavailable or insufficient).
- Ansible needs to run from the local machine with access to the local SSH agent or inventory, and the target hosts are reachable from the workstation.
- The post-provisioning configuration is short-lived and does not justify a separate CI/CD pipeline or dedicated automation server.

## Prerequisites

- Terraform installed and authenticated with the target cloud provider.
- Ansible installed on the machine running `terraform apply`.
- SSH access to the provisioned hosts (key-based authentication recommended).
- A valid Ansible inventory or dynamically generated inventory from Terraform outputs.

## Steps

1. **Define the Terraform resource with a `local-exec` provisioner.** The provisioner runs a shell command on the local machine after the resource is created. Invoke `ansible-playbook` with the appropriate inventory and playbook path.

   ```hcl
   resource "aws_instance" "web" {
     ami           = "ami-0c02fb55956c7d316"
     instance_type = "t2.micro"

     provisioner "local-exec" {
       command = <<EOT
         ansible-playbook -i ${self.public_ip}, configure-web.yml \
           --private-key ${var.ssh_private_key} \
           --user ubuntu
       EOT
     }
   }
   ```

2. **Write the Ansible playbook to target the instance.** Use the IP address passed from Terraform as the inventory source. The playbook should handle idempotent configuration of the web server, including package installation, service startup, and firewall rules.

   ```yaml
   ---
   - hosts: localhost
     become: yes
     tasks:
       - name: Install nginx
         apt:
           name: nginx
           state: present
           update_cache: yes

       - name: Start and enable nginx
         service:
           name: nginx
           state: started
           enabled: yes

       - name: Configure firewall
         ufw:
           rule: allow
           port: "80"
           proto: tcp
   ```

3. **Pass Terraform outputs to Ansible using environment variables or a generated inventory file.** For multiple hosts, write a dynamic inventory script that reads Terraform state or use `terraform output` to generate a JSON inventory.

   ```hcl
   provisioner "local-exec" {
     command = <<EOT
       export TF_INVENTARY=$(terraform output -json instance_ips)
       ansible-playbook -i <(echo "${TF_INVENTARY}") configure-all.yml
     EOT
   }
   ```

4. **Run `terraform apply` and observe the Ansible output.** The `local-exec` provisioner executes after the `aws_instance` resource is created. Ansible connects to the new instance and applies the playbook. If Ansible fails, Terraform rolls back the resource creation.

## Verify

- After `terraform apply` completes, confirm the target host is reachable via SSH and the configured service is running.
- Run the Ansible playbook manually against the same inventory to verify idempotency: `ansible-playbook -i <inventory> configure-web.yml` should report `ok` with no `changed` tasks on a second run.
- Check the Terraform state to confirm the resource was created and the provisioner command exited successfully (return code 0).
- Inspect the Ansible log output for any task failures or unreachable hosts.

## Rollback

- If the Ansible playbook fails during `terraform apply`, Terraform marks the resource as tainted and rolls back the creation. Re-run `terraform apply` after fixing the playbook to recreate the resource.
- To remove the infrastructure and its configuration, run `terraform destroy`, which destroys the resources but does not clean up any configuration applied by Ansible (SSH keys, firewall rules on the instance must be cleaned manually if needed).
