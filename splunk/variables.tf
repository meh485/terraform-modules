variable "region" {
  description = "The region of AWS you want to work in, such as us-west-2 or us-east-1"
}
variable "instance_size" {
  desdescription = "Instance size to use for splunk ec2 instances"
}
variable "create_vpc" {
  description = "Whether to create VPC for splunk instances or not"
  type = bool
}
variable "ebs_size" {
  description = "Size in GB for splunk instance EBS volume"
}