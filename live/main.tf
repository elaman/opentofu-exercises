terraform {
  # S3 and DynamoDB is created in general folder.
  backend "s3" {
    bucket         = "drupalhosting-tfstate"
    key            = "live/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "drupalhosting-tfstate-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "db_pass" {
  description = "Password for database"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "CloudFlare API token"
  type        = string
  sensitive   = true
}

locals {
  environment = "live"
}

module "drpler" {
  source = "../app-module"

  app_name              = "drpler"
  app_environment       = local.environment
  compute_instance_type = "t2.micro"
  dns_domain            = "drpler.com"
  db_name               = "drpler${local.environment}"
  db_user               = "drpleruser"
  db_pass               = var.db_pass
}
