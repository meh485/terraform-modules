# Create the lambda function
resource "aws_lambda_function" "vpc_flow_log_remediation" {
  function_name    = var.lambda_function_name
  description      = "Lambda function to enable VPC flow logs on a VPC"
  filename         = data.archive_file.lambda_function.output_path
  role             = var.vpc_flow_log_remediation_role_arn
  handler          = "vpc-flow-log-remediation.lambda_handler"
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime          = var.python_runtime
  timeout          = var.lambda_function_timeout

  tags = var.tags
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "${path.module}/files/vpc-flow-log-remediation.py"
  output_path = "${path.module}/files/vpc-flow-log-remediation.zip"
}
