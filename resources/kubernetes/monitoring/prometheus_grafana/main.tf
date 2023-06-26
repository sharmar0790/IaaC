//installs additional components for monitoring Kubernetes, such as kube-state-metrics,
// node-exporter and cAdvisor
//OpenTelemetry, kube-state-metrics and prometheus-node-exporter charts
resource "helm_release" "prometheus_grafana" {
  count = var.enable_prometheus_grafana ? 1 : 0

  chart      = var.prometheus_grafana_chart
  name       = var.prometheus_grafana_name
  namespace  = var.namespace
  repository = var.prometheus_grafana_helm_repo
  version    = var.prometheus_grafana_chart_version
  //  values     = [try(yamlencode(var.prometheus_values), null)]
  create_namespace = true
}
