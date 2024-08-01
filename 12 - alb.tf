data "aws_iam_policy_document" "aws-load-balancer-controller_assume_role_policy" {
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
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "aws-load-balancer-controller" {
  name               = "aws-load-balancer-controller"
  description        = "IAM role for ALB Load Balancer Controller"
  assume_role_policy = data.aws_iam_policy_document.aws-load-balancer-controller_assume_role_policy.json
  tags = {
    Name    = "aws-load-balancer-controller"
    Owner   = "AK"
    Project = "EKS_Project"
  }
}

resource "aws_iam_policy" "aws-load-balancer-controller" {
  name        = "aws-load-balancer-controller"
  description = "IAM policy for ALB Load Balancer Controller"
  policy      = file("./AWSIngressController.json")
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.aws-load-balancer-controller.name
  policy_arn = aws_iam_policy.aws-load-balancer-controller.arn
}