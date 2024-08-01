data "aws_iam_policy_document" "my_eks_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.irsa[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.irsa[0].url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }
  }
}

resource "aws_iam_role" "my_eks_autoscaler_role" {
  name               = "my-eks-autoscaler-role"
  description        = "IAM role for Amazon EKS Autoscaler"
  assume_role_policy = data.aws_iam_policy_document.my_eks_autoscaler_assume_role_policy.json
  tags = {
    Name    = "my-eks-autoscaler-role"
    Owner   = "AK"
    Project = "EKS_Project"
  }
}

resource "aws_iam_policy" "my_eks_autoscaler_policy" {
  name        = "my-eks-autoscaler-policy"
  description = "IAM policy for Amazon EKS Autoscaler"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_eks_autoscaler_policy_attachment" {
  role       = aws_iam_role.my_eks_autoscaler_role.name
  policy_arn = aws_iam_policy.my_eks_autoscaler_policy.arn
}