output "prometheus_grafana_id" {
  value = try(helm_release.prometheus_grafana[0].id, null)
}

output "prometheus_grafana_name" {
  value = try(helm_release.prometheus_grafana[0].name, null)
}

output "prometheus_grafana_metadata" {
  value = try(helm_release.prometheus_grafana[0].metadata, null)
}
