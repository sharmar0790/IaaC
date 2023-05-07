terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/vpc/with-nlb"
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {

  vpc_name = "${include.locals.organization}-${include.locals.env_name}-VPC"
  lb_name = "${include.locals.organization}-${include.locals.env_name}"
  app_path = "/api/v1"
  vpc_cidr = "10.0.0.0/20"
  enable_dns_hostnames = false
  enable_dns_support = false

  create_lb = true

  lb_target_groups = [
    {
      backend_port = "80"
      backend_protocol = "TCP_UDP"
      target_type = "instance"
      stickiness = {
        enabled = true
        type = "source_ip"
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
      port = "80"
      protocol = "TCP_UDP"
      //      action_type = "forward"
    }
  ]
}
