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

# Data blocks reference exising resource.
data "aws_vpc" "default_vpc" {
  default = true
}
data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_instance" "drupal" {
  ami             = "ami-04075458d3b9f6a5b"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
    #!/bin/bash
    echo "Hello world" > index.html
    python3 -m http.server 8080 &
    EOF
}

# Unlike variables you can define resources down the line from using it.
resource "aws_security_group" "instances" {
  name = "instance-security-group"
}
resource "aws_security_group_rule" "allow_http_inbound" {
  from_port         = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.instances.id
  to_port           = 8080
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}