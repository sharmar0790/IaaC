locals {
  eks_cluster_name = "${include.locals.organization}-${include.locals.env_name}-Eks-Cluster"
  vpc_name = "${include.locals.organization}-${include.locals.env_name}-VPC"
}

terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/eks/public-sub-external-lb"
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
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
    // this tag we needed to make sure ALB ingress while provisioning will be able ot
    // identify subnets
  }
  //eks inputs
  eks_cluster_name = local.eks_cluster_name
  eks_cluster_version = "1.25"

  // Application LB inputs
  create_lb = true
  lb_name = "${include.locals.organization}-${include.locals.env_name}-ALB"
  alb_sg_name = "${include.locals.organization}-${include.locals.env_name}-ALB"
  alb_sg_description = "Allow Traffic ${include.locals.organization}-${include.locals.env_name}-ALB"

  // target_group_binding

  metadata_name = "sample"
  serviceref_name = "sample"
  serviceref_port = 9090

  lb_target_groups = [
    {
      backend_port = "80"
      backend_protocol = "HTTP"
      target_type = "instance"
      load_balancing_cross_zone_enabled = true
      stickiness = {
        enabled = true
        type = "lb_cookie"
        cookie_duration = 60
      }
      health_check = {
        enabled = true
        interval = 30
        path = "/healthz"
        port = "traffic-port"
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 6
      }
    }
  ]

  http_tcp_listeners = [
    {
      port = "81"
      protocol = "HTTP"
      //action_type = "forward"
      target_group_index = 0
    },
    {
      port = "82"
      protocol = "HTTP"
      action_type = "redirect"
      redirect = {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"

      }
    },
    {
      port = "80"
      protocol = "HTTP"
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Internal Server Error"
        status_code = 500

      }
    }
  ]
}
