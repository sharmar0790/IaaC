variable "enable_grafana" {
  type    = bool
  default = false
}
variable "namespace" {
  type    = string
  default = "grafana"
}

variable "grafana_chart" {
  type    = string
  default = "grafana"
}

variable "grafana_name" {
  type    = string
  default = "grafana"
}

variable "grafana_helm_repo" {
  type    = string
  default = "https://grafana.github.io/helm-charts"
}

variable "grafana_chart_version" {
  type    = string
  default = "6.24.1"
}

variable "prometheus_name" {
  type = string
  //  default = "6.24.1"
}

variable "eks_cluster_certificate_authority" {}
variable "eks_cluster_endpoint" {}
variable "eks_cluster_name" {}
