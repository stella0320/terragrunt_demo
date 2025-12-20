terraform {
  source = "../../../modules/s3_gateway_endpoint"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# -----------------------------
# Dependency: VPC
# -----------------------------
dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id                   = "mock-vpc"
    private_route_table_ids  = ["mock-rtb"]
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

# -----------------------------
# Inputs
# -----------------------------
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  private_route_table_ids = dependency.vpc.outputs.private_route_table_ids

  project_name = "terragrunt-demo"
  tags = {
    Project = "terragrunt-demo"
    Env     = "dev"
  }
}


