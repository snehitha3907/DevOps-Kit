# last_verified: 2026-10-05 · OpenTofu n/a
# Every resource the module manages gets a referencing output so callers
# never need to reach into module internals with data sources.

output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the created VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets, in input order."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets, in input order."
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the VPC internet gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT gateways (empty when enable_nat_gateway is false)."
  value       = aws_nat_gateway.this[*].id
}

output "public_route_table_id" {
  description = "ID of the shared public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "IDs of the per-subnet private route tables (empty when NAT is disabled)."
  value       = aws_route_table.private[*].id
}
