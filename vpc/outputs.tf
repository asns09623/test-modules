output "vpc_id" {
  value = aws_vpc.abhi_vpc.id
}

output "private_subnets" {
  value = aws_subnet.abhi_private_subnet[*].id
}

output "public_subnets" {
  value = aws_subnet.abhi_public_subnet[*].id
}

// Not available in this module:
// output "hosted_zone_id" { value = module.dns.zone_id }
// output "hosted_zone_name" { value = module.dns.zone_name }
// output "kms_key_arn" { value = module.kms.kms_key_arn }
// output "oidc_provider_arn" { value = module.irsa.oidc_provider_arn }
