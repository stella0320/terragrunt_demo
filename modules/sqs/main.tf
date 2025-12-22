resource "aws_sqs_queue" "dlq" {
  name = "${var.queue_name}-dlq"
  sqs_managed_sse_enabled = true

  tags = merge(
    {
      Name = "${var.queue_name}-dlq"
    },
    var.tags,
  )
}

resource "aws_sqs_queue" "main" {
  name = var.queue_name


  # ---- 基本設定 ----
  visibility_timeout_seconds = 60
  receive_wait_time_seconds  = 10
  message_retention_seconds  = 345600 # 4 days
  delay_seconds              = 0
  max_message_size           = 262144

  # ---- 加密 ----
  sqs_managed_sse_enabled = true

  # ---- Dead Letter Queue ----
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
  tags = merge(
    {
      Name = var.queue_name
    },
    var.tags,
  )
}

