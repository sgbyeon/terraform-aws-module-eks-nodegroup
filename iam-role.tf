resource "aws_iam_role" "this" {
  name = "${var.prefix}-${var.cluster_name}-nodegroup-role"
  description = "The role that Amazon EKS node group will use to interact AWS resources for Kubernetes clusters"
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
}

resource "aws_iam_policy" "Amazon_EBS_CSI_Driver" {
  name = "${var.cluster_name}-Amazon_EBS_CSI_Driver"
  description = "CSI driver for Amazon EBS"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:ModifyVolume"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "Amazon_EBS_CSI_Driver" {
  policy_arn = aws_iam_policy.Amazon_EBS_CSI_Driver.arn
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AutoScalingReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"
  role = aws_iam_role.this.name
}