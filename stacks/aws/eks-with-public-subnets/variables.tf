variable "instance_tenancy" {
  type = string
}

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

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "vpc_name" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "cw_logs_retention_in_days" {
  type = number
}

variable "enabled_cluster_log_types" {
  type = list(string)
}

variable "public_subnet_tags" {
  type = map(string)
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_cluster_addons" {
  type = map(object({
    version = string,
    resolve_conflicts = string,
    configuration_values = string,
    service_account_role_arn = string,
    preserve = bool
  }))
  default = {}
  description = "Eks Cluster Addons specific values"
}

// eks node group variables

variable "desired_size" {
  type = number
  default = 1
}
variable "max_size" {
  type = number
  default = 2
}
variable "min_size" {
  type = number
  default = 1
}
variable "max_unavailable" {
  type = number
  default = 1
}

variable "capacity_type" {
  default = "SPOT"
}
variable "ami_type" {
  type = string
  default = "AL2_x86_64"
}
variable "disk_size" {
  type = number
  default = 20
}
variable "instance_types" {
  type = set(string)
  default = [
    "t4g.medium"]
}
variable "force_update_version" {
  type = bool
  default = false
}
variable "labels" {
  type = map(string)
}
variable "release_version" {
  type = string
  default = ""
}

variable "kubernetes_taints" {
  type = list(object({
    key = string
    value = string
    effect = string
  }))
  description = <<-EOT
    List of `key`, `value`, `effect` objects representing Kubernetes taints.
    `effect` must be one of `NO_SCHEDULE`, `NO_EXECUTE`, or `PREFER_NO_SCHEDULE`.
    `key` and `effect` are required, `value` may be null.
    EOT
  default = []
}

variable "endpoint_public_access" {}
variable "env_name" {}


