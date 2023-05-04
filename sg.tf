resource "aws_security_group" "gptea_private" {
  name   = "gptea-private"
  vpc_id = aws_vpc.gptea.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "gptea-private"
  }
}

resource "aws_security_group" "gptea_test_private" {
  name   = "gptea-test-private"
  vpc_id = aws_vpc.gptea_test.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "gptea-test-private"
  }
}


resource "aws_security_group" "gptea_db" {
  name   = "gptea-db"
  vpc_id = aws_vpc.gptea.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.gptea_private.id, aws_security_group.gptea_bastion.id]
  }
  tags = {
    Name = "gptea-db"
  }
}

resource "aws_security_group" "gptea_test_db" {
  name   = "gptea-test-db"
  vpc_id = aws_vpc.gptea_test.id
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.gptea_test_private.id, aws_security_group.gptea_test_bastion.id]
  }
  tags = {
    Name = "gptea-test-db"
  }
}