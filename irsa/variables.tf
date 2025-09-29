variable "bucket_name" {
  description = "Name of the *public* S3 bucket hosting OIDC discovery docs"
  type        = string
  default     = "example-oidc-bucket"
}

variable "example_oidc_bucket" {
  description = "Example OIDC S3 bucket name"
  type        = string
  default     = "example-oidc-bucket"
}

variable "prefix" {
  description = "Prefix (folder) inside the bucket for OIDC discovery docs (e.g., clusters/dev)"
  type        = string
  default     = "oidc"
}

variable "client_id_list" {
  description = "OIDC audiences; for IRSA must include sts.amazonaws.com"
  type        = list(string)
  default     = ["sts.amazonaws.com"]
}

variable "thumbprints" {
  description = "Optional override for thumbprint list; if empty, Terraform computes from issuer_url"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
