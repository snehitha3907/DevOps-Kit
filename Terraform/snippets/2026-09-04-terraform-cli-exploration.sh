# last_verified: 2026-09-04 · Terraform · n/a

# init → plan → apply → destroy with the local provider

mkdir tf-demo && cd tf-demo
cat > main.tf <<'EOF'
resource "local_file" "hello" {
  content  = "Hello from Terraform!"
  filename = "hello.txt"
}
EOF
terraform init && terraform plan
terraform apply -auto-approve && cat hello.txt
terraform destroy -auto-approve
cd .. && rm -rf tf-demo
