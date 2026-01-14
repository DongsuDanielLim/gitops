# ==============================================================================
# Dev Environment Configuration
# ==============================================================================

# General
project_name = "ecommerce"
aws_region   = "ap-northeast-2"
environment  = "dev"

# VPC
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]

public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
database_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]

# NAT Gateway (dev는 비용 절감을 위해 단일)
enable_nat_gateway = true
single_nat_gateway = true

# EKS
eks_cluster_version     = "1.29"
eks_node_instance_types = ["t3.medium"]
eks_node_desired_size   = 2
eks_node_min_size       = 1
eks_node_max_size       = 4
eks_node_capacity_type  = "ON_DEMAND"  # 비용 절감 시 "SPOT"
eks_public_access_cidrs = ["0.0.0.0/0"]  # 프로덕션에서는 제한 필요

# ECR
ecr_repository_names = ["order-service"]