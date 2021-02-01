resource "aws_security_group" "ubuntu_security_group" {
  name        = "allow_SSH_http(s)"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = aws_vpc.vpc_demo.id

  dynamic "ingress" {
    for_each = ["80", "443", "22", "5432"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "Allow Postgres and SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc_demo.id

  dynamic "ingress" {
    for_each = ["5432", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
