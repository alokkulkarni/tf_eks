# public subnet

resource "aws_subnet" "publicSubnet" {
  count                   = length(var.aws_public_subnet_cidr)
  vpc_id                  = aws_vpc.myVPC.id
  cidr_block              = var.aws_public_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name    = "publicSubnet-${count.index}"
    Owner   = "AK"
    Project = "VPC_Project"
    "kubernetes.io/role/elb" = "1"
  }
}

# private subnet

resource "aws_subnet" "privateSubnet" {
  count             = length(var.aws_private_subnet_cidr)
  vpc_id            = aws_vpc.myVPC.id
  cidr_block        = var.aws_private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name    = "privateSubnet-${count.index}"
    Owner   = "AK"
    Project = "VPC_Project"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

#private subnet
resource "aws_subnet" "privateSubnet2" {
  count             = length(var.aws_private_subnet_cidr2)
  vpc_id            = aws_vpc.myVPC.id
  cidr_block        = var.aws_private_subnet_cidr2[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name    = "privateSubnet2-${count.index}"
    Owner   = "AK"
    Project = "VPC_Project"
    "kubernetes.io/role/internal-elb" = "1"
  }
}