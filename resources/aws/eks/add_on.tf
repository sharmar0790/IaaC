resource "aws_eks_addon" "main" {
  for_each     = var.eks_cluster_addons
  cluster_name = aws_eks_cluster.main.name
  addon_name   = each.key
  #e.g., previous version v1.8.7-eksbuild.2 and the new version is v1.8.7-eksbuild.3
  //Valid Values: OVERWRITE | NONE | PRESERVE
  resolve_conflicts    = try(each.value.resolve_conflicts, "PRESERVE")
  configuration_values = try(each.value.configuration_values, null)
  preserve             = try(each.value.preserve, true)
  //  service_account_role_arn = local.create_irsa ? module.irsa_addon[0].irsa_iam_role_arn : try(var.addon_config.service_account_role_arn, null)
  service_account_role_arn = try(each.value.service_account_role_arn, null)


  //  timeouts {
  //    create = try(each.value.timeouts.create, var.cluster_addons_timeouts.create, null)
  //    update = try(each.value.timeouts.update, var.cluster_addons_timeouts.update, null)
  //    delete = try(each.value.timeouts.delete, var.cluster_addons_timeouts.delete, null)
  //  }
}
