terraform {
  required_version = "~> 1.4.4"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

provider "kubectl" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  //  token = var.cluster_auth_token[0].data
  load_config_file = "false"
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
    var.eks_cluster_name]
    command = "aws"
  }
}

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = var.cluster_auth_token
}
