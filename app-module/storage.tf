# S3 bucket to store open tofu state.
resource "aws_s3_bucket" "bucket_tfstate" {
  force_destroy = true
  bucket = "opentofu-tfstate"
}

resource "aws_s3_bucket_versioning" "bucket_versioning_tfstate" {
  bucket = aws_s3_bucket.bucket_tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_tfstate_encryption" {
  bucket = aws_s3_bucket.bucket_tfstate.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Prevent simultaneous changes to the state.
resource "aws_dynamodb_table" "tfstate_locks" {
  hash_key = "LockID"
  name     = "tfstate-locking"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}