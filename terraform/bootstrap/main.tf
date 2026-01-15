# ==============================================================================
# Terraform Backend Infrastructure
# ==============================================================================
#
# S3 버킷: Terraform State 저장
# DynamoDB: State Lock (동시 실행 방지)
#
# 사용법:
#   terraform init
#   terraform plan
#   terraform apply
# ==============================================================================

locals {
  bucket_name = "${var.project_name}-terraform-state-${var.aws_account_id}"
}

# ------------------------------------------------------------------------------
# S3 Bucket for Terraform State
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = local.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
