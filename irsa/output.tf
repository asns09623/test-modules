output "issuer_url" {
  description = "The OIDC issuer URL (matches iss claim in tokens)"
  value       = local.issuer_url
}

output "oidc_provider_arn" {
  description = "AWS IAM OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.this.arn
}
