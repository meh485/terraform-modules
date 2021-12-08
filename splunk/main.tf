# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE VPC, ASG and ELB to host splunk
# ---------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"
  # insert the 21 required variables here
}

module "splunk-cluster-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.9.0"
  # insert the 57 required variables here
}

module "splunk_hec_lb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "3.0.0"
  # insert the 6 required variables here
}