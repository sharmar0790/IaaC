/*data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["linux/images/hvm-ssd/al2023-ami-2023.0.20230419.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  //owners = ["099720109477"] # Canonical
  owners = var.owners # Canonical
}

data "aws_key_pair" "demo" {
  key_name           = var.key_name
  include_public_key = true

  filter {
    name   = "tag:Component"
    values = ["web"]
  }
}*/

resource "aws_instance" "this" {
  ami             = try(var.ami_id, "")
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = try(module.ec2_security_group[0].security_group_id, var.security_groups)
  subnet_id       = try(var.subnet_id, null)
  user_data       = try(var.user_data, null)
  tags            = merge(var.instance_additional_tags, var.tags)

  depends_on = [module.ec2_security_group]
}

module "ec2_security_group" {
  source = "../security-group"

  vpc_id          = var.vpc_id
  security_groups = var.aws_instance_security_groups
}
