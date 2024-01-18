terraform {
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

variable "db_pass" {
  description = "Password for database"
  type        = string
  sensitive   = true
}

module "drpler" {
  source = "./app-module"

  app_name         = "drpler"
  compute_instance_type    = "t2.micro"
  dns_create_zone  = true
  dns_domain           = "drpler.com"
  db_name          = "drplerdb"
  db_user          = "drpleruser"
  db_pass          = var.db_pass
}
