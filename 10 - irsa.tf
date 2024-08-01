data "aws_iam_policy_document" "my_oidc_assume_role_policy" {
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
      values   = ["system:serviceaccount:default:aws-test"]
    }
  }
}

resource "aws_iam_role" "my_eks_oidc_role" {
  name               = "my-eks-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.my_oidc_assume_role_policy.json
}

resource "aws_iam_policy" "my_s3_eks_policy" {
  name        = "my-s3-eks-policy"
  description = "IAM policy for Amazon S3 and EKS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetBucketLocation", "s3:ListAllMyBuckets"],
        Resource = ["arn:aws:s3:::*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_s3_eks_policy_attachment" {
  role       = aws_iam_role.my_eks_oidc_role.name
  policy_arn = aws_iam_policy.my_s3_eks_policy.arn
}

data "tls_certificate" "irsa" {
  count = var.enable_irsa ? 1 : 0
  url   = aws_eks_cluster.my_eks_cluster.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "irsa" {
  count           = var.enable_irsa ? 1 : 0
  url             = aws_eks_cluster.my_eks_cluster.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.irsa[0].certificates[0].sha1_fingerprint]
}