resource "aws_flow_log" "vpc_flow_log" {
  depends_on = [
    aws_iam_role.vpc_flow_log_iam_role
  ]
  iam_role_arn    = "arn:aws:iam::${local.account_id}:role/${var.vpc_flow_log_iam_role_name}"
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_cw_log_group.arn
  log_format      = var.vpc_flow_log_format
  traffic_type    = var.vpc_flow_log_traffic_type
  vpc_id          = var.vpc_id
  tags            = var.tags
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_cw_log_group" {
  name              = var.cw_log_group_name
  retention_in_days = var.cw_log_group_retention
  tags              = var.tags
}

resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  depends_on = [
    aws_iam_role.cwl_to_log_destination_role[0]
  ]
  name            = var.subscription_filter_name
  role_arn        = "arn:aws:iam::${local.account_id}:role/${var.cwl_to_logs_dest_role_name}"
  log_group_name  = aws_cloudwatch_log_group.vpc_flow_log_cw_log_group.name
  filter_pattern  = var.subscription_filter_pattern
  destination_arn = var.cw_log_destination_arn
}

