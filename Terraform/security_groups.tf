
////////////////////////////////////////////////////////////////////
//                         Jenkins                                //
////////////////////////////////////////////////////////////////////
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group to allow traffic to and from Jenkins"
  vpc_id      = aws_vpc.projen-env.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Egress rule to block outbound ICMP traffic (ping)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Block all outbound ICMP traffic (ping)"
  }
}

////////////////////////////////////////////////////////////////////
//                            Apps                                //
////////////////////////////////////////////////////////////////////
resource "aws_security_group" "allow_ports_5080_5443" {
  name        = "AllowPorts5080And5443"
  description = "Security group to allow traffic on ports 5080 and 5443"
  vpc_id      = aws_vpc.projen-env.id

  ingress {
    from_port   = 5080
    to_port     = 5080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    # Inbound rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }



  egress {
    from_port   = 5080
    to_port     = 5080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }


  # Egress rule to block outbound ICMP traffic (ping)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Block all outbound ICMP traffic (ping)"
  }
}


////////////////////////////////////////////////////////////////////
//                            Nexus                               //
////////////////////////////////////////////////////////////////////
resource "aws_security_group" "nexus_sg" {
  name        = "nexus-sg"
  description = "Security group allowing SSH and port 8081 access"
  vpc_id = aws_vpc.projen-env.id
  
  # Inbound rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Inbound rule for port 8081
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}


////////////////////////////////////////////////////////////////////
//                            Sonar                               //
////////////////////////////////////////////////////////////////////
resource "aws_security_group" "sonar_sg" {
  name        = "sonar-sg"
  description = "Security group allowing SSH and port 9000 access"
  vpc_id = aws_vpc.projen-env.id
  
  # Inbound rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Inbound rule for port 9000
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  
  # Inbound rule for port SMTPS
  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}


////////////////////////////////////////////////////////////////////
//                            JMeter                              //
////////////////////////////////////////////////////////////////////

resource "aws_security_group" "jmeter_sg" {
  name_prefix = "jmeter-sg"
  description = "Security group for JMeter"
  vpc_id = aws_vpc.projen-env.id

  ingress {
    description      = "Allow SSH connections"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Inbound rules - allow incoming traffic
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Allow Apps traffic"
    from_port        = 5080
    to_port          = 5080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "Allow Apps traffic"
    from_port        = 5443
    to_port          = 5443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow SSH connections"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    description      = "Allow APPs traffic"
    from_port        = 5443
    to_port          = 5443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow APPs traffic"
    from_port        = 5080
    to_port          = 5080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}