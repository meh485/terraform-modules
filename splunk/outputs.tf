output "hec_url" {
  description = "HEC url"
  value       = "https://${splunk_hec_lb.elb_dns_name}/"
}
