resource "aws_db_instance" "db_instance" {
  allocated_storage   = 20
  storage_type        = "gp3"
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t4g.micro"
  db_name             = var.db_name
  username            = var.db_user
  password            = var.db_pass
  skip_final_snapshot = true
}
