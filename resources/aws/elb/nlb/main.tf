resource "aws_lb" "lb" {
  count              = var.create_lb ? 1 : 0
  name               = "${var.lb_name}-NLB"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection

  subnets = var.public_subnet_ids

  tags = merge(
    {
      Name = "${var.lb_name}-NLB"
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

  dynamic "health_check" {
    for_each = try([var.lb_target_groups[count.index].health_check], [])

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
    Name = "${var.lb_name}-tg1"
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

    content {
      type             = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([null, ""], lookup(default_action.value, "action_type", "")) ? aws_lb_target_group.main[lookup(default_action.value, "target_group_index", count.index)].id : null

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [
        lookup(default_action.value, "fixed_response", {})]
        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }
    }
  }
  tags = merge({
    Name = "${var.lb_name}-listener-http"
  }, var.tags)
}

/*resource "aws_lb_listener" "https_listeners" {
  count = var.create_lb ? length(var.https_listeners) : 0

  load_balancer_arn = aws_lb.lb[0].arn
  port = var.https_listeners[count.index]["port"]
  protocol = var.https_listeners[count.index]["protocol"]
  //  port              = "443"
  //  protocol          = "HTTPS"
  certificate_arn = var.certificate_arn
  //  ssl_policy        = "ELBSecurityPolicy-2016-08"
  ssl_policy = lookup(var.https_listeners[count.index], "ssl_policy", var.listener_ssl_policy_default)
  alpn_policy = lookup(var.https_listeners[count.index], "alpn_policy", null)

  dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [
      var.http_tcp_listeners[count.index]]

    content {
      type = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([
        null,
        "",
        "forward"],
      lookup(default_action.value, "action_type", "")) ? aws_lb_target_group.main[lookup(default_action.value, "target_group_index", count.index)].id : null

    }
  }
}*/


//resource "aws_lb_listener_rule" "http_tcp_listener" {
//  count = var.create_lb ? length(var.http_tcp_listener_rules) : 0
//
//  listener_arn = aws_lb_listener.http_listener[lookup(var.http_tcp_listener_rules[count.index], "http_tcp_listener_index", count.index)].arn
//  priority     = lookup(var.http_tcp_listener_rules[count.index], "priority", null)
//
//  # redirect actions
//  dynamic "action" {
//    for_each = [
//      for action_rule in var.http_tcp_listener_rules[count.index].actions :
//      action_rule
//      if action_rule.type == "redirect"
//    ]
//
//    content {
//      type = action.value["type"]
//      redirect {
//        host        = lookup(action.value, "host", null)
//        path        = lookup(action.value, "path", null)
//        port        = lookup(action.value, "port", null)
//        protocol    = lookup(action.value, "protocol", null)
//        query       = lookup(action.value, "query", null)
//        status_code = action.value["status_code"]
//      }
//    }
//  }
//
//  # fixed-response actions
//  dynamic "action" {
//    for_each = [
//      for action_rule in var.http_tcp_listener_rules[count.index].actions :
//      action_rule
//      if action_rule.type == "fixed-response"
//    ]
//
//    content {
//      type = action.value["type"]
//      fixed_response {
//        message_body = lookup(action.value, "message_body", null)
//        status_code  = lookup(action.value, "status_code", null)
//        content_type = action.value["content_type"]
//      }
//    }
//  }
//
//  # forward actions
//  dynamic "action" {
//    for_each = [
//      for action_rule in var.http_tcp_listener_rules[count.index].actions :
//      action_rule
//      if action_rule.type == "forward"
//    ]
//
//    content {
//      type             = action.value["type"]
//      target_group_arn = aws_lb_target_group.main[lookup(action.value, "target_group_index", count.index)].id
//    }
//  }
//  //  action {
//  //    type = "forward"
//  //    target_group_arn = aws_lb_target_group.alb_tg1.arn
//  //  }
//
//  /*condition {
//    path_pattern {
//      values = [
//        var.app_path]
//    }
//  }*/
//
//  # Http header condition
//  dynamic "condition" {
//    for_each = [
//      for condition_rule in var.http_tcp_listener_rules[count.index].conditions :
//      condition_rule
//      if length(lookup(condition_rule, "http_headers", [])) > 0
//    ]
//
//    content {
//      dynamic "http_header" {
//        for_each = condition.value["http_headers"]
//
//        content {
//          http_header_name = http_header.value["http_header_name"]
//          values           = http_header.value["values"]
//        }
//      }
//    }
//  }
//
//  # Http request method condition
//  dynamic "condition" {
//    for_each = [
//      for condition_rule in var.http_tcp_listener_rules[count.index].conditions :
//      condition_rule
//      if length(lookup(condition_rule, "http_request_methods", [])) > 0
//    ]
//
//    content {
//      http_request_method {
//        values = condition.value["http_request_methods"]
//      }
//    }
//  }
//
//  # Query string condition
//  dynamic "condition" {
//    for_each = [
//      for condition_rule in var.http_tcp_listener_rules[count.index].conditions :
//      condition_rule
//      if length(lookup(condition_rule, "query_strings", [])) > 0
//    ]
//
//    content {
//      dynamic "query_string" {
//        for_each = condition.value["query_strings"]
//
//        content {
//          key   = lookup(query_string.value, "key", null)
//          value = query_string.value["value"]
//        }
//      }
//    }
//  }
//
//  # Source IP address condition
//  dynamic "condition" {
//    for_each = [
//      for condition_rule in var.http_tcp_listener_rules[count.index].conditions :
//      condition_rule
//      if length(lookup(condition_rule, "source_ips", [])) > 0
//    ]
//
//    content {
//      source_ip {
//        values = condition.value["source_ips"]
//      }
//    }
//  }
//}
