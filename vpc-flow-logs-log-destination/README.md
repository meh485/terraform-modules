# VPC Flow Logs to Centralized Log Destination

This module creates a VPC Flow log for an existing VPC and creates a Cloudwatch Log Subscription filter to Cloudwatch Log Destination

## Usage Instructions

This module offers creating IAM roles for VPC Flow Logs and Subscription filter.

Below example shows it creating new IAM roles

##### Example
```
module "vpc_flow_logs" {
  source = "github.com/meh485/terraform-modules/vpc-flow-logs-log-destination"
  vpc_id = "<VPC Id to create flow logs>"
  cw_log_group_name = "<Cloduwatch Log Group name to store VPC Flow Logs>"
  cw_log_group_retention = <Number of days to retain logs>
  create_vpc_flow_logs_role = true
  vpc_flow_log_iam_role_name = <Name of IAM Role>
  create_cwl_to_logs_dest_role = true
  cwl_to_logs_dest_role_name = <Name of IAM Role>
  cw_log_destination_arn = <Arn of the Cloudwatch Log Destination>
  subscription_filter_name = <Name of subscription filter>
}

```

### Inputs

| Variable Name | Description | Type  | Default | Required |
|---------------|-------------|-------|---------|----------|
| region | The region of AWS you want to work in, such as us-west-2 or us-east-1 | string | - | yes |
| vpc_id | VPC Id which vpc flow logs will be created for. | string | - | yes |
| cw_log_group_name | Cloduwatch Log Group name to store VPC Flow Logs | string | - | yes |
| cw_log_group_retention | Number of days to retain logs | integer | `7` | no |
| vpc_flow_log_traffic_type | Type of traffic for VPC Flow logs to monitor. | string | `ALL` | no |
| cw_log_destination_arn | CloudWatch Logs Destination Arn to subscribe to sent to Splunk | string | - | yes |
| create_cwl_to_logs_dest_role  | Whether to create the IAM role to subscribe log group to log destination. If false, cwl_to_logs_dest_role_name must already exist. If true an IAM role with name cwl_to_logs_dest_role_name will be created | bool | - | yes |
| cwl_to_logs_dest_role_name | Name of the IAM role allowing logs.amazonaws.com to trust. This role does not need any policy, it is used just to authenticate the source account to the log destination | string | - | yes |
| create_vpc_flow_logs_role | Whether to create the IAM role so VPC Flow logs can write to Cloudwatch logs. If false, vpc_flow_log_iam_role_name must already exist. If true an IAM role with name vpc_flow_log_iam_role_name will be created | bool | - | yes |
| vpc_flow_log_iam_role_name | Name of the IAM role for VPC Flow Logs. This role must exist if create_vpc_flow_logs_role is false. | string | - | yes |
| subscription_filter_name | Name of the Cloudwatch logs subscription filter. | string | - | yes |
| subscription_filter_pattern | Cloudwatch logs subscription filter pattern. | string | `""` | no |
| vpc_flow_log_format | (Optional) The fields to include in the flow log record, in the order in which they should appear. | string | `null` | no |
| tags | Map of tags to put on the resource | map | `null` | no |
|

### Outputs

| Name | Description |
|------|-------------|
| vpc_flow_log_id | Id of the VPC Flow Log |
| vpc_flow_log_arn | Arn of the VPC Flow Log |
| vpc_flow_log_iam_role_arn | Arn of the VPC Flow Log IAM Role |
| vpc_flow_log_cw_log_group_arn | Arn of the Cloudwatch Log Group |
|
