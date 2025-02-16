resource "aws_vpc" "vpc-test" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.vpc-test.id
  cidr_block = each.value
  for_each = var.public_subnet_cidr
  availability_zone = each.key
}

resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.vpc-test.id
  cidr_block = each.value
  for_each = var.private_subnet_cidr
  availability_zone = each.key
  

  tags = {
    Name = "private-subnet"
  }
}

output "pub-sub" {
  value = keys(aws_subnet.public-subnet)
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-test.id
  tags = {
    Name = "Internet-gateway"
  }
}

resource "aws_eip" "nat-ip" {
  domain   = "vpc"
  tags = {
    Name = "Nat Gateway"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = var.nat_az[count.index]
  count = 1

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw, aws_subnet.private-subnet]
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc-test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc-test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway.id
  }

  depends_on = [ aws_nat_gateway.nat-gateway ]
}


# resource "aws_route_table_association" "public-sub-association" {
#   subnet_id      = aws_subnet.public-subnet[count.index].id
#   count = var.count_sub
#   route_table_id = aws_route_table.public-rt.id

#   depends_on = [ aws_subnet.public-subnet ]
# }

# resource "aws_route_table_association" "private-sub-association" {
#   subnet_id      = aws_subnet.private-subnet[count.index].id
#   count = var.count_sub
#   route_table_id = aws_route_table.private-rt.id

#   depends_on = [ aws_subnet.private-subnet ]
# }