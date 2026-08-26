# last_verified: 2026-08-25 · OpenTofu · n/a

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# I switched to the local backend so I can inspect the state file directly
# without standing up a remote store like S3 or GCS.

resource "local_file" "hello" {
  content  = "Hello from the local backend!"
  filename = "${path.module}/hello-local.txt"
}

output "state_path" {
  description = "Where the local state file lives"
  value       = terraform.workspace == "default" ? "${path.module}/terraform.tfstate" : "${path.module}/${terraform.workspace}.tfstate"
}
