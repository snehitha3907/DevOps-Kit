terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

# I kept the variable block inline here so the whole config is one file
variable "greeting" {
  description = "Text to write into the local file"
  type        = string
  default     = "Hello from Terraform with variables and outputs!"
}

variable "output_dir" {
  description = "Directory to write the file in"
  type        = string
  default     = "."
}

resource "local_file" "hello" {
  content  = var.greeting
  filename = "${pathexpand(var.output_dir)}/hello-vars.txt"
}

output "written_to" {
  description = "Absolute path of the created file"
  value       = abspath(local_file.hello.filename)
}

output "content_length" {
  description = "Character count of the written content"
  value       = length(local_file.hello.content)
}
