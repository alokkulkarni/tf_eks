resource "aws_eip" "aws_eip_nat" {
  domain = "vpc"
  tags = {
    Name    = "myEIP"
    Owner   = "AK"
    Project = "VPC_Project"
  }
}

resource "aws_nat_gateway" "myNATGateway" {
  allocation_id = aws_eip.aws_eip_nat.id
  subnet_id     = aws_subnet.publicSubnet[0].id
  tags = {
    Name    = "myNATGateway"
    Owner   = "AK"
    Project = "VPC_Project"
  }
}