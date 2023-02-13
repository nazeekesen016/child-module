terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
  name = "vpc-${var.name}" }
}

resource "aws_subnet" "subnet1" {
  count                   = length(var.subnets-cidr-block)
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.subnets-cidr-block[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    name = "${var.subnet-name}[count.index]"
  }

}
resource "aws_subnet" "private-subnets" {
  count             = length(var.private-subnets-cidr-block)
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = var.private-subnets-cidr-block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    name = "${var.subnet-name}[count.index]"
  }

  map_public_ip_on_launch = true
  depends_on = [
    aws_vpc.my-vpc
  ]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  count          = length(var.subnets-cidr-block)
  subnet_id      = aws_subnet.subnet1[count.index].id
  route_table_id = aws_route_table.rt.id
}


resource "aws_eip" "fornat" {
  count      = length(var.private-subnets-cidr-block)
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "forprivatesubnets" {
  count         = length(var.private-subnets-cidr-block)
  allocation_id = aws_eip.fornat[count.index].id
  subnet_id     = element(aws_subnet.subnet1[*].id, count.index)
}
