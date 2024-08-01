resource "aws_eks_node_group" "my_eks_node_group" {

  cluster_name    = aws_eks_cluster.my_eks_cluster.name
  node_group_name = "my-eks-node-group"
  node_role_arn   = aws_iam_role.my_eks_node_role.arn
  subnet_ids      = [aws_subnet.privateSubnet[0].id, aws_subnet.privateSubnet[1].id, aws_subnet.privateSubnet[2].id]
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.medium"]

  lifecycle {
    create_before_destroy = true
    # Allow external changes without Terraform plan difference
    ignore_changes = [scaling_config[0].desired_size]
  }

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "worker"
  }

  launch_template {
    id      = aws_launch_template.my_eks_node_template.id
    version = aws_launch_template.my_eks_node_template.latest_version
  }


  tags = {
    Name    = "my-eks-node-group"
    Owner   = "AK"
    Project = "EKS_Project"
  }

  depends_on = [
    aws_iam_role.my_eks_node_role,
    aws_iam_role_policy_attachment.my_eks_node_role_policy_attachment,
    aws_iam_role_policy_attachment.my_eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.my_eks_ecr_policy_attachment,
    aws_iam_role_policy_attachment.my_eks_SSMManagedInstanceCore_policy_attachment,
  ]
}

resource "aws_launch_template" "my_eks_node_template" {
  name = "my-eks-node-template"
}