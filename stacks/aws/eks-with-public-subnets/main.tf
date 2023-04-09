data "aws_availability_zones" "az" {}

module "eks_cluster" {
  source = "../../../resources/aws/eks"

  cw_logs_retention_in_days = var.cw_logs_retention_in_days
  subnet_ids = module.public_subnets.subnet_ids
  cluster_name = var.eks_cluster_name

  enabled_cluster_log_types = var.enabled_cluster_log_types
  cluster_version = var.eks_cluster_version
  eks_cluster_addons = var.eks_cluster_addons
  ami_type = var.ami_type
  disk_size = var.disk_size
  instance_types = var.instance_types
  capacity_type = var.capacity_type
  release_version = var.release_version
  max_unavailable = var.max_unavailable
  min_size = var.min_size
  max_size = var.max_size
  desired_size = var.desired_size

  labels = {}

  tags = merge({
    "eks.amazonaws.com/capacityType" : var.capacity_type
  }, var.tags)
  force_update_version = var.force_update_version
  endpoint_public_access = var.endpoint_public_access
  cluster_security_groups_id = module.eks_sg.sg_id
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
  map_public_ip_on_launch_public_subnets = true
  public_subnet_tags = var.public_subnet_tags

  availability_zone = data.aws_availability_zones.az.names
}

module "eks_sg" {
  source = "../../../resources/aws/security-groups"
  eks_cluster_name = var.eks_cluster_name
  vpc_id = module.vpc.vpc_id
  env_name = var.env_name
}

module "lb-controller" {
  source = "../../../resources/aws/alb-controller"

  aws_iam_openid_connect_provider_arn = module.eks_cluster.aws_iam_openid_connect_provider_arn
  eks_cluster_endpoint = module.eks_cluster.eks_cluster_endpoint
  eks_cluster_certificate_authority = module.eks_cluster.kubeconfig-certificate-authority-data
  eks_cluster_name = var.eks_cluster_name
  tags = var.tags
  vpc_id = module.vpc.vpc_id
  aws_iam_openid_connect_provider_extract_from_arn = module.eks_cluster.aws_iam_openid_connect_provider_extract_from_arn
}
