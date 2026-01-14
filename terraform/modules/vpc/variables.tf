# ==============================================================================
# VPC Module - Input Variables
# ==============================================================================

variable "project_name" {
  description = "프로젝트 이름 (리소스 네이밍에 사용)"
  type        = string
}

variable "environment" {
  description = "환경 (dev, stage, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDR 목록 (EKS 워커 노드)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  description = "데이터베이스 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "enable_nat_gateway" {
  description = "NAT Gateway 생성 여부"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "단일 NAT Gateway 사용 여부 (비용 절감, HA 감소)"
  type        = bool
  default     = true  # dev는 true, prod는 false 권장
}

variable "enable_dns_hostnames" {
  description = "DNS 호스트네임 활성화"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "DNS 지원 활성화"
  type        = bool
  default     = true
}

variable "tags" {
  description = "모든 리소스에 적용할 추가 태그"
  type        = map(string)
  default     = {}
}