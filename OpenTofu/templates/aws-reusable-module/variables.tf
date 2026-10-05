# last_verified: 2026-10-05 · OpenTofu n/a
# Inputs for the shared VPC module. Every value a caller is likely to vary
# per environment is a variable; everything structural (DNS support, route
# table layout) stays fixed inside main.tf.

variable "project_name" {
  description = "Short name stamped onto every resource Name tag."
  type        = string
}

variable "environment" {
  description = "Environment label stamped onto every resource Name tag (e.g. dev, staging, prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. Subnet CIDRs must sit inside it."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across. Subnets wrap around this list."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "One CIDR per public subnet (routed through the internet gateway)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "One CIDR per private subnet (routed through NAT when enabled, isolated otherwise)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "When true, create NAT gateways plus private route tables so private subnets reach the internet outbound. When false, private subnets stay fully isolated and no NAT charges accrue."
  type        = bool
  default     = true

  validation {
    condition     = !var.enable_nat_gateway || length(var.public_subnet_cidrs) > 0
    error_message = "enable_nat_gateway requires at least one public subnet to host the NAT gateway."
  }
}

variable "tags" {
  description = "Extra tags merged onto every resource (project cost-centre, owner, etc.)."
  type        = map(string)
  default     = {}
}
