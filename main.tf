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

resource "aws_instance" "drupal" {
  ami           = "ami-04075458d3b9f6a5b"
  instance_type = "t2.micro"
}
