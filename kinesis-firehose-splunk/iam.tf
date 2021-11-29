# --------------------------------------------------------------------------
# IAM ROLE FOR KINESIS TRANSFORM/PROCESSING LAMBDA FUNCTION
# --------------------------------------------------------------------------
resource "aws_iam_role" "kinesis_firehose_lambda" {
  name        = var.kinesis_firehose_lambda_role_name
  description = "Role for Lambda function to transformation CloudWatch logs into Splunk compatible format"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "lambda.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

data "aws_iam_policy_document" "kinesis_firehose_lambda_policy_doc" {
  statement {
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]

    resources = [
      aws_kinesis_firehose_delivery_stream.kinesis_firehose.arn
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/lambda/${var.lambda_function_name}",
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:log-stream:*"
    ]
  }
}

resource "aws_iam_policy" "lambda_transform_policy" {
  name   = var.lambda_iam_policy_name
  policy = data.aws_iam_policy_document.kinesis_firehose_lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_role_attachment" {
  role       = aws_iam_role.kinesis_firehose_lambda.name
  policy_arn = aws_iam_policy.lambda_transform_policy.arn
}

# --------------------------------------------------------------------------
# IAM ROLE FOR KINESIS DELIVERY FIREHOSE
# --------------------------------------------------------------------------
resource "aws_iam_role" "kinesis_firehose_delivery" {
  name        = var.kinesis_firehose_role_name
  description = "IAM Role for Kinesis Firehose"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "firehose.amazonaws.com"
        },
        "Action" = "sts:AssumeRole",
        "Condition" = {
          "StringEquals" : {
            "sts:ExternalId" : "${local.account_id}"
          }
        }
      }
    ]
  })
  tags = var.tags
}

data "aws_iam_policy_document" "kinesis_firehose_delivery_policy_document" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.backsplash_bucket.arn,
      "${aws_s3_bucket.backsplash_bucket.arn}/*",
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]

    resources = [
      "${aws_lambda_function.firehose_lambda_transform.arn}:${var.lambda_function_alias}",
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.kinesis_logs.arn}:log-stream:*"
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      aws_kms_key.central_logging_kms_key.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "s3.${var.region}.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values = [
        "${aws_s3_bucket.backsplash_bucket.arn}/*",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_policy" "kinesis_firehose_iam_policy" {
  name   = var.kinesis_firehose_iam_policy_name
  policy = data.aws_iam_policy_document.kinesis_firehose_delivery_policy_document.json
}

resource "aws_iam_role_policy_attachment" "kinesis_fh_role_attachment" {
  role       = aws_iam_role.kinesis_firehose_delivery.name
  policy_arn = aws_iam_policy.kinesis_firehose_iam_policy.arn
}

# --------------------------------------------------------------------------
# IAM ROLE FOR CLOUDWATCH LOGS DESTINATION
# -------------------------------------------------------------------------
resource "aws_iam_role" "cloudwatch_to_firehose_trust" {
  name        = var.cloudwatch_to_firehose_trust_iam_role_name
  description = "Role for CloudWatch Log Group subscription"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "logs.${var.region}.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

data "aws_iam_policy_document" "cloudwatch_to_fh_access_policy" {
  statement {
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]

    effect = "Allow"

    resources = [
      aws_kinesis_firehose_delivery_stream.kinesis_firehose.arn,
    ]
  }

  statement {
    actions = [
      "iam:PassRole",
    ]

    effect = "Allow"

    resources = [
      aws_iam_role.cloudwatch_to_firehose_trust.arn,
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_to_fh_access_policy" {
  name        = var.cloudwatch_to_fh_access_policy_name
  description = "Cloudwatch to Firehose Subscription Policy"
  policy      = data.aws_iam_policy_document.cloudwatch_to_fh_access_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_to_fh" {
  role       = aws_iam_role.cloudwatch_to_firehose_trust.name
  policy_arn = aws_iam_policy.cloudwatch_to_fh_access_policy.arn
}
