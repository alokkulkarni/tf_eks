# ===============================================================
#   OUTPUTS
# ===============================================================

output "vpc_id" {
  value = aws_vpc.myVPC.id
}

output "public_subnet_ids" {
  value = aws_subnet.publicSubnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.privateSubnet[*].id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.my_eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.my_eks_cluster.endpoint
}

output "openid_provider_url" {
  value = aws_eks_cluster.my_eks_cluster.identity[0].oidc[0].issuer
}

output "openid_provider_arn" {
  value = aws_eks_cluster.my_eks_cluster.identity[0].oidc[0].issuer
}

output "irsa_provider_arn" {
  value = aws_iam_openid_connect_provider.irsa[0].arn
}

output "irsa_provider_url" {
  value = aws_iam_openid_connect_provider.irsa[0].url
}

output "aws-load-balancer-controller_role_arn" {
  value = aws_iam_role.aws-load-balancer-controller.arn
}

output "aws-load-balancer-controller_role_name" {
  value = aws_iam_role.aws-load-balancer-controller.name
}
