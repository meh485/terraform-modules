output "config_bucket_arn" {
  value       = module.s3_bucket_logging.bucket_arn
}
output "config_bucket_id" {
  value       = module.s3_bucket_logging.bucket_id
}
output "aws_config_configuration_recorder_id" {
  value = module.aws_config_recorder.aws_config_configuration_recorder_id
}
