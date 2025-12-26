terraform {
  source = "../../../modules/sqs"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(
    find_in_parent_folders("root.hcl")
  )
}

inputs = {
  queue_name = "customer_queue"
  tags = local.root.locals.tags
}