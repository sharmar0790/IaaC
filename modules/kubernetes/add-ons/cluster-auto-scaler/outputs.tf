output "release_metadata" {
  description = "Map of attributes of the Helm release metadata"
  value       = helm_release.cluster-autoscaler.metadata
}
