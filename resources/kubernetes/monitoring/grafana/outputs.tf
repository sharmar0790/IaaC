output "grafana_id" {
  value = helm_release.grafana.id
}

output "grafana_name" {
  value = helm_release.grafana.name
}

output "grafana_password" {
  value = kubernetes_secret.grafana.data
}
