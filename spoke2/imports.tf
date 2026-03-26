# Terraform 1.7+ import blocks for existing ALBs.
# Each ALB listed in var.albs is imported into module.alb_existing.aws_lb.this.
# If var.albs is empty, nothing is imported.
import {
  for_each = var.albs
  to       = module.alb_existing.aws_lb.this[each.key]
  id       = each.value.arn
}
