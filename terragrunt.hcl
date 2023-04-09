# Indicate where to source the terraform module from.
# The URL used here is a shorthand for
# "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=3.5.0".
# Note the extra `/` after the protocol is required for the shorthand
# notation.
//terraform {
//  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.5.0"
//}


# Indicate the input values to use for the variables of the module.
locals {
  /*name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false*/

  organization = "local-practice"
  org_project = "local-dev-practice"

  //  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  //  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  //  service_vars = read_terragrunt_config(find_in_parent_folders("service.hcl"))
  //  group_vars   = read_terragrunt_config(find_in_parent_folders("group.hcl", "ignored.hcl"), { locals : {}, inputs = {} })

  //  project_id    = "${local.account_vars.locals.project_id}"
  //  project_name  = "${local.project_vars.locals.project_name}"
  //  project_short = "${local.project_vars.locals.project_short}"
  env_name = "${local.env_vars.locals.environment}"
  //  service_name  = "${local.service_vars.locals.service}"
  region = "${local.env_vars.locals.region}"

  tags_map = {
    tags = merge(
    {
      organization = local.organization,
      org_project = local.org_project,
    },
    //    local.account_vars.locals.labels,
    local.env_vars.locals.tags
    //    local.project_vars.locals.labels,
    //    local.service_vars.locals.labels
    )
  }
}

remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket = "${local.org_project}-tg-tf-state"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.region}"
    encrypt = true
    dynamodb_table = "${local.org_project}-tg-tf-table"
    //    prefix = "${path_relative_to_include()}/terraform"
    //    project  = "${local.project_id}"
  }
}


# Indicate what region to deploy the resources into
generate "providers" {
  path = "_aws_provider_autogen.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
        provider "aws" {
          region = "${local.region}"
          //allowed_account_ids = [var.aws_account_id]
        }
        provider "http" {
//          region = "${local.region}"
        }
        provider "helm" {
//          region = "${local.region}"
        }
//        provider "kubernetes" {
//          region = "${local.region}"
          //allowed_account_ids = [var.aws_account_id]
//        }
    EOF
}

generate "versions" {
  path = "_versions.autogen.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<-EOT
    terraform {
      required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "4.61.0"
        }
        kubernetes = {
          source = "hashicorp/kubernetes"
          version = "2.19.0"
        }
        helm = {
          source = "hashicorp/helm"
          version = "~> 2.5"
        }
        http = {
          source = "hashicorp/http"
          version = "~> 2.1"
        }
//        sops = {
//          source = "carlpett/sops"
//          version = "0.7.2"
//        }
      }
    }
  EOT
}

inputs = merge(
local.env_vars.inputs,
local.tags_map
)