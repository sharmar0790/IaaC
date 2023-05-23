variable "kubernetes_secrets" {
  type = map(object({
    registry_server   = string
    registry_username = string
    //    registry_password = string
    registry_email = string
    namespace      = string
  }))
  default     = {}
  description = "Key value pair to create the secrets"
}

variable "wait_for_service_account_token" {
  default = false
  type    = bool
}

variable "eks_cluster_name" {}
variable "eks_cluster_certificate_authority" {}
variable "eks_cluster_endpoint" {}
