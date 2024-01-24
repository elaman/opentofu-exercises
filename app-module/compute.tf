resource "aws_instance" "app" {
  count           = var.compute_replicas
  ami             = var.compute_ami
  instance_type   = var.compute_instance_type
  security_groups = [aws_security_group.instances.name]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello world on instance #${count.index + 1} in ${var.app_environment} environment" > index.html
    python3 -m http.server 8080 &
    EOF

  tags = {
    Name        = var.app_name
    Environment = var.app_environment
  }
}

# Todo dynamic instances