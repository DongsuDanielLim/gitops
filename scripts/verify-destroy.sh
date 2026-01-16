#!/bin/bash
#
# Terraform destroy 후 잔존 리소스 확인
#
# 사용법: ./scripts/verify-destroy.sh
#

set -e

echo "=========================================="
echo "  Destroy 후 잔존 리소스 확인"
echo "=========================================="
echo ""

echo "1. VPC 확인:"
vpcs=$(aws ec2 describe-vpcs \
    --filters "Name=tag:Name,Values=*ecommerce*" \
    --query 'Vpcs[*].VpcId' --output text 2>/dev/null)
if [ -z "$vpcs" ]; then
    echo "   ✅ ecommerce VPC 없음"
else
    echo "   ⚠️  남은 VPC: $vpcs"
fi

echo ""
echo "2. EBS Volumes (orphaned):"
volumes=$(aws ec2 describe-volumes \
    --filters "Name=status,Values=available" \
    --query 'Volumes[*].VolumeId' --output text 2>/dev/null)
if [ -z "$volumes" ]; then
    echo "   ✅ Orphaned 볼륨 없음"
else
    echo "   ⚠️  삭제 필요: $volumes"
    echo "   삭제 명령어: aws ec2 delete-volume --volume-id <volume-id>"
fi

echo ""
echo "3. Elastic IPs:"
eips=$(aws ec2 describe-addresses \
    --query 'Addresses[?AssociationId==null].AllocationId' --output text 2>/dev/null)
if [ -z "$eips" ]; then
    echo "   ✅ 미사용 EIP 없음"
else
    echo "   ⚠️  삭제 필요: $eips"
fi

echo ""
echo "4. Load Balancers:"
lbs=$(aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[?contains(LoadBalancerName, `k8s-`)].LoadBalancerName' --output text 2>/dev/null)
if [ -z "$lbs" ]; then
    echo "   ✅ K8s LB 없음"
else
    echo "   ⚠️  남은 LB: $lbs"
fi

echo ""
echo "5. ECR Repositories:"
repos=$(aws ecr describe-repositories \
    --query 'repositories[?contains(repositoryName, `ecommerce`)].repositoryName' --output text 2>/dev/null)
if [ -z "$repos" ]; then
    echo "   ✅ ecommerce ECR 없음"
else
    echo "   ⚠️  남은 ECR: $repos"
fi

echo ""
echo "6. CloudWatch Log Groups:"
logs=$(aws logs describe-log-groups \
    --log-group-name-prefix "/aws/eks/ecommerce" \
    --query 'logGroups[*].logGroupName' --output text 2>/dev/null)
if [ -z "$logs" ]; then
    echo "   ✅ EKS 로그 그룹 없음"
else
    echo "   ⚠️  남은 로그 그룹: $logs"
fi

echo ""
echo "=========================================="
echo "  확인 완료"
echo "=========================================="