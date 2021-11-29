# Kinesis Firehose to Splunk

This module creates a Kinesis Firehose Delivery Stream and all supporting infrastructure required to allow accounts
within an AWS Organization to deliver their logs to Splunk via Cloudwatch Log Destination

## Usage Instructions

In order to configure the Kinesis Firehose data to Splunk you will need to first obtain an HEC Token from your Splunk administrator and store it into AWS Secrets Manager.

Once you have the AWS Secrets Manager Id, you can proceed forward in creating a `module` resource, such as the one in the Example below.

##### Example
```
module "kinesis_firehose" {
  source = "github.com/meh485/terraform-modules/kinesis-firehose-splunk"
  hec_url = "<Splunk_Kinesis_ingest_URL>"
  hec_token_secret_id = "<Secret Id of HEC token stored in AWS Secretes Manager>"
  backsplash_bucket_name = "<mybucketname>"
  kms_alias = "alias/central-logging"
  cloudwatch_logs_dest_name = "CentralCWLogDestination"
  python_runtime = "python3.8"
  organization_id = "<AWS Organization Id>"
}

```

### Inputs

| Variable Name | Description | Type  | Default | Required |
|---------------|-------------|-------|---------|----------|
| region | The region of AWS you want to work in, such as us-west-2 or us-east-1 | string | - | yes |
| hec_token_secret_id | AWS Secrets Manager secret with the Splunk security token needed to submit data to Splunk vai HEC URL. | string | - | yes |
| hec_url | Splunk Kinesis URL for submitting CloudWatch logs to splunk | string | - | yes |
| hec_endpoint_type | The Splunk HEC endpoint type. | string | `Raw` | no |
| kms_alias | Alias to assign to the KMS Key used for encrypting S3 bucket and Firehose. | string | - | yes |
| python_runtime | Runtime version of python for Lambda function | string | `python3.8` | no |
| firehose_name  | Name of the Kinesis Firehose | string | `kinesis-firehose-to-splunk` | no |
| kinesis_firehose_buffer | Best to read it [here](https://www.terraform.io/docs/providers/aws/r/kinesis_firehose_delivery_stream.html#buffer_size) | integer | `5` | no |
| kinesis_firehose_buffer_interval | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination | integer | `300` | no |
| s3_prefix | Optional prefix (a slash after the prefix will show up as a folder in the s3 bucket).  The "YYYY/MM/DD/HH" time format prefix is automatically used for delivered S3 files. | string | `kinesis-firehose/` | no |
| hec_acknowledgment_timeout | The amount of time, in seconds between 180 and 600, that Kinesis Firehose waits to receive an acknowledgment from Splunk after it sends it data. | integer | `300` | no |
| s3_backup_mode | Defines how documents should be delivered to Amazon S3. Valid values are `FailedEventsOnly` and `AllEvents`. | string | `FailedEventsOnly` | no |
| enable_fh_cloudwatch_logging | Enable kinesis firehose CloudWatch logging. (It only logs errors). | boolean | `true` | no |
| tags | Map of tags to put on the resource | map | `null` | no |
| cloudwatch_log_retention | Length in days to keep CloudWatch logs of Kinesis Firehose | integer | `30` | no |
| log_stream_name | Name of the CloudWatch log stream for Kinesis Firehose CloudWatch log group | string | `SplunkDelivery` | no |
| backsplash_bucket_name  | Name of the S3 bucket Kinesis Firehose uses for backups | string | - | yes |
| backsplash_bucket_expire_days  | Number of days to expire objects in the backsplash bucket | integer | `30` | no |
| s3_compression_format | The compression format for what the Kinesis Firehose puts in the s3 bucket | string | `GZIP` | no |
| kinesis_firehose_lambda_role_name | Name of IAM Role for Lambda function that transforms CloudWatch data for Kinesis Firehose into Splunk compatible format | string | `KinesisFirehoseToLambaRole` | no |
| lambda_iam_policy_name | Name of the IAM policy that is attached to the IAM Role for the lambda transform function | string | `Kinesis-Firehose-to-Splunk-Policy` | no |
| lambda_function_name | The name of the lambda function used to process/transform records. | string | `kinesis-firehose-transform` | no |
| lambda_function_timeout | The function execution time at which Lambda should terminate the function. | integer | `180` | no |
| lambda_function_alias | The published alias used by the Kinesis Firehose. | string | `prod` | no |
| kinesis_firehose_role_name | IAM Role name for Kinesis Firehose Delievry Stream | string | `KinesisFirehoseRole` | no |
| kinesis_firehose_iam_policy_name | Name of the IAM Policy attached to IAM Role for the Kinesis Firehose | string | `KinesisFirehose-Policy` | no |
| cloudwatch_to_firehose_trust_iam_role_name | IAM Role name for CloudWatch to Kinesis Firehose subscription | string | `CloudWatchToSplunkFirehoseTrust` | no |
| cloudwatch_to_fh_access_policy_name | Name of IAM policy attached to the IAM role for CloudWatch to Kinesis Firehose subscription | string | `KinesisCloudWatchToFirehosePolicy` | no |
| cloudwatch_logs_dest_name | Name of Cloudwatch Log Destination used to accept cross-account logs | string | - | yes |
| organization_id | AWS Organizations Id used to allow the orgnanization permission to use the Cloudwatch Log Destination | string | - | yes |
|

### Outputs

| Name | Description |
|------|-------------|
| cloudwatch_logs_destination_arn | CloudWatch log destination Arn, used as destination when creating Cloudwatch log subscription filter |
| backsplash_bucket_arn | Backsplash S3 bucket arn |
| central_logging_kms_key_arn | Kms Key arn used for encrypting S3 bucket and Firehose |
| firehose_lambda_transform_arn | Lambda function arn used for transforming/processing records |
| kinesis_firehose_arn | Kinesis Firehose Delievryy Stream Arn |
