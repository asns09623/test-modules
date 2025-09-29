variable "oidc_provider_arn" { type = string }
variable "oidc_issuer_url"   { type = string } # needed for condition
variable "namespace" {
  type    = string
  default = "*"
} # can scope later
variable "tags" {
  type    = map(string)
  default = {}
}

locals {
  sa = {
    external_dns = { sa = "external-dns",     policy = "route53" }
    cert_manager = { sa = "cert-manager",     policy = "cert-manager" }
    autoscaler   = { sa = "cluster-autoscaler", policy = "autoscaling" }
    alb_ctrl     = { sa = "aws-load-balancer-controller", policy = "albc" }
    argocd_repo  = { sa = "argocd-repo-server", policy = "s3-ecr-ro" }
  }
}

# Trust policy template
data "aws_iam_policy_document" "trust" {
  for_each = local.sa
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${each.value.sa}"]
    }
  }
}

# Example: Route53 policy for external-dns
data "aws_iam_policy_document" "route53" {
  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    actions   = ["route53:ListHostedZones","route53:ListResourceRecordSets","route53:ListHostedZonesByName"]
    resources = ["*"]
  }
}

# Minimal policies for others (trim/add per your org)
data "aws_iam_policy_document" "autoscaling" {
  statement {
    actions = [
      "autoscaling:Describe*",
      "ec2:Describe*",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "albc" {
  statement {
    actions = [
      "elasticloadbalancing:*",
      "ec2:Describe*",
      "iam:CreateServiceLinkedRole",
      "cognito-idp:DescribeUserPoolClient",
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "wafv2:GetWebACL",
      "shield:DescribeProtection",
      "shield:GetSubscriptionState"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cert-manager" {
  statement {
    actions = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    actions = ["route53:ListHostedZonesByName","route53:ListResourceRecordSets"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "s3-ecr-ro" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = ["*"]
  }
  statement {
    actions = ["s3:GetObject","s3:ListBucket"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "p" {
  for_each = {
    route53      = data.aws_iam_policy_document.route53.json
    autoscaling  = data.aws_iam_policy_document.autoscaling.json
    albc         = data.aws_iam_policy_document.albc.json
    certmanager  = data.aws_iam_policy_document.cert-manager.json
    s3ecr        = data.aws_iam_policy_document.s3-ecr-ro.json
  }
  name   = "kops-irsa-${each.key}"
  policy = each.value
  tags   = var.tags
}

resource "aws_iam_role" "r" {
  for_each = local.sa
  name               = "kops-irsa-${each.key}"
  assume_role_policy = data.aws_iam_policy_document.trust[each.key].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "att" {
  for_each   = local.sa
  role       = aws_iam_role.r[each.key].name
  policy_arn = aws_iam_policy.p[each.value.policy == "route53" ? "route53" :
                                each.value.policy == "autoscaling" ? "autoscaling" :
                                each.value.policy == "albc" ? "albc" :
                                each.value.policy == "cert-manager" ? "certmanager" :
                                "s3ecr"].arn
}

output "irsa_role_arns" {
  value = { for k, v in aws_iam_role.r : k => v.arn }
}
