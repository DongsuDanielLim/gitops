# Terraform IaC GitOps

## 버전 
```bash
# 도커 버전
Docker version 28.2.2

# kubectl version --client
Kustomize Version: v5.5.0

# kind version
kind version 0.31.0

```

# Terraform Backend Bootstrap

Terraform State를 저장할 S3 버킷과 Lock용 DynamoDB 테이블 생성.

## 왜 별도 프로젝트인가?

Terraform State를 S3에 저장하려면 S3 버킷이 먼저 존재해야한다.
이 "닭-달걀 문제"를 해결하기 위해 Backend 인프라는 로컬 State로 관리한다.

## 생성되는 리소스

| 리소스 | 이름 | 용도                          |
|--------|------|-----------------------------|
| S3 Bucket | `{project}-terraform-state` | State 파일 저장, Native Locking |

## 사용법

### 1. 초기화 및 생성
```bash
cd terraform/bootstrap

terraform init
terraform plan
terraform apply
```

### 2. 출력 확인
```bash
terraform output
```

### 3. Backend 설정

출력된 `backend_config`를 `environments/*/backend.tf`에 복사.

## S3 버킷 설정

| 설정 | 값 | 이유 |
|------|----|----|
| Versioning | Enabled | State 복구 가능 |
| Encryption | AES256 | 보안 |
| Public Access | 모두 차단 | 보안 |

## 비용

| 리소스 | 예상 비용 |
|--------|----------|
| S3 | ~$0.023/GB/월 |
| **합계** | **거의 무료** (~$1/월 미만) |

## 주의사항

- `terraform.tfstate`는 Git에 커밋하지 않습니다
- `prevent_destroy = true`로 실수 삭제 방지됨
- 삭제 시 `lifecycle` 블록 주석 처리 필요

## 점검 순서
```bash
terraform init
terraform validate
# check 결과가 있으면 포맷팅 진행
terraform fmt -check
# 포맷팅 진행 명령어 : 출력이 없어야 완료
terraform fmt
```

## 삭제 방법
```hcl
# main.tf에서 lifecycle 블록 주석 처리 후
# lifecycle {
#   prevent_destroy = true
# }

terraform destroy