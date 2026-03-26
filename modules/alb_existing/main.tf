data "aws_lb" "existing" {
  for_each = var.albs
  arn      = each.value.arn
}

resource "aws_lb" "this" {
  for_each = var.albs

  name               = data.aws_lb.existing[each.key].name
  internal           = data.aws_lb.existing[each.key].internal
  load_balancer_type = data.aws_lb.existing[each.key].load_balancer_type
  security_groups    = try(data.aws_lb.existing[each.key].security_groups, null)
  subnets            = data.aws_lb.existing[each.key].subnets

  access_logs {
    bucket  = var.hub_bucket_name
    prefix  = trim(var.alb_prefix, "/")
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      security_groups,
      subnets,
      tags,
      tags_all,
    ]
  }
}
