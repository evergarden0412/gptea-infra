
resource "aws_security_group" "gptea_bastion" {
  name   = "gptea-bastion"
  vpc_id = aws_vpc.gptea.id
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "gptea-bastion"
  }
}

resource "aws_security_group" "gptea_test_bastion" {
  name   = "gptea-test-bastion"
  vpc_id = aws_vpc.gptea_test.id
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "gptea-test-bastion"
  }
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "gptea_bastion" {
  name                = "gptea-bastion"
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

resource "aws_iam_instance_profile" "gptea_bastion" {
  name = "gptea-bastion"
  role = aws_iam_role.gptea_bastion.name
}


resource "aws_instance" "gptea_bastion" {
  ami                         = "ami-03f54df9441e9b380"
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.gptea_bastion.id
  subnet_id                   = aws_subnet.gptea_private[0].id
  associate_public_ip_address = false
  security_groups             = [aws_security_group.gptea_bastion.id]
}

resource "aws_instance" "gptea_test_bastion" {
  ami                         = "ami-03f54df9441e9b380"
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.gptea_bastion.id
  subnet_id                   = aws_subnet.gptea_test_private[0].id
  associate_public_ip_address = false
  security_groups             = [aws_security_group.gptea_test_bastion.id]
}