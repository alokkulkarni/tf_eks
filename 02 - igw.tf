resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name    = "myIGW"
    Owner   = "AK"
    Project = "VPC_Project"
  }
}