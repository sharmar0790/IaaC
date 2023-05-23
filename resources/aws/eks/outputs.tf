output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "kubeconfig-certificate-authority-data" {
  value     = aws_eks_cluster.main.certificate_authority[0].data
  sensitive = true
}

//output "kubeconfig-certificate-authority-data1" {
//  value = aws_eks_cluster.main.certificate_authority[0].
//  sensitive = true
//}

output "eks_cluster_identity" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "eks_cluster_auth_token" {
  value = aws_eks_cluster.main.certificate_authority[0].data
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

output "thumbprint_sha1_fingerprint" {
  value = data.tls_certificate.example.certificates[0].sha1_fingerprint
}

locals {
  aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", aws_iam_openid_connect_provider.connect_provider.arn), 1)
}

# Output: AWS IAM Open ID Connect Provider ARN
output "aws_iam_openid_connect_provider_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value       = aws_iam_openid_connect_provider.connect_provider.arn
}

# Output: AWS IAM Open ID Connect Provider
output "aws_iam_openid_connect_provider_extract_from_arn" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
  value       = local.aws_iam_oidc_connect_provider_extract_from_arn
}


data "aws_eks_cluster_auth" "kubernetes_token" {
  name = var.cluster_name
}

output "cluster_auth_token" {
  value = data.aws_eks_cluster_auth.kubernetes_token.token
}

output "node_security_group_id" {
  value = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

################################################################################
# EKS Managed Node Group
################################################################################

output "eks_managed_node_groups_autoscaling_group_names_public" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = try(flatten(aws_eks_node_group.public_subnet_node_group[*].resources[*].autoscaling_groups[*].name), [])
}

output "eks_managed_node_groups_names_public" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = try(flatten(aws_eks_node_group.public_subnet_node_group[*].arn), [])
}

output "eks_managed_node_groups_names_private" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = try(flatten(aws_eks_node_group.private_subnet_node_group[*].arn), [])
}

output "eks_managed_node_groups_autoscaling_group_names_private" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = try(flatten(aws_eks_node_group.private_subnet_node_group[*].resources[*].autoscaling_groups[*].name), [])
}

output "eks_managed_node_groups_node_role_arn_private" {
  value = try(flatten(aws_eks_node_group.private_subnet_node_group[*].node_role_arn), [])
}

output "config_file" {
  value = local_file.config.source
}

