data "aws_availability_zones" "az" {}

module "vpc" {
  source = "../../../../resources/aws/vpc-subnets"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags

  public_subnet_name                     = var.vpc_name
  public_subnet_cidrs                    = var.public_subnet_cidr
  vpc_id                                 = module.vpc.vpc_id
  map_public_ip_on_launch_public_subnets = true
  public_subnet_tags                     = var.public_subnet_tags

  availability_zone = data.aws_availability_zones.az.names

  enable_nat_gw        = var.enable_nat_gw
  single_nat_gw        = var.single_nat_gw
  private_subnet_name  = var.vpc_name
  private_subnet_cidrs = var.private_subnet_cidrs
}
