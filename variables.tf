variable "account_id" {
  description = "List of Allowed AWS account IDs"
  type = list(string)
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "prefix" {
  description = "prefix for aws resources and tags"
  type = string
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type = string
}

variable "cluster_version" {
  description = "eks cluster version"
  type = string
  default = ""
}

variable "node_group_name" {
  description = "Name of node group"
  type = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EKS node group"
  type = list(string)
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type = string
  default = "AL2_x86_64"
}

variable "capacity_type" {
  description = "On-Deamnd or SPOT"
  type = string
  default = ""
}

variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  type = list(string)
}

variable "scaling_desired_size" {
  description = "Desired size of worker nodes for auto scaling"
  type = number
}

variable "scaling_min_size" {
  description = "Min size of worker nodes for auto scaling"
  type = number
}

variable "scaling_max_size" {
  description = "Max size of worker nodes for auto scaling"
  type = number
}

variable "key_name" {
  description = "EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group."
  type = string
}

variable "source_security_group_ids" {
  description = "Define the security group of the instance that can connect to the EKS node with ssh"
  type = string
}

variable "tags" {
  description = "tag map"
  type = map(string)
}