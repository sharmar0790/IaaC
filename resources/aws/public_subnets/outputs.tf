output "subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "subnet_arn" {
  value = aws_subnet.public_subnet[*].arn
}

output "igw_id" {
  value = aws_internet_gateway.this[0].id
}

output "igw_arn" {
  value = aws_internet_gateway.this[0].arn
}

output "public_route_table_id" {
  value = aws_route_table.this[0].id
}

output "nat_gw_id" {
  value = aws_nat_gateway.public_nat_gw[*].id
}

output "public_eip" {
  value = aws_eip.nat_eip[*].id
}
