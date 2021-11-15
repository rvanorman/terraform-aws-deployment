# Specify the provider and alternative access details below if needed
provider "aws" {
  assume_role {
    role_arn = var.aws_assumed_role_arn
  }
  shared_credentials_file = var.aws_cred_file
  profile                 = var.aws_profile
  region                  = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1.2"
    }
  }
}

module "root" {
  source = "./module/root"

  vpc_cidr                 = var.vpc_cidr
  images_life_cycle        = var.images_life_cycle
  logs_life_cycle          = var.logs_life_cycle
  ssh_key_name             = var.ssh_key_name
  subnet_one_cidr          = var.subnet_one_cidr
  subnet_one_type          = var.subnet_one_type
  subnet_two_cidr          = var.subnet_two_cidr
  subnet_two_type          = var.subnet_two_type
  solo_instance_type       = var.solo_instance_type
  solo_instance_storage    = var.solo_instance_storage
  subnet_three_cidr        = var.subnet_three_cidr
  subnet_three_type        = var.subnet_three_type
  subnet_four_cidr         = var.subnet_four_cidr
  subnet_four_type         = var.subnet_four_type
  asg_instance_type        = var.asg_instance_type
  asg_instance_storage     = var.asg_instance_storage
  asg_minimum_count        = var.asg_minimum_count
  asg_maximum_count        = var.asg_maximum_count
  alb_listening_port       = var.alb_listening_port
}
/*
module "public_subnet_one" {
  source = "./module/public_subnet_one"

  subnet_one_cidr         = var.subnet_one_cidr
  subnet_one_type         = var.subnet_one_type
}

module "public_subnet_two" {
  source = "./module/public_subnet_two"

  subnet_two_cidr         = var.subnet_two_cidr
  subnet_two_type         = var.subnet_two_type
  solo_instance_ami       = var.solo_instance_ami
  solo_instance_type      = var.solo_instance_type
  solo_instance_storage   = var.solo_instance_storage
}

module "private_subnet_three" {
  source = "./module/private_subnet_three"

  subnet_three_cidr         = var.subnet_three_cidr
  subnet_three_type         = var.subnet_three_type
}

module "private_subnet_four" {
  source = "./module/private_subnet_four"

  subnet_four_cidr         = var.subnet_four_cidr
  subnet_four_type         = var.subnet_four_type
  asg_instance_ami         = var.asg_instance_ami
  asg_instance_type        = var.asg_instance_type
  asg_instance_storage     = var.asg_instance_storage
  asg_minimum_count        = var.asg_minimum_count
  asg_maximum_count        = var.asg_maximum_count
  alb_listening_port       = var.alb_listening_port
}
*/
variable "aws_assumed_role_arn" {
}

variable "aws_profile" {
}

variable "aws_cred_file" {
}

variable "aws_region" {
}

variable "ssh_key_name" {
}

variable "vpc_cidr" {
}

variable "subnet_one_cidr" {
}

variable "subnet_two_cidr" {
}

variable "subnet_three_cidr" {
}

variable "subnet_four_cidr" {
}

variable "subnet_one_type" {
}

variable "subnet_two_type" {
}

variable "subnet_three_type" {
}

variable "subnet_four_type" {
}

variable "solo_instance_type" {
}

variable "solo_instance_storage" {
}

variable "asg_instance_type" {
}

variable "asg_instance_storage" {
}

variable "asg_minimum_count" {
}

variable "asg_maximum_count" {
}

variable "alb_listening_port" {
}

variable "images_life_cycle" {
}

variable "logs_life_cycle" {
}

output created_VPC {
  value = module.root.created_VPC
}

output created_subnet_one {
  value = module.root.created_subnet_one
}

output created_subnet_two {
  value = module.root.created_subnet_two
}

output created_subnet_three {
  value = module.root.created_subnet_three
}

output created_subnet_four {
  value = module.root.created_subnet_four
}

output used_aws_ami_id {
  value = module.root.used_aws_ami_id
}