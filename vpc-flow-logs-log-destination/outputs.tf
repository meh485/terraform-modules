output "vpc_flow_log_id" {
  description = "Id of the VPC Flow Log"
  value       = aws_flow_log.vpc_flow_log.id
}

output "vpc_flow_log_arn" {
  description = "Arn of the VPC Flow Log"
  value       = aws_flow_log.vpc_flow_log.arn
}

output "vpc_flow_log_iam_role_arn" {
  description = "Arn of the VPC Flow Log IAM Role"
  value       = "arn:aws:iam::${local.account_id}:role/${var.vpc_flow_log_iam_role_name}"
}

output "vpc_flow_log_cw_log_group_arn" {
  description = "Arn of the Cloudwatch Log Group"
  value       = aws_cloudwatch_log_group.vpc_flow_log_cw_log_group.arn
}
