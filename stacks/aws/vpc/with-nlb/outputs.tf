output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "nlb_arn" {
  value = module.nlb.nlb_arn
}

output "tg_arn" {
  value = module.nlb.target_group_arn
}

output "aws_lb_listener_http_arn" {
  value = module.nlb.aws_lb_listener_http_arn
}