
terraform {
    source ="../../../modules/lambda"
}


include "root" {
  path = find_in_parent_folders("root.hcl")
}

# -------------------------------------------------
# Dependencies
# -------------------------------------------------

# VPC (private subnets + security group)
dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnet_ids = ["mock-subnet"]
    lambda_sg_id       = "mock-sg"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

# S3 bucket
dependency "s3" {
  config_path = "../s3"

  mock_outputs = {
    bucket_name = "mock-bucket-name"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

dependency "sqs" {
  config_path = "../sqs"
  mock_outputs = {
    sqs_queue_name = "mock_quene_name",
    sqs_queue_url = "mock_queue_url"
  }
  
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

# -------------------------------------------------
# Inputs
# -------------------------------------------------
inputs = {
  function_name = "s3-endpoint-verify-lambda"

  # 從 VPC module 取得 private subnet
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  # Lambda 使用的 security group
  security_group_id = dependency.vpc.outputs.lambda_sg_id

  # 要驗證的 S3 bucket
  bucket_name = dependency.s3.outputs.bucket_name

  sqs_queue_name = dependency.sqs.outputs.sqs_queue_name
  sqs_queue_url = dependency.sqs.outputs.sqs_queue_url
  # Tags 統一來自 root.hcl
  tags = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.tags
}