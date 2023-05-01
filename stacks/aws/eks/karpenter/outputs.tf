output "vpc_id" {
  value = module.vpc
}

output "eks_security_groups" {
  value = module.eks_security_group
}

//eks outputs
output "eks_cluster_endpoint" {
  value = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks_cluster.eks_cluster_name
}

output "eks_managed_node_groups_autoscaling_group_names_public" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = try(flatten(module.eks_cluster.eks_managed_node_groups_autoscaling_group_names_public), null)
}

output "eks_managed_node_groups_autoscaling_group_names_private" {
  description = "List of the autoscaling group names created by EKS managed node groups"
  value       = try(flatten(module.eks_cluster.eks_managed_node_groups_autoscaling_group_names_private), null)
}

output "eks_managed_node_groups_names_private" {
  value = module.eks_cluster.eks_managed_node_groups_names_private
}

output "eks_managed_node_groups_names_public" {
  value = module.eks_cluster.eks_managed_node_groups_names_public
}

output "kube_config_file" {
  value = module.eks_cluster.config_file
}

output "karpenter" {
  value = module.karpenter
}
