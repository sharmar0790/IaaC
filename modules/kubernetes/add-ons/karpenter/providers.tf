terraform {
  required_version = "~> 1.4.4"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.61.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "kubectl" {
  host                   = var.host
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  load_config_file       = "false"
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
