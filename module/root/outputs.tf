output "created_VPC" {
  value = aws_vpc.robs_terraform_vpc.id
}

output "created_subnet_one" {
  value = aws_subnet.robs_tf_public_subnet_one.id
}

output "created_subnet_two" {
  value = aws_subnet.robs_tf_public_subnet_two.id
}

output "created_subnet_three" {
  value = aws_subnet.robs_tf_private_subnet_three.id
}

output "created_subnet_four" {
  value = aws_subnet.robs_tf_private_subnet_four.id
}

output "used_aws_ami_id" {
  value = data.aws_ami.red_hat_8.id
}