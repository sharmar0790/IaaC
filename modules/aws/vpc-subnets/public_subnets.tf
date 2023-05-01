resource "aws_subnet" "public" {
  count      = length(var.public_subnet_cidrs) > 0 ? length(var.public_subnet_cidrs) : 0
  vpc_id     = var.vpc_id
  cidr_block = var.public_subnet_cidrs[count.index]

  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch_public_subnets

  tags = merge({
    Name = format("%s-Public-subnet-%s", var.public_subnet_name, count.index)
  }, var.tags, var.public_subnet_tags)
}

//public subnet RT
resource "aws_route_table" "public" {
  count  = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = merge({
    Name = format("%s-public-route-table-%s", var.public_subnet_name, count.index)
  }, var.tags)
}


// associating the public route table with the public subnets
resource "aws_route_table_association" "subnet_association" {
  count          = length(var.public_subnet_cidrs) > 0 ? length(var.public_subnet_cidrs) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id

  depends_on = [
  aws_route_table.public]
}

// associating the internet gateway with the public subnets
/*resource "aws_route_table_association" "gateway_association" {
  route_table_id = aws_route_table.public[0].id
  gateway_id     = aws_internet_gateway.main[0].id
}*/

/*resource "aws_main_route_table_association" "this" {
  count          = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.public[count.index].id
}*/

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "main" {
  count  = length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = var.vpc_id
  tags = merge({
    Name = format("%s-IGW-%s", var.public_subnet_name, count.index)
  }, var.tags)
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  count = var.enable_nat_gw ? var.single_nat_gw ? 1 : length(var.public_subnet_cidrs) : 0
  vpc   = true

  tags = merge({
    Name = format("%s-nat-eip-%s", var.public_subnet_name, count.index)
  }, var.tags)
}

//nat gateway so that instances from private subnet can be communicate to Internet
resource "aws_nat_gateway" "public_nat_gw" {
  count         = var.enable_nat_gw ? var.single_nat_gw ? 1 : length(var.public_subnet_cidrs) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge({
    Name = format("%s-nat-gw-%s", var.public_subnet_name, count.index)
  }, var.tags)

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
  aws_internet_gateway.main]
}

# Egress-only IGW (if indicated)
resource "aws_egress_only_internet_gateway" "eigw" {
  count  = var.egress_only_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = var.vpc_name
    },
    var.tags
  )
}
