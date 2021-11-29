variable "region" {
  description = "The region of AWS you want to work in, such as us-west-2 or us-east-1"
}

variable "hec_url" {
  description = "Splunk Kinesis URL for submitting CloudWatch logs to splunk"
}

variable "kms_alias" {
  description = "Alias for KMS CMK used for encrypting Kinesis firehose and s3 bucket"
}

variable "hec_token_secret_id" {
  description = "AWS Secrets Manager secret id containing hec token"
}
variable "python_runtime" {
  description = "Runtime version of python for Firehose Lambda transform function"
  default     = "python3.8"
}

variable "firehose_name" {
  description = "Name of the Kinesis Firehose"
  default     = "kinesis-firehose-to-splunk"
}

variable "kinesis_firehose_buffer" {
  description = "https://www.terraform.io/docs/providers/aws/r/kinesis_firehose_delivery_stream.html#buffer_size"
  default     = 5 # Megabytes
}

variable "kinesis_firehose_buffer_interval" {
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination"
  default     = 300 # Seconds
}

variable "s3_prefix" {
  description = "Optional prefix (a slash after the prefix will show up as a folder in the s3 bucket).  The YYYY/MM/DD/HH time format prefix is automatically used for delivered S3 files."
  default     = "kinesis-firehose/"
}

variable "hec_acknowledgment_timeout" {
  description = "The amount of time, in seconds between 180 and 600, that Kinesis Firehose waits to receive an acknowledgment from Splunk after it sends it data."
  default     = 300
}

variable "hec_endpoint_type" {
  description = "Splunk HEC endpoint type; `Raw` or `Event`"
  default     = "Raw"
}

variable "s3_backup_mode" {
  description = "Defines how documents should be delivered to Amazon S3. Valid values are FailedEventsOnly and AllEvents."
  default     = "FailedEventsOnly"
}

variable "s3_compression_format" {
  description = "The compression format for what the Kinesis Firehose puts in the s3 bucket"
  default     = "GZIP"
}

variable "enable_fh_cloudwatch_logging" {
  description = "Enable kinesis firehose CloudWatch logging. (It only logs errors)"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to put on the resource"
  default     = {}
}

variable "cloudwatch_log_retention" {
  description = "Length in days to keep CloudWatch logs of Kinesis Firehose"
  default     = 7
}

variable "log_stream_name" {
  description = "Name of the CloudWatch log stream for Kinesis Firehose CloudWatch log group"
  default     = "SplunkDelivery"
}

variable "backsplash_bucket_name" {
  description = "Name of the s3 bucket Kinesis Firehose uses for backups"
}

variable "backsplash_bucket_expire_days" {
  description = "Number of days to delete objects in the backsplash bucket"
  default     = 30
}

variable "kinesis_firehose_lambda_role_name" {
  description = "Name of IAM Role for Lambda function that transforms CloudWatch data for Kinesis Firehose into Splunk compatible format"
  default     = "KinesisFirehoseToLambaRole"
}

variable "kinesis_firehose_role_name" {
  description = "Name of IAM Role for the Kinesis Firehose"
  default     = "KinesisFirehoseRole"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function that transforms CloudWatch data for Kinesis Firehose into Splunk compatible format"
  default     = "kinesis-firehose-transform"
}

variable "lambda_function_timeout" {
  description = "The function execution time at which Lambda should terminate the function."
  default     = 180
}

variable "lambda_function_alias" {
  description = "Name of the alias Kinesis firehose will use"
  default     = "prod"

}

variable "lambda_iam_policy_name" {
  description = "Name of the IAM policy that is attached to the IAM Role for the lambda transform function"
  default     = "Kinesis-Firehose-to-Splunk-Policy"
}

variable "kinesis_firehose_iam_policy_name" {
  description = "Name of the IAM Policy attached to IAM Role for the Kinesis Firehose"
  default     = "KinesisFirehose-Policy"
}

variable "cloudwatch_to_firehose_trust_iam_role_name" {
  description = "IAM Role name for CloudWatch to Kinesis Firehose subscription"
  default     = "CloudWatchToSplunkFirehoseTrust"
}

variable "cloudwatch_to_fh_access_policy_name" {
  description = "Name of IAM policy attached to the IAM role for CloudWatch to Kinesis Firehose subscription"
  default     = "KinesisCloudWatchToFirehosePolicy"
}

variable "cloudwatch_logs_dest_name" {
  description = "Name of the Cloudwatch Logs Destination that accepts logs and forwards to Firehose"
}

variable "organization_id" {
  description = "The AWS Organization Id to allow using logs destination"
}
