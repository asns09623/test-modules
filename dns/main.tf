resource "aws_route53_zone" "abhi_corp_zone" {
  name = "corp.${var.env}.example.internal"
  tags = {
    Name = "abhi-corp-zone-${var.env}"
  }
}