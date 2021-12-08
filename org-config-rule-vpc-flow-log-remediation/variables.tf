variable "lambda_function_name" {
  description = "Name of the Lambda function that transforms CloudWatch data for Kinesis Firehose into Splunk compatible format"
  default     = "vpc-flow-log-remediator"
}

variable "lambda_function_timeout" {
  description = "The function execution time at which Lambda should terminate the function."
  default     = 180
}

variable "vpc_flow_log_remediation_role_arn" {
  description = "Arn of IAM Role for the lambda function"
}

variable "python_runtime" {
  description = "Runtime version of python for Lambda function"
  default     = "python3.8"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to put on the resource"
  default     = {}
}

variable "bus_name" {
  description = "Name of Eventbridge bus to create rules"
}
