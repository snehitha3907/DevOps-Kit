# last_verified: 2026-08-25 · Terraform · n/a
#
# Reusable VPC module: one VPC, public + private subnets across the given
# Availability Zones, an Internet Gateway for the public tier, and optional
# NAT Gateways so the private tier can reach the internet outbound.
#
# The module body below is written as a single-file reference (variables,
# resources, outputs together). To consume it, place the variable/resource/
# output blocks in a module directory and call it from a root module:
#
#   module "vpc" {
#     source               = "./modules/vpc"
#     name                 = "app-dev"
#     vpc_cidr             = "10.0.0.0/16"
#     availability_zones   = ["us-east-1a", "us-east-1b"]
#     public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
#     private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
#   }
#
# No provider version constraint is declared here on purpose — pin the AWS
# provider in the root module where the upgrade decision belongs.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "name" {
  description = "Short project name used to tag every resource (Name = <name>-<role>)."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC itself, e.g. 10.0.0.0/16."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block, e.g. 10.0.0.0/16."
  }
}

variable "availability_zones" {
  description = "AZ names to spread subnets across, e.g. [\"us-east-1a\", \"us-east-1b\"]. Subnet lists map onto these by index."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 1
    error_message = "Provide at least one Availability Zone."
  }
}

variable "public_subnet_cidrs" {
  description = "One CIDR per public subnet (internet-facing load balancers, NAT gateways)."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) >= 1 && alltrue([for c in var.public_subnet_cidrs : can(cidrnetmask(c))])
    error_message = "public_subnet_cidrs must be a non-empty list of valid IPv4 CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "One CIDR per private subnet (application servers, databases — no direct inbound from the internet)."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) >= 1 && alltrue([for c in var.private_subnet_cidrs : can(cidrnetmask(c))])
    error_message = "private_subnet_cidrs must be a non-empty list of valid IPv4 CIDR blocks."
  }
}

variable "enable_nat_gateway" {
  description = "Whether private subnets get outbound-only internet access through NAT Gateway(s). A NAT Gateway bills hourly whether traffic flows or not (~$32.85/month in us-east-1 at $0.045/hour, plus per-GB processing), so set false for throwaway dev stacks. [source: https://devopscloudconsult.com/blog/aws-nat-gateway-cost-2026-pricing-8-ways-to-cut-it/]"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "When true (default), one shared NAT Gateway serves every private subnet — cheapest option, but its AZ is a single point of failure. Set false to deploy one NAT Gateway per private-subnet AZ."
  type        = bool
  default     = true
}

locals {
  # One EIP + NAT Gateway pair when single_nat_gateway is set, otherwise one
  # per private subnet (and therefore per AZ); zero when NAT is disabled.
  nat_gateway_count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.private_subnet_cidrs)) : 0

  common_tags = {
    ManagedBy = "terraform"
    Module    = "reusable-vpc"
    Project   = var.name
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, { Name = "${var.name}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, { Name = "${var.name}-public-${count.index + 1}", Tier = "public" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(local.common_tags, { Name = "${var.name}-private-${count.index + 1}", Tier = "private" })
}

# Private tiers always get their own route tables; the NAT default route is
# attached separately so disabling NAT does not orphan any resources.
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, { Name = "${var.name}-private-rt-${count.index + 1}" })
}

resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(local.common_tags, { Name = "${var.name}-nat-eip-${count.index + 1}" })
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  # NAT gateways must live in a public subnet; with a single shared gateway
  # only the first public subnet hosts one.
  subnet_id         = aws_subnet.public[count.index].id
  connectivity_type = "public"
  depends_on        = [aws_internet_gateway.this]

  tags = merge(local.common_tags, { Name = "${var.name}-nat-${count.index + 1}" })
}

resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? length(aws_subnet.private) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

output "vpc_id" {
  description = "ID of the VPC — pass into security group rules and peerings."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR, handy for allow-listing internal ranges elsewhere."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs for internet-facing load balancers."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for application instances and databases."
  value       = aws_subnet.private[*].id
}

output "nat_elastic_ips" {
  description = "Static egress IPs of the NAT gateway(s) — give these to third-party API allow-lists."
  value       = aws_eip.nat[*].public_ip
}
