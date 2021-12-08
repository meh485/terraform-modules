# ---------------------------------------------------------------------------------------------------------------------
# Create AWS Config Recorder and Org Rules
# https://aws.amazon.com/blogs/mt/aws-organizations-aws-config-and-terraform/
# ---------------------------------------------------------------------------------------------------------------------

module "s3_bucket_logging" {
  source      = "StratusGrid/s3-bucket-logging/aws"
  version     = "1.2.1"
  name_prefix = var.config_bucket_prefix
}

module "aws_config_recorder" {
  source                        = "StratusGrid/config-recorder/aws"
  version                       = "1.0.1"
  log_bucket_id                 = module.s3_bucket_logging.bucket_id
  include_global_resource_types = true
}


# AWS Config Rule that checks if vpc flow logs are enabled
resource "aws_config_organization_managed_rule" "vpc_flow_logs_enabled_organization_config_rule" {
  count = local.region == "us-east-1" ? 1 : 0
  depends_on = [
    aws_config_configuration_recorder.config_recorder
  ]
  name              = "vpc-flow-logs-enabled"
  rule_identifier   = "VPC_FLOW_LOGS_ENABLED"
  excluded_accounts = var.excluded_accounts
}
