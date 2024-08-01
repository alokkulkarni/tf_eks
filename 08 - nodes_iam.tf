resource "aws_iam_role" "my_eks_node_role" {
  name               = "my-eks-node-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name    = "my-eks-node-role"
    Owner   = "AK"
    Project = "EKS_Project"
  }
}

resource "aws_iam_role_policy_attachment" "my_eks_node_role_policy_attachment" {
  role       = aws_iam_role.my_eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "my_eks_cni_policy_attachment" {
  role       = aws_iam_role.my_eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "my_eks_ecr_policy_attachment" {
  role       = aws_iam_role.my_eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "my_eks_SSMManagedInstanceCore_policy_attachment" {
  role       = aws_iam_role.my_eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

