variable "aws_region" {
  description = "AWS Region for the hub bucket"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "prd"
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
  description = "Top-level prefix for ALB access logs in the hub bucket"
  type        = string
  default     = "alb"
}

variable "waf_prefix" {
  description = "Top-level prefix for WAF logs in the hub bucket when using direct S3 delivery"
  type        = string
  default     = "waf"
}

variable "spoke_accounts" {
  description = "Spoke accounts that are allowed to deliver ALB and WAF logs"
  type = list(object({
    account_id = string
    region     = string
    name       = optional(string)
  }))
  default = []
}

variable "enable_deny_insecure_transport" {
  description = "Whether to deny non-TLS requests to the hub bucket"
  type        = bool
  default     = true
}
