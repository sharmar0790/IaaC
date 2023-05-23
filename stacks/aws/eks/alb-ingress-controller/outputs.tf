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

// lb-controller
output "lbc_iam_role_arn" {
  description = "AWS Load Balancer Controller IAM Role ARN"
  value       = module.load-balancer-controller.lbc_iam_role_arn
}

output "lbc_helm_id" {
  description = "Metadata Block outlining status of the deployed release."
  value       = module.load-balancer-controller.lbc_helm_id
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

output "prometheus_grafana" {
  value = module.prometheus_grafana
}
