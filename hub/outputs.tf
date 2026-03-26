output "hub_bucket_name" {
  description = "Existing hub S3 bucket name"
  value       = var.hub_bucket_name
}

output "hub_bucket_arn" {
  description = "Existing hub S3 bucket ARN"
  value       = var.hub_bucket_arn
}

output "hub_bucket_policy_json" {
  description = "Rendered centralized hub bucket policy JSON"
  value       = module.hub_s3_policy.rendered_policy_json
}
