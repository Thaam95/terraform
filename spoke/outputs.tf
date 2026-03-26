output "alb_access_log_paths" {
  description = "Expected ALB log paths in the hub bucket"
  value = {
    for k, v in var.albs :
    k => "s3://${var.hub_bucket_name}/${trim(var.alb_prefix, "/")}/AWSLogs/${var.spoke_account_id}/elasticloadbalancing/${var.aws_region}/"
  }
}

output "waf_log_destination_arn" {
  description = "WAF S3 logging destination ARN used during terraform apply"
  value       = local.waf_log_destination_arn
}

output "waf_log_paths" {
  description = "Expected WAF log prefixes in the hub bucket"
  value = {
    for k, v in var.wafs :
    k => (
      trim(var.waf_prefix, "/") == ""
      ? "s3://${var.hub_bucket_name}/AWSLogs/${var.spoke_account_id}/WAFLogs/${v.region}/"
      : "s3://${var.hub_bucket_name}/${trim(var.waf_prefix, "/")}/AWSLogs/${var.spoke_account_id}/WAFLogs/${v.region}/"
    )
  }
}
