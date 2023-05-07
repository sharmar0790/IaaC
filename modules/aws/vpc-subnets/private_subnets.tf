resource "aws_subnet" "private" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnet_cidrs[count.index]

  map_public_ip_on_launch = var.map_public_ip_on_launch_private_subnets
  availability_zone       = var.availability_zone[count.index]

  tags = merge({
    Name = format("%s-Private-subnet-%s", var.private_subnet_name, count.index)
  }, var.tags, var.private_subnet_tags)
}

//private subnet RT
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs) > 0 && length(aws_nat_gateway.public_nat_gw.*.id) > 0 ? length(var.private_subnet_cidrs) : 0
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.single_nat_gw ? aws_nat_gateway.public_nat_gw[0].id : aws_nat_gateway.public_nat_gw[count.index].id
  }
  tags = merge({
    Name = format("%s-private-route-table-%s", var.private_subnet_name, count.index)
  }, var.tags)
}

/* Route table associations */
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs) > 0 && length(aws_nat_gateway.public_nat_gw.*.id) > 0 ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
