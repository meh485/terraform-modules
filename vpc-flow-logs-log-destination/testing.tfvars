region = "us-east-2"
vpc_id = "vpc-0196afe5b6648c77d"
cw_log_group_name = "/aws/vpc/flowlogs"
cw_log_group_retention = "7"
create_vpc_flow_logs_role = true
vpc_flow_log_iam_role_name = "VpcFlowLogRole"

create_cwl_to_logs_dest_role = true
cwl_to_logs_dest_role_name = "CWLToLogDestination"
cw_log_destination_arn = "arn:aws:logs:us-east-2:575545547189:destination:CentralCWLogDestination"
subscription_filter_name = "CWLToSplunk"
