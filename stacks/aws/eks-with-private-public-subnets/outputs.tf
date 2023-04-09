output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_arn" {
  value = module.public_subnets.subnet_arn
}

output "public_subnet_id" {
  value = module.public_subnets.subnet_id
}

output "private_subnet_arn" {
  value = module.private_subnets.subnet_arn
}

output "private_subnet_id" {
  value = module.private_subnets.subnet_id
}

output "igw_id" {
  value = module.public_subnets.igw_id
}

output "igw_arn" {
  value = module.public_subnets.igw_arn
}

output "public_rt_ass_id" {
  value = module.public_subnets.public_route_table_ass_id
}

output "public_rt_id" {
  value = module.public_subnets.public_route_table_id
}

output "nat_gw_id" {
  value = module.public_subnets.nat_gw_id
}

output "public_eip" {
  value = module.public_subnets.public_eip
}

output "private_rt_ass_id" {
  value = module.private_subnets.private_route_table_ass_id
}

output "private_rt_id" {
  value = module.private_subnets.private_route_table_id
}
