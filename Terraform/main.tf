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
  region = var.aws_region
}




////////////////////////////////////////////////////////////////////
//                          Jenkins                               //
////////////////////////////////////////////////////////////////////
resource "aws_instance" "jenkins_server" {
  ami                         = var.ec2_medium_ami_type
  instance_type               = var.ec2_medium_instance_type
  key_name                    = aws_key_pair.jenkins_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_all_except_icmp_sg.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "Jenkins"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypairs/${var.key_pair_jenkins}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      #Project
      "git clone https://github.com/dubrajennifer/TFM-CICD-Ansible.git Configuration",
      "cd Configuration",
      "git checkout feature/Jenkins",
      "git pull",
      "cd ..",
      # Ansible 
      "ansible-playbook Configuration/Ansible/playbook.yaml",
      "sudo chmod +x Configuration/Ansible/search_java_maven_paths.py",
      "sudo sh Configuration/Ansible/Adding_path_to_bash_profile.sh",
    ]
  }
}



////////////////////////////////////////////////////////////////////
//                         APP SERVERS                            //
////////////////////////////////////////////////////////////////////

// App server
resource "aws_instance" "app_openmeetings_server_1" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.app_server_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_all_except_icmp_sg.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "App OpenMeeting Server A"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypairs/${var.key_pair_app_server}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install java-17-amazon-corretto -y",
      "sudo yum install java-17-amazon-corretto-devel -y",
      "sudo yum install java-17-amazon-corretto-jmods -y",
      "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64",
      "sudo mkdir /home/ec2-user/openmeetings",
      "sudo chmod 777 /home/ec2-user/openmeetings",
      "sudo mkdir /home/ec2-user/openmeetings-app",
      "sudo chmod 777 /home/ec2-user/openmeetings-app"
    ]
  }
}



// App server
resource "aws_instance" "app_openmeetings_server_2" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.app_server_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_all_except_icmp_sg.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "App OpenMeeting Server B"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypairs/${var.key_pair_app_server}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install java-17-amazon-corretto -y",
      "sudo yum install java-17-amazon-corretto-devel -y",
      "sudo yum install java-17-amazon-corretto-jmods -y",
      "export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64",
      "sudo mkdir /home/ec2-user/openmeetings",
      "sudo chmod 777 /home/ec2-user/openmeetings",
      "sudo mkdir /home/ec2-user/openmeetings-app",
      "sudo chmod 777 /home/ec2-user/openmeetings-app"
    ]
  }
}

////////////////////////////////////////////////////////////////////
//                            Nexus                               //
////////////////////////////////////////////////////////////////////
resource "aws_instance" "nexus_server" {
  ami                         = var.ec2_small_ami_type
  instance_type               = var.ec2_small_instance_type
  key_name                    = aws_key_pair.nexus_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_all_except_icmp_sg.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "Nexus"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypairs/${var.key_pair_nexus}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      "ansible-galaxy init nexus",
      #Project
      "git clone https://github.com/dubrajennifer/TFM-CICD-Ansible.git Configuration",
      "cd Configuration",
      "git checkout feature/Nexus",
      "cd ..",
      "ansible-playbook  Configuration/Ansible/Nexus/playbook.yaml"
    ]
  }
}


////////////////////////////////////////////////////////////////////
//                          Sonarqube                             //
////////////////////////////////////////////////////////////////////
resource "aws_instance" "sonar_server" {
  ami                         = var.ec2_medium_ami_type
  instance_type               = var.ec2_medium_instance_type
  key_name                    = aws_key_pair.sonar_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_all_except_icmp_sg.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "SonarQube"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypairs/${var.key_pair_sonar}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      #Project
      "git clone https://github.com/dubrajennifer/TFM-CICD-Ansible.git Configuration",
      "cd Configuration",
      "git checkout feature/Sonar",
      "cd ..",
      "sudo amazon-linux-extras install docker -y",
      # Download the latest version of Docker Compose
      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      # Apply executable permissions to the binary
      "sudo chmod +x /usr/local/bin/docker-compose",
      # Create a symbolic link to make the binary accessible globally
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "ansible-playbook Configuration/Ansible/Sonar/playbook.yaml"
    ]
  }
}