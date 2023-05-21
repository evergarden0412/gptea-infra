provider "aws" {
  region  = "ap-northeast-2"
  profile = "keenranger"
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "keenranger"
}

resource "aws_vpc" "gptea" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "gptea"
  }
}

resource "aws_vpc" "gptea_test" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "gptea-test"
  }
}

resource "aws_subnet" "gptea_public" {
  count             = 2
  vpc_id            = aws_vpc.gptea.id
  cidr_block        = cidrsubnet(aws_vpc.gptea.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "gptea-public-${var.availability_zones[count.index]}"
  }
}

resource "aws_subnet" "gptea_private" {
  count             = 2
  vpc_id            = aws_vpc.gptea.id
  cidr_block        = cidrsubnet(aws_vpc.gptea.cidr_block, 8, count.index + 2)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "gptea-private-${var.availability_zones[count.index]}"
  }
}

resource "aws_subnet" "gptea_test_public" {
  count             = 2
  vpc_id            = aws_vpc.gptea_test.id
  cidr_block        = cidrsubnet(aws_vpc.gptea_test.cidr_block, 8, count.index)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "gptea-test-public-${var.availability_zones[count.index]}"
  }

}

resource "aws_subnet" "gptea_test_private" {
  count             = 2
  vpc_id            = aws_vpc.gptea_test.id
  cidr_block        = cidrsubnet(aws_vpc.gptea_test.cidr_block, 8, count.index + 2)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "gptea-test-private-${var.availability_zones[count.index]}"
  }
}