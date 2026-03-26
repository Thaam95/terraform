locals {
  normalized_alb_prefix = trim(var.alb_prefix, "/")
  normalized_waf_prefix = trim(var.waf_prefix, "/")

  waf_log_destination_arn = var.waf_log_destination_override != null ? var.waf_log_destination_override : (
    local.normalized_waf_prefix == "" ? var.hub_bucket_arn : "${var.hub_bucket_arn}/${local.normalized_waf_prefix}"
  )
}
