resource "aws_vpc" "abhi_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "abhi-vpc-${var.env}"
  }
}

resource "aws_subnet" "abhi_public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.abhi_vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "abhi-public-subnet-${var.env}-${count.index}"
  }
}

resource "aws_subnet" "abhi_private_subnet" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.abhi_vpc.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "abhi-private-subnet-${var.env}-${count.index}"
  }
}

resource "aws_nat_gateway" "abhi_nat_gateway" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.abhi_nat_eip[count.index].id
  subnet_id     = element(aws_subnet.abhi_public_subnet.*.id, count.index)

  tags = {
    Name = "abhi-nat-gateway-${var.env}-${count.index}"
  }
}

resource "aws_eip" "abhi_nat_eip" {
  count = length(var.public_subnet_cidrs)
}

resource "aws_route_table" "abhi_public_route_table" {
  vpc_id = aws_vpc.abhi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.abhi_internet_gateway.id
  }

  tags = {
    Name = "abhi-public-route-table-${var.env}"
  }
}

resource "aws_route_table" "abhi_private_route_table" {
  vpc_id = aws_vpc.abhi_vpc.id

  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.abhi_nat_gateway.*.id, 0)
  }

  tags = {
    Name = "abhi-private-route-table-${var.env}"
  }
}

resource "aws_route_table_association" "abhi_public_route_table_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.abhi_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.abhi_public_route_table.id
}

resource "aws_route_table_association" "abhi_private_route_table_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.abhi_private_subnet.*.id, count.index)
  route_table_id = aws_route_table.abhi_private_route_table.id
}

resource "aws_internet_gateway" "abhi_internet_gateway" {
  vpc_id = aws_vpc.abhi_vpc.id

  tags = {
    Name = "abhi-internet-gateway-${var.env}"
  }
}
