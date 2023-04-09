output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
  sensitive = true
}

output "eks_cluster_identity" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "eks-cluster-id" {
  value = aws_eks_cluster.main.id
}

output "ekscluster-arn" {
  value = aws_eks_cluster.main.arn
}

output "ekscluster-status" {
  value = aws_eks_cluster.main.status
}

output "ekscluster-vpc-config" {
  value = aws_eks_cluster.main.vpc_config
}

output "ekscluster-version" {
  value = aws_eks_cluster.main.version
}

output "ekscluster-platform-version" {
  value = aws_eks_cluster.main.platform_version
}

output "node_group_id" {
  value = aws_eks_node_group.main.id
}

output "node_group_arn" {
  value = aws_eks_node_group.main.arn
}

output "thumbprint_sha1_fingerprint" {
  value = data.tls_certificate.example.certificates[0].sha1_fingerprint
}

locals {
  aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", aws_iam_openid_connect_provider.connect_provider.arn), 1)
}

# Output: AWS IAM Open ID Connect Provider ARN
output "aws_iam_openid_connect_provider_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value = aws_iam_openid_connect_provider.connect_provider.arn
}

# Output: AWS IAM Open ID Connect Provider
output "aws_iam_openid_connect_provider_extract_from_arn" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
  value = local.aws_iam_oidc_connect_provider_extract_from_arn
}

