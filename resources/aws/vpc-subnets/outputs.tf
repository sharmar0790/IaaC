output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}

################################################################
#############     Public Subnets             ###################
################################################################
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "public_subnet_arn" {
  value = aws_subnet.public[*].arn
}

output "igw_id" {
  value = aws_internet_gateway.main[0].id
}

output "igw_arn" {
  value = aws_internet_gateway.main[0].arn
}

output "public_route_table_id" {
  value = aws_route_table.public[0].id
}

output "nat_gw_id" {
  value = aws_nat_gateway.public_nat_gw[*].id
}

output "public_eip" {
  value = aws_eip.nat_eip[*].id
}

################################################################
#############     Private Subnets             ###################
################################################################
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "private_subnet_arn" {
  value = aws_subnet.private[*].arn
}

output "private_route_table_id" {
  value = aws_route_table.private.*.id
}

output "private_route_table_association_id" {
  value = aws_route_table_association.private.*.id
}

