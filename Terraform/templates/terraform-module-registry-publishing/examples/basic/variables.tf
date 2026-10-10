variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner/team name"
  type        = string
  default     = "platform-team"
}

variable "module_name" {
  description = "Module name"
  type        = string
  default     = "artifact-store"
}