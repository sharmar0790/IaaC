module "ecr-repo" {
  source = "../../../resources/aws/ecr-repo"

  for_each                 = var.repositories
  name                     = each.key
  additional_tags          = each.value.additional_tags
  project_family           = each.value.project_family
  ecr_image_tag_mutability = each.value.image_tag_mutability
  ecr_scan_on_push         = each.value.scan_on_push
  environment              = each.value.environment
  lifecycle_policy         = ""
  tags                     = var.tags
  expiration_after_days    = each.value.expiration_after_days
}
