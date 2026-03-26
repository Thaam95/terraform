# Optional:
# If the hub bucket policy already exists and you want Terraform to adopt it
# before replacing it, import it manually with:
#
# terraform import module.hub_s3_policy.aws_s3_bucket_policy.this <hub-bucket-name>
#
# This repository does not use a native import block here so it works whether
# the bucket currently has a policy or not.
