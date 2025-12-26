terraform {
    source ="../../../modules/s3"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(
    find_in_parent_folders("root.hcl")
  )
}

# -------------------------------------------------
# Inputs
# -------------------------------------------------
inputs = {
  project_name = local.root.locals.project_name

  tags = local.root.locals.tags
  #distribution_arn = dependency.cloud_front.outputs.distribution_arn
} 