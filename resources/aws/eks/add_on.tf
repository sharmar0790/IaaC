resource "aws_eks_addon" "example" {
  for_each = var.eks_cluster_addons
  cluster_name = aws_eks_cluster.main.name
  addon_name = each.key
  //data.aws_eks_addon_version.this[each.key].version
  //  addon_version = try(each.value.version, "")
  #e.g., previous version v1.8.7-eksbuild.2 and the new version is v1.8.7-eksbuild.3
  //Valid Values: OVERWRITE | NONE | PRESERVE
  resolve_conflicts = try(each.value.resolve_conflicts, "PRESERVE")
  configuration_values = try(each.value.configuration_values, "")
  preserve = try(each.value.preserve, null)

  //  timeouts {
  //    create = try(each.value.timeouts.create, var.cluster_addons_timeouts.create, null)
  //    update = try(each.value.timeouts.update, var.cluster_addons_timeouts.update, null)
  //    delete = try(each.value.timeouts.delete, var.cluster_addons_timeouts.delete, null)
  //  }
}