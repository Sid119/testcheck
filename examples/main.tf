# resource "aws_iam_role" "this" {
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }


# data "aws_iam_policy_document" "bucket_policy" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_role.this.arn]
#     }

#     actions = [
#       "s3:ListBucket",
#     ]

#     resources = [
#       "arn:aws:s3:::${var.bucket}",
#     ]
#   }
# }

data "aws_caller_identity" "current" {}

module "s3" {
  source = "../"

             
  # count = length(var.bucket)
  for_each = toset(var.bucket)
  region              = var.region 
  #bucket              = "cms-ceq-dev-bucket"   # 
  #bucket              = var.bucket[count.index]
  bucket              = each.value
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  common_tags         = var.common_tags
  s3_tags             = var.s3_tags

  acceleration_status = var.acceleration_status
  request_payer       = var.request_payer

  # logging                              = var.logging
  server_side_encryption_configuration = var.server_side_encryption_configuration
  object_lock_configuration            = var.object_lock_configuration
  versioning                           = var.versioning
  acl                                  = var.acl
  lifecycle_rule                       = var.lifecycle_rule
  intelligent_tiering                  = var.intelligent_tiering
  metric_configuration                 = var.metric_configuration

  #Bucket policies
  attach_policy = var.attach_policy
  #policy                                = data.aws_iam_policy_document.bucket_policy.json
  attach_deny_insecure_transport_policy = var.attach_deny_insecure_transport_policy
  attach_require_latest_tls_policy      = var.attach_require_latest_tls_policy

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  # S3 Bucket Ownership Controls
  control_object_ownership = var.control_object_ownership
  object_ownership         = var.object_ownership
  expected_bucket_owner    = data.aws_caller_identity.current.account_id
}


# module "s3-1" {
#   source = "../"

#   region              = var.region
#   bucket              = "cms-ceq-bucket-prod"
#   force_destroy       = var.force_destroy
#   object_lock_enabled = var.object_lock_enabled
#   common_tags         = var.common_tags
#   s3_tags             = var.s3_tags

#   acceleration_status = var.acceleration_status
#   request_payer       = var.request_payer

#   # logging                              = var.logging
#   server_side_encryption_configuration = var.server_side_encryption_configuration
#   object_lock_configuration            = var.object_lock_configuration
#   versioning                           = var.versioning
#   acl                                  = var.acl
#   lifecycle_rule                       = var.lifecycle_rule
#   intelligent_tiering                  = var.intelligent_tiering
#   metric_configuration                 = var.metric_configuration

#   #Bucket policies
#   attach_policy = var.attach_policy
#   #policy                                = data.aws_iam_policy_document.bucket_policy.json
#   attach_deny_insecure_transport_policy = var.attach_deny_insecure_transport_policy
#   attach_require_latest_tls_policy      = var.attach_require_latest_tls_policy

#   # S3 bucket-level Public Access Block configuration
#   block_public_acls       = var.block_public_acls
#   block_public_policy     = var.block_public_policy
#   ignore_public_acls      = var.ignore_public_acls
#   restrict_public_buckets = var.restrict_public_buckets

#   # S3 Bucket Ownership Controls
#   control_object_ownership = var.control_object_ownership
#   object_ownership         = var.object_ownership
#   expected_bucket_owner    = data.aws_caller_identity.current.account_id
# }

# module "s3-2" {
#   source = "../"

#   region              = var.region
#   bucket              = "cms-ceq-bucket-test"
#   force_destroy       = var.force_destroy
#   object_lock_enabled = var.object_lock_enabled
#   common_tags         = var.common_tags
#   s3_tags             = var.s3_tags

#   acceleration_status = var.acceleration_status
#   request_payer       = var.request_payer

#   # logging                              = var.logging
#   server_side_encryption_configuration = var.server_side_encryption_configuration
#   object_lock_configuration            = var.object_lock_configuration
#   versioning                           = var.versioning
#   acl                                  = var.acl
#   lifecycle_rule                       = var.lifecycle_rule
#   intelligent_tiering                  = var.intelligent_tiering
#   metric_configuration                 = var.metric_configuration

#   #Bucket policies
#   attach_policy = var.attach_policy
#   #policy                                = data.aws_iam_policy_document.bucket_policy.json
#   attach_deny_insecure_transport_policy = var.attach_deny_insecure_transport_policy
#   attach_require_latest_tls_policy      = var.attach_require_latest_tls_policy

#   # S3 bucket-level Public Access Block configuration
#   block_public_acls       = var.block_public_acls
#   block_public_policy     = var.block_public_policy
#   ignore_public_acls      = var.ignore_public_acls
#   restrict_public_buckets = var.restrict_public_buckets

#   # S3 Bucket Ownership Controls
#   control_object_ownership = var.control_object_ownership
#   object_ownership         = var.object_ownership
#   expected_bucket_owner    = data.aws_caller_identity.current.account_id
# }
