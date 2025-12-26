variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
  
}

variable "bucket_name" {
  description = "s3 bucket name"
}

variable "subnet_ids" {
  description = "subnet ids"
  type = list(string)
}

variable "security_group_id" {
  description = "security group id"
}

variable "sqs_queue_name" {
  description = "queue name"
}

variable "sqs_queue_url" {
  description = "sqs queue name"
}