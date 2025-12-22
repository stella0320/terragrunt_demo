
terraform {
  source = "../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  vpc_name = "terragrunt-demo"
  vpc_cidr = "10.0.0.0/16"

  azs = [
    "ap-northeast-1a",
    "ap-northeast-1c"
  ]

  private_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]

  tags = {
    Project = "terragrunt-demo"
    Env     = "dev"
  }
}
