/*
# -------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# -------------------------------------------------------------------------------------------------------------------
*/
aws_assumed_role_arn = "arn:aws:iam::<account-id>:role/<role-name>" # This field is only necessary when an assumed role is required. Commented out by default

aws_profile = "aws-profile" # The AWS profile configured for credentials OR matching AWS_PROFILE environment variable

aws_cred_file = "~/.aws/credentials" # An AWS credentials file to specify your credentials

ssh_key_name = "xxxxxxxxxxx" # An ssh key that you have access two on your local machine to manage instances spun up

aws_region = "xx-xxxx-x" # Desired region to deploy into

vpc_cidr = "10.1.0.0/16" // Specify the VPC CIDR block

subnet_one_cidr = "10.1.1.0/24" // Specify the cidr range of the respective subnet

subnet_two_cidr = "10.1.2.0/24" // Specify the cidr range of the respective subnet

subnet_three_cidr = "10.1.3.0/24" // Specify the cidr range of the respective subnet

subnet_four_cidr = "10.1.4.0/24" // Specify the cidr range of the respective subnet

subnet_one_type = "Public" // Select if the subnet is a public or private subnet. Enter Public or Private

subnet_two_type = "Public" // Select if the subnet is a public or private subnet. Enter Public or Private

subnet_three_type = "Private" // Select if the subnet is a public or private subnet. Enter Public or Private

subnet_four_type = "Private" // Select if the subnet is a public or private subnet. Enter Public or Private

solo_instance_type = "t2.micro" // Desired EC2 instance type

solo_instance_storage = "20" //Desired capacity of drive space on instance in GB

asg_instance_type = "t2.micro" // Desired EC2 instance type

asg_instance_storage = "20" // Desired capacity of drive space on instances in GB

asg_minimum_count = "2" // Desired count for the minimum number of instances

asg_maximum_count = "6" // Desired count for the maximum number of instances

alb_listening_port = "80" // Desired port for the Application Load Balancer to listen on

images_life_cycle = "90" // Desired number of days for the life cycle of the images path in S3 to move to Glacier

logs_life_cycle = "90" // Desired number of days for the life cycle of the images path in S3 to be erased