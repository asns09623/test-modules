resource "aws_iam_oidc_provider" "abhi_oidc_provider" {
  url = "https://oidc.eks.${var.region}.amazonaws.com/id/${var.cluster_id}"
  client_id_list = ["sts.amazonaws.com"]
}
