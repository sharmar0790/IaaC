resource "helm_release" "argocd" {
  name             = var.argocd_name
  repository       = var.helm_repo_url
  chart            = "argo-cd"
  namespace        = var.argocd_namespace
  create_namespace = true
  version          = var.argocd_helm_chart_version == "" ? null : var.argocd_helm_chart_version

  values = []
  //    templatefile(
  //    "${path.module}/templates/values.yaml.tpl",
  //      {
  //        "argocd_ingress_enabled"          = var.argocd_ingress_enabled
  //        "argocd_ingress_class"            = "alb"
  //        "argocd_server_host"              = var.argocd_server_host
  //        "argocd_load_balancer_name"       = "argocd-${var.argocd_name}-alb-ingress"
  //        "argocd_ingress_tls_acme_enabled" = true
  //        "argocd_acm_arn"                  = data.terraform_remote_state.eks.outputs.aws_acm_certificate_arn
  //      }
  //    )
  //  ]

  set {
    name  = "server.service.type"
    value = "NodePort"
    type  = "string"
  }

  set { # Define the application controller --app-resync - refresh interval for apps, default is 180 seconds
    name  = "controller.args.appResyncPeriod"
    value = "30"
  }

  set { # Define the application controller --repo-server-timeout-seconds - repo refresh timeout, default is 60 seconds
    name  = "controller.args.repoServerTimeoutSeconds"
    value = "15"
  }

  set { # Manage Argo CD configmap (Declarative Setup)
    name  = "server.configEnabled"
    value = "true"
  }

  set { # Argo CD server name
    name  = "server.name"
    value = "argocd-server"
  }
  //  depends_on = [
  //    kubernetes_namespace.argocd
  //  ]
}

data "kubernetes_service" "argo_nodeport" {
  depends_on = [
    helm_release.argocd
  ]
  metadata {
    name      = "${var.argocd_name}-server"
    namespace = var.argocd_namespace
  }
}
