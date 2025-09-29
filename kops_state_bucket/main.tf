variable "bucket_name" { type = string }
resource "aws_s3_bucket" "kops" { bucket = var.bucket_name }
resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.kops.id
  versioning_configuration { status = "Enabled" }
}
output "kops_state" { value = aws_s3_bucket.kops.bucket }
