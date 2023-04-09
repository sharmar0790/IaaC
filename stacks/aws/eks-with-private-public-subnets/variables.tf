variable "instance_tenancy" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
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
