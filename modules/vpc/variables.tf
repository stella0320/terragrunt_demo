variable "vpc_name" {
  description = "name of vpc"
}
variable "vpc_cidr" {
  description = "VPC IP range"
}

variable "azs" {
  type = list(string)
  description = "List of availability zones"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "private subnet CIDR blocks"
}

variable "tags" {
  type = map(string)
    description = "A map of tags to add to all resources"
}
