locals {
  spoke_accounts_by_id = {
    for spoke in var.spoke_accounts :
    spoke.account_id => spoke
  }
}
