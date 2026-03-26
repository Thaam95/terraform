aws_region       = "ap-southeast-1"
environment      = "sbx"
spoke_account_id = "115713006605"

hub_bucket_name = "aws-waf-logs-splunk-test-thaam-cta"
hub_bucket_arn  = "arn:aws:s3:::aws-waf-logs-splunk-test-thaam-cta"

albs = {
  app1 = {
    arn = "arn:aws:elasticloadbalancing:ap-southeast-1:115713006605:loadbalancer/app/k8s-test2048-ingress2-3b43123b93/db121ab0c90d2964"
  }
  app2 = {
    arn = "arn:aws:elasticloadbalancing:ap-southeast-1:115713006605:loadbalancer/app/k8s-test2048-ingressw-5cebbcae82/6a6ecec786ed3dd4"
  }
}

wafs = {
  web1 = {
    arn    = "arn:aws:wafv2:ap-southeast-1:115713006605:regional/webacl/waf-phumipat-aw-dev-001/045f1cc4-2576-4bd7-bb96-224cce4b6ea9"
    region = "ap-southeast-1"
  }
}
