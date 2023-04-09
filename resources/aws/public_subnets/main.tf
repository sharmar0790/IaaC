resource "aws_subnet" "public_subnet" {
  //  count = length(var.availability_zone)
  count = length(var.public_subnet_cidr)
  vpc_id = var.vpc_id
  cidr_block = var.public_subnet_cidr[count.index]

  availability_zone = var.availability_zone[count.index]
  //data.aws_availability_zone.az.name_suffix
  map_public_ip_on_launch = var.map_public_ip_on_launch_public_subnets

  tags = merge({
    Name = var.public_subnet_name
  }, var.tags, var.public_subnet_tags)
}

//public subnet RT
resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags)
}

resource "aws_main_route_table_association" "main_public_route_table_association" {
  vpc_id = var.vpc_id
  route_table_id = aws_route_table.route_table.id
}

/* Route table associations */
//resource "aws_route_table_association" "public_route_table_association" {
//  count = length(var.public_subnet_cidr)
//  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
//  route_table_id = aws_route_table.route_table.id
//}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
  tags = merge(var.tags)
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0
  vpc = true
  depends_on = [
    aws_internet_gateway.gw]
}

//nat gateway so that instances from private subnet can be communicate to Internet
resource "aws_nat_gateway" "public_nat_gw" {
  count = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnet[count.index].id

  tags = merge(var.tags)

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
    aws_internet_gateway.gw]
}

