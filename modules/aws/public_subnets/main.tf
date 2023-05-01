resource "aws_subnet" "public_subnet" {
  count      = var.create_subnet ? length(var.public_subnet_cidr) : 0
  vpc_id     = var.vpc_id
  cidr_block = var.public_subnet_cidr[count.index]

  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch_public_subnets

  tags = merge({
    Name = "${var.public_subnet_name}-Public-Subnet"
  }, var.tags, var.public_subnet_tags)
}

//public subnet RT
resource "aws_route_table" "this" {
  count  = var.create_subnet ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge({
    Name = format("%s-route-table-%s", var.public_subnet_name, count.index)
  }, var.tags)
}

resource "aws_main_route_table_association" "this" {
  count          = var.create_subnet ? 1 : 0
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.this[count.index].id
}

/* Route table associations */
//resource "aws_route_table_association" "public_route_table_association" {
//  count = length(var.public_subnet_cidr)
//  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
//  route_table_id = aws_route_table.route_table.id
//}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "this" {
  count  = var.create_subnet ? 1 : 0
  vpc_id = var.vpc_id
  tags = merge({
    Name = format("%s-IGW-%s", var.public_subnet_name, count.index)
  }, var.tags)
}


/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  //  count = length(var.enable_nat_gw) > 0 ? length(var.private_subnet_cidr) : 0
  count = var.enable_nat_gw ? length(var.public_subnet_cidr) : 0
  vpc   = true
  depends_on = [
  aws_internet_gateway.this]
  tags = merge({
    Name = format("%s-nat-eip-%s", var.public_subnet_name, count.index)
  }, var.tags)
}

//nat gateway so that instances from private subnet can be communicate to Internet
resource "aws_nat_gateway" "public_nat_gw" {
  count         = var.enable_nat_gw ? length(var.public_subnet_cidr) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = merge({
    Name = format("%s-nat-gw-%s", var.public_subnet_name, count.index)
  }, var.tags)

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
  aws_internet_gateway.this]
}

