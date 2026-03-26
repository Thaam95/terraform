aws_region      = "ap-southeast-1"
environment     = "sbx"
hub_bucket_name = "aws-waf-logs-splunk-test-thaam-cta"
hub_bucket_arn  = "arn:aws:s3:::aws-waf-logs-splunk-test-thaam-cta"

spoke_accounts = [
  {
    account_id = "115713006605"
    region     = "ap-southeast-1"
    name       = "act-cdcsandbox-aw-sbx"
  },
  {
    account_id = "217946272355"
    region     = "ap-southeast-1"
    name       = "act-Networking-aw-dev"
  }
]
