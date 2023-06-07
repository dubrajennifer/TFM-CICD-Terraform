
//subnets.tf
resource "aws_subnet" "subnet-a" {
  cidr_block              = cidrsubnet(aws_vpc.projen-env.cidr_block, 3, 1)
  vpc_id                  = aws_vpc.projen-env.id
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
}


resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.route-table-projen-env.id
}