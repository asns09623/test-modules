resource "aws_route53_zone" "abhi_corp_zone" {
  name = "corp.${var.env}.example.internal"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name = "abhi-corp-zone-${var.env}"
  }
}