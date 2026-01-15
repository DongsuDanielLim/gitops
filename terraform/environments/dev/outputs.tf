# ==============================================================================
# Dev Environment - Outputs
# ==============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 IDs"
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  description = "데이터베이스 서브넷 IDs"
  value       = module.vpc.database_subnet_ids
}

output "database_subnet_group_name" {
  description = "RDS 서브넷 그룹 이름"
  value       = module.vpc.database_subnet_group_name
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}

# EKS Outputs
output "eks_cluster_name" {
  description = "EKS 클러스터 이름"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API 엔드포인트"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS 버전"
  value       = module.eks.cluster_version
}

output "eks_configure_kubectl" {
  description = "kubectl 설정 명령어"
  value       = module.eks.configure_kubectl
}

output "eks_oidc_provider_arn" {
  description = "OIDC Provider ARN (IRSA용)"
  value       = module.eks.oidc_provider_arn
}

# ECR Outputs
output "ecr_repository_urls" {
  description = "ECR 저장소 URLs"
  value       = module.ecr.repository_urls
}

output "alb_controller_role_arn" {
  description = "AWS Load Balancer Controller IAM Role ARN"
  value       = module.eks.alb-controller-role-arn
}