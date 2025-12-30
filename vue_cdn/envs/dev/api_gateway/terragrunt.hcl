terraform {
    source ="../../../modules/api_gateway"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(
    find_in_parent_folders("root.hcl")
  )
}

dependency "lambda" {
  config_path = "../lambda"
   mock_outputs = {
    lambda_arn = "lambda_arn"
    lambda_name = "lambda_name"
  } 
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}


# -------------------------------------------------
# Inputs
# -------------------------------------------------
inputs = {
  api_name = "todolist-${local.root.locals.tags.Env}-api"

  lambda_arn  = dependency.lambda.outputs.lambda_arn
  lambda_name = dependency.lambda.outputs.lambda_name
  cors_allow_origins = ["*"]

  tags = local.root.locals.tags
} 