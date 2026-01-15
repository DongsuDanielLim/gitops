# ==============================================================================
# Outputs
# ==============================================================================

output "s3_bucket_name" {
  description = "Terraform State 저장용 S3 버킷 이름"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.terraform_state.arn
}

output "backend_config" {
  description = "environments/*/backend.tf 설정 예시"
  value       = <<-EOT

    # ==========================================================================
    # 아래 내용을 environments/<env>/backend.tf에 복사하세요
    # ==========================================================================

    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.terraform_state.id}"
        key            = "<ENV>/terraform.tfstate"
        region         = "${var.aws_region}"
        encrypt        = true
        use_lockfile   = true
      }
    }

    # <ENV>를 환경에 맞게 변경: dev, stage, prod

  EOT
}