resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-ingress-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.1"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.my_eks_cluster.id
  }

  set {
    name  = "image.tag"
    value = "v2.4.2"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws-load-balancer-controller.arn
  }

  depends_on = [
    aws_eks_node_group.my_eks_node_group,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
  ]
}