//variable "eks_cluster_version" {
//  description = "The Kubernetes version for the cluster - used to match appropriate version for image used"
//  type        = string
//}

variable "helm_config" {
  description = "Cluster Autoscaler Helm Config"
  type        = any
  default     = {}
}

//variable "create_addon" {
//  description = "Determines if the add-on should be created."
//  type        = bool
//  default     = false
//}

variable "eks_cluster_name" {
  description = "Name of the EKS CLUSTER."
  type        = string
}

variable "cluster_autoscaler_tags" {
  type    = map(string)
  default = {}
}

/*variable "addon_context" {
  description = "Input configuration for the addon"
  type = object({
    aws_caller_identity_account_id = string
    aws_caller_identity_arn        = string
    aws_eks_cluster_endpoint       = string
    aws_partition_id               = string
    aws_region_name                = string
    eks_cluster_id                 = string
    eks_oidc_issuer_url            = string
    eks_oidc_provider_arn          = string
    tags                           = map(string)
    irsa_iam_role_path             = string
    irsa_iam_permissions_boundary  = string
  })
  default = ({
    aws_caller_identity_account_id = ""
    aws_caller_identity_arn        = ""
    aws_eks_cluster_endpoint       = ""
    aws_partition_id               = ""
    aws_region_name                = ""
    eks_cluster_id                 = ""
    eks_oidc_issuer_url            = ""
    eks_oidc_provider_arn          = ""
    tags                           = {}
    irsa_iam_role_path             = ""
    irsa_iam_permissions_boundary  = ""
  })
}*/
