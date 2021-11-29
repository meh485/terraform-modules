# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE KINESIS DATA FIREHOSE
# ---------------------------------------------------------------------------------------------------------------------
# Kinesis firehose stream
# Record Transformation Required, called "processing_configuration" in Terraform
resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose" {
  name        = var.firehose_name
  destination = "splunk"

  s3_configuration {
    role_arn           = aws_iam_role.kinesis_firehose_delivery.arn
    prefix             = var.s3_prefix
    bucket_arn         = aws_s3_bucket.backsplash_bucket.arn
    buffer_size        = var.kinesis_firehose_buffer
    buffer_interval    = var.kinesis_firehose_buffer_interval
    compression_format = var.s3_compression_format
    kms_key_arn        = aws_kms_key.central_logging_kms_key.arn
  }

  splunk_configuration {
    hec_endpoint               = var.hec_url
    hec_token                  = data.aws_secretsmanager_secret_version.splunk_hec_token.secret_string
    hec_acknowledgment_timeout = var.hec_acknowledgment_timeout
    hec_endpoint_type          = var.hec_endpoint_type
    s3_backup_mode             = var.s3_backup_mode

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.firehose_lambda_transform.arn}:${var.lambda_function_alias}"
        }
        parameters {
          parameter_name  = "RoleArn"
          parameter_value = aws_iam_role.kinesis_firehose_delivery.arn
        }
      }
    }

    cloudwatch_logging_options {
      enabled         = var.enable_fh_cloudwatch_logging
      log_group_name  = aws_cloudwatch_log_group.kinesis_logs.name
      log_stream_name = aws_cloudwatch_log_stream.kinesis_logs.name
    }
  }

  server_side_encryption {
    enabled  = true
    key_type = "CUSTOMER_MANAGED_CMK"
    key_arn  = aws_kms_key.central_logging_kms_key.arn
  }

  tags = var.tags
}

# Cloudwatch logging group for Kinesis Firehose
resource "aws_cloudwatch_log_group" "kinesis_logs" {
  name              = "/aws/kinesisfirehose/${var.firehose_name}"
  retention_in_days = var.cloudwatch_log_retention

  tags = var.tags
}

# Create the stream
resource "aws_cloudwatch_log_stream" "kinesis_logs" {
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.kinesis_logs.name
}

# handle the sensitivity of the hec_token variable
data "aws_secretsmanager_secret_version" "splunk_hec_token" {
  secret_id = var.hec_token_secret_id
}

resource "aws_cloudwatch_log_destination" "cw_logs_destination" {
  name       = var.cloudwatch_logs_dest_name
  role_arn   = aws_iam_role.cloudwatch_to_firehose_trust.arn
  target_arn = aws_kinesis_firehose_delivery_stream.kinesis_firehose.arn

}

data "aws_iam_policy_document" "cw_logs_destination_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = ["*"]

    }

    actions = [
      "logs:PutSubscriptionFilter",
    ]

    resources = [
      aws_cloudwatch_log_destination.cw_logs_destination.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.organization_id]
    }
  }
}

resource "aws_cloudwatch_log_destination_policy" "cw_logs_destination_policy" {
  destination_name = aws_cloudwatch_log_destination.cw_logs_destination.name
  access_policy    = data.aws_iam_policy_document.cw_logs_destination_policy_doc.json
}
