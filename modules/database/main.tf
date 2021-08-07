resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_db_instance" "db" {
  name                   = "test_app_db"
  allocated_storage      = 10
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  identifier             = "${var.namespace}-db"
  username               = "admin"
  password               = random_password.password.result
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.sg_id.db]
  db_subnet_group_name   = var.vpc.database_subnet_group
}
