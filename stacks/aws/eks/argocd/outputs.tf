output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "public_rt_id" {
  value = module.vpc.public_route_table_id
}

output "nat_gw_id" {
  value = module.vpc.nat_gw_id
}

output "public_eip" {
  value = module.vpc.public_eip
}

//eks outputs
output "eks_cluster_endpoint" {
  value = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks_cluster.eks_cluster_name
}

output "eks_cluster_identity" {
  value = module.eks_cluster.eks_cluster_identity
}

output "kubeconfig_certificate_authority_data" {
  value     = module.eks_cluster.kubeconfig-certificate-authority-data
  sensitive = true
}

output "eks-cluster-id" {
  value = module.eks_cluster.eks-cluster-id
}

output "ekscluster-status" {
  value = module.eks_cluster.ekscluster-status
}

output "ekscluster-version" {
  value = module.eks_cluster.ekscluster-version
}

output "eks_managed_node_groups_names_private" {
  value = module.eks_cluster.eks_managed_node_groups_names_private
}

output "eks_managed_node_groups_names_public" {
  value = module.eks_cluster.eks_managed_node_groups_names_public
}

// openid_connect_provider output
output "aws_iam_openid_connect_provider_arn" {
  value = module.eks_cluster.aws_iam_openid_connect_provider_arn
}

output "aws_iam_openid_connect_provider_extract_from_arn" {
  value = module.eks_cluster.aws_iam_openid_connect_provider_extract_from_arn
}

output "cluster_connect_command" {
  value = "aws eks --region eu-west-2 update-kubeconfig --name ${module.eks_cluster.eks_cluster_name}"
}

output "cluster_security_group_id" {
  value = module.eks_cluster.cluster_security_group_id
}

output "security_group_ids" {
  value = module.eks_cluster.security_group_ids
}
