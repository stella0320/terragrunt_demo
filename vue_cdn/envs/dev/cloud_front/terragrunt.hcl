terraform {
    source ="../../../modules/cloud_front"
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


inputs = {
  
  project_name = local.root.locals.project_name
  tags = local.root.locals.tags
  bucket_domain_name = dependency.s3.outputs.bucket_regional_domain_name
}