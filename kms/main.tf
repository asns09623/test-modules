resource "aws_kms_key" "abhi_kms_key" {
  description = "KMS key for secrets encryption"
  tags = {
    Name = "abhi-kms-key-${var.env}"
  }
}
