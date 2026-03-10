resource "aws_vpc" "this" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

################################
# Internet Gateway
################################

resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

################################
# Public Subnet
################################

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

################################
# Private Subnet
################################

resource "aws_subnet" "private" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet
  availability_zone = var.az

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

################################
# Public Route Table
################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}