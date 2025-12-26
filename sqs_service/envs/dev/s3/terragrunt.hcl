terraform {
    source ="../../../modules/s3"
}


include "root" {
  path = find_in_parent_folders("root.hcl")
}

# -------------------------------------------------
# Dependencies
# -------------------------------------------------

# s3 gateway endpoint
dependency "s3_gateway_endpont" {
  config_path = "../s3_gateway_endpoint"

  mock_outputs = {
    vpc_endpint_id = "vpce-id-xxxxx"
    vpc_endpint_arn       = "vpce-arn-xxx"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}


# -------------------------------------------------
# Inputs
# -------------------------------------------------
inputs = {
  bucket_name = "sqs-service-demo"

  enable_versioning = false

  # 安全預設：阻擋所有 public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  allowed_vpce_id = dependency.s3_gateway_endpont.outputs.vpc_endpint_id
  tags = {
    Project = "sqs-service-demo"
    Env     = "dev"
  }
}