plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_deprecated_syntax" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format = "snake_case"
}

rule "terraform_module_version" {
  enabled = true
  source = "registry"
}

rule "aws_security_group_description" {
  enabled = true
}

rule "aws_instance_no_public_ip" {
  enabled = false
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_providers" {
  enabled = true
}