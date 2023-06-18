
resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "tls_private_key" "app_server_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = var.key_pair_jenkins
  public_key = tls_private_key.jenkins_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.jenkins_key.private_key_pem}' > ./keypairs/${var.key_pair_jenkins}.pem"
  }
}

resource "aws_key_pair" "app_server_key_pair" {
  key_name   = var.key_pair_app_server
  public_key = tls_private_key.app_server_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.app_server_key.private_key_pem}' > ./keypairs/${var.key_pair_app_server}.pem"
  }
}