#!/bin/bash
# Bootstrap a Terraform project with variables and outputs
# I wanted to see how a real project is structured — separate files for
# resources, variables, and outputs — instead of cramming everything into main.tf

mkdir -p ~/tf-structured-project
cd ~/tf-structured-project || exit

# main.tf — the resource declaration using a variable for the filename
cat > main.tf << 'TF'
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

resource "local_file" "greeting" {
  content  = var.file_content
  filename = "${path.module}/${var.file_name}"
}
TF

# variables.tf — lets me change content and filename without editing the resource block
cat > variables.tf << 'TF'
variable "file_content" {
  description = "Content to write into the file"
  type        = string
  default     = "Hello from my structured Terraform project!"
}

variable "file_name" {
  description = "Name of the output file"
  type        = string
  default     = "greeting.txt"
}
TF

# outputs.tf — shows me the result path after apply
cat > outputs.tf << 'TF'
output "file_path" {
  description = "Full path of the generated file"
  value       = abspath(local_file.greeting.filename)
}

output "file_content_preview" {
  description = "First 50 characters of the file content"
  value       = substr(local_file.greeting.content, 0, 50)
}
TF

terraform init
terraform plan
terraform apply -auto-approve

echo "--- Outputs ---"
terraform output

echo "--- File created at ---"
terraform output -raw file_path

# Clean up so I can re-run this script
terraform destroy -auto-approve
