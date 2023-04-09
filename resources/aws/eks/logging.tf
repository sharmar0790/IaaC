resource "aws_cloudwatch_log_group" "eks_cw_log_group" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cw_logs_retention_in_days

  # ... potentially other configuration ...
}