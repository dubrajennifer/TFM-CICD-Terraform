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


// Jenkins server
resource "aws_instance" "jenkins_server" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.jenkins_key_pair.key_name
  security_groups             = ["${aws_security_group.ssh_and_port8080_sg.id}"]
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
      "git clone https://github.com/dubrajennifer/TFM-CICD-Ansible.git Configuration",
      "cd Configuration",
      "git checkout feature/Jenkins",
      "git pull",
      "cd ..",
      "ansible-playbook Configuration/Ansible/playbook.yaml",
      "sudo chmod +x Configuration/Ansible/search_java_maven_paths.py",
      "sudo sh Configuration/Ansible/Adding_path_to_bash_profile.sh",
      "sudo yum install java-17-openjdk",
      "wget https://dlcdn.apache.org/maven/maven-3/3.9.2/binaries/apache-maven-3.9.2-bin.tar.gz",
      "tar xvf apache-maven-3.9.2-bin.tar.gz",
      "sudo mv apache-maven-3.9.2 /usr/local/apache-maven",
      "export M2_HOME=/usr/local/apache-maven",
      "export M2=$M2_HOME/bin",
      "export PATH=$M2:$PATH",
      "source ~/.bashrc"
    ]
  }
}

// Jenkins server
resource "aws_instance" "app_openmeetings_server" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.app_server_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_all_except_icmp_sg.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "App OpenMeeting Server"
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
      "sudo yum install git -y",
      # quitar despues de probar a desplegar
      "sudo yum install java-17-openjdk",
      "wget https://dlcdn.apache.org/maven/maven-3/3.9.2/binaries/apache-maven-3.9.2-bin.tar.gz",
      "tar xvf apache-maven-3.9.2-bin.tar.gz",
      "sudo mv apache-maven-3.9.2 /usr/local/apache-maven",
      "export M2_HOME=/usr/local/apache-maven",
      "export M2=$M2_HOME/bin",
      "export PATH=$M2:$PATH",
      "source ~/.bashrc"
    ]
  }
}
