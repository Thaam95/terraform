variable "hub_bucket_name" {
  type = string
}

variable "hub_bucket_arn" {
  type = string
}

variable "alb_prefix" {
  type    = string
  default = "alb"
}

variable "waf_prefix" {
  type    = string
  default = "waf"
}

variable "spoke_accounts" {
  type = list(object({
    account_id = string
    region     = string
    name       = optional(string)
  }))
  default = []
}

variable "enable_deny_insecure_transport" {
  type    = bool
  default = true
}
