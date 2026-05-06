# terraform-project

Practice project for Terraform Associate exam.

## What's inside

- EC2 instance on AWS (t2.micro, eu-central-1)
- GitHub repository managed by Terraform

## Setup

Create `terraform.tfvars` with your GitHub token:

```hcl
github_token = "github_pat_..."
```

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```
