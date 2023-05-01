resource "kubectl_manifest" "k8s-manifest" {
  yaml_body = <<YAML
    apiVersion: elbv2.k8s.aws/v1beta1
    kind: TargetGroupBinding
    metadata:
      name: "${var.metadata_name}-tgb"
    spec:
      serviceRef:
        name: ${var.serviceref_name}
        port: ${var.serviceref_port}
      targetGroupARN: ${var.target_group_arn}
    YAML
}
