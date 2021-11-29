output "cloudwatch_logs_destination_arn" {
  description = "Arn of the Cloudwatch Logs Destination"
  value       = aws_cloudwatch_log_destination.cw_logs_destination.arn
}

output "backsplash_bucket_arn" {
  description = "Arn of the S3 Backsplash Bucket"
  value       = aws_s3_bucket.backsplash_bucket.arn
}

output "central_logging_kms_key_arn" {
  description = "Arn of the Central Logging KMS Key"
  value       = aws_kms_key.central_logging_kms_key.arn
}

output "firehose_lambda_transform_arn" {
  description = "Arn of the Lambda function used for Kinesis Firehose"
  value       = aws_lambda_function.firehose_lambda_transform.arn
}

output "kinesis_firehose_arn" {
  description = "Arn of the Kinesis Firehose"
  value       = aws_kinesis_firehose_delivery_stream.kinesis_firehose.arn
}
