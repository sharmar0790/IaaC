resource "kubernetes_secret_v1" "main" {
  for_each = var.kubernetes_secrets
  metadata {
    namespace = each.value.namespace
    name = each.key
    labels = {
      "sensitive" = "true"
    }
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (each.value.registry_server) = {
          "username" = each.value.registry_username
          "password" = data.aws_ecr_authorization_token.token.password
          "email" = each.value.registry_email
          //          "auth" = base64encode("${each.value.registry_username}:${each.value.registry_password}")
          "auth" = data.aws_ecr_authorization_token.token.authorization_token
        }
      }
    })
  }

  wait_for_service_account_token = var.wait_for_service_account_token
}

data "aws_ecr_authorization_token" "token" {
  //registry_id = ""
}