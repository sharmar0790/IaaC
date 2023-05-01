data "aws_availability_zones" "az" {}

module "vpc" {
  source = "../../../../modules/aws/vpc"

  vpc_name             = var.vpc_name
  instance_tenancy     = var.instance_tenancy
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags
}

module "eks_cluster" {
  source = "../../../../modules/aws/eks"

  cw_logs_retention_in_days = var.cw_logs_retention_in_days
  public_subnet_ids         = module.public_subnets.subnet_ids
  cluster_name              = var.eks_cluster_name

  enabled_cluster_log_types  = var.enabled_cluster_log_types
  cluster_version            = var.eks_cluster_version
  eks_cluster_addons         = var.eks_cluster_addons
  private_subnet_ids         = []
  tags                       = var.tags
  endpoint_public_access     = var.endpoint_public_access
  cluster_security_groups_id = module.eks_sg.security_group_id

  depends_on = [
    module.vpc,
  module.public_subnets]
}


module "public_subnets" {
  source = "../../../../modules/aws/public_subnets"

  public_subnet_name                     = "Public-Subnet-${var.vpc_name}"
  public_subnet_cidr                     = var.public_subnet_cidr
  vpc_id                                 = module.vpc.vpc_id
  tags                                   = var.tags
  map_public_ip_on_launch_public_subnets = true
  public_subnet_tags                     = var.public_subnet_tags

  availability_zone = data.aws_availability_zones.az.names

  depends_on = [
  module.vpc]
}

module "eks_sg" {
  source  = "../../../../modules/aws/security-group"
  vpc_id  = module.vpc.vpc_id
  sg_name = "${var.eks_cluster_name}-SG"

  description         = "${var.eks_cluster_name}-eks-sg"
  ingress_description = "${var.eks_cluster_name}-eks-sg"
  //  ingress_cidr_blocks      = []
  //  ingress_ipv6_cidr_blocks = []
  security_groups = [
  module.alb_sg.security_group_id]
  depends_on = [
  module.vpc]
}

module "lb-controller" {
  source = "../../../../modules/aws/alb-controller"

  aws_iam_openid_connect_provider_arn              = module.eks_cluster.aws_iam_openid_connect_provider_arn
  eks_cluster_name                                 = var.eks_cluster_name
  tags                                             = var.tags
  vpc_id                                           = module.vpc.vpc_id
  aws_iam_openid_connect_provider_extract_from_arn = module.eks_cluster.aws_iam_openid_connect_provider_extract_from_arn

  depends_on = [
  module.eks_cluster]
}

module "alb" {
  source    = "../../../../modules/aws/elb/alb"
  create_lb = var.create_lb

  lb_name = var.lb_name
  tags    = var.tags
  vpc_id  = module.vpc.vpc_id

  lb_security_groups = [
  module.alb_sg.security_group_id]
  public_subnet_ids = module.public_subnets.subnet_ids

  lb_target_groups   = var.lb_target_groups
  http_tcp_listeners = var.http_tcp_listeners
}

module "alb_sg" {
  source = "../../../../modules/aws/security-group"

  sg_name             = var.alb_sg_name
  vpc_id              = module.vpc.vpc_id
  description         = var.alb_sg_description
  ingress_description = var.alb_sg_description
  tags                = var.tags
  ingress_from_port   = 80
  ingress_to_port     = 80
  ingress_protocol    = "tcp"

  sg_additional_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" : "owned"
  }
}

module "sg_rule_eks_node_alb_ingress" {
  source = "../../../../modules/aws/security_group_rule"

  destination_security_group_id = module.eks_sg.security_group_id
  source_security_group_id      = module.alb_sg.security_group_id
}

module "k8s-targetgroupbinding" {
  source = "../../../../modules/kubernetes/target-group-binding"

  eks_cluster_name       = var.eks_cluster_name
  host                   = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate = module.eks_cluster.kubeconfig-certificate-authority-data
  cluster_auth_token     = module.eks_cluster.eks_cluster_auth_token

  metadata_name   = var.metadata_name
  serviceref_name = var.serviceref_name
  serviceref_port = var.serviceref_port
  //  target_group_arn = module.alb[0].target_group_arn
  target_group_arn = module.alb.target_group_arn[0]
}
