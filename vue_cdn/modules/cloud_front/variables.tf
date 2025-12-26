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