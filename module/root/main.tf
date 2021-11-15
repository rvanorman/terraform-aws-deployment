/*
References:
Used bits and pieces from here https://adamtheautomator.com/terraform-vpc/ to get the base ideas of my resource blocks
Used some ideas from various searches under https://registry.terraform.io/modules/terraform-aws-modules/ and https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ for things like tagging, dependancy handling etc
*/

# Create the VPC. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "robs_terraform_vpc" {
  cidr_block         = var.vpc_cidr
  instance_tenancy   = "default"

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-terraform-vpc"
  }
}

# Create Public Subnet One. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet 
resource "aws_subnet" "robs_tf_public_subnet_one" {
  vpc_id            = aws_vpc.robs_terraform_vpc.id
  cidr_block        = var.subnet_one_cidr
  availability_zone = "us-west-2a"
  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-public-subnet-one"
    Accessibility = "${var.subnet_one_type}"
  }
}

# Create Public Subnet Two.
resource "aws_subnet" "robs_tf_public_subnet_two" {
  vpc_id            = aws_vpc.robs_terraform_vpc.id
  cidr_block        = var.subnet_two_cidr
  availability_zone = "us-west-2b"
  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-public-subnet-two"
    Accessibility = "${var.subnet_two_type}"
  }
}

# Create Private Subnet Three.
resource "aws_subnet" "robs_tf_private_subnet_three" {
  vpc_id            = aws_vpc.robs_terraform_vpc.id
  cidr_block        = var.subnet_three_cidr
  availability_zone = "us-west-2a"
  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-private-subnet-three"
    Accessibility = "${var.subnet_three_type}"
  }
}

# Create Private Subnet Four.
resource "aws_subnet" "robs_tf_private_subnet_four" {
  vpc_id            = aws_vpc.robs_terraform_vpc.id
  cidr_block        = var.subnet_four_cidr
  availability_zone = "us-west-2b"
  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-private-subnet-four"
    Accessibility = "${var.subnet_four_type}"
  }
}

# Create the Elastic IP for Nat Gateway. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat_gateway_ip" {
  vpc      = true

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-nat-gw-ip"
  }
}

# Create Internet Gateway. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "robs_tf_internet_gw" {
  vpc_id = aws_vpc.robs_terraform_vpc.id

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-internet-gw"
  }
}

# Create NAT Gateway. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway 
resource "aws_nat_gateway" "robs_tf_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip.id
  subnet_id     = aws_subnet.robs_tf_public_subnet_one.id

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.robs_tf_internet_gw]
}

# Create the Route Table for Private Subnets. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table 
resource "aws_route_table" "robs_tf_private_route_table" {
  vpc_id = aws_vpc.robs_terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.robs_tf_nat_gateway.id
  }

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-private-route-table"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_nat_gateway.robs_tf_nat_gateway]
}

# Create the Route Table for Public Subnets
resource "aws_route_table" "robs_tf_public_route_table" {
  vpc_id = aws_vpc.robs_terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.robs_tf_internet_gw.id
  }

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-public-route-table"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.robs_tf_internet_gw]
}

# Remove any default route associations. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table 
resource "aws_default_route_table" "robs_tf_default_route_table" {
  default_route_table_id = aws_vpc.robs_terraform_vpc.default_route_table_id

  route = []

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-default-route-table"
  }
}

# Associate Private Subnets to Private Route Table. Used https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "robs_tf_private_route_table_association_a" {
  subnet_id      = aws_subnet.robs_tf_private_subnet_three.id
  route_table_id = aws_route_table.robs_tf_private_route_table.id
}

resource "aws_route_table_association" "robs_tf_private_route_table_association_b" {
  subnet_id      = aws_subnet.robs_tf_private_subnet_four.id
  route_table_id = aws_route_table.robs_tf_private_route_table.id
}

# Associate Public Subnets to Public Route Table.
resource "aws_route_table_association" "robs_tf_public_route_table_association_a" {
  subnet_id      = aws_subnet.robs_tf_public_subnet_one.id
  route_table_id = aws_route_table.robs_tf_public_route_table.id
}

resource "aws_route_table_association" "robs_tf_public_route_table_association_b" {
  subnet_id      = aws_subnet.robs_tf_public_subnet_two.id
  route_table_id = aws_route_table.robs_tf_public_route_table.id
}

# Create the AMI data point to be used for later. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
data "aws_ami" "red_hat_8" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.4.0_HVM-20210825-x86_64-0-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # RHEL
}

# Create the Security Group for the Jump Box
resource "aws_security_group" "robs_tf_jump_box_sg" {
  name        = "robs-tf-jump-box-sg"
  description = "Jump Box Security Group"
  vpc_id      = aws_vpc.robs_terraform_vpc.id

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Communication to the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description      = "Communication to the World"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-jump-box-sg"
  }
}

# Create the Primary Interface for the Jump Box
resource "aws_network_interface" "robs_tf_jump_box_interface" {
  subnet_id       = aws_subnet.robs_tf_public_subnet_two.id
  security_groups = [aws_security_group.robs_tf_jump_box_sg.id]

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-jump-box-primary-network-interface"
  }
}

