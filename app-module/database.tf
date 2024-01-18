resource "aws_db_instance" "db_instance" {
  allocated_storage   = 20
  storage_type        = "standard"
  engine              = "mysql"
  engine_version      = "8.0.35"
  name                = var.db_name # deprecated?
  username            = var.db_user
  password            = var.db_pass
  skip_final_snapshot = true
  instance_class      = "db.t2.micro"
}
