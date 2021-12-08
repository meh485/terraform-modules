# ---------------------------------------------------------------------------------------------------------------------
# Create AWS Config Recorder and Org Rules
# https://aws.amazon.com/blogs/mt/aws-organizations-aws-config-and-terraform/
# ---------------------------------------------------------------------------------------------------------------------

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name   = var.bus_name
  create_bus = false

  rules = {
    flow_logs = {
      description   = "Capture if flow logs rule is non-compliant"
      event_pattern = jsonencode({ "source" : ["aws.config"] })
    }
  }

  targets = {
    lambda = [
      {
        name = "vpc-flow-log-remediation"
        arn  = aws_lambda_function.vpc_flow_log_remediation.arn
      }
    ]
  }

}
