# path: gitops/scripts/cleanup-dev.sh

#!/bin/bash
#
# Dev 환경 정리 스크립트
# terraform destroy 전 K8s/AWS 리소스 정리
#
# 사용법: ./scripts/cleanup-dev.sh
#

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}  Dev 환경 정리 스크립트${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# 확인 프롬프트
echo -e "${RED}⚠️  경고: 이 스크립트는 dev 환경의 모든 리소스를 삭제합니다.${NC}"
echo ""
read -p "계속하시겠습니까? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "취소되었습니다."
    exit 0
fi

echo ""
echo -e "${GREEN}=== Step 1/7: K8s Ingress/LoadBalancer 삭제 ===${NC}"
echo -e "${CYAN}[삭제 전 상태]${NC}"
kubectl get ingress -n order-api 2>/dev/null || echo "  Ingress 없음"
kubectl get svc postgres-external -n order-api 2>/dev/null || echo "  postgres-external 서비스 없음"
echo ""
echo -e "${CYAN}[삭제 실행]${NC}"
kubectl delete ingress --all -n order-api --ignore-not-found
kubectl delete svc postgres-external -n order-api --ignore-not-found
echo ""
echo -e "${CYAN}[삭제 후 상태]${NC}"
kubectl get ingress -n order-api 2>/dev/null || echo "  ✅ Ingress 없음"
kubectl get svc postgres-external -n order-api 2>/dev/null || echo "  ✅ postgres-external 서비스 없음"

echo ""
echo -e "${GREEN}=== Step 2/7: ArgoCD Applications 삭제 ===${NC}"
echo -e "${CYAN}[삭제 전 상태]${NC}"
kubectl get applications -n argocd 2>/dev/null || echo "  Application 없음"
echo ""
echo -e "${CYAN}[삭제 실행]${NC}"
kubectl delete application order-api -n argocd --ignore-not-found
kubectl delete application postgres-dev -n argocd --ignore-not-found
kubectl delete application aws-load-balancer-controller -n argocd --ignore-not-found
echo ""
echo -e "${CYAN}[삭제 후 상태]${NC}"
kubectl get applications -n argocd 2>/dev/null || echo "  ✅ Application 없음"

echo ""
echo -e "${GREEN}=== Step 3/7: ALB/NLB 삭제 대기 (60초) ===${NC}"
echo -e "${CYAN}[현재 상태]${NC}"
aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-orderapi`)].[LoadBalancerName,State.Code]' \
    --output table 2>/dev/null || echo "  LB 없음"
echo ""
echo "AWS Load Balancer 삭제 대기 중 (60초)..."
sleep 60
echo ""
echo -e "${CYAN}[대기 후 상태]${NC}"
aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-orderapi`)].[LoadBalancerName,State.Code]' \
    --output table 2>/dev/null || echo "  ✅ LB 없음"

echo ""
echo -e "${GREEN}=== Step 4/7: ArgoCD Namespace 삭제 ===${NC}"
echo -e "${CYAN}[삭제 전 상태]${NC}"
kubectl get namespace argocd 2>/dev/null || echo "  argocd namespace 없음"
echo ""
echo -e "${CYAN}[삭제 실행]${NC}"
kubectl delete namespace argocd --ignore-not-found --wait=false
echo ""
echo -e "${CYAN}[삭제 후 상태]${NC}"
kubectl get namespace argocd 2>/dev/null || echo "  ✅ argocd namespace 없음"

echo ""
echo -e "${GREEN}=== Step 5/7: PVC 삭제 ===${NC}"
echo -e "${CYAN}[삭제 전 상태 - K8s PVC]${NC}"
kubectl get pvc -n order-api 2>/dev/null || echo "  PVC 없음"
echo ""
echo -e "${CYAN}[삭제 전 상태 - AWS EBS]${NC}"
aws ec2 describe-volumes \
    --filters "Name=tag:kubernetes.io/created-for/pvc/namespace,Values=order-api" \
    --query 'Volumes[*].[VolumeId,State]' \
    --output table 2>/dev/null || echo "  관련 EBS 없음"
echo ""
echo -e "${CYAN}[삭제 실행]${NC}"
kubectl delete pvc --all -n order-api --ignore-not-found
echo ""
echo -e "${CYAN}[삭제 후 상태 - K8s PVC]${NC}"
kubectl get pvc -n order-api 2>/dev/null || echo "  ✅ PVC 없음"

echo ""
echo -e "${GREEN}=== Step 6/7: order-api Namespace 삭제 ===${NC}"
echo -e "${CYAN}[삭제 전 상태]${NC}"
kubectl get all -n order-api 2>/dev/null || echo "  리소스 없음"
echo ""
echo -e "${CYAN}[삭제 실행]${NC}"
kubectl delete namespace order-api --ignore-not-found --wait=false
echo ""
echo -e "${CYAN}[삭제 후 상태]${NC}"
kubectl get namespace order-api 2>/dev/null || echo "  ✅ order-api namespace 없음"

echo ""
echo -e "${GREEN}=== Step 7/7: AWS 리소스 최종 확인 ===${NC}"
echo ""
echo -e "${CYAN}[Load Balancers]${NC}"
aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-`)].[LoadBalancerName,State.Code]' \
    --output table 2>/dev/null || echo "  ✅ K8s LB 없음"

echo ""
echo -e "${CYAN}[Target Groups]${NC}"
aws elbv2 describe-target-groups \
    --query 'TargetGroups[?contains(TargetGroupName, `k8s-`)].[TargetGroupName]' \
    --output table 2>/dev/null || echo "  ✅ K8s Target Group 없음"

echo ""
echo -e "${CYAN}[Orphaned EBS Volumes]${NC}"
aws ec2 describe-volumes \
    --filters "Name=status,Values=available" \
    --query 'Volumes[*].[VolumeId,Size,Tags[?Key==`kubernetes.io/created-for/pvc/name`].Value|[0]]' \
    --output table 2>/dev/null || echo "  ✅ Orphaned 볼륨 없음"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  K8s 리소스 정리 완료${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "다음 명령어로 Terraform destroy 실행:"
echo ""
echo "  cd terraform/environments/dev"
echo "  terraform destroy"
echo ""