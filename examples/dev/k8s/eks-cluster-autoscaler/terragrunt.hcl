locals {
  stack_name = "cluster-autoscaler"
  eks_cluster_name = "${local.stack_name}-${include.locals.env_name}-EKS-CLUSTER"
  vpc_name = "${local.stack_name}-${include.locals.env_name}-VPC"
}

terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/eks/cluster-autoscaler"
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {

  // vpc inputs
  vpc_cidr = "10.0.0.0/20"
  vpc_name = local.vpc_name

  //The VPC must have DNS hostname and DNS resolution support. Otherwise, nodes can't register to your cluster.
  // For more information, see DNS attributes for your VPC in the Amazon VPC User Guide.
  enable_dns_hostnames = true
  enable_dns_support = true

  region = "${include.locals.region}"
  // public subnet inputs
  map_public_ip_on_launch_public_subnets = true
  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"]

  //private subnets
  enable_nat_gw = true
  private_subnet_cidrs = [
    "10.0.3.0/24",
    "10.0.4.0/24"]

  single_nat_gw = true
  public_subnet_tags = {
    // this tag we needed to make sure ALB ingress while provisioning will be able ot
    // identify subnets
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = "true"
  }
  ####################################################
  ############### EKS Cluster Inputs #################
  ####################################################
  eks_cluster_name = local.eks_cluster_name
  eks_security_groups = [
    {
      name = "${local.eks_cluster_name}-EKS-kappa"
      description = "${local.eks_cluster_name}-EKS"
      ingress = [
        {
          from_port = 8443
          protocol = "tcp"
          to_port = 8443
          self = true
          cidr_blocks = [
            "0.0.0.0/0"]
          ipv6_cidr_blocks = [
            "::/0"]
          description = "EKS-Ingress-8443"
        },
        {
          from_port = 0
          protocol = "tcp"
          to_port = 0
          self = true
          cidr_blocks = [
            "0.0.0.0/0"]
          ipv6_cidr_blocks = [
            "::/0"]
          description = "EKS-Ingress-0"
        }
      ]
      egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
          "0.0.0.0/0"]
        ipv6_cidr_blocks = [
          "::/0"]
        description = ""
      }
    }
  ]

  ####################################################
  ############### EKS Node Groups #################
  ####################################################
  create_node_group = true
  public_subnet_node_groups = []
  private_subnet_node_groups = [
    {
      node_group_name = "EKS-Group-1"
      scaling_config = {
        desired_size = 1
        min_size = 1
        max_size = 3
      }
      capacity_type = "SPOT"
      ami_type = "AL2_ARM_64"
      disk_size = "10"
      instance_types = [
        "t4g.medium"]
      force_update_version = false
      labels = {
        "alpha.eksctl.io/cluster-name" = local.eks_cluster_name
        "alpha.eksctl.io/nodegroup-name" = "EKS-Group-1"
      }
      update_config = {
        max_unavailable = 1
      }
      /*taint = {
        key = "dedicated"
        value = "EKS-Group-1"
        effect = "NO_SCHEDULE"
      }*/
      additional_tags = {
        Name = "Karpenter-Example"
        "eks.amazonaws.com/capacityType" = "SPOT"
        "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
        # Requitred by karpenter
        "karpenter.sh/discovery" = local.eks_cluster_name
      }
    }
  ]
}
