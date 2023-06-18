# Input Variables
variable "aws_region" {
  description = "Region in which AWS resource to be created"
  type        = string
  default     = "us-west-2"

}


variable "ec2_instance_type" {
  description = "EC2 Instance type "
  type        = string
  default     = "t2.micro"

}

variable "ec2_ami_type" {
  description = "AMI type "
  type        = string
  default     = "ami-076bca9dd71a9a578"
}


variable "key_pair_jenkins" {
  type    = string
  default = "jenkinskeypair"
}


variable "key_pair_app_server" {
  type    = string
  default = "appkeypair"
}