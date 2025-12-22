locals {
  region = "ap-northeast-1"

  tags = {
    Project = "terragrunt-s3-demo"
    Env     = "dev"
  }

  project_name = "terragrunt-demo"
}



# -----------------------------
# Terraform Remote State
# -----------------------------
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-demo-state-dev"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "terragrunt-demo-lock-dev"
  }
}

terraform {
  extra_arguments "aws_region_for_backend" {
    commands = ["init", "plan", "apply","destroy"]

    env_vars = {
      AWS_REGION         = local.region
      AWS_DEFAULT_REGION = local.region
    }
  }
}

# -----------------------------
# Provider
# -----------------------------
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}


