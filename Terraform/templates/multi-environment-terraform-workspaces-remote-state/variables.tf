# last_verified: 2026-09-13 · Terraform · n/a
# Shared input variables. Values are supplied per environment via
# environments/<env>/terraform.tfvars.

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
}

variable "environment" {
  description = "Name of the environment (dev, prod, ...)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the sample service."
  type        = string
  default     = "t3.micro"
}

variable "dynamodb_table" {
  description = "DynamoDB table used for state locking."
  type        = string
  default     = "tf-state-lock"
}