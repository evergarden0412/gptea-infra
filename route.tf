resource "aws_internet_gateway" "gptea" {
  vpc_id = aws_vpc.gptea.id
  tags = {
    Name = "gptea-igw"
  }
}

resource "aws_eip" "gptea_nat" {
  count = 2
  vpc   = true
  tags = {
    Name = "gptea-nat-eip${var.availability_zones[count.index]}"
  }
}

resource "aws_nat_gateway" "gptea" {
  count         = 2
  allocation_id = aws_eip.gptea_nat[count.index].id
  subnet_id     = aws_subnet.gptea_public[count.index].id
  tags = {
    Name = "gptea-nat-${var.availability_zones[count.index]}"
  }
}


resource "aws_internet_gateway" "gptea_test" {
  vpc_id = aws_vpc.gptea_test.id
  tags = {
    Name = "gptea-test-igw"
  }
}

resource "aws_eip" "gptea_test_nat" {
  count = 2
  vpc   = true
  tags = {
    Name = "gptea-test-nat-eip${var.availability_zones[count.index]}"
  }
}

resource "aws_nat_gateway" "gptea_test" {
  count         = 2
  allocation_id = aws_eip.gptea_test_nat[count.index].id
  subnet_id     = aws_subnet.gptea_test_public[count.index].id
  tags = {
    Name = "gptea-test-nat-${var.availability_zones[count.index]}"
  }
}


resource "aws_route_table" "gptea_public" {
  vpc_id = aws_vpc.gptea.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gptea.id
  }
  tags = {
    Name = "gptea-rtb-public"
  }
}

resource "aws_route_table_association" "gptea_public" {
  count          = 2
  subnet_id      = aws_subnet.gptea_public[count.index].id
  route_table_id = aws_route_table.gptea_public.id
}

resource "aws_route_table" "gptea_private" {
  count  = 2
  vpc_id = aws_vpc.gptea.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gptea[count.index].id
  }
  tags = {
    Name = "gptea-rtb-private-${var.availability_zones[count.index]}"
  }
}

resource "aws_route_table_association" "gptea_private" {
  count          = 2
  subnet_id      = aws_subnet.gptea_private[count.index].id
  route_table_id = aws_route_table.gptea_private[count.index].id
}

resource "aws_vpc_endpoint" "gptea_s3" {
  vpc_id          = aws_vpc.gptea.id
  service_name    = "com.amazonaws.ap-northeast-2.s3"
  route_table_ids = aws_route_table.gptea_private[*].id
  tags = {
    Name = "gptea-vpce-s3"
  }
}

resource "aws_route_table" "gptea_test_public" {
  vpc_id = aws_vpc.gptea_test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gptea_test.id
  }
  tags = {
    Name = "gptea-test-rtb-public"
  }
}

resource "aws_route_table_association" "gptea_test_public" {
  count          = 2
  subnet_id      = aws_subnet.gptea_test_public[count.index].id
  route_table_id = aws_route_table.gptea_test_public.id
}

resource "aws_route_table" "gptea_test_private" {
  count  = 2
  vpc_id = aws_vpc.gptea_test.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gptea_test[count.index].id
  }
  tags = {
    Name = "gptea-test-rtb-private-${var.availability_zones[count.index]}"
  }
}

resource "aws_route_table_association" "gptea_test_private" {
  count          = 2
  subnet_id      = aws_subnet.gptea_test_private[count.index].id
  route_table_id = aws_route_table.gptea_test_private[count.index].id
}

resource "aws_vpc_endpoint" "gptea_test_s3" {
  vpc_id          = aws_vpc.gptea_test.id
  service_name    = "com.amazonaws.ap-northeast-2.s3"
  route_table_ids = aws_route_table.gptea_test_private[*].id
  tags = {
    Name = "gptea-test-vpce-s3"
  }
}