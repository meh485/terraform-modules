# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE KMS KEY TO ENCRYPT LOGS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "central_logging_kms_key" {
  enable_key_rotation = true
  policy              = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::${local.account_id}:root"},
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_kms_alias" "central_logging_kms_key_alias" {
  name          = var.kms_alias
  target_key_id = aws_kms_key.central_logging_kms_key.id
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE S3 BUCKET FOR KINESIS DATA FIREHOSE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "backsplash_bucket" {
  bucket = var.backsplash_bucket_name
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.central_logging_kms_key.arn
      }
    }
  }
  lifecycle_rule {
    id      = "DeleteBucketObjects"
    enabled = true
    expiration {
      days = var.backsplash_bucket_expire_days
    }
  }
}
resource "aws_s3_bucket_public_access_block" "backsplash_bucket_bpa" {
  bucket = aws_s3_bucket.backsplash_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
resource "aws_s3_bucket_policy" "backsplash_bucket_policy" {
  bucket = aws_s3_bucket.backsplash_bucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        "Sid"       = "DenyUnEncryptedObjectUploads",
        "Effect"    = "Deny",
        "Principal" = "*",
        "Action"    = "s3:PutObject",
        "Resource"  = "${aws_s3_bucket.backsplash_bucket.arn}/*",
        "Condition" = {
          "StringNotEquals" : {
            "s3:x-amz-server-side-encryption" : "aws:kms"
          }
        }
      },
      {
        "Sid"       = "DenyInsecureConnections",
        "Effect"    = "Deny",
        "Principal" = "*",
        "Action"    = "s3:*",
        "Resource"  = "${aws_s3_bucket.backsplash_bucket.arn}/*",
        "Condition" = {
          "Bool" = {
            "aws:SecureTransport" : "false"
          }
        }
      },
      {
        "Sid"    = "Firehose Access to Bucket",
        "Effect" = "Allow",
        "Principal" = {
          "AWS" = aws_iam_role.kinesis_firehose_delivery.arn
        },
        "Action" = [
          "s3:AbortMultipartUpload",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Resource" = [
          aws_s3_bucket.backsplash_bucket.arn,
          "${aws_s3_bucket.backsplash_bucket.arn}/*"
        ]
      }
    ]
  })
}
