locals {
  environment = "dev"
  region = "eu-west-2"

  tags = {
    environment = local.environment
  }
}

inputs = {
  env_name = local.environment
  region = local.region
}
