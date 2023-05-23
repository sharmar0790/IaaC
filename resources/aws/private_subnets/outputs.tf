output "subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "subnet_arn" {
  value = aws_subnet.private_subnet[*].arn
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.*.id
}

output "private_route_table_association_id" {
  value = aws_route_table_association.private_route_table_association.*.id
}
