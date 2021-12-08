# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE EVENTBRIDGE and PERMISSIONS
# ---------------------------------------------------------------------------------------------------------------------

module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "1.13.2"
  # insert the 6 required variables here
  bus_name = var.bus_name
}

resource "aws_cloudwatch_event_permission" "OrganizationAccess" {
  principal    = "*"
  statement_id = "OrganizationAccess"
  action       = "events:PutEvents"

  condition {
    key   = "aws:PrincipalOrgID"
    type  = "StringEquals"
    value = var.organization_id
  }
}
