resource "aws_route53_zone" "abhi_corp_zone" {
  name = "corp.${var.env}.example.internal"
  private_zone = true
  tags = {
    Name = "abhi-corp-zone-${var.env}"
  }
}