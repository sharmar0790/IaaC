output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "public_rt_ids" {
  value = module.vpc.public_route_table_id
}

output "nat_gw_id" {
  value = module.vpc.nat_gw_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "private_subnets_ids" {
  value = module.vpc.private_subnet_ids
}

output "private_subnets_rt_ids" {
  value = module.vpc.private_route_table_id
}
