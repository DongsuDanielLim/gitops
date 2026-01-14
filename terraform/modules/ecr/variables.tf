# ==============================================================================
# ECR Module - Variables
# ==============================================================================

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경"
  type        = string
}

variable "repository_names" {
  description = "생성할 ECR 저장소 이름 목록"
  type        = list(string)
  default     = ["order-service"]
}

variable "image_tag_mutability" {
  description = "이미지 태그 변경 가능 여부"
  type        = string
  default     = "MUTABLE"  # 프로덕션에서는 IMMUTABLE 권장
}

variable "scan_on_push" {
  description = "푸시 시 이미지 스캔"
  type        = bool
  default     = true
}

variable "tags" {
  description = "추가 태그"
  type        = map(string)
  default     = {}
}