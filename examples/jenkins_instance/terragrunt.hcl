terraform {
  source = "${get_parent_terragrunt_dir()}//stacks/aws/instance"
}

include {
  path = find_in_parent_folders()
  expose = true
}

inputs = {

  owners = ["${include.locals.account_vars.locals.account_id}"]
  ami_id = "ami-0d76271a8a1525c1a"
  instance_additional_tags = {
    Name = "Jenkins Instance"
  }
  user_data = file("user_data.sh")
  key_name = "demo-saml"
  instance_type = "t3.medium"
}
