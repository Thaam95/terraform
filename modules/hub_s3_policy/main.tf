locals {
  waf_resource_prefix = trim(var.waf_prefix, "/")

  waf_put_resource = local.waf_resource_prefix == "" ? "${var.hub_bucket_arn}/AWSLogs/*" : "${var.hub_bucket_arn}/${local.waf_resource_prefix}/AWSLogs/*"
  alb_put_resources = [
    for spoke in var.spoke_accounts :
    "${var.hub_bucket_arn}/${trim(var.alb_prefix, "/")}/AWSLogs/${spoke.account_id}/*"
  ]
  waf_source_accounts = [for spoke in var.spoke_accounts : spoke.account_id]
  waf_source_arns = [
    for spoke in var.spoke_accounts :
    "arn:aws:logs:${spoke.region}:${spoke.account_id}:*"
  ]
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = length(var.spoke_accounts) > 0 ? [1] : []
    content {
      sid    = "AllowALBLogDelivery"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
      }

      actions   = ["s3:PutObject"]
      resources = local.alb_put_resources

      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = local.waf_source_accounts
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.spoke_accounts) > 0 ? [1] : []
    content {
      sid    = "AWSLogDeliveryWrite"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }

      actions   = ["s3:PutObject"]
      resources = [local.waf_put_resource]

      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }

      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = local.waf_source_accounts
      }

      condition {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = local.waf_source_arns
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.spoke_accounts) > 0 ? [1] : []
    content {
      sid    = "AWSLogDeliveryAclCheck"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }

      actions   = ["s3:GetBucketAcl"]
      resources = [var.hub_bucket_arn]

      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = local.waf_source_accounts
      }

      condition {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = local.waf_source_arns
      }
    }
  }

  dynamic "statement" {
    for_each = var.enable_deny_insecure_transport ? [1] : []
    content {
      sid    = "DenyNonTLSRequests"
      effect = "Deny"

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      actions = ["s3:*"]
      resources = [
        var.hub_bucket_arn,
        "${var.hub_bucket_arn}/*",
      ]

      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = var.hub_bucket_name
  policy = data.aws_iam_policy_document.this.json
}
