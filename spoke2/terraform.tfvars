aws_region       = "ap-southeast-1"
environment      = "dev"
spoke_account_id = "217946272355"

hub_bucket_name = "aws-waf-logs-splunk-test-thaam-cta"
hub_bucket_arn  = "arn:aws:s3:::aws-waf-logs-splunk-test-thaam-cta"

albs = {
  app1 = {
    arn = "arn:aws:elasticloadbalancing:ap-southeast-1:217946272355:loadbalancer/app/alb-HubPrivate-aw-apse1-dev-001/70547e9e9e1475d2"
  }
  # app2 = {
  #   arn = ""
  # }
}

wafs = {
  web1 = {
    arn    = "arn:aws:wafv2:ap-southeast-1:217946272355:regional/webacl/test-splunk/99905604-0bc1-4a9f-a48e-ad41d0bad984"
    region = "ap-southeast-1"
  }
  web2 = {
    arn    = "arn:aws:wafv2:ap-southeast-1:217946272355:regional/webacl/test-splunk2/d4f96931-c036-44e2-8ca4-55cf9ea89fbb"
    region = "ap-southeast-1"
  }
}
