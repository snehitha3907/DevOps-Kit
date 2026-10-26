# last_verified: 2026-10-26 · AWS · n/a
# Input variables for the Control Tower landing zone scaffold.

variable "aws_region" {
  description = "AWS region for the organization root and OUs"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Management account ID where the organization root exists"
  type        = string
}

variable "enable_guardduty" {
  description = "Whether to enable GuardDuty across the landing zone"
  type        = bool
  default     = true
}

variable "enable_securityhub" {
  description = "Whether to enable Security Hub across the landing zone"
  type        = bool
  default     = true
}

variable "enable_inspector2" {
  description = "Whether to enable Inspector2 across the landing zone"
  type        = bool
  default     = true
}