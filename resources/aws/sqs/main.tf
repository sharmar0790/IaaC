resource "aws_sqs_queue" "this" {
  count                     = var.create_sqs_queue ? 1 : 0
  name                      = var.sqs_name
  delay_seconds             = try(var.delay_seconds, null)
  max_message_size          = try(var.queue_max_message_size, null)
  message_retention_seconds = try(var.queue_message_retention_seconds, 300)
  // 86400
  receive_wait_time_seconds = try(var.queue_receive_wait_time_seconds, null)
  // 10

  fifo_queue = try(var.fifo_queue, null)
  //true
  content_based_deduplication = try(var.content_based_deduplication, null)
  //true
  deduplication_scope = try(var.deduplication_scope, null)
  //"messageGroup"
  fifo_throughput_limit = try(var.fifo_throughput_limit, null)
  //"perMessageGroupId"


  sqs_managed_sse_enabled           = try(var.sqs_managed_sse_enabled, null)
  kms_master_key_id                 = try(var.queue_kms_master_key_id, null)
  kms_data_key_reuse_period_seconds = try(var.queue_kms_data_key_reuse_period_seconds, null)


  redrive_policy = jsonencode({
    deadLetterTargetArn = try(var.queue_dead_letter_target_arn, null)
    // aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount = 4
  })

  tags = var.tags
}
