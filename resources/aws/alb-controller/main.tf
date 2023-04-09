# Datasource: AWS Load Balancer Controller IAM Policy get from aws-load-balancer-controller/ GIT Repo (latest)
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
  //  curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json
  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

# Install AWS Load Balancer Controller using HELM

# Resource: Helm Release
resource "helm_release" "loadbalancer_controller" {
  name = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"

  namespace = "kube-system"

  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-2.amazonaws.com/amazon/aws-load-balancer-controller"
    # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  }

  set {
    name = "serviceAccount.create"
    value = "true"
  }

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.lbc_iam_role.arn
  }

  set {
    name = "vpcId"
    value = var.vpc_id
  }
  set {
    name = "image.tab"
    value = "v2.1.0"
  }

  set {
    name = "region"
    value = data.aws_region.current.name
  }

  set {
    name = "clusterName"
    value = var.eks_cluster_name
  }

  depends_on = [
    aws_iam_role.lbc_iam_role]

}