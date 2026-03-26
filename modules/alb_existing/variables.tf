variable "aws_region" {
  type = string
}

variable "hub_bucket_name" {
  type = string
}

variable "hub_bucket_arn" {
  type = string
}

variable "spoke_account_id" {
  type = string
}

variable "alb_prefix" {
  type    = string
  default = "alb"
}

variable "albs" {
  type = map(object({
    arn = string
  }))
  default = {}
}
