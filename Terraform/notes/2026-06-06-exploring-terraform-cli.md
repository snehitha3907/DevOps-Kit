# Exploring Terraform CLI

I installed Terraform and ran init, plan, and apply on a tiny project.

## Setting up

Used the install script that sets up Terraform. Created a fresh folder for a test project.

## init

Ran `terraform init`. It downloaded the provider plugins and set up the working directory. Took a few seconds.

## plan

Made a simple main.tf with a local_file resource. Ran `terraform plan` — it showed what would be created without touching anything. Saw "+ local_file.demo" in the output.

## apply

Ran `terraform apply`. It showed the plan again and asked for confirmation. Typed "yes". The file hello.txt appeared with "Hello from Terraform!" inside.

## Got stuck on

The `-auto-approve` flag skips the confirmation prompt. I used it in the script but running `terraform apply` interactively first helped me understand what was happening.
