# ==============================================================================
# Terraform Backend Configuration
# ==============================================================================
#
# Terraform 1.10+ S3 Native Locking 사용
# DynamoDB 불필요
# ==============================================================================

terraform {
  backend "s3" {
    bucket         = "ecommerce-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    use_lockfile   = true
  }
}