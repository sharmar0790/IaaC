variable "create_sqs_queue" {
  default = false
  type    = bool
}

variable "sqs_name" {}

variable "delay_seconds" {
  type = number
}

variable "queue_max_message_size" {
  default = ""
}

variable "queue_message_retention_seconds" {
  default = ""
}

variable "queue_receive_wait_time_seconds" {}
variable "content_based_deduplication" {}
variable "deduplication_scope" {}
variable "fifo_throughput_limit" {}
variable "sqs_managed_sse_enabled" {}
variable "queue_kms_master_key_id" {}
variable "queue_kms_data_key_reuse_period_seconds" {}
variable "queue_dead_letter_target_arn" {}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "fifo_queue" {
  default = false
  type    = bool
}
