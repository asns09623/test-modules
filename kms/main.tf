data "aws_caller_identity" "cur" {}
variable "alias" { type = string }

resource "aws_kms_key" "cmk" {
  description         = "CMK for kOps & app secrets"
  enable_key_rotation = true
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid = "EnableRoot",
      Effect = "Allow",
      Principal = { AWS = "*" },
      Action = "kms:*",
      Resource = "*",
      Condition = { StringEquals = { "aws:PrincipalAccount" = data.aws_caller_identity.cur.account_id } }
    }]
  })
}

resource "aws_kms_alias" "a" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.cmk.key_id
}

output "key_arn" { value = aws_kms_key.cmk.arn }
