variable "config_bucket_prefix" {
  description = "Name prefix for the AWS Config Recorder S3 Bucket"
}
variable "excluded_accounts" {
  description = "(Optional) List of AWS account identifiers to exclude from the rule"
  type = list(string)
  default = []
}
