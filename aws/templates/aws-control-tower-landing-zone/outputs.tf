# last_verified: 2026-10-26 · AWS · n/a
# Output values for the Control Tower landing zone scaffold.

output "organization_id" {
  description = "AWS Organization root ID"
  value       = aws_organization_organization.this.id
}

output "security_ou_id" {
  description = "Security organizational unit ID"
  value       = aws_organization_organizational_unit.security.id
}

output "production_ou_id" {
  description = "Production organizational unit ID"
  value       = aws_organization_organizational_unit.production.id
}

output "non_production_ou_id" {
  description = "Non-production organizational unit ID"
  value       = aws_organization_organizational_unit.non_production.id
}

output "analytics_ou_id" {
  description = "Analytics organizational unit ID"
  value       = aws_organization_organizational_unit.analytics.id
}

output "guardduty_status" {
  description = "GuardDuty enabled flag"
  value       = var.enable_guardduty
}

output "securityhub_status" {
  description = "Security Hub enabled flag"
  value       = var.enable_securityhub
}

output "inspector2_status" {
  description = "Inspector2 enabled flag"
  value       = var.enable_inspector2
}