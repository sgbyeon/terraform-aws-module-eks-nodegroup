# AWS EKS managed-NodeGroup Terraform custom module
* EKS Cluster에 조인할 매니지드 node group 생성
* ebs 기본 암호(기본키 사용, 선택불가)
* 

## Usage

### `terraform.tfvars`
* 모든 변수는 적절하게 변경하여 사용
```
account_id = ["628842917615"] # 아이디 변경 필수, output 확인용, 실수 방지용도, 리소스에 사용하진 않음
region = "ap-northeast-2" # 리전 변경 필수, output 확인용, 실수 방지용도, 리소스에 사용하진 않음
prefix = "bsg-demo"
cluster_name = "fully-private-eks-cluster"
node_group_name = "ondemand-managed-nodegroup"
cluster_version = "1.21"

# EKS node group이 배치 될 VPC의 TAG, data에서 tag 기반으로 for_each
vpc_filters = {
  "Name" = "bsg-demo-eks-vpc"
}

ami_type = "AL2_x86_64" # Amazon Linux 2
capacity_type = "ON_DEMAND" # or "SPOT"
instance_types = ["t3.large"]

scaling_desired_size = "2"
scaling_min_size = "2"
scaling_max_size = "5"

key_name = "demo-eks-key" # EKS node(EC2 instance) 에 접속할 수 있는 ssh key
source_security_group_ids = ["sg-050238316c3791057"] # EKS node(EC2 instance) 에 접속할 수 있는 Bastion host의 시큐리티 그룹 ID 필요, ssh 접근 허용 위함

# 공통 tag, 생성되는 모든 리소스에 태깅
tags = {
    "CreatedByTerraform" = "true"
}
```
---

### `main.tf`
```
module "nodegroup" {
  source = "git::https://github.com/sgbyeon/terraform-aws-module-eks-nodegroup.git"
  account_id = var.account_id
  vpc_id = data.aws_vpc.this.id
  prefix = var.prefix
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  node_group_name = var.node_group_name
  subnet_ids = data.aws_subnet_ids.private.ids
  instance_types = var.instance_types
  ami_type = var.ami_type
  capacity_type = var.capacity_type
  scaling_min_size = var.scaling_min_size
  scaling_max_size = var.scaling_max_size
  scaling_desired_size = var.scaling_desired_size
  key_name = var.key_name
  source_security_group_ids = var.source_security_group_ids
  tags = var.tags
}
```
---
### `data.tf`
```
data "aws_region" "current" {}

data "aws_vpc" "this" {
  dynamic "filter" {
    for_each = var.vpc_filters # block를 생성할 정보를 담은 collection 전달, 전달 받은 수 만큼 block 생성
    iterator = tag # 각각의 item 에 접근할 수 있는 라벨링 부여, content block에서 tag 를 사용하여 접근
    
    content { # block안에서 실제 전달되는 값들
      name = "tag:${tag.key}"
      values = [
        tag.value
      ]
    }
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    Tier = "private" # Tier 태그가 private 서브넷만 추출
  }
}
```

### `provider.tf`
```
provider  "aws" {
  region  =  var.region
}
```
---

### `terraform.tf`
```
terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.39"
    }
  }
}
```
---

### `variables.tf`
```
variable "account_id" {
  description = "List of Allowed AWS account IDs"
  type = list(string)
  default = [""]
}

variable "region" {
  description = "AWS Region"
  type = string
  default = ""
}

variable "vpc_filters" {
  description = "Filters to select vpc"
  type = map(string)
}

variable "prefix" {
  description = "prefix for aws resources and tags"
  type = string
}

variable "cluster_name" {
  description = "eks cluster name"
  type = string
  default = ""
}

variable "cluster_version" {
  description = "eks cluster version"
  type = string
  default = ""
}

variable "node_group_name" {
  type = string
  description = "Name of node group"
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type = string
  default = ""
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
  type = list(string)
}

variable "tags" {
  description = "tag map"
  type = map(string)
}
```
---

### `outputs.tf`
```
output "account_id" {
  description = "AWS Account ID"
  value = module.nodegroup.account_id
}

output "region" {
  description = "AWS region"
  value = module.nodegroup.region
}

output "vpc_id" {
  description = "VPC ID"
  value = module.nodegroup.vpc_id
}

output "cluster_name" {
  description = "EKS cluster name"
  value = module.nodegroup.cluster_name
}

output "cluster_version" {
  description = "EKS cluster name"
  value = module.nodegroup.cluster_version
}

output "node_group_name" {
  description = "EKS nodegroup name"
  value = module.nodegroup.node_group_name
}
```