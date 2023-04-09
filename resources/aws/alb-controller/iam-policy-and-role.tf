data "aws_region" "current" {}
//data "aws_caller_identity" "current" {}


# Resource: Create AWS Load Balancer Controller IAM Policy
resource "aws_iam_policy" "lbc_iam_policy" {
  name = "${var.eks_cluster_name}-AWSLoadBalancerControllerIAMPolicy"
  path = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy = data.http.lbc_iam_policy.body
}


# Resource: Create IAM Role
resource "aws_iam_role" "lbc_iam_role" {
  name = "${var.eks_cluster_name}-lbc-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid = ""
        Principal = {
          //          Federated = var.aws_iam_openid_connect_provider_arn
          Federated = var.aws_iam_openid_connect_provider_arn
          //          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.region-code.amazonaws.com/id/${var.oidc_issuer}"

        }
        Condition = {
          /*StringEquals = {
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:aud" : "sts.amazonaws.com",
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
          StringEquals = {
            "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${var.oidc_issuer}:aud" : "sts.amazonaws.com",
            "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${var.oidc_issuer}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }*/
          StringEquals = {
            "${var.aws_iam_openid_connect_provider_extract_from_arn}:aud" : "sts.amazonaws.com",
            "${var.aws_iam_openid_connect_provider_extract_from_arn}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "AmazonEKSLoadBalancerControllerRole"
  }
}

# Associate Load Balanacer Controller IAM Policy to  IAM Role
resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.lbc_iam_policy.arn
  role = aws_iam_role.lbc_iam_role.name
}

