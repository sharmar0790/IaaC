locals {
  name                          = try(var.helm_config.name, "cluster-autoscaler")
  k8s_service_account_namespace = try(var.helm_config.namespace, "kube-system")
  k8s_service_account_name      = try(var.helm_config.service_account, "${local.name}-sa")
}

module "iam_assumable_role_admin" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "~> 4.0"
  create_role  = true
  role_name    = "cluster-autoscaler"
  provider_url = replace(data.aws_eks_cluster.current.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns = [
  aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = [
  "system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
}

resource "helm_release" "cluster-autoscaler" {
  name             = "cluster-autoscaler"
  namespace        = local.k8s_service_account_namespace
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  version          = "9.21.0"
  create_namespace = false

  set {
    name  = "awsRegion"
    value = data.aws_region.current.name
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = local.k8s_service_account_name
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_admin.iam_role_arn
    type  = "string"
  }
  set {
    name  = "apiVersion"
    value = "v1"
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = local.name
  }
  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }
  set {
    name  = "rbac.create"
    value = "true"
  }
}

/*module "helm_addon" {
  count  = var.create_addon ? 1 : 0
  source = "../helm-addon"

  # https://github.com/kubernetes/autoscaler/blob/master/charts/cluster-autoscaler/Chart.yaml
  helm_config = merge({
    name        = local.name
    chart       = local.name
    version     = "9.21.0"
    repository  = "https://kubernetes.github.io/autoscaler"
    namespace   = local.namespace
    description = "Cluster AutoScaler helm Chart deployment configuration."
    values = [templatefile("${path.module}/values.yaml", {
      aws_region     = var.addon_context.aws_region_name
      eks_cluster_id = var.addon_context.eks_cluster_id
      image_tag      = "v${var.eks_cluster_version}.0"
    })]
    },
    var.helm_config
  )

  set_values = [
    {
      name  = "rbac.serviceAccount.create"
      value = "false"
    },
    {
      name  = "rbac.serviceAccount.name"
      value = local.service_account
    }
  ]

  irsa_config = {
    create_kubernetes_namespace         = try(var.helm_config.create_namespace, false)
    kubernetes_namespace                = local.namespace
    create_kubernetes_service_account   = true
    create_service_account_secret_token = try(var.helm_config["create_service_account_secret_token"], false)
    kubernetes_service_account          = local.service_account
    irsa_iam_policies                   = [aws_iam_policy.cluster_autoscaler[0].arn]
  }

  addon_context = var.addon_context
}*/

resource "aws_iam_policy" "cluster_autoscaler" {
  //  count       = var.create_addon ? 1 : 0
  name        = "${data.aws_eks_cluster.current.id}-${local.name}-irsa"
  description = "Cluster Autoscaler IAM policy"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json

  tags = var.cluster_autoscaler_tags
}
