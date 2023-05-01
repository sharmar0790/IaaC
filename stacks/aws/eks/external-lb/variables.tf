variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "vpc_cidr" {
  type = string
}

variable "create_lb" {
  type = bool
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
  default = [
    "10.0.1.0/24",
  "10.0.2.0/24"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_group_additional_tags" {
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

variable "eks_cluster_version" {
  type = string
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
variable "alb_sg_name" {}
variable "lb_name" {}
variable "alb_sg_description" {}

//variable "ingress_egress_rules" {
//  type = map(object({
//    ingress = object({
//      from_port = number
//      to_port = number
//      protocol = string
//      cidr_blocks = set(string)
//      ipv6_cidr_blocks = set(string)
//      security_groups = set(string)
//    }),
//    egress = object({
//      from_port = number
//      to_port = number
//      protocol = string
//      cidr_blocks = set(string)
//      ipv6_cidr_blocks = set(string)
//    })
//  }))
//  /*default = {
//    "Sample Rule" = {
//      ingress = {
//        from_port = 0
//        to_port = 0
//        protocol = "tcp"
//        cidr_blocks = [
//          "0.0.0.0/0"]
//        ipv6_cidr_blocks = [
//          "::/0"]
//        security_groups = []
//      },
//      egress = {
//        from_port = 0
//        to_port = 0
//        protocol = "tcp"
//        cidr_blocks = [
//          "0.0.0.0/0"]
//        ipv6_cidr_blocks = [
//          "::/0"]
//      }
//    }
//  }*/
//}

variable "metadata_name" {}
variable "serviceref_name" {}
variable "serviceref_port" {}
variable "lb_target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
}

variable "http_tcp_listeners" {
  type = any
}



