resource "aws_eks_node_group" "main" {
  cluster_name = var.cluster_name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn = aws_iam_role.eks-node-group.arn
  subnet_ids = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }
  //Valid Values: ON_DEMAND | SPOT
  capacity_type = var.capacity_type

  //Valid Values: AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 |
  // BOTTLEROCKET_x86_64 | BOTTLEROCKET_ARM_64_NVIDIA | BOTTLEROCKET_x86_64_NVIDIA |
  // WINDOWS_CORE_2019_x86_64 |
  // WINDOWS_FULL_2019_x86_64 | WINDOWS_CORE_2022_x86_64 | WINDOWS_FULL_2022_x86_64
  ami_type = var.ami_type
  disk_size = var.disk_size
  instance_types = var.instance_types
  force_update_version = var.force_update_version
  labels = var.labels
  release_version = var.release_version

  dynamic "taint" {
    for_each = var.kubernetes_taints
    content {
      key = taint.value["key"]
      value = taint.value["value"]
      // Accepted effect Value NO_SCHEDULE, NO_EXECUTE, PREFER_NO_SCHEDULE
      effect = taint.value["effect"]
    }
  }

  //  version = ""

  tags = var.tags

  update_config {
    max_unavailable = var.max_unavailable
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.main
  ]

  lifecycle {
    create_before_destroy = false
    ignore_changes = [
      scaling_config[0].desired_size]
    prevent_destroy = false
  }
}