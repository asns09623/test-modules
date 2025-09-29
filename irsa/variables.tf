variable "env" {
  description = "The environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_id" {
  description = "The EKS Cluster ID for OIDC provider"
  type        = string
  default     = "my-cluster-id"
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-west-2"
}
