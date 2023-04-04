resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  # Must be enabled for EFS
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-main"
  }
}

resource "aws_subnet" "private-us-west-2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-west-2a"

  tags = {
    "Name"                                      = "private-us-west-2a"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-us-west-2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-west-2b"

  tags = {
    "Name"                                      = "private-us-west-2b"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-us-west-2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-us-west-2a"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-us-west-2b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-us-west-2b"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "eks-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "eks-public"
  }
}

resource "aws_route_table_association" "private-us-west-2a" {
  subnet_id      = aws_subnet.private-us-west-2a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-west-2b" {
  subnet_id      = aws_subnet.private-us-west-2b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-us-west-2a" {
  subnet_id      = aws_subnet.public-us-west-2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-us-west-2b" {
  subnet_id      = aws_subnet.public-us-west-2b.id
  route_table_id = aws_route_table.public.id
}

