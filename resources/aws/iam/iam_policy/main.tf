resource "aws_iam_policy" "this" {
  count = var.create_iam_policy ? 1 : 0

  name_prefix = "${var.iam_policy_name}-"
  path        = var.iam_policy_path
  description = var.iam_policy_description
  policy      = var.iam_policy
  //  data.aws_iam_policy_document.irsa[0].json

  tags = var.tags
}


