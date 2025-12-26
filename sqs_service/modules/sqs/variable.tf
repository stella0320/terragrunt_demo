variable "queue_name" {
  description = "queue name"
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}
