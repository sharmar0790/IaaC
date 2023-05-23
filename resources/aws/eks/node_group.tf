resource "aws_eks_node_group" "public_subnet_node_group" {
  count           = var.create_node_group && length(var.public_subnet_ids) > 0 ? length(var.public_subnet_node_groups) : 0
  cluster_name    = var.cluster_name
  node_group_name = var.public_subnet_node_groups[count.index].node_group_name
  node_role_arn   = lookup(var.public_subnet_node_groups[count.index], "node_role_arn", aws_iam_role.eks_node_group.arn)
  subnet_ids      = var.public_subnet_ids

  dynamic "scaling_config" {
    for_each = length(keys(lookup(var.public_subnet_node_groups[count.index], "scaling_config", {}))) == 0 ? [] : [
    lookup(var.public_subnet_node_groups[count.index], "scaling_config", {})]
    content {
      desired_size = scaling_config.value["desired_size"]
      max_size     = scaling_config.value["max_size"]
      min_size     = scaling_config.value["min_size"]
    }
  }
  //Valid Values: ON_DEMAND | SPOT
  capacity_type = try(var.public_subnet_node_groups[count.index].capacity_type, null)
  ami_type      = try(var.public_subnet_node_groups[count.index].ami_type, null)
  disk_size     = try(var.public_subnet_node_groups[count.index].disk_size, null)
  //Valid Values: AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 |
  // BOTTLEROCKET_x86_64 | BOTTLEROCKET_ARM_64_NVIDIA | BOTTLEROCKET_x86_64_NVIDIA |
  // WINDOWS_CORE_2019_x86_64 |
  // WINDOWS_FULL_2019_x86_64 | WINDOWS_CORE_2022_x86_64 | WINDOWS_FULL_2022_x86_64
  instance_types       = try(var.public_subnet_node_groups[count.index].instance_types, null)
  force_update_version = try(var.public_subnet_node_groups[count.index].force_update_version, null)
  labels               = try(var.public_subnet_node_groups[count.index].labels, null)
  release_version      = try(var.public_subnet_node_groups[count.index].release_version, null)

  dynamic "taint" {
    for_each = length(keys(lookup(var.public_subnet_node_groups[count.index], "taint", {}))) == 0 ? [] : [
    lookup(var.public_subnet_node_groups[count.index], "taint", {})]
    content {
      key   = taint.value["key"]
      value = taint.value["value"]
      // Accepted effect Value NO_SCHEDULE, NO_EXECUTE, PREFER_NO_SCHEDULE
      effect = taint.value["effect"]
    }
  }

  tags = merge({
    Name = "Public-NG-${var.private_subnet_node_groups[count.index].node_group_name}"
  }, try(var.public_subnet_node_groups[count.index].additional_tags, null), var.tags)

  dynamic "update_config" {
    for_each = length(keys(lookup(var.public_subnet_node_groups[count.index], "update_config", {}))) == 0 ? [] : [
    lookup(var.public_subnet_node_groups[count.index], "update_config", {})]
    content {
      max_unavailable = update_config.value["max_unavailable"]
    }
  }

  remote_access {
    ec2_ssh_key = lookup(var.public_subnet_node_groups[count.index], "ec2_ssh_key", null)
    //try(var.public_subnet_node_groups[count.index].ec2_ssh_key, null)
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
    create_before_destroy = true
    /*ignore_changes = [
    scaling_config[0].desired_size]*/
    prevent_destroy = false
  }
}

resource "aws_eks_node_group" "private_subnet_node_group" {
  count           = var.create_node_group && length(var.private_subnet_ids) > 0 ? length(var.private_subnet_node_groups) : 0
  cluster_name    = var.cluster_name
  node_group_name = var.private_subnet_node_groups[count.index].node_group_name
  node_role_arn   = lookup(var.private_subnet_node_groups[count.index], "node_role_arn", aws_iam_role.eks_node_group.arn)
  subnet_ids      = var.private_subnet_ids

  dynamic "scaling_config" {
    for_each = length(keys(lookup(var.private_subnet_node_groups[count.index], "scaling_config", {}))) == 0 ? [] : [
    lookup(var.private_subnet_node_groups[count.index], "scaling_config", {})]
    content {
      desired_size = scaling_config.value["desired_size"]
      max_size     = scaling_config.value["max_size"]
      min_size     = scaling_config.value["min_size"]
    }

  }
  //Valid Values: ON_DEMAND | SPOT
  capacity_type = try(var.private_subnet_node_groups[count.index].capacity_type, null)
  ami_type      = try(var.private_subnet_node_groups[count.index].ami_type, null)
  disk_size     = try(var.private_subnet_node_groups[count.index].disk_size, null)
  //Valid Values: AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 |
  // BOTTLEROCKET_x86_64 | BOTTLEROCKET_ARM_64_NVIDIA | BOTTLEROCKET_x86_64_NVIDIA |
  // WINDOWS_CORE_2019_x86_64 |
  // WINDOWS_FULL_2019_x86_64 | WINDOWS_CORE_2022_x86_64 | WINDOWS_FULL_2022_x86_64
  instance_types       = try(var.private_subnet_node_groups[count.index].instance_types, null)
  force_update_version = try(var.private_subnet_node_groups[count.index].force_update_version, null)
  labels               = try(var.private_subnet_node_groups[count.index].labels, null)
  release_version      = try(var.private_subnet_node_groups[count.index].release_version, null)

  dynamic "taint" {
    for_each = length(keys(lookup(var.private_subnet_node_groups[count.index], "taint", {}))) == 0 ? [] : [
    lookup(var.private_subnet_node_groups[count.index], "taint", {})]
    content {
      key   = taint.value["key"]
      value = taint.value["value"]
      // Accepted effect Value NO_SCHEDULE, NO_EXECUTE, PREFER_NO_SCHEDULE
      effect = taint.value["effect"]
    }
  }

  tags = merge({
    Name = "Private-NG-${var.private_subnet_node_groups[count.index].node_group_name}"
  }, try(var.private_subnet_node_groups[count.index].additional_tags, null), var.tags)

  dynamic "update_config" {
    for_each = length(keys(lookup(var.private_subnet_node_groups[count.index], "update_config", {}))) == 0 ? [] : [
    lookup(var.private_subnet_node_groups[count.index], "update_config", {})]
    content {
      max_unavailable = update_config.value["max_unavailable"]
    }
  }

//  remote_access {
//    ec2_ssh_key = try(var.private_subnet_node_groups[count.index].ec2_ssh_key, null)
//  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.main
  ]

  lifecycle {
    create_before_destroy = true
    //    ignore_changes = [
    //    scaling_config[0].desired_size]
    prevent_destroy = false
  }
}
