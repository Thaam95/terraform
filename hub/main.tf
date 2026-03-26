data "aws_s3_bucket" "hub" {
  bucket = var.hub_bucket_name
}

module "hub_s3_policy" {
  source = "../modules/hub_s3_policy"

  hub_bucket_name                = var.hub_bucket_name
  hub_bucket_arn                 = var.hub_bucket_arn
  alb_prefix                     = var.alb_prefix
  waf_prefix                     = var.waf_prefix
  spoke_accounts                 = var.spoke_accounts
  enable_deny_insecure_transport = var.enable_deny_insecure_transport
}
