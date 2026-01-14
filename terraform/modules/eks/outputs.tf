# ==============================================================================
# EKS Module - Outputs
# ==============================================================================

output "cluster_id" {
  description = "EKS 클러스터 ID"
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "EKS 클러스터 이름"
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS 클러스터 ARN"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "EKS 클러스터 API 엔드포인트"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "EKS 클러스터 버전"
  value       = aws_eks_cluster.this.version
}

output "cluster_certificate_authority_data" {
  description = "EKS 클러스터 CA 인증서 (base64)"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "EKS 클러스터 보안 그룹 ID"
  value       = aws_security_group.cluster.id
}

output "node_group_security_group_id" {
  description = "노드 그룹 보안 그룹 ID"
  value       = aws_security_group.node_group.id
}

output "node_group_role_arn" {
  description = "노드 그룹 IAM Role ARN"
  value       = aws_iam_role.node_group.arn
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN (IRSA용)"
  value       = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  description = "OIDC Provider URL"
  value       = aws_iam_openid_connect_provider.this.url
}

# kubectl 설정 명령어
output "configure_kubectl" {
  description = "kubectl 설정 명령어"
  value       = "aws eks update-kubeconfig --region ap-northeast-2 --name ${aws_eks_cluster.this.name}"
}