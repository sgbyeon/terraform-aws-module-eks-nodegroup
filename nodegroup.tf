resource "aws_eks_node_group" "this" {
  cluster_name = format("%s-%s", var.prefix, var.cluster_name)
  version = var.cluster_version
  node_group_name = format("%s-%s", var.prefix, var.node_group_name)
  node_role_arn = aws_iam_role.this.arn
  subnet_ids = var.subnet_ids

  scaling_config {
    desired_size = var.scaling_desired_size
    min_size = var.scaling_min_size
    max_size = var.scaling_max_size
  }

  ami_type = var.ami_type
  capacity_type = var.capacity_type
  instance_types = var.instance_types

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.Amazon_EBS_CSI_Driver
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config.0.desired_size
    ]
  }

  remote_access {
    ec2_ssh_key  = var.key_name
    source_security_group_ids = var.source_security_group_ids
  }

  tags = merge(var.tags, tomap({
    Name = format("%s-%s-%s", var.prefix, var.cluster_name, var.node_group_name),
    "kubernetes.io/cluster/${var.prefix}-${var.cluster_name}" = "owned"
  }))
}