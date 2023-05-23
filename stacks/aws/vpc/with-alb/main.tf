data "aws_availability_zones" "az" {}

module "vpc" {
  source = "../../../../resources/aws/vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags
}

module "public_subnets" {
  source = "../../../../resources/aws/public_subnets"

  public_subnet_name                     = "Public-Subnet-${var.vpc_name}"
  public_subnet_cidr                     = var.public_subnet_cidr
  vpc_id                                 = module.vpc.vpc_id
  tags                                   = var.tags
  map_public_ip_on_launch_public_subnets = true
  public_subnet_tags                     = var.public_subnet_tags

  availability_zone = data.aws_availability_zones.az.names
}

module "alb_sg" {
  source      = "../../../../resources/aws/security-group"
  sg_name     = var.sg_name
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
  description = var.sg_description
}

module "alb" {
  source = "../../../../resources/aws/elb/alb"

  lb_security_groups = [
  module.alb_sg.security_group_id]
  lb_name            = var.lb_name
  public_subnet_ids  = module.public_subnets.subnet_ids
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  create_lb          = var.create_lb
  lb_target_groups   = var.lb_target_groups
  http_tcp_listeners = var.http_tcp_listeners
}
