//variable "eks_cluster_id" {}
variable "eks_managed_node_groups_autoscaling_group_names" {
  default = []
}
variable "asg_tags" {
  type    = map(string)
  default = {}
}
