module "alb_existing" {
  source = "../modules/alb_existing"

  aws_region       = var.aws_region
  hub_bucket_name  = var.hub_bucket_name
  hub_bucket_arn   = var.hub_bucket_arn
  spoke_account_id = var.spoke_account_id
  alb_prefix       = var.alb_prefix
  albs             = var.albs
}

module "waf_logging_cli" {
  source = "../modules/waf_logging_cli"

  wafs                    = var.wafs
  waf_log_destination_arn = local.waf_log_destination_arn
}
