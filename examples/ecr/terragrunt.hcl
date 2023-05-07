locals {
  repositories = {
    "parking-lot" = {
      project_family = "sample"
      image_tag_mutability = "MUTABLE"
      scan_on_push = false
      expiration_after_days = 1
      environment = "${include.locals.env_name}"
      additional_tags = {
        Project = "ECR"
        Description = "Sample docker image"
      }
    }
  }
}


terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/ecr"
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  repositories = local.repositories
}
