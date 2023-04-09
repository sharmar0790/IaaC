variable "eks_cluster_name" {}
variable "tags" {}
variable "eks_cluster_identity" {}
variable "thumbprint_list" {
  type = set(string)
}