output "target_group_arn" {
  value = aws_lb_target_group.main.*.arn
}

output "lb_arn" {
  value = aws_lb.lb.*.arn
}

output "http_listener_rule" {
  value = aws_lb_listener_rule.http_listener_rule.*.arn
}
