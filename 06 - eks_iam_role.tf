resource "aws_iam_role" "my_eks_iam_role" {
  name = "my-eks-iam-role"

  description        = "IAM role for Amazon EKS"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
  }
  EOF
  tags = {
    Name    = "my-eks-iam-role"
    Owner   = "AK"
    Project = "EKS_Project"
  }
}

resource "aws_iam_policy" "my_eks_control_plane_log_policy" {
  name        = "my-eks-control-plane-log-policy"
  description = "IAM policy for Amazon EKS control plane"
  policy      = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
  }
  EOF
}


# Attach the AmazonEKSServicePolicy managed policy to the IAM role log policy
resource "aws_iam_role_policy_attachment" "my_eks_control_plane_log_policy_attachment" {
  role       = aws_iam_role.my_eks_iam_role.name
  policy_arn = aws_iam_policy.my_eks_control_plane_log_policy.arn
}

# Attach the AmazonEKSClusterPolicy managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "my_eks_iam_role_policy_attachment" {
  role       = aws_iam_role.my_eks_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