# Create the Jump Box Instance. 
resource "aws_instance" "robs_tf_jump_box" {
  ami                         = data.aws_ami.red_hat_8.id
  instance_type               = var.solo_instance_type
  key_name                    = var.ssh_key_name
  network_interface {
    network_interface_id = aws_network_interface.robs_tf_jump_box_interface.id
    device_index         = 0
  }
  root_block_device {
    volume_size               = var.solo_instance_storage
  }

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-jump-box"
  }
}

# Create the Elastic IP for the Jump Box
resource "aws_eip" "jump_box_public_ip" {
  instance = aws_instance.robs_tf_jump_box.id
  vpc      = true

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-jump-box-public-ip"
  }
}

# Create the Security Group for the Apache Servers
resource "aws_security_group" "robs_tf_asg_sg" {
  name        = "robs-tf-asg-sg"
  description = "Apache ASG Security Group"
  vpc_id      = aws_vpc.robs_terraform_vpc.id

  ingress {
    description = "Inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Inbound HTTPD"
    from_port   = var.alb_listening_port
    to_port     = var.alb_listening_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Communication to the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description      = "Communication to the World"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-asg-sg"
  }
}

# Create the Launch Configuration for Apache Servers. Used http://roshpr.net/blog/2016/10/terraform-using-user-data-in-launch-configuration/ for assistance with user_data
resource "aws_launch_configuration" "robs_tf_launch_configuration" {
  name                = "robs-tf-launch-configuration"
  image_id            = data.aws_ami.red_hat_8.id
  instance_type       = var.asg_instance_type
  security_groups     = [aws_security_group.robs_tf_asg_sg.id]
  key_name            = var.ssh_key_name
	
  user_data = <<-EOF
  #! /bin/bash
  sudo yum -y install httpd
  sudo yum -y update
  sudo systemctl enable httpd
  sudo systemctl start  httpd
  sudo echo "<h1>Check out my Apache server deployed via Terraform!</h1>" | sudo tee /var/www/html/index.html
  sudo systemctl restart httpd
	EOF

  root_block_device {
    volume_size               = var.asg_instance_storage
  }
}

# Create the Auto Scaling Group for Apache Servers
resource "aws_autoscaling_group" "robs_tf_asg" {
  name                 = "robs-tf-asg"
  depends_on           = [aws_launch_configuration.robs_tf_launch_configuration]
  vpc_zone_identifier  = [aws_subnet.robs_tf_private_subnet_three.id, aws_subnet.robs_tf_private_subnet_four.id]
  launch_configuration = aws_launch_configuration.robs_tf_launch_configuration.id
  min_size             = var.asg_minimum_count
  max_size             = var.asg_maximum_count
  target_group_arns    = ["${aws_lb_target_group.robs_tf_target_group.arn}"]
}

# Create the Security Group for the Application Load Balancer
resource "aws_security_group" "robs_tf_alb_sg" {
  name        = "robs-tf-alb-sg"
  description = "Application Load Balancer Security Group"
  vpc_id      = aws_vpc.robs_terraform_vpc.id

  ingress {
    description = "Inbound HTTP"
    from_port   = var.alb_listening_port
    to_port     = var.alb_listening_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Communication to the Apache Servers"
    from_port       = var.alb_listening_port
    to_port         = var.alb_listening_port
    protocol        = "tcp"
    security_groups = [aws_security_group.robs_tf_asg_sg.id]
  }

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-alb-sg"
  }
}

# Create the Application Load Balancer. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb 
resource "aws_lb" "robs_tf_application_lb" {
  name               = "robs-tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.robs_tf_alb_sg.id]
  subnets            = [aws_subnet.robs_tf_public_subnet_one.id, aws_subnet.robs_tf_public_subnet_two.id]

  tags = {
    Terraform     = "true"
    Environment   = "dev"
    Name          = "robs-tf-application-lb"
  }
}

# Create the Target Group for the ALB Listener
resource "aws_lb_target_group" "robs_tf_target_group" {
  name        = "robs-tf-target-group"
  port        = var.alb_listening_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.robs_terraform_vpc.id
  target_type = "instance"
}

# Create the Listener for the ALB
resource "aws_lb_listener" "robs_tf_alb_listener" {
  load_balancer_arn = aws_lb.robs_tf_application_lb.arn
  port              = var.alb_listening_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.robs_tf_target_group.arn
  }
}

# Create the S3 Bucket
resource "aws_s3_bucket" "robs_tf_bucket" {
  bucket = "robs-awesome-tf-bucket"
  acl    = "private"

  lifecycle_rule {
    id      = "logs"
    enabled = true

    prefix = "logs/"

    tags = {
      rule      = "logs"
      autoclean = "true"
    }

    expiration {
      days = var.logs_life_cycle
    }
  }

  lifecycle_rule {
    id      = "images"
    prefix  = "images/"
    enabled = true

    transition {
      days          = var.images_life_cycle
      storage_class = "GLACIER"
    }
    tags = {
      rule      = "images"
      autoclean = "true"
    }
  }
}