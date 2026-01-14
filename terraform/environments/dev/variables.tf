# ==============================================================================
# Environment Variables
# ==============================================================================

variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 이름"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
}

variable "availability_zones" {
  description = "가용 영역 목록"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDR 목록"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "데이터베이스 서브넷 CIDR 목록"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "NAT Gateway 생성 여부"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "단일 NAT Gateway 사용 (비용 절감)"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# EKS Variables
# ------------------------------------------------------------------------------
variable "eks_cluster_version" {
  description = "EKS 클러스터 버전"
  type        = string
  default     = "1.29"
}

variable "eks_node_instance_types" {
  description = "EKS 노드 인스턴스 타입"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_desired_size" {
  description = "EKS 노드 희망 개수"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "EKS 노드 최소 개수"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "EKS 노드 최대 개수"
  type        = number
  default     = 4
}

variable "eks_node_capacity_type" {
  description = "EKS 노드 용량 타입 (ON_DEMAND/SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_public_access_cidrs" {
  description = "EKS API 퍼블릭 접근 허용 CIDR"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ------------------------------------------------------------------------------
# ECR Variables
# ------------------------------------------------------------------------------
variable "ecr_repository_names" {
  description = "ECR 저장소 이름 목록"
  type        = list(string)
  default     = ["order-service"]
}