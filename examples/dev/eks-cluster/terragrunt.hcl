locals {
  eks_cluster_name = "Local-Dev-Eks-Cluster"
}

terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/eks-with-public-subnets"
}

dependency "ecr" {
  config_path = "../ecr"
  skip_outputs = true
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  // vpc inputs
  instance_tenancy = "default"
  vpc_cidr = "10.0.0.0/20"
  vpc_name = "Local-DEV"

  //The VPC must have DNS hostname and DNS resolution support. Otherwise, nodes can't register to your cluster.
  // For more information, see DNS attributes for your VPC in the Amazon VPC User Guide.
  enable_dns_hostnames = true
  enable_dns_support = true

  region = "${include.locals.region}"
  // public subnet inputs
  public_subnet_cidr = [
    "10.0.1.0/24",
    "10.0.2.0/24"]
  map_public_ip_on_launch_public_subnets = true
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
    // this tag we needed to make sure ALB ingress while provisioning will be able ot
    // identify subnets
  }
  private_subnet_cidr = []

  /*private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  // private subnet inputs
  private_subnet_cidr = [
    "10.0.3.0/24",
    "10.0.4.0/24"]
  map_public_ip_on_launch_private_subnets = false*/


  //eks inputs
  cw_logs_retention_in_days = 3
  eks_cluster_name = local.eks_cluster_name
  eks_cluster_version = "1.25"
  enabled_cluster_log_types = [
    "api",
    "audit"
  ]

  eks_cluster_addons = {}

  /*eks_cluster_addons = {
    "vpc-cni" = {
//      version = "v1.10.1-eksbuild.1"
      version = ""
      resolve_conflicts = "OVERWRITE"
      namespace = "kube-system"
      service_account = "aws-node"
      configuration_values = ""
      preserve = true
      // TODO
      service_account_role_arn = ""
      tags = {
        Name = "vpc-cni"
        Env = "Dev"
      }
      additional_iam_policies = []
    },
    "coredns" = {
//      version = "v1.8.7-eksbuild.3"
      resolve_conflicts = "OVERWRITE"
      version = ""
      namespace = "kube-system"
      service_account = "coredns"
      configuration_values = ""
      preserve = true
      // TODO
      service_account_role_arn = ""
      tags = {
        Name = "vpc-cni"
        Env = "Dev"
      }
      additional_iam_policies = []
    },
    "kube-proxy" = {
//      version = "v1.21.2-eksbuild.2"
      resolve_conflicts = "OVERWRITE"
      version = ""
      namespace = "kube-system"
      service_account = "kube-proxy"
      preserve = true
      configuration_values = ""
      // TODO
      service_account_role_arn = ""
      tags = {
        Name = "vpc-cni"
        Env = "Dev"
      }
      additional_iam_policies = []
    },
    "aws-ebs-csi-driver" = {
//      version = "v1.4.0-eksbuild.preview"
      version = ""
      resolve_conflicts = "OVERWRITE"
      namespace = "kube-system"
      service_account = "ebs-csi-controller-sa"
      preserve = true
      configuration_values = ""
      // TODO
      service_account_role_arn = ""
      tags = {
        Name = "vpc-cni"
        Env = "Dev"
      }
      additional_iam_policies = []
    }
  }
  */

  // Managed node groups inputs
  max_unavailable = 1
  min_size = 2
  max_size = 5
  desired_size = 2
  kubernetes_taints = {}
  release_version = ""
  capacity_type = "SPOT"
  disk_size = 10
  ami_type = "AL2_ARM_64"
  labels = {
    "alpha.eksctl.io/cluster-name" = "mycluster1"
    "alpha.eksctl.io/nodegroup-name" = "ng1-mycluster1"
    "eks.amazonaws.com/capacityType" = "SPOT"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
  }

  kubernetes_taints = [
    {
      key = "dedicated"
      value = ""
      effect = "NO_SCHEDULE"
    }]

  endpoint_public_access = true

  env_name = "${include.locals.env_name}"
}
