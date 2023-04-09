variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  description = "A set of key/value label pairs to be assigned"
  default = {}
}

variable "cw_logs_retention_in_days" {
  type = number
}

variable "enabled_cluster_log_types" {
  type = list(string)
}

variable "cluster_version" {
  type = string
}

variable "eks_cluster_addons" {
  type = map(object({
    version = string,
    resolve_conflicts = string,
    configuration_values = optional(string),
    service_account_role_arn = string,
    preserve = optional(bool)
  }))
  default = {}
  description = "Eks Cluster Addons specific values"
}


// eks node group variables

/*variable "desired_size" {
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
  type = list(string)
  default = [
    "t3.medium"]
}
variable "force_update_version" {
  type = string
  default = ""
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
}*/


///

variable "ami_type" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "instance_types" {
  type = set(string)
}

variable "capacity_type" {
  type = string
}

variable "release_version" {
  type = string
}

variable "force_update_version" {
  type = bool
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

variable "desired_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "max_unavailable" {
  type = number
}

variable "labels" {
  type = map(string)
}

variable "endpoint_public_access" {
  default = false
  type = bool
}

variable "cluster_security_groups_id" {}