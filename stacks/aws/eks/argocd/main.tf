data "aws_availability_zones" "az" {}

module "vpc" {
  source = "../../../../resources/aws/vpc-subnets"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags

  public_subnet_name                     = var.vpc_name
  public_subnet_cidrs                    = var.public_subnet_cidrs
  vpc_id                                 = module.vpc.vpc_id
  map_public_ip_on_launch_public_subnets = true
  public_subnet_tags                     = var.public_subnet_tags
  private_subnet_tags                    = var.private_subnet_tags

  availability_zone = data.aws_availability_zones.az.names

  enable_nat_gw        = var.enable_nat_gw
  single_nat_gw        = var.single_nat_gw
  private_subnet_name  = var.vpc_name
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks_cluster" {
  source = "../../../../resources/aws/eks"

  cw_logs_retention_in_days = var.cw_logs_retention_in_days
  public_subnet_ids         = module.vpc.public_subnet_ids
  cluster_name              = var.eks_cluster_name
  private_subnet_ids        = module.vpc.private_subnet_ids
  enabled_cluster_log_types = var.enabled_cluster_log_types
  eks_cluster_addons        = var.eks_cluster_addons

  tags                   = var.tags
  endpoint_public_access = var.endpoint_public_access
  //  cluster_security_groups_id = module.eks_security_group.security_group_id[0]

  create_node_group          = var.create_node_group
  public_subnet_node_groups  = var.public_subnet_node_groups
  private_subnet_node_groups = var.private_subnet_node_groups

  vpc_name = var.vpc_name

  depends_on = [module.vpc]
}

module "eks_security_group_rule" {
  source = "../../../../resources/aws/security_group_rule"

  destination_security_group_id = module.eks_cluster.cluster_security_group_id
}

module "argocd" {
  source = "../../../../resources/kubernetes/add-ons/argocd"

  argocd_helm_chart_version = "4.9.7"

  depends_on = [module.eks_cluster]
}
