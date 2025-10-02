# Terraform Modules: State, KMS, IRSA, DNS

This repository contains modular Terraform configurations for AWS infrastructure. Each module is self-contained and can be tested independently.

---

## Modules

- [`state`](./state): S3 bucket and DynamoDB table for Terraform state and locking.
- [`kms`](./kms): AWS KMS key management.
- [`irsa`](./irsa): IAM OIDC provider for IRSA.
- [`dns`](./dns): Route53 private hosted zone.

---

## Usage

Each module contains its own `provider.tf`. You can test each module individually.

### 1. Initialize

```sh
cd <module>
terraform init
```

### 2. Apply

```sh
terraform apply
```

You may be prompted for input variables. You can override them using `-var` flags or by editing the `variables.tf` file.

### 3. Destroy

```sh
terraform destroy
```

---

## Example: Testing a Module

```sh
cd state
terraform init
terraform apply
terraform destroy
```

Repeat for `kms`, `irsa`, and `dns` modules.

---

## Provider

Each module declares its own AWS provider in `provider.tf`. Example:

```hcl
provider "aws" {
  version = "~> 6.0"
  region  = "ap-south-1"
}
```

---

## Notes

- Ensure your AWS credentials are configured (via environment variables or AWS CLI).
- Adjust variables as needed for your environment.
- Outputs are defined in each module's `outputs.tf`.

---
