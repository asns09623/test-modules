resource "aws_iam_role" "abhi_node_role" {
  name = "abhi-node-instance-role-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  tags = {
    Name = "abhi-node-instance-role-${var.env}"
  }
}
