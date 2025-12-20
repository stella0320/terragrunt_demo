output "vpc_endpint_id" {
  description = "ID of the S3 Gateway Endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "vpc_endpint_arn" {
  description = "ARN of the S3 Gateway Endpoint"
  value = aws_vpc_endpoint.s3.arn
}