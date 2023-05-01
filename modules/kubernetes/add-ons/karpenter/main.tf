data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  dns_suffix = data.aws_partition.current.dns_suffix
}

################################################################################
# IAM Role for Service Account (IRSA)
# This is used by the Karpenter controller
################################################################################

locals {
  create_irsa      = var.create && var.create_irsa
  irsa_name        = coalesce(var.irsa_name, "KarpenterIRSA-${var.eks_cluster_name}")
  irsa_policy_name = coalesce(var.irsa_policy_name, local.irsa_name)

  irsa_oidc_provider_url = replace(var.irsa_oidc_provider_arn, "/^(.*provider/)/", "")
}

data "aws_iam_policy_document" "irsa_assume_role" {
  count = local.create_irsa ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
    "sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
      var.irsa_oidc_provider_arn]
    }

    condition {
      test     = var.irsa_assume_role_condition_test
      variable = "${local.irsa_oidc_provider_url}:sub"
      values   = [for sa in var.irsa_namespace_service_accounts : "system:serviceaccount:${sa}"]
    }

    # https://aws.amazon.com/premiumsupport/knowledge-center/eks-troubleshoot-oidc-and-irsa/?nc1=h_ls
    condition {
      test     = var.irsa_assume_role_condition_test
      variable = "${local.irsa_oidc_provider_url}:aud"
      values = [
      "sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "irsa" {
  count = local.create_irsa ? 1 : 0

  name = var.irsa_use_name_prefix ? null : local.irsa_name
  //  name_prefix = var.irsa_use_name_prefix ? "${local.irsa_name}-" : null
  path        = var.irsa_path
  description = var.irsa_description

  assume_role_policy    = data.aws_iam_policy_document.irsa_assume_role[0].json
  max_session_duration  = var.irsa_max_session_duration
  permissions_boundary  = var.irsa_permissions_boundary_arn
  force_detach_policies = true

  tags = merge(var.tags, var.irsa_tags)
}

data "aws_iam_policy_document" "irsa" {
  count = local.create_irsa ? 1 : 0

  statement {
    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:CreateTags",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSpotPriceHistory",
      "pricing:GetProducts",
    ]

    resources = [
    "*"]
  }

  statement {
    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate",
    ]

    resources = [
    "*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${var.irsa_tag_key}"
      values = [
      var.eks_cluster_name]
    }
  }

  statement {
    actions = [
    "ec2:RunInstances"]
    resources = [
      "arn:${local.partition}:ec2:*:${local.account_id}:launch-template/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${var.irsa_tag_key}"
      values = [
      var.eks_cluster_name]
    }
  }

  statement {
    actions = [
    "ec2:RunInstances"]
    resources = [
      "arn:${local.partition}:ec2:*::image/*",
      "arn:${local.partition}:ec2:*:${local.account_id}:instance/*",
      "arn:${local.partition}:ec2:*:${local.account_id}:spot-instances-request/*",
      "arn:${local.partition}:ec2:*:${local.account_id}:security-group/*",
      "arn:${local.partition}:ec2:*:${local.account_id}:volume/*",
      "arn:${local.partition}:ec2:*:${local.account_id}:network-interface/*",
      "arn:${local.partition}:ec2:*:${coalesce(var.irsa_subnet_account_id, local.account_id)}:subnet/*",
    ]
  }

  statement {
    actions = [
    "ssm:GetParameter"]
    resources = var.irsa_ssm_parameter_arns
  }

  statement {
    actions = [
    "eks:DescribeCluster"]
    resources = [
    "arn:${local.partition}:eks:*:${local.account_id}:cluster/${var.eks_cluster_name}"]
  }

  statement {
    actions = [
    "iam:PassRole"]
    resources = [
    var.create_iam_role ? aws_iam_role.this[0].arn : var.iam_role_arn]
  }

  dynamic "statement" {
    for_each = local.enable_spot_termination ? [
    1] : []

    content {
      actions = [
        "sqs:DeleteMessage",
        "sqs:GetQueueUrl",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage",
      ]
      resources = [
      aws_sqs_queue.this[0].arn]
    }
  }
}

