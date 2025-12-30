variable "table_name" {
  type = string
}

variable "partition_key" {
  type    = string
  default = "pk"
}

variable "sort_key" {
  type    = string
  default = "sk"
}

variable "tags" {
  type    = map(string)
  default = {}
}
