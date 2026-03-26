resource "terraform_data" "put_logging_configuration" {
  for_each = var.wafs

  input = {
    resource_arn     = each.value.arn
    destination_arn  = var.waf_log_destination_arn
    region           = each.value.region
  }

  provisioner "local-exec" {
    command = "aws wafv2 put-logging-configuration --region ${self.input.region} --logging-configuration ResourceArn=${self.input.resource_arn},LogDestinationConfigs=${self.input.destination_arn}"
  }
}
