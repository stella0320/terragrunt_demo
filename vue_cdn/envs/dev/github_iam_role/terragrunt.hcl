terraform {
    source ="../../../modules/github_iam_role"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(
    find_in_parent_folders("root.hcl")
  )
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    bucket_id = "bucket_id"
    bucket_regional_domain_name = "bucket_regional_domain_name"
  } 
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}


# -------------------------------------------------
# Inputs
# -------------------------------------------------
inputs = {
  github_org = "stella0320"
  github_repo = "terragrunt_demo"
  github_branch = "api_gateway"
  s3_bucket_name = dependency.s3.outputs.bucket_id
} 