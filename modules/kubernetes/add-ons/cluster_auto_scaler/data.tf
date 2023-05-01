data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_eks_cluster" "current" {
  name = var.eks_cluster_name
}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = ""
    effect = "Allow"
    resources = [
    "*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"
    resources = [
    "*"]

    actions = [
      "ec2:DescribeInstanceTypes",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${data.aws_eks_cluster.current.name}"
      values = [
      "owned"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"
    resources = [
    "arn:${data.aws_partition.current.id}:autoscaling:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:autoScalingGroup:*"]

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${data.aws_eks_cluster.current.name}"
      values = [
      "owned"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"
    resources = [
    "arn:${data.aws_partition.current.id}:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:nodegroup/${data.aws_eks_cluster.current.name}/*"]

    actions = [
      "eks:DescribeNodegroup",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${data.aws_eks_cluster.current.name}"
      values = [
      "owned"]
    }
  }
}
