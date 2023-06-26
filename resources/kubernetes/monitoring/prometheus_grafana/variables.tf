variable "enable_prometheus_grafana" {
  type        = bool
  default     = false
  description = "Variable to install the prometheus or not"
}
variable "namespace" {
  type        = string
  default     = "prometheus"
  description = "Namespace under which prometheus will be deployed."
}

variable "prometheus_grafana_chart" {
  type    = string
  default = "kube-prometheus-stack"
}

variable "prometheus_grafana_name" {
  type    = string
  default = "kube-prometheus-stackr"
}

variable "prometheus_grafana_helm_repo" {
  type    = string
  default = "https://prometheus-community.github.io/helm-charts"
}

variable "prometheus_grafana_chart_version" {
  type    = string
  default = "36.6.2"
}

variable "prometheus_grafana_values" {
  /*default = {
    alertmanager = {
      persistentVolume = {
        storageClass = "gp2"
      }
    }
    server = {
      persistentVolume = {
        storageClass = "gp2"
      }
    }
  }*/
  default     = {}
  description = "Additional settings which will be passed to Prometheus Helm chart values."
}


//variable "eks_cluster_certificate_authority" {}
//variable "eks_cluster_endpoint" {}
//variable "eks_cluster_name" {}
