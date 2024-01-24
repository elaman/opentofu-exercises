resource "aws_db_instance" "db_instance" {
  allocated_storage     = 10
  max_allocated_storage = 10
  storage_type          = "gp2"
  instance_class        = "db.t2.micro"
  engine                = "mariadb"
  engine_version        = "10.6.14"
  name                  = var.db_name # deprecated?
  username              = var.db_user
  password              = var.db_pass
  skip_final_snapshot   = true

  tags = {
    Name = var.app_name
    Environment = var.app_environment
  }
}
