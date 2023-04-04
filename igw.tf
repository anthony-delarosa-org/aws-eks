resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Nmae = "eks-igw"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "eks-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-west-2a.id

  tags = {
    Name = "eks-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