resource "aws_iam_policy" "irsa" {
  count = local.create_irsa ? 1 : 0

  name_prefix = "${local.irsa_policy_name}-"
  path        = var.irsa_path
  description = var.irsa_description
  policy      = data.aws_iam_policy_document.irsa[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "irsa" {
  count = local.create_irsa ? 1 : 0

  role       = aws_iam_role.irsa[0].name
  policy_arn = aws_iam_policy.irsa[0].arn
}

resource "aws_iam_role_policy_attachment" "irsa_additional" {
  for_each = { for k, v in var.policies : k => v if local.create_irsa }

  role       = aws_iam_role.irsa[0].name
  policy_arn = each.value
}

################################################################################
# Node Termination Queue
################################################################################

locals {
  enable_spot_termination = var.create && var.enable_spot_termination

  queue_name = coalesce(var.queue_name, "Karpenter-${var.eks_cluster_name}")
}

resource "aws_sqs_queue" "this" {
  count = local.enable_spot_termination ? 1 : 0

  name                              = local.queue_name
  message_retention_seconds         = 300
  sqs_managed_sse_enabled           = var.queue_managed_sse_enabled ? var.queue_managed_sse_enabled : null
  kms_master_key_id                 = var.queue_kms_master_key_id
  kms_data_key_reuse_period_seconds = var.queue_kms_data_key_reuse_period_seconds

  tags = var.tags
}

data "aws_iam_policy_document" "queue" {
  count = local.enable_spot_termination ? 1 : 0

  statement {
    sid = "SqsWrite"
    actions = [
    "sqs:SendMessage"]
    resources = [
    aws_sqs_queue.this[0].arn]

    principals {
      type = "Service"
      identifiers = [
        "events.${local.dns_suffix}",
        "sqs.${local.dns_suffix}",
      ]
    }

  }
}

resource "aws_sqs_queue_policy" "this" {
  count = local.enable_spot_termination ? 1 : 0

  queue_url = aws_sqs_queue.this[0].url
  policy    = data.aws_iam_policy_document.queue[0].json
}

################################################################################
# Node Termination Event Rules
################################################################################

locals {
  events = {
    health_event = {
      name        = "HealthEvent"
      description = "Karpenter interrupt - AWS health event"
      event_pattern = {
        source = [
        "aws.health"]
        detail-type = [
        "AWS Health Event"]
      }
    }
    spot_interupt = {
      name        = "SpotInterrupt"
      description = "Karpenter interrupt - EC2 spot instance interruption warning"
      event_pattern = {
        source = [
        "aws.ec2"]
        detail-type = [
        "EC2 Spot Instance Interruption Warning"]
      }
    }
    instance_rebalance = {
      name        = "InstanceRebalance"
      description = "Karpenter interrupt - EC2 instance rebalance recommendation"
      event_pattern = {
        source = [
        "aws.ec2"]
        detail-type = [
        "EC2 Instance Rebalance Recommendation"]
      }
    }
    instance_state_change = {
      name        = "InstanceStateChange"
      description = "Karpenter interrupt - EC2 instance state-change notification"
      event_pattern = {
        source = [
        "aws.ec2"]
        detail-type = [
        "EC2 Instance State-change Notification"]
      }
    }
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for k, v in local.events : k => v if local.enable_spot_termination }

  name_prefix   = "${var.rule_name_prefix}${each.value.name}-"
  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)

  tags = merge(
    {
      "ClusterName" : var.eks_cluster_name
    },
    var.tags,
  )
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = { for k, v in local.events : k => v if local.enable_spot_termination }

  rule      = aws_cloudwatch_event_rule.this[each.key].name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = aws_sqs_queue.this[0].arn
}

################################################################################
# Node IAM Role
# This is used by the nodes launched by Karpenter
################################################################################

locals {
  create_iam_role = var.create && var.create_iam_role

  iam_role_name          = coalesce(var.iam_role_name, "Karpenter-${var.eks_cluster_name}")
  iam_role_policy_prefix = "arn:${local.partition}:iam::aws:policy"
  cni_policy             = var.cluster_ip_family == "ipv6" ? "${local.iam_role_policy_prefix}/AmazonEKS_CNI_IPv6_Policy" : "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy"
}

data "aws_iam_policy_document" "assume_role" {
  count = local.create_iam_role ? 1 : 0

  statement {
    sid = "EKSNodeAssumeRole"
    actions = [
    "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
      "ec2.${local.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.create_iam_role ? 1 : 0

  name = var.iam_role_use_name_prefix ? null : local.iam_role_name
  //  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  max_session_duration  = var.iam_role_max_session_duration
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = merge(var.tags, var.iam_role_tags)
}

# Policies attached ref https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in toset(compact([
    "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly",
    var.iam_role_attach_cni_policy ? local.cni_policy : "",
  ])) : k => v if local.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.iam_role_additional_policies : k => v if local.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

################################################################################
# Node IAM Instance Profile
# This is used by the nodes launched by Karpenter
################################################################################

locals {
  external_role_name = try(replace(var.iam_role_arn, "/^(.*role/)/", ""), null)
}

resource "aws_iam_instance_profile" "this" {
  count = var.create && var.create_instance_profile ? 1 : 0

  name = var.iam_role_use_name_prefix ? null : local.iam_role_name
  //  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path = var.iam_role_path
  role = var.create_iam_role ? aws_iam_role.this[0].name : local.external_role_name

  tags = merge(var.tags, var.iam_role_tags)
}


resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "v0.21.1"

  set {
    name  = "settings.aws.clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = var.eks_cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.irsa[0].arn
    //  module.karpenter.irsa_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.this[0].name
    //  module.karpenter.instance_profile_name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = aws_sqs_queue.this[0].name
    //  module.karpenter.queue_name
  }
}

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: default
    spec:
      requirements:
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot"]
      limits:
        resources:
          cpu: 1000
      providerRef:
        name: default
      ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_template" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: default
    spec:
      subnetSelector:
        karpenter.sh/discovery: ${var.eks_cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${var.eks_cluster_name}
      tags:
        karpenter.sh/discovery: ${var.eks_cluster_name}
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

# Example deployment using the [pause image](https://www.ianlewis.org/en/almighty-pause-container)
# and starts with zero replicas
/*
resource "kubectl_manifest" "karpenter_example_deployment" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: inflate
    spec:
      replicas: 0
      selector:
        matchLabels:
          app: inflate
      template:
        metadata:
          labels:
            app: inflate
        spec:
          terminationGracePeriodSeconds: 0
          containers:
            - name: inflate
              image: public.ecr.aws/eks-distro/kubernetes/pause:3.7
              resources:
                requests:
                  cpu: 1
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}*/
