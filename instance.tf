resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_1.id
  private_ip             = "10.0.1.50"
  vpc_security_group_ids = [aws_security_group.ubuntu_security_group.id]
  availability_zone      = "eu-central-1a"
  key_name               = var.key_name
  user_data = templatefile("./scripts/scripts.sh.tpl", {
    db_host              = aws_db_instance.postgres.address
    db_port              = aws_db_instance.postgres.port
    db_name              = aws_db_instance.postgres.name
    db_username          = aws_db_instance.postgres.username
    db_password          = aws_db_instance.postgres.password
    db_allocated_storage = aws_db_instance.postgres.allocated_storage
  })

  tags = {
    Name = "RDS_Postgres_Example"
  }
  depends_on = [aws_db_instance.postgres]
}
