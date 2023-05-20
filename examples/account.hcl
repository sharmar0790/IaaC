locals {
  account_id = "<AWS_ACCOUNT_ID>"

  tags = {
    account_id = local.account_id
  }
}

inputs = {
  account_id = local.account_id
}
