# terragrunt_demo

這個 Repository 是 **Terragrunt + Terraform** 的實作練習，包含兩個完整的 AWS 架構範例，示範如何用 Terragrunt 管理多模組、多環境的 IaC 專案。

---

## 專案結構

```
terragrunt_demo/
├── version_backend/        # 初始化 Terraform remote state 用的 backend 資源
│   ├── sqs_service/        # SQS 服務的 S3 bucket + DynamoDB lock table
│   └── vue_cdn/            # Vue CDN 服務的 S3 bucket + DynamoDB lock table
│
├── sqs_service/            # 範例一：Lambda 透過 VPC Endpoint 存取 SQS / S3
│   ├── envs/dev/           # dev 環境的 Terragrunt 組裝
│   └── modules/            # 可重用的 Terraform 模組
│
└── vue_cdn/                # 範例二：Vue 3 前端搭配 CloudFront + API Gateway + Lambda + DynamoDB
    ├── envs/dev/           # dev 環境的 Terragrunt 組裝
    ├── modules/            # 可重用的 Terraform 模組
    └── vue-cdn-project/    # Vue 3 + Vite 前端原始碼
```

---

## 範例一：sqs_service

### 架構說明

示範 Lambda 部署在 **私有子網路（Private Subnet）** 中，透過 VPC Endpoint 私下存取 AWS 託管服務，完全不需要走公開網路。

```
Lambda (Private Subnet)
    │
    ├─── S3 Gateway Endpoint  ──► S3 Bucket
    │
    └─── SQS Interface Endpoint ──► SQS Queue (含 DLQ)
```

### 使用到的 AWS 服務

| 服務 | 說明 |
|------|------|
| **VPC** | 含 Private Subnet、Route Table、Security Group |
| **S3** | 私有 Bucket，僅允許透過 VPC Endpoint 存取（Bucket Policy 限制） |
| **S3 Gateway Endpoint** | 讓 Private Subnet 內的資源可免費走 AWS 骨幹存取 S3 |
| **SQS** | 主要佇列 + Dead Letter Queue（DLQ），啟用 SSE 加密，Long Polling |
| **SQS Interface Endpoint** | 讓 Lambda 可在 VPC 內透過 Private DNS 存取 SQS |
| **Lambda** | Python 3.14，部署於 Private Subnet，驗證 S3 存取與 SQS 送訊 |

### Lambda 執行邏輯

1. 列出指定 S3 Bucket 的物件清單
2. 印出 SQS 的 DNS 解析 IP（驗證是否走 Private DNS，`10.x.x.x` 表示透過 VPC Endpoint）
3. 傳送訊息至 SQS Queue

### 模組結構

```
sqs_service/
├── envs/dev/
│   ├── root.hcl                  # 共用設定（region、tags、S3 backend）
│   ├── vpc/                      # VPC、Private Subnet、Security Group
│   ├── s3/                       # S3 Bucket
│   ├── s3_gateway_endpoint/      # S3 Gateway Endpoint
│   ├── sqs/                      # SQS Queue + DLQ
│   ├── sqs_interface_endpoint/   # SQS Interface Endpoint
│   └── lambda/                   # Lambda（依賴 vpc、s3、sqs）
└── modules/
    ├── vpc/
    ├── s3/
    ├── s3_gateway_endpoint/
    ├── sqs/
    ├── sqs_interface_endpoint/
    └── lambda/
```

---

## 範例二：vue_cdn

### 架構說明

示範「用 CloudFront CDN 同時分發靜態前端與後端 API」的全端架構。

```
使用者瀏覽器
    │
    └─► CloudFront (CDN)
            │
            ├─► /api/*  ──► API Gateway (HTTP API)
            │                   └─► Lambda (Python) ──► DynamoDB
            │
            └─► /*      ──► S3 (靜態網站 index.html)
```

### 使用到的 AWS 服務

| 服務 | 說明 |
|------|------|
| **S3** | 存放 Vue 3 打包後的靜態網站檔案 |
| **CloudFront** | CDN 入口，依 path behavior 路由到不同 origin |
| **API Gateway** | HTTP API，提供 `/api/*` 端點，處理 CORS |
| **Lambda** | Python，實作 Todo CRUD 業務邏輯 |
| **DynamoDB** | NoSQL 資料庫，儲存 Todo 資料 |
| **GitHub IAM Role** | 供 GitHub Actions CI/CD 使用的 OIDC IAM Role |

### API 端點（Todo）

| Method | Path | 說明 |
|--------|------|------|
| `GET` | `/api/todos?userId={userId}` | 列出指定使用者的所有 Todo |
| `POST` | `/api/todos` | 新增 Todo（Body：`{ "userId": "...", "message": "..." }`） |
| `DELETE` | `/api/todos/{userId}/{messageId}` | 刪除指定 Todo |

### 模組結構

```
vue_cdn/
├── root.hcl                  # 共用設定（region、tags、S3 backend）
├── envs/dev/
│   ├── s3/                   # 靜態網站 Bucket
│   ├── s3_policy/            # S3 Bucket Policy（限制僅允許 CloudFront 存取）
│   ├── cloud_front/          # CloudFront Distribution
│   ├── api_gateway/          # HTTP API
│   ├── lambda/               # Lambda
│   ├── dynamodb/             # DynamoDB
│   └── github_iam_role/      # GitHub Actions OIDC Role
└── modules/
    ├── s3/
    ├── s3_policy/
    ├── cloud_front/
    ├── api_gateway/
    ├── lambda/
    ├── dynamodb/
    └── github_iam_role/
```

詳細說明請參閱 [vue_cdn/README.md](vue_cdn/README.md)。

---

## Remote State Backend

在初次部署任一範例前，需要先建立 Terraform remote state 所需的 S3 bucket 與 DynamoDB lock table。

```bash
# 以 sqs_service 為例
cd version_backend/sqs_service
terraform init
terraform apply
```

| Backend 資源 | 值 |
|---|---|
| S3 Bucket | `sqs-service-state-dev` |
| DynamoDB Table | `sqs-service-lock-dev` |
| Region | `ap-northeast-1`（東京） |

---

## 部署流程

### 前置需求

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) >= 0.50
- AWS CLI 已設定具備足夠權限的 credentials

### 部署單一模組

```bash
# 例：部署 sqs_service 的 VPC
cd sqs_service/envs/dev/vpc
terragrunt init
terragrunt plan
terragrunt apply
```

### 部署整個環境（所有模組）

```bash
# 例：部署 sqs_service dev 環境下所有模組（依賴順序自動處理）
cd sqs_service/envs/dev
terragrunt run-all apply
```

### 銷毀資源

```bash
cd sqs_service/envs/dev
terragrunt run-all destroy
```

---

## 前端本機開發（vue_cdn）

```bash
cd vue_cdn/vue-cdn-project
npm install
npm run dev
```

前端路由：
- `/todos`：Todo 管理頁面
- `/error`：404 頁面（未匹配路由自動導向）

