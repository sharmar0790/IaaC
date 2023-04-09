resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)
  vpc_id = var.vpc_id
  cidr_block = var.private_subnet_cidr[count.index]

  map_public_ip_on_launch = var.map_public_ip_on_launch_private_subnets

  tags = merge({
    Name = var.private_subnet_name
  }, var.tags)
}


//private subnet RT
resource "aws_route_table" "private_route_table" {
  count = length(var.nat_gw_id)
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gw_id[count.index]
  }
  tags = merge(var.tags)
}

/* Route table associations */
resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_subnet_cidr)
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table[count.index].id
}
