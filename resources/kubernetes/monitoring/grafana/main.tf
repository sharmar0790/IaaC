resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana"
    namespace = var.namespace
  }

  data = {
    admin-user     = "admin"
    admin-password = random_password.grafana.result
  }
}

resource "random_password" "grafana" {
  length = 24
}

resource "helm_release" "grafana" {
  count      = var.enable_grafana ? 1 : 0
  chart      = var.grafana_chart
  name       = var.grafana_name
  repository = var.grafana_helm_repo
  namespace  = var.namespace
  version    = var.grafana_chart_version

  values = [
    templatefile("${path.module}/templates/grafana-values.yaml", {
      admin_existing_secret = kubernetes_secret.grafana.metadata[0].name
      admin_user_key        = "admin-user"
      admin_password_key    = "admin-password"
      prometheus_svc        = "${var.prometheus_name}-server"
      replicas              = 1
    })
  ]
}
