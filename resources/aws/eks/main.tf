resource "aws_eks_cluster" "main" {
  name = var.cluster_name
  role_arn = aws_iam_role.eks_iam_role.arn

  version = var.cluster_version
  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_public_access = var.endpoint_public_access
    endpoint_private_access = true
    security_group_ids = [
      var.cluster_security_groups_id]
  }

  // valid types are "api","audit", "controllerManager","scheduler","authenticator"
  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = merge({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "Cluster-name" = var.cluster_name
  }, var.tags)


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.eks_cw_log_group
  ]
}


