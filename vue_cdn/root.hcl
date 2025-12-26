locals {
  region = "ap-northeast-1"

  tags = {
    Project = "vue-cdn-demo"
    Env     = "dev"
  }

  project_name = "vue-cdn-demo"
}



# -----------------------------
# Terraform Remote State
# -----------------------------
remote_state {
  backend = "s3"
  config = {
    bucket         = "sqs-service-state-dev"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "sqs-service-lock-dev"
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


