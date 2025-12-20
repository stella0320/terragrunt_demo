variable "project_name" {
  description = "project name"
}
variable "vpc_id" {
  description = "VPC ID"
}

variable "private_route_table_ids" {
  description = "Private route table IDs"
  type        = list(string)
}

variable "tags" {
  type = map(string)
}