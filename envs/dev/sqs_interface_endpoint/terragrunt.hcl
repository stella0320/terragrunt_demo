terraform {
  source = "../../../modules/sqs_interface_endpoint"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(
    find_in_parent_folders("root.hcl")
  )
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id                   = "mock-vpc"
    private_route_table_ids  = ["mock-rtb"]
    lambda_sg_id = "lambda-sg-id"
    subnet_ids = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}


inputs = {
  project_name = local.root.locals.project_name

  vpc_id = dependency.vpc.outputs.vpc_id

  subnet_ids = [dependency.vpc.outputs.private_subnet_ids[1]]

  security_group_id = dependency.vpc.outputs.sqs_sg_id

  tags = {
    Environment = "dev"
  }

}
