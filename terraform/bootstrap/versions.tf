# ==============================================================================
# Terraform & Provider Version Constraints
# ==============================================================================

terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Bootstrap의 State는 로컬에 저장 (닭-달걀 문제)
  # terraform.tfstate는 .gitignore에 추가
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Purpose   = "Terraform Backend"
    }
  }
}