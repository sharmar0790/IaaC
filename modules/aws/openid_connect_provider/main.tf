# Datasource: AWS Partition
# Use this data source to lookup information about the current AWS partition in which Terraform is working
data "aws_partition" "current" {}

resource "aws_iam_openid_connect_provider" "default" {
  url = var.eks_cluster_identity
  client_id_list = [
  "sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = var.thumbprint_list
  tags            = var.tags
}
