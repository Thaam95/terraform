output "rendered_policy_json" {
  value = data.aws_iam_policy_document.this.json
}
