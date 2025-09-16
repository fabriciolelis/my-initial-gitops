locals {
  prefix_name           = "${var.application}-${var.environment}"
  vpc_name              = "${local.prefix_name}-vpc"
  internet_gateway_name = "${local.prefix_name}-internet-gtw"
  private_subnet        = "${local.prefix_name}-private-subnet"
  public_subnet         = "${local.prefix_name}-public-subnet"
  route_table_public    = "${local.prefix_name}-route-table-public"
  nat_gateway           = "${local.prefix_name}-nat-gateway"
  elastic_ip            = "${local.prefix_name}-elastic-ip"
  route_table_private   = "${local.prefix_name}-route-table-private"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = merge(
    tomap({ "Service" = "VPC" }),
    tomap({ "Name" = local.vpc_name })
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    tomap({ "Service" = "Internet Gateway" }),
    tomap({ "Name" = local.internet_gateway_name })
  )
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)
  tags = merge(
    tomap({ "Service" = "Subnet" }),
    tomap({ "Name" = local.private_subnet })
  )
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
  tags = merge(
    tomap({ "Service" = "Subnet" }),
    tomap({ "Name" = local.public_subnet })
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    tomap({ "Service" = "Route Table" }),
    tomap({ "Name" = local.route_table_public })
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on = [
    aws_internet_gateway.main
  ]
  tags = merge(
    tomap({ "Service" = "NAT Gateway" }),
    tomap({ "Name" = local.nat_gateway })
  )
}

resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc   = true
  tags = merge(
    tomap({ "Service" = "Elastic IP" }),
    tomap({ "Name" = local.elastic_ip })
  )
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  tags = merge(
    tomap({ "Service" = "Route Table" }),
    tomap({ "Name" = local.route_table_private })
  )
}

resource "aws_route" "private" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}


