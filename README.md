# Centralized ALB + WAF logging

This repository onboards spoke AWS accounts to a centralized S3 logging bucket.

## Design

- **ALB access logs** are enabled on existing ALBs in each spoke account and delivered directly to the hub bucket under `alb/`.
- **WAF logs** are sent directly from each spoke web ACL to the hub bucket under the configured WAF destination prefix, by running `aws wafv2 put-logging-configuration` during `terraform apply`.
- **No spoke-side WAF bucket** and **no replication** are used in this design.

This matches AWS's current WAF centralized S3 guidance and the Terraform model where ALB access logging is managed on the `aws_lb` resource. AWS documents the WAF S3 destination requirements, including the `aws-waf-logs-` bucket-name prefix and the direct S3 logging flow, and Terraform exposes ALB access logging on `aws_lb`.

## Folder layout

- `hub/` — apply in the central logging account
- `spoke/` — apply in each spoke account
- `modules/` — shared Terraform modules

## Important behavior

This repo does **not** auto-discover arbitrary ALBs or WAF web ACLs.

Instead:
- if a spoke has no ALBs, set `albs = {}`
- if a spoke has no WAFs, set `wafs = {}`
- if a spoke has multiple ALBs or WAFs, add them to the map

That gives you safe and explicit onboarding. Terraform supports repeated resources and repeated imports with `for_each`, which is what this repo uses for the ALB side.

## Prerequisites

- Terraform 1.7+
- AWS provider 5.x
- The hub S3 bucket already exists
- The hub bucket name must start with `aws-waf-logs-` if it will receive WAF logs
- The hub bucket is in the correct Region for the WAF and ALB sources you plan to onboard
- The person running `spoke/` must have AWS CLI configured, because the WAF logging step uses `aws wafv2 put-logging-configuration`

AWS WAF requires the destination bucket name to start with `aws-waf-logs-`, and `PutLoggingConfiguration` is the API/CLI call that enables logging for a web ACL.

## Hub configuration

Update `hub/terraform.tfvars`:

```hcl
aws_region      = "ap-southeast-1"
environment     = "prd"
hub_bucket_name = "aws-waf-logs-example-bucket"
hub_bucket_arn  = "arn:aws:s3:::aws-waf-logs-example-bucket"

spoke_accounts = [
  {
    account_id = "111111111111"
    region     = "ap-southeast-1"
    name       = "spoke-a"
  },
  {
    account_id = "222222222222"
    region     = "ap-southeast-1"
    name       = "spoke-b"
  }
]
```

The hub bucket policy that Terraform renders includes:
- ALB delivery from `logdelivery.elasticloadbalancing.amazonaws.com`
- WAF direct S3 delivery from `delivery.logs.amazonaws.com`
- `aws:SourceAccount` and `aws:SourceArn` conditions for all listed spokes
- optional deny for non-TLS access

## Spoke configuration

Update `spoke/terraform.tfvars`.

### Example: spoke with both ALB and WAF

```hcl
aws_region       = "ap-southeast-1"
environment      = "sbx"
spoke_account_id = "111111111111"

hub_bucket_name = "aws-waf-logs-example-bucket"
hub_bucket_arn  = "arn:aws:s3:::aws-waf-logs-example-bucket"

albs = {
  app1 = {
    arn = "arn:aws:elasticloadbalancing:ap-southeast-1:111111111111:loadbalancer/app/example-alb/1234567890abcdef"
  }
  app2 = {
    arn = "arn:aws:elasticloadbalancing:ap-southeast-1:111111111111:loadbalancer/app/example-alb-2/abcdef1234567890"
  }
}

wafs = {
  web1 = {
    arn    = "arn:aws:wafv2:ap-southeast-1:111111111111:regional/webacl/example-web-acl/12345678-abcd-1234-abcd-1234567890ab"
    region = "ap-southeast-1"
  }
}
```

### Example: spoke with only ALB

```hcl
albs = {
  app1 = {
    arn = "arn:aws:elasticloadbalancing:ap-southeast-1:111111111111:loadbalancer/app/example-alb/1234567890abcdef"
  }
}

wafs = {}
```

### Example: spoke with only WAF

```hcl
albs = {}

wafs = {
  web1 = {
    arn    = "arn:aws:wafv2:ap-southeast-1:111111111111:regional/webacl/example-web-acl/12345678-abcd-1234-abcd-1234567890ab"
    region = "ap-southeast-1"
  }
}
```

## Apply order

### 1. Apply hub first

Run in the hub account:

```bash
cd hub
terraform init
terraform plan
terraform apply
```

If the bucket already has a policy and you want Terraform to adopt it before replacement, import it manually first:

```bash
terraform import module.hub_s3_policy.aws_s3_bucket_policy.this <hub-bucket-name>
```

### 2. Apply spoke second

Run in the spoke account:

```bash
cd spoke
terraform init
terraform plan
terraform apply
```

What happens in `spoke/`:
- every ALB listed in `albs` is imported into Terraform state using native import blocks and then managed as `aws_lb`
- Terraform turns on the ALB `access_logs` block for each imported ALB
- every WAF listed in `wafs` runs `aws wafv2 put-logging-configuration` during apply

AWS documents that `PutLoggingConfiguration` is the operation that associates the logging destination with a web ACL, and Terraform import only works for pre-existing resources with matching configuration.

## Verification

### Verify ALB attributes

```bash
aws elbv2 describe-load-balancer-attributes --load-balancer-arn <alb-arn>
```

Look for:
- `access_logs.s3.enabled = true`
- `access_logs.s3.bucket = <hub bucket>`
- `access_logs.s3.prefix = alb`

### Verify WAF logging

```bash
aws wafv2 get-logging-configuration --resource-arn <web-acl-arn> --region <region>
```

### Expected S3 locations

ALB:

```text
s3://<hub-bucket>/alb/AWSLogs/<spoke-account-id>/elasticloadbalancing/<region>/...
```

WAF, when `waf_prefix = "waf"`:

```text
s3://<hub-bucket>/waf/AWSLogs/<spoke-account-id>/WAFLogs/<region>/<web-acl-name>/...
```

AWS documents the WAF S3 object path under `AWSLogs/account-id/WAFLogs/Region/web-acl-name/...` following any prefix you provide.

## Notes and cautions

- The `aws_s3_bucket_policy` resource manages the **entire** bucket policy. Make sure all required statements are represented in Terraform before applying.
- The ALB resource is imported and then managed as `aws_lb`, so review the first `terraform plan` carefully for drift.
- The WAF step uses AWS CLI during `terraform apply`; the runner must have a working AWS CLI session.
