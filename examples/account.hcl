locals {
  account_id = "035864429412"

  tags = {
    account_id = local.account_id
  }
}

inputs = {
  account_id = local.account_id
}
