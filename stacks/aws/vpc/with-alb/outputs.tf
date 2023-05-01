output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "lb_arn" {
  value = module.alb.*.lb_arn
}

output "tg_arn" {
  value = module.alb.target_group_arn
}