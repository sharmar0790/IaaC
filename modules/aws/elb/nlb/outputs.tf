output "target_group_arn" {
  value = aws_lb_target_group.main.*.arn
}

output "nlb_arn" {
  value = aws_lb.lb.*.arn
}

output "aws_lb_listener_http_arn" {
  value = aws_lb_listener.http_listener.*.arn
}