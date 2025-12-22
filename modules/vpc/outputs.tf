output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = aws_route_table.this[*].id
}

output "lambda_sg_id" {
  description = "Lambda security group ID"
  value       = aws_security_group.lambda.id
}

output "sqs_sg_id" {
  description = "sqs security group id"
  value = "${aws_security_group.sqs_endpoint.id}"
}