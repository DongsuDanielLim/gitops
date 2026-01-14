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