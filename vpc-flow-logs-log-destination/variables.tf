variable "vpc_id" {
  description = "Id of the VPC to enable flow logs"
}

variable "region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "cw_log_group_name" {
  description = "Name of CloudWatch Log Group to send VPC Flow Logs"
}

variable "cw_log_group_retention" {
  description = "Number of days to retain vpc flow logs in the log group"
  type        = Number
  default     = 7
}

variable "vpc_flow_log_traffic_type" {
  description = "Type of traffic for VPC Flow logs to monitor"
  default     = "ALL"
}

variable "cw_log_destination_arn" {
  description = "CloudWatch Logs Destination Arn to subscribe to sent to Splunk"
}

variable "create_cwl_to_logs_dest_role" {
  description = "Whether to create the IAM role to subscribe log group to log destination. If false, cwl_to_logs_dest_role_name must already exist. If true an IAM role with name cwl_to_logs_dest_role_name will be created"
  type        = bool
}

variable "cwl_to_logs_dest_role_name" {
  description = "Name of the IAM role allowing logs.amazonaws.com to trust. This role does not need any policy, it is used just to authenticate the source account to the log destination"
}

variable "create_vpc_flow_logs_role" {
  description = "Whether to create the IAM role so VPC Flow logs can write to Cloudwatch logs. If false, vpc_flow_log_iam_role_name must already exist. If true an IAM role with name vpc_flow_log_iam_role_name will be created"
  type        = bool
}

variable "vpc_flow_log_iam_role_name" {
  description = "Name of the IAM role for VPC Flow Logs. This role must exist if create_vpc_flow_logs_role is false"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to put on the resource"
  default     = {}
}

variable "subscription_filter_name" {
  description = "Name of the Cloudwatch logs subscription filter"
}

variable "subscription_filter_pattern" {
  description = "Cloudwatch logs subscription filter pattern"
  default     = ""
}

variable "vpc_flow_log_format" {
  description = "(Optional) The fields to include in the flow log record, in the order in which they should appear."
  default     = null
}
