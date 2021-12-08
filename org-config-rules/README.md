# Splunk

This module creates a Splunk cluster hosted on EC2. It also offers to create a VPC.

##### Example
```
module "splunk" {
  source = "github.com/meh485/terraform-modules/splunk"
  region = "us-east-1"
  instance_size = "m5.xlarge"
  create_vpc = true
  ebs_size = "50gb"
  ....
  ....
  ....
}

```

### Outputs

| Name | Description |
|------|-------------|
| hec_url | Http Endpoint Collector Endpoint URL |
