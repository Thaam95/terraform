output "alb_arns" {
  value = {
    for k, v in aws_lb.this :
    k => v.arn
  }
}
