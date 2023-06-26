provider "kubernetes" {
  host                   = module.eks_cluster.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.kubeconfig-certificate-authority-data)
  token                  = module.eks_cluster.cluster_auth_token
}

//provider "helm" {
//  kubernetes {
//    host                   = module.eks_cluster.eks_cluster_endpoint
//    cluster_ca_certificate = base64decode(module.eks_cluster.kubeconfig-certificate-authority-data)
//    token                  = module.eks_cluster.cluster_auth_token
//  }
//}

//provider "kubectl" {
//  host                   = module.eks_cluster.eks_cluster_endpoint
//  cluster_ca_certificate = base64decode(module.eks_cluster.kubeconfig-certificate-authority-data)
//  token                  = module.eks_cluster.cluster_auth_token
//}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

