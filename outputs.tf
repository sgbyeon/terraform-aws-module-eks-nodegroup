output "node_group_name" {
  description = "EKS nodegroup name"
  value = aws_eks_node_group.this.node_group_name
}