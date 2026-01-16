# path: gitops/scripts/README.md

# 운영 스크립트

## 개요

Terraform/K8s 인프라 관리를 위한 운영 스크립트 모음입니다.

## 스크립트 목록

| 스크립트 | 용도 | 환경 |
|---------|------|------|
| `cleanup-dev.sh` | terraform destroy 전 K8s 리소스 정리 | dev |
| `verify-destroy.sh` | destroy 후 잔존 리소스 확인 | 공통 |

## 사용법

### Dev 환경 삭제

\`\`\`bash
# 1. K8s 리소스 정리
./scripts/cleanup-dev.sh

# 2. Terraform destroy
cd terraform/environments/dev
terraform destroy

# 3. 잔존 리소스 확인
./scripts/verify-destroy.sh
\`\`\`

## 주의사항

- ⚠️ `cleanup-*.sh`는 해당 환경의 **모든 리소스를 삭제**합니다
- 실행 전 반드시 환경(dev/stage/prod) 확인
- prod 환경은 별도 승인 절차 필요