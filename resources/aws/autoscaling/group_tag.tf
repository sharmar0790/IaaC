resource "aws_autoscaling_group_tag" "main" {
  for_each               = var.asg_tags
  autoscaling_group_name = try(var.eks_managed_node_groups_autoscaling_group_names, null)

  tag {
    key                 = each.key
    propagate_at_launch = true
    value               = each.value
  }
}
