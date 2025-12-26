output "sqs_queue_name" {
  value = aws_sqs_queue.main.name
}

output "sqs_queue_url" {
  value = aws_sqs_queue.main.url
}