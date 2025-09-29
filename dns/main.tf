variable "zone_name" { type = string }

resource "aws_route53_zone" "env" {
  name = var.zone_name
}

output "zone_id"   { value = aws_route53_zone.env.zone_id }
output "zone_name" { value = aws_route53_zone.env.name }
