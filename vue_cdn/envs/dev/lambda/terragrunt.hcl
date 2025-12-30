terraform {
    source ="../../../modules/lambda"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(
    find_in_parent_folders("root.hcl")
  )
}


dependency "dynamodb" {
  config_path = "../dynamodb"
  mock_outputs = {
    table_name = "table_name"
    table_arn = "table_arn"
  } 
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}
# -------------------------------------------------
# Inputs
# -------------------------------------------------
inputs = {
  function_name = "todolist"
  dynamodb_table_name = dependency.dynamodb.outputs.table_name
  project_name = local.root.locals.project_name
  tags = local.root.locals.tags
} 