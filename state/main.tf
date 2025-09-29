resource "aws_s3_bucket" "abhi_state_bucket" {
  bucket = "abhi-state-bucket-${var.env}"
  acl    = "private"
  tags = {
    Name = "abhi-state-bucket-${var.env}"
  }
}

resource "aws_dynamodb_table" "abhi_state_lock" {
  name           = "abhi-state-lock-${var.env}"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
