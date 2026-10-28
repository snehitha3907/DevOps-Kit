# last_verified: 2026-10-27 · terraform n/a

output "vpc_id" {
  value       = module.network.vpc_id
  description = "ID of the VPC created for this environment."
}

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "IDs of the subnets created for this environment."
}
