locals {
  vpc_name = "${include.locals.organization}-${include.locals.env_name}-VPC"
}

terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/vpc/with-subnets"
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {
  // vpc inputs
  vpc_cidr = "10.0.0.0/20"
  vpc_name = local.vpc_name

  //The VPC must have DNS hostname and DNS resolution support. Otherwise, nodes can't register to your cluster.
  // For more information, see DNS attributes for your VPC in the Amazon VPC User Guide.
  enable_dns_hostnames = true
  enable_dns_support = true

  region = "${include.locals.region}"
  // public subnet inputs
  map_public_ip_on_launch_public_subnets = true
  public_subnet_cidr = [
    "10.0.1.0/24"]

  //private subnets
  enable_nat_gw = true
  private_subnet_cidrs = [
    "10.0.3.0/24"]

  single_nat_gw = true
}
