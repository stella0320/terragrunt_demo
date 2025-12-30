variable "function_name" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "project_name" {
  
}