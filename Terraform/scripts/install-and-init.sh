#!/bin/bash
# Install Terraform and run my first project
sudo snap install terraform --classic
terraform version
mkdir -p ~/terraform-first-project && cd ~/terraform-first-project
terraform init
cat > main.tf << 'EOF'
resource "local_file" "demo" {
  filename = "hello.txt"
  content  = "Hello from Terraform!"
}
EOF
terraform plan
terraform apply -auto-approve