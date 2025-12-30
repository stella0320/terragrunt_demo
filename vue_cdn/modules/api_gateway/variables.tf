variable "api_name" {
  type = string
}

variable "lambda_arn" {
  type = string
}

variable "lambda_name" {
  type = string
}

variable "stage_name" {
  type    = string
  default = "dev"
}

variable "cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}

variable "cors_allow_methods" {
  type    = list(string)
  default = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "cors_allow_headers" {
  type    = list(string)
  default = ["content-type"]
}

variable "tags" {
  type    = map(string)
  default = {}
}