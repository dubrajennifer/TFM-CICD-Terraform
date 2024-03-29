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
//                         APP SERVERS                            //
////////////////////////////////////////////////////////////////////

// DEVELOPMENT App server
resource "aws_instance" "stg_app_server" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.stg_app_server_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_ports_5080_5443.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "(STG) App Server"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypairs/${var.stg_key_pair_app_server}.pem")
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
resource "aws_instance" "app_server_1" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.app_server_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_ports_5080_5443.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "App Server A"
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
resource "aws_instance" "app_server_2" {
  ami                         = var.ec2_ami_type
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.app_server_key_pair.key_name
  security_groups             = ["${aws_security_group.allow_ports_5080_5443.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "App Server B"
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
  security_groups             = ["${aws_security_group.nexus_sg.id}"]
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
      #Project
      "git clone https://github.com/dubrajennifer/TFM-CICD-Ansible.git Configuration",
      "ansible-playbook  Configuration/Ansible/Nexus/playbook.yml"
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
  security_groups             = ["${aws_security_group.sonar_sg.id}"]
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
      "sudo amazon-linux-extras install docker -y",
      # Download the latest version of Docker Compose
      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      # Apply executable permissions to the binary
      "sudo chmod +x /usr/local/bin/docker-compose",
      # Create a symbolic link to make the binary accessible globally
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "ansible-playbook Configuration/Ansible/Sonar/playbook.yml"
    ]
  }
}



////////////////////////////////////////////////////////////////////
//                          JMeter                                //
////////////////////////////////////////////////////////////////////
resource "aws_instance" "jmeter_server" {
  ami                         = var.ec2_small_ami_type
  instance_type               = var.ec2_small_instance_type
  key_name                    = aws_key_pair.jmeter_key_pair.key_name
  security_groups             = ["${aws_security_group.jmeter_sg.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet-a.id

  tags = {
    Name = "JMeter"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypairs/${var.key_pair_jmeter}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      #Project
      "git clone https://github.com/dubrajennifer/TFM-CICD-Ansible.git Configuration",
      "ansible-playbook  Configuration/Ansible/JMeter/playbook.yml"
    ]
  }
}

////////////////////////////////////////////////////////////////////
//                          Jenkins                               //
////////////////////////////////////////////////////////////////////
resource "aws_instance" "jenkins_server" {
  ami                         = var.ec2_large_ami_type
  instance_type               = var.ec2_large_instance_type
  key_name                    = aws_key_pair.jenkins_key_pair.key_name
  security_groups             = ["${aws_security_group.jenkins_sg.id}"]
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

  provisioner "file" {
    source      = "keypairs/${var.stg_key_pair_app_server}.pem"
    destination = ".ssh/${var.stg_key_pair_app_server}.pem"  
  }
  
  provisioner "file" {
    source      = "keypairs/${var.key_pair_app_server}.pem"
    destination = ".ssh/${var.key_pair_app_server}.pem"  
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum install git -y",
      #Project
      "git clone https://github.com/dubrajennifer/TFM-CICD-Ansible.git Configuration",
      "echo '  - key: \"APP_BLUE_IP\"",
      "    value: \"${aws_instance.app_server_1.public_ip}\"' >> Configuration/Ansible/Jenkins/jenkins/vars/environment_variables.yml",
      "echo '  - key: \"APP_GREEN_IP\"",
      "    value: \"${aws_instance.app_server_2.public_ip}\"' >> Configuration/Ansible/Jenkins/jenkins/vars/environment_variables.yml",
      "echo '  - key: \"APP_STG_SERVER_IP\"",
      "    value: \"${aws_instance.stg_app_server.public_ip}\"' >> Configuration/Ansible/Jenkins/jenkins/vars/environment_variables.yml",
      "echo '  - key: \"NEXUS_IP\"",
      "    value: \"${aws_instance.nexus_server.public_ip}:8081\"' >> Configuration/Ansible/Jenkins/jenkins/vars/environment_variables.yml",
      "echo '  - key: \"APP_BLUE_ARN\"",
      "    value: \"${aws_lb_target_group.a_target.arn}\"' >> Configuration/Ansible/Jenkins/jenkins/vars/environment_variables.yml",
      "echo '  - key: \"APP_GREEN_ARN\"",
      "    value: \"${aws_lb_target_group.b_target.arn}\"' >> Configuration/Ansible/Jenkins/jenkins/vars/environment_variables.yml",
      "echo '  - key: \"APP_LISTENER_ARN\"",
      "    value: \"${aws_lb.ab_alb.arn}\"' >> Configuration/Ansible/Jenkins/jenkins/vars/environment_variables.yml",
      # Ansible 
      #Change initial user jenkins
      "ansible-playbook Configuration/Ansible/Jenkins/playbook.yml -e 'jenkins_admin_username=jenkins jenkins_admin_password=jenkins'"
      #"echo 'jenkins_password=jenkins' >> /var/jenkins_home/secrets/initialAdminPassword",

      #"systemctl restart jenkins"  
    ]
  }
}
