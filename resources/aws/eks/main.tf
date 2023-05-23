data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_iam_role.arn

  version = var.cluster_version
  vpc_config {
    subnet_ids              = var.public_subnet_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = true
    security_group_ids = [
    var.cluster_security_groups_id]
  }

  // valid types are "api","audit", "controllerManager","scheduler","authenticator"
  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = merge({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "Cluster-name"                              = var.cluster_name
  }, var.tags)


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.eks_cw_log_group
  ]
}

data "template_file" "config" {
  template = file("${path.module}/../../../templates/kube_config.tpl")
  vars = {
    certificate_data = aws_eks_cluster.main.certificate_authority[0].data
    cluster_endpoint = aws_eks_cluster.main.endpoint
    aws_region       = data.aws_region.current.name
    cluster_name     = var.cluster_name
    account_id       = data.aws_caller_identity.current.account_id
  }
  depends_on = [
  aws_eks_cluster.main]
}

resource "local_file" "config" {
  content    = data.template_file.config.rendered
  filename   = "${path.module}/${var.cluster_name}_config"
  depends_on = [aws_eks_cluster.main]
  //  filename = pathexpand("../${path.cwd}/${var.cluster_name}-config")
}

/*data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    aws_region                = data.aws_region.current.name
    eks_cluster_name          = var.cluster_name
    eks_endpoint              = aws_eks_cluster.main.endpoint
    eks_certificate_authority = aws_eks_cluster.main.certificate_authority
    vpc_name                  = var.vpc_name
    log_group_name            = var.cluster_name
  }
}*/


