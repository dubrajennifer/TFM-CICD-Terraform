terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

#KEYPAIRS

variable "key_pair_name" {
  type    = string
  default = "jenkinskeypair"
}

resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.jenkins_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.jenkins_key.private_key_pem}' > ./keypairs/${var.key_pair_name}.pem"
  }
}

#SECURITY GROUP

//network.tf
resource "aws_vpc" "projen-env" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  
  enable_dns_support   = true
  tags = {
    Name = "projen-env"
  }
}

resource "aws_eip" "ip-projen-env" {
  instance = "${aws_instance.app_server.id}"
  vpc      = true
}

//gateways.tf
resource "aws_internet_gateway" "projen-env-gw" {
  vpc_id = "${aws_vpc.projen-env.id}"
  tags = {
    Name = "projen-env-gw"
  }
}

//subnets.tf
resource "aws_subnet" "subnet-a" {
  cidr_block        = cidrsubnet(aws_vpc.projen-env.cidr_block, 3, 1)
  vpc_id            = aws_vpc.projen-env.id
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
}

//security.tf
resource "aws_security_group" "ingress-all-projen" {
  name   = "projen-sg"
  vpc_id = aws_vpc.projen-env.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  } // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "route-table-projen-env" {
  vpc_id = "${aws_vpc.projen-env.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.projen-env-gw.id}"
  }
  tags = {
    Name = "projen-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-a.id}"
  route_table_id = "${aws_route_table.route-table-projen-env.id}"
}


// Jenkins server
resource "aws_instance" "app_server" {
  ami             = "ami-830c94e3"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.jenkins_key_pair.key_name
  security_groups = ["${aws_security_group.ingress-all-projen.id}"]
  associate_public_ip_address=true
  subnet_id = "${aws_subnet.subnet-a.id}"
  
  tags = {
    Name = "Jenkins"
  }
}
