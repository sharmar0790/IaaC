terraform {
  source = "${get_parent_terragrunt_dir()}//resources/aws/secrets"
}


include {
  path = find_in_parent_folders()
  expose = true
}
dependency "eks_cluster" {
  config_path = "../eks-cluster"
}

inputs = {
  // secrets inputs

  kubernetes_secrets = {
    "docker-registry" = {
      registry_server = "035864429412.dkr.ecr.eu-west-2.amazonaws.com"
      registry_username = "AWS"
      //      registry_password = "$(aws ecr get-login-password)"
      registry_email = "abc@abc.com"
      namespace = "default"
    }
  }

  eks_cluster_name = dependency.eks_cluster.outputs.eks_cluster_name
  eks_cluster_certificate_authority = dependency.eks_cluster.outputs.kubeconfig_certificate_authority_data
  eks_cluster_endpoint = dependency.eks_cluster.outputs.eks_cluster_endpoint
}
