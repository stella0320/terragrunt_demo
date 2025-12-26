terraform {
    source ="../../../modules/s3_policy"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(
    find_in_parent_folders("root.hcl")
  )
}

dependency "cloud_front" {
  
  config_path = "../cloud_front"
  mock_outputs = {
    cloudfront_arn = "cloudfront_arn"
  } 
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    bucket_id = "bucket_id"
    bucket_regional_domain_name = "bucket_regional_domain_name"
    s3_bucket_arn = "s3_bucket_arn"
  } 
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
# -------------------------------------------------
# Inputs
# -------------------------------------------------
inputs = {
  bucket_id = dependency.s3.outputs.bucket_id
  s3_bucket_arn = dependency.s3.outputs.s3_bucket_arn
  cloudfront_arn = dependency.cloud_front.outputs.cloudfront_arn
} 