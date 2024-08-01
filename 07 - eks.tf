resource "aws_eks_cluster" "my_eks_cluster" {
  name    = var.cluster_name
  version = var.cluster_version

  role_arn = aws_iam_role.my_eks_iam_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.privateSubnet[0].id, aws_subnet.privateSubnet[1].id, aws_subnet.privateSubnet[2].id]

    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
  }

  enabled_cluster_log_types = var.enable_cluster_log_types

  tags = {
    Name    = var.cluster_name
    Owner   = "AK"
    Project = "EKS_Project"
  }

  depends_on = [
    aws_iam_role.my_eks_iam_role,
    aws_iam_role_policy_attachment.my_eks_iam_role_policy_attachment,
    aws_iam_policy.my_eks_control_plane_log_policy,
  ]
}

# Create a CloudWatch log group for the EKS control plane logs
resource "aws_cloudwatch_log_group" "my_eks_control_plane_logs" {
  name              = "/aws/eks/${var.cluster_name}/control-plane-logs"
  retention_in_days = 7
}
