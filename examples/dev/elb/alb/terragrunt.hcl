terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/vpc/with-alb"
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {

  vpc_name = "${include.locals.organization}-${include.locals.env_name}-VPC"
  lb_name = "${include.locals.organization}-${include.locals.env_name}"
  vpc_cidr = "10.0.0.0/20"
  enable_dns_hostnames = false
  enable_dns_support = false

  sg_name = "${include.locals.organization}-${include.locals.env_name}"
  sg_description = "Security group - VPC - PS - NLB"
  create_lb = true

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
