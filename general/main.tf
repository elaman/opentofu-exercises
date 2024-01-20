terraform {
  backend "s3" {
    bucket         = "drupalhosting-tfstate"
    key            = "general/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "drupalhosting-tfstate-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# S3 bucket to store open tofu state.
resource "aws_s3_bucket" "bucket_tfstate" {
  force_destroy = true
  bucket = "drupalhosting-tfstate"
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
  name     = "drupalhosting-tfstate-locking"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}