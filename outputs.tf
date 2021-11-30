output "account_id" {
  description = "AWS Account ID"
  value = var.account_id
}

output "vpc_id" {
  description = "VPC ID"
  value = var.vpc_id
}

output "cluster_name" {
  description = "EKS cluster name"
  value = aws_eks_node_group.this.cluster_name
}

output "cluster_version" {
  description = "EKS cluster name"
  value = aws_eks_node_group.this.version
}

output "node_group_name" {
  description = "EKS nodegroup name"
  value = aws_eks_node_group.this.node_group_name
}