resource "aws_lb" "lb" {
  count              = var.create_lb ? 1 : 0
  name               = "${var.lb_name}-ALB"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection

  subnets         = var.public_subnet_ids
  security_groups = var.lb_security_groups

  tags = merge(
    {
      Name = "${var.lb_name}-ALB"
    },
    var.tags,
    var.lb_tags,
  )

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}

resource "aws_lb_target_group" "main" {
  count  = var.create_lb ? length(var.lb_target_groups) : 0
  vpc_id = var.vpc_id

  port             = try(var.lb_target_groups[count.index].backend_port, null)
  protocol         = try(var.lb_target_groups[count.index].backend_protocol, null)
  protocol_version = try(upper(var.lb_target_groups[count.index].protocol_version), null)
  target_type      = try(var.lb_target_groups[count.index].target_type, null)

  connection_termination             = try(var.lb_target_groups[count.index].connection_termination, null)
  deregistration_delay               = try(var.lb_target_groups[count.index].deregistration_delay, null)
  slow_start                         = try(var.lb_target_groups[count.index].slow_start, null)
  proxy_protocol_v2                  = try(var.lb_target_groups[count.index].proxy_protocol_v2, false)
  lambda_multi_value_headers_enabled = try(var.lb_target_groups[count.index].lambda_multi_value_headers_enabled, false)
  load_balancing_algorithm_type      = try(var.lb_target_groups[count.index].load_balancing_algorithm_type, null)
  preserve_client_ip                 = try(var.lb_target_groups[count.index].preserve_client_ip, null)
  ip_address_type                    = try(var.lb_target_groups[count.index].ip_address_type, null)
  load_balancing_cross_zone_enabled  = try(var.lb_target_groups[count.index].load_balancing_cross_zone_enabled, null)

  dynamic "health_check" {
    for_each = try([
    var.lb_target_groups[count.index].health_check], [])

    content {
      enabled             = try(health_check.value.enabled, null)
      interval            = try(health_check.value.interval, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
      timeout             = try(health_check.value.timeout, null)
      protocol            = try(health_check.value.protocol, null)
      matcher             = try(health_check.value.matcher, null)
    }
  }

  dynamic "stickiness" {
    for_each = try([
    var.lb_target_groups[count.index].stickiness], [])
    content {
      enabled         = try(stickiness.value.enabled, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
      type            = try(stickiness.value.type, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = merge({
    Name = "${var.lb_name}-alb-tg"
  }, var.tags)
}

resource "aws_lb_listener" "http_listener" {
  count = var.create_lb ? length(var.http_tcp_listeners) : 0

  load_balancer_arn = aws_lb.lb[0].arn
  port              = var.http_tcp_listeners[count.index]["port"]
  protocol          = var.http_tcp_listeners[count.index]["protocol"]

  dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [
    var.http_tcp_listeners[count.index]]

    # Defaults to forward action if action_type not specified
    content {
      type = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([
        null,
      ""], lookup(default_action.value, "action_type", "")) ? aws_lb_target_group.main[lookup(default_action.value, "target_group_index", count.index)].id : null

      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [
        lookup(default_action.value, "redirect", {})]

        content {
          path        = lookup(redirect.value, "path", null)
          host        = lookup(redirect.value, "host", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [
        lookup(default_action.value, "fixed_response", {})]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }

      dynamic "forward" {
        for_each = length(keys(lookup(default_action.value, "forward", {}))) == 0 ? [] : [
        lookup(default_action.value, "forward", {})]

        content {
          dynamic "target_group" {
            for_each = forward.value["target_groups"]

            content {
              arn    = aws_lb_target_group.main[target_group.value["target_group_index"]].id
              weight = lookup(target_group.value, "weight", null)
            }
          }

          dynamic "stickiness" {
            for_each = length(keys(lookup(forward.value, "stickiness", {}))) == 0 ? [] : [
            lookup(forward.value, "stickiness", {})]

            content {
              enabled  = lookup(stickiness.value, "enabled", false)
              duration = lookup(stickiness.value, "duration", 60)
            }
          }
        }
      }
    }
  }
  tags = merge({
    Name = "${var.lb_name}-listener-http"
  }, var.tags)
}
/*
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Internal Server Error"
      status_code  = "500"
    }
  }

  tags = merge({
    Name = "${var.lb_name}-listener-http"
  }, var.tags)
}*/

/*resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.certificate.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Internal Server Error"
      status_code  = "500"
    }
  }
}*/

/*resource "aws_lb_listener_rule" "alb_listener_http_rule_forwarding_path" {
  listener_arn = aws_lb_listener.alb_listener_http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg1.arn
  }

  condition {
    path_pattern {
      values = [
      var.app_path]
    }
  }
}*/
