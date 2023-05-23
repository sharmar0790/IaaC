# default variables

locals {
  default_lifecycle_policy = {
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep only one 1 image, expire all others",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 1
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  }
}


/*
locals {
  default_lifecycle_policy_since_image_pushed = {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Expire images older than ${var.expiration_after_days} days",
        "selection": {
          "tagStatus": "any",
          "countType": "sinceImagePushed",
          "countUnit": "days",
          "countNumber": ${var.expiration_after_days}
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
}
*/

