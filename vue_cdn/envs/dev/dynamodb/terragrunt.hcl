terraform {
    source ="../../../modules/dynamodb"
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
  table_name     = "${local.root.locals.project_name}-${local.root.locals.tags.Env}-todolist-table"
  partition_key = "pk"
  sort_key      = "sk"

  tags = local.root.locals.tags
}
