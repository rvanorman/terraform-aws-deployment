variable "vpc_cidr" {
  description = "The CIDR range desired for the VPC to be created"
}

variable "images_life_cycle" {
  description = "Desired number of days for the life cycle of the images path in S3 to move to Glacier"
}

variable "logs_life_cycle" {
  description = "Desired number of days for the life cycle of the images path in S3 to be erased"
}

variable "ssh_key_name" {
  description = "Key name of the SSH key desired to use for the jump box"
}

variable "subnet_one_cidr" {
  description = "Desired cidr range of the respective subnet"
}

variable "subnet_one_type" {
  description = "Designaton of whether the subnet is a public or private subnet"
}

variable "subnet_two_cidr" {
  description = "Desired cidr range of the respective subnet"
}

variable "subnet_two_type" {
  description = "Designaton of whether the subnet is a public or private subnet"
}

variable "solo_instance_type" {
  description = "Instance type of the single instance to spin up"
}

variable "solo_instance_storage" {
  description = "The size on disk of the instance"
}

variable "subnet_three_cidr" {
  description = "Desired cidr range of the respective subnet"
}

variable "subnet_three_type" {
  description = "Designaton of whether the subnet is a public or private subnet"
}

variable "subnet_four_cidr" {
  description = "Desired cidr range of the respective subnet"
}

variable "subnet_four_type" {
  description = "Designaton of whether the subnet is a public or private subnet"
}

variable "asg_instance_type" {
  description = "Instance type of the launch configuration instance to be used by the ASG"
}

variable "asg_instance_storage" {
  description = "The size on disk of the instances"
}

variable "asg_minimum_count" {
  description = "Minimum count of appliance for the ASG to run"
}

variable "asg_maximum_count" {
  description = "Maximum count of appliance for the ASG to run"
}

variable "alb_listening_port" {
  description = "Desired port for the Application Load Balancer to listen on"
}