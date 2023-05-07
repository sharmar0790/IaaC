locals {
  stack_name = "target-group-example"
  eks_cluster_name = "${local.stack_name}-${include.locals.env_name}-CLUSTER"
  vpc_name = "${local.stack_name}-${include.locals.env_name}-VPC"
}

terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/eks/tgb"
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
  }
  ####################################################
  ############### EKS Cluster Inputs #################
  ####################################################
  eks_cluster_name = local.eks_cluster_name
  eks_security_groups = [
    {
      name = local.eks_cluster_name
      description = local.eks_cluster_name
      ingress = [
        {
          from_port = 0
          protocol = "-1"
          to_port = 0
          self = true
//          cidr_blocks = ["0.0.0.0/0"]
//          ipv6_cidr_blocks = ["::/0"]
          description = "EKS-Ingress"
        }
      ]
      egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
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
      instance_types = ["t4g.medium"]
      force_update_version = false
      labels = {
        "alpha.eksctl.io/cluster-name" = local.eks_cluster_name
        "alpha.eksctl.io/nodegroup-name" = "EKS-Group-1"
      }
      update_config = {
        max_unavailable = 1
      }
      additional_tags = {
        "eks.amazonaws.com/capacityType" = "SPOT"
        "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
      }
    }
  ]


  create_lb = true
  load_balancer_name = local.stack_name

  elb_security_groups = [
    {
      name = "${local.stack_name}-ALB"
      description = "${local.stack_name}-ALB"
      ingress = [
        {
          from_port = 0
          protocol = "-1"
          to_port = 0
          self = true
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
          description = "Load Balancer Incoming Requests"
        }
      ]
      egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description = "Load Balancer Outgoing Response"
      }
    }
  ]

  lb_target_groups = [
    {
      name = "parking-lot-tg"
      backend_port = "9090"
      backend_protocol = "HTTP"
      target_type = "ip"
      stickiness = {
        enabled = true
        type = "lb_cookie"
        cookie_duration = 60
      }
      health_check = {
        enabled = true
        interval = 30
        path = "/api/v1/health"
        port = "traffic-port"
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 5
      }
    }
  ]

  http_tcp_listeners = [
    {
      port = "80"
      protocol = "HTTP"
      //action_type = "forward"
      target_group_index = 0
    }
  ]

  http_listener_rule = [
    {
      priority = 100
      //action_type = "forward"
      target_group_index = 0
      path_pattern = ["/api/v1/","/api/v1/*"]
    }
  ]
}
