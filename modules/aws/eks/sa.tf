# Datasource: AWS Partition
# Use this data source to lookup information about the current AWS partition in which Terraform is working
data "aws_partition" "current" {}

data "tls_certificate" "example" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "connect_provider" {
  client_id_list = [
  "sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = data.tls_certificate.example.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.example.url
  tags            = var.tags
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
    "sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.connect_provider.url, "https://", "")}:sub"
      values = [
      "system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [
      aws_iam_openid_connect_provider.connect_provider.arn]
      type = "Federated"
    }
  }
}

resource "aws_iam_role" "example" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = "${var.cluster_name}-iam-assume-role-policy"
}
