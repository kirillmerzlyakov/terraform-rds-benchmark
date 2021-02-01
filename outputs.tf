output "ubuntu_id" {
  value = aws_instance.ubuntu.id
}

output "ubuntu_ami" {
  value = aws_instance.ubuntu.ami
}

output "ubuntu_private_ip" {
  value = aws_instance.ubuntu.private_ip
}

output "ubuntu_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "database_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "database" {
  value = aws_db_instance.postgres
}
