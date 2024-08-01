# Route Table for Public Subnets

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.myVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name    = "publicRouteTable"
    Owner   = "AK"
    Project = "VPC_Project"
  }
}

# Route Table for Private Subnets

resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.myVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myNATGateway.id
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myNATGateway.id
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myNATGateway.id
  }
  tags = {
    Name    = "privateRouteTable"
    Owner   = "AK"
    Project = "VPC_Project"
  }
}

resource "aws_route_table" "privateRouteTable2" {
  vpc_id = aws_vpc.myVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myNATGateway.id
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myNATGateway.id
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myNATGateway.id
  }
  tags = {
    Name    = "privateRouteTable2"
    Owner   = "AK"
    Project = "VPC_Project"
  }
}

# Route Table Association for Public and Private Subnets

resource "aws_route_table_association" "publicRouteTableAssociation" {
  count          = length(var.aws_public_subnet_cidr)
  subnet_id      = element(aws_subnet.publicSubnet[*].id, count.index)
  route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_route_table_association" "privateRouteTableAssociation" {
  count          = length(var.aws_private_subnet_cidr)
  subnet_id      = element(aws_subnet.privateSubnet[*].id, count.index)
  route_table_id = aws_route_table.privateRouteTable.id
}

resource "aws_route_table_association" "privateRouteTableAssociation2" {
  count          = length(var.aws_private_subnet_cidr2)
  subnet_id      = element(aws_subnet.privateSubnet2[*].id, count.index)
  route_table_id = aws_route_table.privateRouteTable2.id
}
