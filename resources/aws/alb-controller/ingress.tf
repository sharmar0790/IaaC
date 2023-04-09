# Resource: Kubernetes Ingress Class
resource "kubernetes_ingress_class_v1" "ingress_class_default" {
  metadata {
    name = "my-aws-ingress-class"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }
  spec {
    controller = "ingress.k8s.aws/alb"
    //    loadBalancerClass = "service.k8s.aws/nlb"
    /*parameters = {
      apiGroup = "elbv2.k8s.aws"
      "kind" = "IngressClassParams"
      "name" = "awesome-class-cfg"
    }*/
  }
  depends_on = [
    helm_release.loadbalancer_controller]
}