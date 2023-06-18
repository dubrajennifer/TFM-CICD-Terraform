
//network.tf
resource "aws_vpc" "projen-env" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  enable_dns_support = true
  tags = {
    Name = "projen-env"
  }
}

resource "aws_eip" "ip-projen-env" {
  instance = aws_instance.app_openmeetings_server.id
  vpc      = true
}

//gateways.tf
resource "aws_internet_gateway" "projen-env-gw" {
  vpc_id = aws_vpc.projen-env.id
  tags = {
    Name = "projen-env-gw"
  }
}

resource "aws_route_table" "route-table-projen-env" {
  vpc_id = aws_vpc.projen-env.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.projen-env-gw.id
  }
  tags = {
    Name = "projen-env-route-table"
  }
}