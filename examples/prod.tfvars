region = "us-east-1"
#bucket = "fins-dev-bucket-test"

bucket = ["cms-cloudeq-bucket-dev", "cms-cloudeq-bucket-prod", "cms-cloudeq-bucket-qa"]

force_destroy       = false
object_lock_enabled = true
common_tags = {
  Owner = "siddharth.awasthi@cloudeq.com"
}

s3_tags = {

  "product" = "cms"
}

acceleration_status = "Suspended"
request_payer       = "BucketOwner"

logging = {
  target_bucket = ""
  target_prefix = "log/"
}

server_side_encryption_configuration = {
  rule = {
    apply_server_side_encryption_by_default = {
      sse_algorithm = "AES256"
    }
  }
}

object_lock_configuration = {
  rule = {
    default_retention = {
      mode = "GOVERNANCE"
      days = 1
    }
  }
}


versioning = {
  status     = true
  mfa_delete = false
}

acl = "private"

lifecycle_rule = [
  {
    id      = "After 30 days to archive"
    enabled = false

    filter = { ####### lifecycle rule s3#######
      tags = {
        some    = "value"
        another = "value2"
      }
    }

    transition = [
      {
        days          = 30
        storage_class = "GLACIER"
      }
    ]
  },
  {
    id                                     = "log1"
    enabled                                = false
    abort_incomplete_multipart_upload_days = 7

    noncurrent_version_transition = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 60
        storage_class = "ONEZONE_IA"
      },
      {
        days          = 90
        storage_class = "GLACIER"
      },
    ]

    noncurrent_version_expiration = {
      days = 300
    }
  },
  {
    id      = "log2"
    enabled = false

    filter = {
      prefix                   = "log1/"
      object_size_greater_than = 200000
      object_size_less_than    = 500000
      tags = {
        some    = "value"
        another = "value2"
      }
    }

    noncurrent_version_transition = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
    ]

    noncurrent_version_expiration = {
      days = 300
    }
  },
]


intelligent_tiering = {
  general = {
    status = "disabled"
    filter = {
      prefix = "/"
      tags = {
        Environment = "dev"
      }
    }
    tiering = {
      ARCHIVE_ACCESS = {
        days = 180
      }
    }
  },
  documents = {
    status = false
    filter = {
      prefix = "documents/"
    }
    tiering = {
      ARCHIVE_ACCESS = {
        days = 125
      }
      DEEP_ARCHIVE_ACCESS = {
        days = 200
      }
    }
  }
}

metric_configuration = [
  {
    name = "documents"
    filter = {
      prefix = "documents/"
      tags = {
        priority = "high"
      }
    }
  },
  {
    name = "other"
    filter = {
      tags = {
        production = "true"
      }
    }
  },
  {
    name = "all"
  }
]


#Bucket policies
attach_policy                         = false
attach_deny_insecure_transport_policy = false
attach_require_latest_tls_policy      = false


#S3 bucket-level Public Access Block configuration
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true

#S3 Bucket Ownership Controls
control_object_ownership = true
object_ownership         = "BucketOwnerPreferred"



