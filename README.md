# Terraform Based AWS Deployment

## Overview

This template is intended to be used to deploy a lightweight, scaleable application on Apache in AWS. It utilizes an ASG to deploy between 2-6 EC2 instances to manage load. there is also some basic foundation for retention policies around s3 bucket paths. This is intended for use with assumed roles, but can be modified accordingly if you do not have assumed roles configured.

## How to Use

1. clone or download the entire repository to your working directory, i.e. ~/aws-manual-deployment

   ```text
   ├── create.tf
   ├── module
   │   ├── root
   │   │   ├── main.tf
   │   │   ├── outputs.tf
   │   │   └── variables.tf
   ├── README.md
   ├── .gitignore   
   └── vars.tfvars

   ```

2. add all the required variable values in a separate file under the same directory, i.e. vars.tfvars
3. run Terraform initialization and apply to create the security resources in AWS:

   ```bash
      terraform init
      terraform apply --var-file vars.tfvars
   ```

   **Provider configuration:**
   The configuration applied to this terraform uses a shared_credentials_file method. Credentials can be provided from separate file (default file name is credentials.tf)
   Variables can be loaded from separate file or passed as parameters. See <https://www.terraform.io/docs/providers/aws/#authentication> for more options.

   If you need to run this without assuming a role with your user account, then you will need to replace the existing "aws" provider section with the below: 
   provider "aws" { 
     shared_credentials_file = var.aws_cred_file 
     profile = var.aws_profile 
     region = var.aws_region
   } 

   Make sure to remove the following variable from the variables section below:
   variable "aws_assumed_role_arn" {}

   Make sure that you comment the section in the vars.tfvars file for the assumed role as well.
