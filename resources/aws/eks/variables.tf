variable "cluster_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "tags" {
  type        = map(string)
  description = "A set of key/value label pairs to be assigned"
  default     = {}
}

variable "cw_logs_retention_in_days" {
  type = number
}

variable "enabled_cluster_log_types" {
  type = list(string)
}

variable "cluster_version" {
  type    = string
  default = "1.25"
}

variable "eks_cluster_addons" {
  type = map(object({
    version                  = string,
    resolve_conflicts        = string,
    configuration_values     = optional(string),
    service_account_role_arn = string,
    preserve                 = optional(bool)
  }))
  default     = {}
  description = "Eks Cluster Addons specific values"
}

variable "endpoint_public_access" {
  default = false
  type    = bool
}

variable "cluster_security_groups_id" {}


variable "create_node_group" {
  type    = bool
  default = false
}

variable "public_subnet_node_groups" {
  type    = any
  default = {}
}

variable "private_subnet_node_groups" {
  type    = any
  default = {}
}

variable "vpc_name" {}
