resource "aws_iam_role" "this" {
  count = var.create_irsa ? 1 : 0

  name        = var.iam_role_name
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy = var.iam_role_assume_role_policy
  //data.aws_iam_policy_document.iam_role_assume_role[0].json
  max_session_duration  = var.iam_role_max_session_duration
  permissions_boundary  = var.iam_role_permissions_boundary_arn
  force_detach_policies = true

  tags = merge(var.tags, var.iam_role_tags)
}

/*resource "aws_iam_role" "irsa" {
  count = local.create_irsa ? 1 : 0

  name = var.irsa_use_name_prefix ? null : local.irsa_name
  path        = var.irsa_path
  description = var.irsa_description

  assume_role_policy    = data.aws_iam_policy_document.irsa_assume_role[0].json
  max_session_duration  = var.irsa_max_session_duration
  permissions_boundary  = var.irsa_permissions_boundary_arn
  force_detach_policies = true

  tags = merge(var.tags, var.irsa_tags)
}*/
