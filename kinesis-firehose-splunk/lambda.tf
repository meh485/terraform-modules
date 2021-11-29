# Create the lambda function
# The lambda function to transform data from compressed format in Cloudwatch to something Splunk can handle (uncompressed)
resource "aws_lambda_function" "firehose_lambda_transform" {
  function_name    = var.lambda_function_name
  description      = "Transform data from CloudWatch format to Splunk compatible format"
  filename         = data.archive_file.lambda_function.output_path
  role             = aws_iam_role.kinesis_firehose_lambda.arn
  handler          = "kinesis-firehose-cloudwatch-logs-processor.lambda_handler"
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime          = var.python_runtime
  timeout          = var.lambda_function_timeout
  publish          = true

  tags = var.tags
}

resource "aws_lambda_alias" "firehose_lambda_function_alias" {
  name             = var.lambda_function_alias
  function_name    = aws_lambda_function.firehose_lambda_transform.function_name
  function_version = aws_lambda_function.firehose_lambda_transform.version
}

# kinesis-firehose-cloudwatch-logs-processor.py was taken by copy/paste from the AWS UI.  It is predefined blueprint
# code supplied to AWS by Splunk.
data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "${path.module}/files/kinesis-firehose-cloudwatch-logs-processor.py"
  output_path = "${path.module}/files/kinesis-firehose-cloudwatch-logs-processor.zip"
}
