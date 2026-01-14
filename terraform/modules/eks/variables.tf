# ==============================================================================
# EKS Module - Input Variables
# ==============================================================================

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, stage, prod)"
  type        = string
}

variable "cluster_version" {
  description = "EKS 클러스터 버전"
  type        = string
  default     = "1.29"
}

# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록 (워커 노드용)"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록 (ALB용)"
  type        = list(string)
}

# ------------------------------------------------------------------------------
# Node Group
# ------------------------------------------------------------------------------
variable "node_group_instance_types" {
  description = "워커 노드 인스턴스 타입"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_desired_size" {
  description = "워커 노드 희망 개수"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "워커 노드 최소 개수"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "워커 노드 최대 개수"
  type        = number
  default     = 4
}

variable "node_group_disk_size" {
  description = "워커 노드 디스크 크기 (GB)"
  type        = number
  default     = 50
}

variable "node_group_capacity_type" {
  description = "용량 타입 (ON_DEMAND 또는 SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

# ------------------------------------------------------------------------------
# Access
# ------------------------------------------------------------------------------
variable "cluster_endpoint_public_access" {
  description = "퍼블릭 API 엔드포인트 활성화"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "프라이빗 API 엔드포인트 활성화"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "퍼블릭 API 접근 허용 CIDR (보안을 위해 제한 권장)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # 프로덕션에서는 사무실 IP로 제한
}

# ------------------------------------------------------------------------------
# Add-ons
# ------------------------------------------------------------------------------
variable "enable_cluster_addons" {
  description = "EKS 관리형 애드온 활성화"
  type        = bool
  default     = true
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}