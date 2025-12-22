variable "vpc_id" {
  description = "vpc id"
}

variable "project_name" {
  description = "project name"
}

variable "subnet_ids" {
  description = "subnet ids"
  type = list(string)
}

variable "security_group_id" {
  description = "security group id"
}

variable "tags" {
  description = "tags"
  type = map(string)
}