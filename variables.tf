# Description: Define the variables used in the Terraform configuration
# ===============================================================
#   Global AWS VARIABLES
# ===============================================================

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2" # Replace with your desired default region
}

variable "profile" {
  description = "AWS profile"
  type        = string
  default     = "default" # Replace with your desired default profile
}

# ===============================================================
#  VPC VARIABLES
# ===============================================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "aws_private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "aws_private_subnet_cidr2" {
  description = "CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "availability_zones" {
  description = "A list of availability zones"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}



# ===============================================================
#  EKS VARIABLES
# ===============================================================
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "enable_irsa" {
  description = "A boolean flag to enable IRSA"
  type        = bool
  default     = true
}

variable "node_group_name" {
  description = "The name of the EKS node group"
  type        = string
  default     = "my-eks-node-group"
}

variable "node_instance_type" {
  description = "The instance type for the EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_group_desired_capacity" {
  description = "The desired number of EKS nodes"
  type        = number
  default     = 2
}

variable "node_group_desired_size" {
  description = "The desired number of EKS nodes"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "The minimum number of EKS nodes"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "The maximum number of EKS nodes"
  type        = number
  default     = 3
}

variable "node_group_volume_size" {
  description = "The volume size for the EKS nodes"
  type        = number
  default     = 20
}

variable "subnet_ids" {
  description = "A list of subnet IDs"
  type        = list(string)
  default     = []
}

variable "endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "node_iam_policies" {
  description = "A list of IAM policies to attach to the EKS nodes"
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "public_access_cidrs" {
  description = "A list of CIDR blocks that can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_groups" {
  description = "A map of node groups"
  type = map(object({
    name           = string
    capacity_type  = string
    instance_types = list(string)
  }))
  default = {
    1 = {
      name           = "my-eks-node-group"
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
    }
  }
}

variable "enable_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}