variable "wafs" {
  type = map(object({
    arn    = string
    region = string
  }))
  default = {}
}

variable "waf_log_destination_arn" {
  type = string
}
