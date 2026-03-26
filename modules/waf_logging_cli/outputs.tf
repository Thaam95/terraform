output "configured_wafs" {
  value = {
    for k, v in terraform_data.put_logging_configuration :
    k => v.output
  }
}
