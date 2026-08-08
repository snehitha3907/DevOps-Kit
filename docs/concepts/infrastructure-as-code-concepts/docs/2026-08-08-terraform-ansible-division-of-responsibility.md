---
last_verified: 2026-08-08
tool_version: n/a
sources:
  - https://devops-daily.com/posts/infrastructure-as-code-fundamentals
  - https://teachmeidea.com/infrastructure-as-code-with-terraform-beginner-to-pro/
  - https://www.hyaking.com/infrastructure-as-code-terraform-beginners-guide/
  - https://trungtmnguyen.com/en/blog/common-terraform-mistakes-and-how-to-avoid-them
---

# Terraform provisions, Ansible configures: splitting IaC duties

> L2 concept notes — what I learned when I split cloud-resource creation (Terraform) from software configuration (Ansible) and let each handle the part it is built for.

## What I set out to do

I wanted to practice the "provision-then-configure" split. Instead of one tool doing everything, I let Terraform build the boxes, networks, and security groups, then handed off to Ansible to install packages, drop config files, and start services. My target was a single Nginx web server reachable from the internet, with the cloud resources tracked in Terraform state and the software inside the VM tracked by Ansible.

## How the division maps out

The cleanest way I found to think about it is declarative versus imperative:

- **Terraform** describes what exists. A `resource "aws_instance"` or `resource "aws_security_group"` says "this VM and these firewall rules should be present." Terraform records everything in a state file so it can diff on the next run and update in place instead of recreating.
- **Ansible** describes how to change a machine. A playbook with `apt` and `service` tasks SSHes in and runs commands until Nginx is installed and serving. Ansible is idempotent per-host, but it does not track whether the cloud resource actually exists — it assumes the VM is already reachable.

## Hands-on: the handoff

I ran Terraform first, then fed its output into Ansible:

```bash
# 1. Provision the instance and security group
terraform init
terraform apply -auto-approve -var="key_name=mykey"

# 2. Pull the created IP out of Terraform state
IP=$(terraform output -raw web_ip)

# 3. Hand the IP to Ansible for configuration
ansible-playbook -i "${IP}," --private-key mykey.pem site.yml
```

The linchpin is `terraform output -raw web_ip`. That is how the provisioning tool talks to the configuration tool. Without a clean output value I would have hard-coded the IP, which defeats the whole point of defining things in code instead of repeating manual steps.

## What tripped me up

- **State-file coupling.** Terraform writes its state locally by default. When Ansible modified files inside the VM and I re-ran `terraform apply`, Terraform saw the disk change and wanted to "correct" it back. I kept Ansible managing only things Terraform does not know about — packages, `/etc` config files, running services — so the two never fought over the same state.
- **SSH reachability.** The instance needs a public IP *and* a security group rule allowing my source address on port 22. I forgot the ingress rule the first time and Ansible just timed out with a connection error. The fix was adding the SG rule before the first run.
- **Double-sourcing config values.** I passed the same `worker_count` as both a Terraform variable and an Ansible variable. I caught it because `terraform plan` showed no change while Ansible's diff did — that gap was the clue they were out of sync.

## What I'd try next

I want to flip the SSH bootstrap: use a `user-data` script so the VM boots already configured, while Terraform still owns the cloud-resource lifecycle. I'd also try pulling an Nginx container image instead of installing the apt package, to compare the two configuration styles — image-based versus package-based — within the same divide-of-responsibility model.
