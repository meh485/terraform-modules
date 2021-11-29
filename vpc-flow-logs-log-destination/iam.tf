# --------------------------------------------------------------------------
# IAM ROLE FOR VPC FLOW LOGS
# --------------------------------------------------------------------------
resource "aws_iam_role" "vpc_flow_log_iam_role" {
  count = var.create_vpc_flow_logs_role ? 1 : 0
  name  = var.vpc_flow_log_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "vpc-flow-logs.amazonaws.com"
        },
        "Action" = "sts:AssumeRole",
        "Condition" = {
          "StringEquals" : {
            "aws:SourceAccount" : "${local.account_id}"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "vpc_flow_log_iam_role_policy" {
  count = var.create_vpc_flow_logs_role ? 1 : 0
  name  = "${var.vpc_flow_log_iam_role_name}Policy"
  role  = aws_iam_role.vpc_flow_log_iam_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Action" = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Resource" = "*"
      }
    ]
  })

}

# --------------------------------------------------------------------------
# IAM ROLE CLOUDWATCH LOGS SUBSCRIPTION FILTER
# --------------------------------------------------------------------------
resource "aws_iam_role" "cwl_to_log_destination_role" {
  count = var.create_cwl_to_logs_dest_role ? 1 : 0
  name  = var.cwl_to_logs_dest_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "logs.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}
