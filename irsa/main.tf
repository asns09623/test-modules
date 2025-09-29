data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  normalized_prefix = trimspace(var.prefix)
  issuer_url        = "https://${var.bucket_name}.s3.${data.aws_region.current.name}.${data.aws_partition.current.dns_suffix}/${local.normalized_prefix}"
}

# -----------------------
#  TLS Thumbprint
# -----------------------
data "tls_certificate" "issuer" {
  count = length(var.thumbprints) == 0 ? 1 : 0
  url   = local.issuer_url
}

locals {
  chain_size         = length(data.tls_certificate.issuer) > 0 ? length(data.tls_certificate.issuer[0].certificates) : 0
  root_fingerprint   = local.chain_size > 0 ? data.tls_certificate.issuer[0].certificates[local.chain_size - 1].sha1_fingerprint : null
  leaf_fingerprint   = local.chain_size > 0 ? data.tls_certificate.issuer[0].certificates[0].sha1_fingerprint : null
  chosen_fingerprint = coalesce(local.root_fingerprint, local.leaf_fingerprint)
  final_thumbprints  = length(var.thumbprints) > 0 ? var.thumbprints : [local.chosen_fingerprint]
}

# -----------------------
#  IAM OIDC Provider
# -----------------------
resource "aws_iam_openid_connect_provider" "this" {
  url             = local.issuer_url
  client_id_list  = var.client_id_list
  thumbprint_list = local.final_thumbprints
  tags            = var.tags
}
