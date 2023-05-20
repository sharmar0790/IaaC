data "aws_vpc" "default" {
  default = true
}

module "ec2_instance" {
  source = "../../../modules/aws/ec2-instance"

  owners                   = var.owners
  tags                     = var.tags
  ami_id                   = var.ami_id
  key_name                 = var.key_name
  instance_type            = var.instance_type
  instance_additional_tags = var.instance_additional_tags
  user_data                = var.user_data
}

