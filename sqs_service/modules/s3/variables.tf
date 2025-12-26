variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

# -----------------------------
# Public access block
# -----------------------------
variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

# Optional: only create the bucket policy denying access unless via this VPC endpoint
variable "allowed_vpce_id" {
  description = "When set (e.g. vpce-0123456789abcdef0) create a bucket policy that denies access unless requests come via this VPC Endpoint. Leave empty to skip creating the policy."
  type        = string
  default     = ""
}