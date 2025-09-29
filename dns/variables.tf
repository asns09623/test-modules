variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "The VPC ID to associate with the Route53 private zone"
  type        = string
}