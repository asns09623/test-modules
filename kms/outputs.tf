output "kms_key_arn" {
  value = aws_kms_key.abhi_kms_key.arn
}

// Not available in this module:
// output "vpc_id" { value = module.network.vpc_id }
// output "private_subnets" { value = module.network.private_subnet_ids }
// output "public_subnets" { value = module.network.public_subnet_ids }
// output "hosted_zone_id" { value = module.dns.zone_id }
// output "hosted_zone_name" { value = module.dns.zone_name }
// output "oidc_provider_arn" { value = module.irsa.oidc_provider_arn }
