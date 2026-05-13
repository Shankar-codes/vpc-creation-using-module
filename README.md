# AWS VPC Creation Using Terraform Module

This project provisions a production-ready AWS Virtual Private Cloud (VPC) by consuming a reusable Terraform module. It sets up a fully segmented network with public, private, and database subnets — along with optional VPC peering — and stores the Terraform state remotely in S3.

---

## Architecture Overview

```
VPC (10.0.0.0/16)
├── Public Subnets    → 10.0.1.0/24, 10.0.2.0/24
├── Private Subnets   → 10.0.11.0/24, 10.0.12.0/24
└── Database Subnets  → 10.0.21.0/24, 10.0.22.0/24
```

VPC peering is enabled by default (`is_peering_required = true`).

---

## Repository Structure

```
vpc-creation-using-module/
├── main.tf         # Module invocation with all input variables
├── variables.tf    # Input variable declarations and default values
├── output.tf       # Outputs: VPC ID and public subnet IDs
├── provider.tf     # AWS provider config + S3 remote backend
└── .gitignore      # Ignores Terraform state and cache files
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.x
- AWS CLI configured with appropriate credentials
- An S3 bucket named `ellamma-roboshop` in `us-east-1` (used for remote state)
- IAM permissions to create VPC, subnets, route tables, internet gateways, and peering connections

---

## Module Source

This root configuration sources a custom Terraform VPC module from:

```
git::https://github.com/Shankar-codes/terraform-vpc-module.git?ref=main
```

---

## Input Variables

| Variable | Default | Description |
|---|---|---|
| `vpc_cidr_block` | `10.0.0.0/16` | CIDR block for the VPC |
| `project_name` | `ellamma-roboshop` | Project name used for resource naming/tagging |
| `environment` | `dev` | Deployment environment (e.g., dev, staging, prod) |
| `vpc_tags` | `{ purpose = "VPC-module-test", DontDelete = "true" }` | Additional tags for the VPC |
| `public_subnet_cidrs` | `["10.0.1.0/24", "10.0.2.0/24"]` | CIDR blocks for public subnets |
| `private_subnet_cidrs` | `["10.0.11.0/24", "10.0.12.0/24"]` | CIDR blocks for private subnets |
| `database_subnet_cidrs` | `["10.0.21.0/24", "10.0.22.0/24"]` | CIDR blocks for database subnets |

---

## Outputs

| Output | Description |
|---|---|
| `vpc_id` | The ID of the created VPC |
| `public_subnet_ids` | List of public subnet IDs |

---

## Remote Backend

Terraform state is stored in S3 with encryption and locking enabled:

```hcl
backend "s3" {
  bucket       = "ellamma-roboshop"
  key          = "vpc-module-demo"
  region       = "us-east-1"
  use_lockfile = true
  encrypt      = true
}
```

> **Note:** Ensure the S3 bucket exists before running `terraform init`.

---

## Usage

**1. Clone the repository**

```bash
git clone https://github.com/Shankar-codes/vpc-creation-using-module.git
cd vpc-creation-using-module
```

**2. Initialize Terraform**

```bash
terraform init
```

**3. Review the execution plan**

```bash
terraform plan
```

**4. Apply the configuration**

```bash
terraform apply
```

**5. Destroy resources (when done)**

```bash
terraform destroy
```

---

## Customization

Override any default variable at apply time:

```bash
terraform apply \
  -var="environment=prod" \
  -var='public_subnet_cidrs=["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]'
```

Or create a `terraform.tfvars` file:

```hcl
project_name          = "my-project"
environment           = "staging"
vpc_cidr_block        = "172.16.0.0/16"
public_subnet_cidrs   = ["172.16.1.0/24", "172.16.2.0/24"]
private_subnet_cidrs  = ["172.16.11.0/24", "172.16.12.0/24"]
database_subnet_cidrs = ["172.16.21.0/24", "172.16.22.0/24"]
```

---

## Provider Details

| Setting | Value |
|---|---|
| Provider | `hashicorp/aws` |
| Version | `6.16.0` |
| Default Region | `us-east-1` |

---

## Author

[Shankar-codes](https://github.com/Shankar-codes)
