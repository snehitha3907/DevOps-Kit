# last_verified: 2026-10-27 · terraform n/a

variable "region" {
  type        = string
  description = "AWS region for this environment."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (dev, staging, prod)."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the environment VPC."
  default     = "10.0.0.0/16"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}
