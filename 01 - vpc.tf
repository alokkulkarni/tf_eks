# Description: This file contains the code to create a VPC with public and private subnets in AWS.
# The VPC module is used to create the VPC, and the public and private subnets are created using the aws_subnet resource.
# The public subnets are associated with a public route table that has a route to the internet gateway, and the private subnets are associated with a private route table that has a route to the NAT gateway.
# The public and private route tables are created using the aws_route_table resource, and the route table associations are created using the aws_route_table_association resource.
# The VPC, public and private subnets, route tables, and route table associations are tagged with the appropriate tags.
# The output variables are used to output the VPC ID, public and private subnet IDs, availability zones, CIDR blocks, and DNS settings.
# The variables.tf file contains the input variables for the VPC module, and the providers.tf file contains the provider configurations for the AWS provider.


# ===============================================================
#   VPC RESOURCE
# ===============================================================

resource "aws_vpc" "myVPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name    = "myVPC"
    Owner   = "AK"
    Project = "VPC_Project"
  }
}






