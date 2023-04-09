module "eks_cluster" {
  source = "../../../resources/aws/eks"

  cw_logs_retention_in_days = var.cw_logs_retention_in_days
  subnet_ids = module.public_subnets.subnet_ids
  cluster_name = var.eks_cluster_name

  enabled_cluster_log_types = var.enabled_cluster_log_types
}

module "vpc" {
  source = "../../../resources/aws/vpc"

  vpc_name = var.vpc_name
  instance_tenancy = var.instance_tenancy
  vpc_cidr = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  tags = var.tags
}

module "public_subnets" {
  source = "../../../resources/aws/public_subnets"

  public_subnet_name = "Public-Subnet-${var.vpc_name}"
  public_subnet_cidr = var.public_subnet_cidr
  vpc_id = module.vpc.vpc_id
  tags = var.tags
  private_subnet_cidr = []
  //  private_subnet_cidr = var.private_subnet_cidr
  map_public_ip_on_launch_public_subnets = true
}

/*
module "private_subnets" {
  source = "../../../resources/aws/private_subnets"

  nat_gw_id = module.public_subnets.nat_gw_id
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_name = "Private-Subnet-${var.vpc_name}"
  vpc_id = module.vpc.vpc_id
  map_public_ip_on_launch_private_subnets = false
}*/
