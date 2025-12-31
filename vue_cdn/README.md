# vue_cdn 專案介紹（大綱）

這個資料夾是一個示範「前端透過 CDN 呼叫 S3 index.html」、「前端透過 CDN 呼叫 API Gateway，再串接 Lambda + DynamoDB」的完整專案骨架，包含基礎的 IaC（Terragrunt/Terraform）與前端 Vue 範例。

## 使用到的服務（AWS）
- **Amazon S3**：存放前端打包後的靜態網站檔案，作為 CloudFront 的靜態內容 origin。
- **Amazon CloudFront**：CDN 入口；將靜態資源快取到邊緣節點，並依 path behavior（例如 `/api/*`）轉發到不同 origin。
- **Amazon API Gateway (HTTP API)**：對外提供 `/api/...` HTTP 端點，負責路由與（可選）CORS、授權等。
- **AWS Lambda**：執行後端業務邏輯（Todo 的查詢/新增/刪除），由 API Gateway 觸發。
- **Amazon DynamoDB**：NoSQL 資料庫，儲存 Todo 資料（以 `pk/sk` 等欄位做查詢與刪除）。

## 架構概覽
- **前端**：`vue-cdn-project/`（Vue 3 + Vite）提供 Todo UI
- **CDN**：CloudFront
  - 一個 origin 放前端靜態檔（S3）
  - 一個 origin 轉發後端 API（API Gateway）
  - 透過 behavior（例如 `/api/*`）將 API 路徑導到 API Gateway
- **後端**：API Gateway（HTTP API）→ Lambda（Python）→ DynamoDB

## 目錄結構
- `envs/`：環境層（dev 等）Terragrunt 組裝與依賴
  - `envs/dev/`：dev 環境的各模組 terragrunt.hcl
- `modules/`：Terraform modules（可重用）
  - `modules/lambda/`：Lambda function 與相關資源
  - `modules/api_gateway/`：HTTP API、routes/integration、CORS 等
  - `modules/cloud_front/`：CloudFront distribution、origins/behaviors
  - `modules/s3/`：靜態網站 bucket（若專案有使用）
  - `modules/dynamodb/`：Todo 資料表（若專案有使用）
- `vue-cdn-project/`：前端專案（Vue 3 + Vite）
- `root.hcl`：共用 Terragrunt 設定（tags、region、backend 等）

## API（Todo）
- **List todos**：`GET /dev/api/todos?userId=u001`
- **Create todo**：`POST /dev/api/todos`（JSON：`{ "userId": "...", "message": "..." }`）
- **Delete todo**：`DELETE /dev/api/todos/{userId}/{messageId}`

## 前端路由（Vue Router）
- `/todos`：Todo 畫面（`src/components/Todos.vue`）
- `/error`：404 畫面（`src/components/ErrorPage.vue`），未匹配路由會 redirect 到 `/error`

## 本機開發（前端）
```bash
cd vue-cdn-project
npm install
npm run dev
```
## 本機 IaC
```bash
terragrunt init
terragrunt plan
terragrunt apply
```
## 部署與 IaC（概念流程）
> 實際指令與順序依你的 `envs/dev/*` 組裝方式為準。

1. 建立基礎資源（例如 DynamoDB、Lambda、S3）
2. 建立 API Gateway routes/integration（HTTP API）
3. 建立 CloudFront（S3 + API Gateway origins，設定 `/api/*` behavior）
4. 驗證：
   - CloudFront 靜態網站可開啟 S3 index.html : https://d2tmmqwl4h1z66.cloudfront.net/todos
   - `/api/...` 透過 CloudFront 可打到 API Gateway/Lambda
