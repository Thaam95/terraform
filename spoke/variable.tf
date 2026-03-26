variable "aws_region" {
  description = "AWS region where the spoke resources exist"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "sbx"

  validation {
    condition     = contains(["prd", "stg", "dev", "sbx"], var.environment)
    error_message = "environment must be one of: prd, stg, dev, sbx."
  }
}

variable "spoke_account_id" {
  description = "12-digit AWS account ID of this spoke"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.spoke_account_id))
    error_message = "spoke_account_id must be a 12-digit AWS account ID."
  }
}

variable "hub_bucket_name" {
  description = "Name of the existing centralized S3 bucket"
  type        = string
}

variable "hub_bucket_arn" {
  description = "ARN of the existing centralized S3 bucket"
  type        = string
}

variable "alb_prefix" {
  description = "Top-level S3 prefix for ALB access logs"
  type        = string
  default     = "alb"
}

variable "waf_prefix" {
  description = "Top-level S3 prefix for WAF logs when using direct S3 delivery"
  type        = string
  default     = "waf"
}

variable "albs" {
  description = "Map of existing ALBs to import and manage for access logging. Use {} when the spoke has no ALBs to onboard."
  type = map(object({
    arn = string
  }))
  default = {}
}

variable "wafs" {
  description = "Map of existing WAF web ACLs to configure for centralized S3 logging. Use {} when the spoke has no WAF web ACLs to onboard."
  type = map(object({
    arn    = string
    region = string
  }))
  default = {}
}

variable "waf_log_destination_override" {
  description = "Optional explicit WAF S3 log destination ARN. Leave null to use <hub_bucket_arn>/<waf_prefix>."
  type        = string
  default     = null
}
