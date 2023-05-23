resource "aws_iam_role_policy_attachment" "irsa" {
  count = var.create_iam_policy ? 1 : 0

  role = var.iam_role
  //aws_iam_role.irsa[0].name
  policy_arn = var.policy_arn
  // aws_iam_policy.this[0].arn // aws_iam_policy.irsa[0].arn
}
