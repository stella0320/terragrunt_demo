variable "project_name" {
  description = "project name"
}

variable "tags" {
  description = "tags"
  type = map(string)
}

variable "bucket_domain_name" {
  description = "s3 domain name"
}

variable "api_gateway_domain_name" {
  description = "domain name for api gateway"
}

variable "api_gateway_stage_name" {
  description = "stage name"
}