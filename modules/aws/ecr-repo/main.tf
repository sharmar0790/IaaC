resource "aws_ecr_repository" "main" {
  name                 = "${var.project_family}/${var.environment}/${var.name}"
  image_tag_mutability = var.ecr_image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }

  tags = merge(var.tags, var.additional_tags)
}

resource "aws_ecr_lifecycle_policy" "repo" {
  count      = var.lifecycle_policy != null && var.lifecycle_policy != "" ? 1 : 0
  repository = aws_ecr_repository.main.name
  //  policy = var.lifecycle_policy == null ? jsonencode(local.default_lifecycle_policy).rules : var.lifecycle_policy
  policy = var.lifecycle_policy != null && var.lifecycle_policy != "" ? jsonencode(var.lifecycle_policy) : jsonencode(local.default_lifecycle_policy)
}

resource "aws_ecr_repository_policy" "repo" {
  repository = aws_ecr_repository.main.name
  policy = jsonencode({
    Statement = [
      {
        Sid = "AllowCrossAccountAccess"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
        ]
        Effect = "Allow"
        Principal = {
          AWS = flatten([
            data.aws_caller_identity.current.account_id,
            var.trusted_accounts,
          ])
        }
    }]
    Version = "2012-10-17"
  })
}

//security/policy
resource "aws_iam_policy" "read" {
  name        = format("%s-ecr-read", var.name)
  description = format("Allow to read images from the ECR")
  path        = "/"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages",
        ]
        Effect = "Allow"
        Resource = [
        aws_ecr_repository.main.arn]
    }]
    Version = "2012-10-17"
  })

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_policy" "write" {
  name        = format("%s-ecr-write", var.name)
  description = format("Allow to push and write images to the ECR")
  path        = "/"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
        ]
        Effect = "Allow"
        Resource = [
        aws_ecr_repository.main.arn]
    }]
    Version = "2012-10-17"
  })

  lifecycle {
    create_before_destroy = false
  }
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "ecr_iam_policy_document" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type = "*"
      identifiers = [
      "*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.main.name
  policy     = data.aws_iam_policy_document.ecr_iam_policy_document.json

  depends_on = [
  aws_ecr_repository.main]
}
