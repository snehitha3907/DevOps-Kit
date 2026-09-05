---
last_verified: 2026-09-03
tool_version: n/a
sources: []
---

# Installing Terraform and my first plan/apply with local_file

I wanted to get Terraform onto this machine and prove it actually does something end-to-end without a cloud account. The `local_file` resource is the classic first target — it's built into Terraform, doesn't need a provider, and you can `cat` the result to confirm it worked.

## Installing Terraform

I grabbed the official HashiCorp zip and dropped `terraform` into `~/bin`:

```bash
# Download the latest Linux amd64 zip from releases.hashicorp.com/terraform
# (look for the newest version directory and grab terraform_<ver>_linux_amd64.zip)
curl -fsSL -o /tmp/tf.zip <paste the URL from releases.hashicorp.com here>
unzip /tmp/tf.zip -d ~/bin
export PATH="$HOME/bin:$PATH"
terraform -version
```

`terraform -version` is the source of truth for what you installed.

## My first plan/apply with local_file

```bash
mkdir ~/tf-first-run && cd ~/tf-first-run
```

```hcl
# main.tf
resource "local_file" "hello" {
  filename = "${path.module}/hello.txt"
  content  = "Hello from Terraform!\nApplied at: ${timestamp()}\n"
}
```

```bash
terraform init      # sets up the working dir; downloads nothing for local_file
terraform plan      # shows "+ create local_file.hello"
terraform apply     # types "yes" at the prompt, creates hello.txt
cat hello.txt
```

`terraform.tfstate` shows up after apply. Don't delete it — Terraform uses it to track what it manages; a missing state file makes the next plan treat the resource as brand new.

## What tripped me up

- `terraform init` for `local_file` only prints "Initializing the backend..." — there's nothing to download.
- Forgetting to `cd` back into the dir between commands. Terraform only knows `.tf` files in the cwd.
- Saying no at the `terraform apply` prompt exits cleanly with no error and no state change.

```bash
terraform destroy   # removes hello.txt
rm -rf ~/tf-first-run
```

Whole loop is about five minutes the first time.
