## Getting started

This project is a terraformation for "Regeular" website homepage.

## Pre-requisites

### Docker & Terraform

- Docker installed
- Terraform CLI installed

### AWS

- AWS Account
    - IAM account with permission for EC2, ECR, and VPC
- AWS CLI installed
- Identified Region to deploy
- AWS AMI launch template on that region

### Terraform

- Terraform CLI installed

## Starting your application

### 1 - Prod setup

This setup is aimed for staging and will require AWS configuration and setup

```bash
# fill in your IAM access key and secret
$ aws configure

# Update your tfvarrs to use username & password from AWS
$ cp example.terraform.tfvars.json terraform.tfvars.json

$ terraform prod plan
$ terraform prod apply
```

## Setting Up Docker

You will need AWS CLI in order for this to work. You can install one from this link:

[Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

Be sure to start docker first.

```bash
$ aws configure
$ aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

```
