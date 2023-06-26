variable "vpc_cidr" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "region" {
  type = string
}

variable "enable_dns_support" {
  type = bool
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_name" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "cw_logs_retention_in_days" {
  type    = number
  default = 3
}

variable "enabled_cluster_log_types" {
  type    = list(string)
  default = []
}

variable "public_subnet_tags" {
  type = map(string)
}

variable "eks_cluster_addons" {
  type = map(object({
    version                  = string,
    resolve_conflicts        = string,
    configuration_values     = string,
    service_account_role_arn = string,
    preserve                 = bool
  }))
  default     = {}
  description = "Eks Cluster Addons specific values"
}

variable "kubernetes_taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  description = <<-EOT
    List of `key`, `value`, `effect` objects representing Kubernetes taints.
    `effect` must be one of `NO_SCHEDULE`, `NO_EXECUTE`, or `PREFER_NO_SCHEDULE`.
    `key` and `effect` are required, `value` may be null.
    EOT
  default     = []
}

variable "endpoint_public_access" {
  default = true
}
variable "create_node_group" {
  type = bool
}
variable "public_subnet_node_groups" {
  type    = any
  default = {}
}

variable "private_subnet_node_groups" {
  type    = any
  default = []
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "enable_nat_gw" {
  type = bool
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "single_nat_gw" {
  type    = bool
  default = false
}

//variable "argocd_helm_chart_version" {
//  description = "argocd helm chart version to use"
//  type        = string
//}
