terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

resource "local_file" "example" {
  content  = "This file is managed by Terraform"
  filename = "${path.module}/example.txt"
}