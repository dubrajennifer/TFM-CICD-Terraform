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

variable "ec2_small_instance_type" {
  description = "EC2 Instance type "
  type        = string
  default     = "t2.small"

}

variable "ec2_medium_instance_type" {
  description = "EC2 Instance type "
  type        = string
  default     = "t2.medium"

}

variable "ec2_ami_type" {
  description = "AMI type "
  type        = string
  default     = "ami-076bca9dd71a9a578"
}

variable "ec2_small_ami_type" {
  description = "AMI type "
  type        = string
  default     = "ami-0cef94f067b35ada0"
}

variable "ec2_medium_ami_type" {
  description = "AMI type "
  type        = string
  default     = "ami-0ae49954dfb447966"
}

variable "key_pair_jenkins" {
  type    = string
  default = "jenkinskeypair"
}

variable "stg_key_pair_app_server" {
  type    = string
  default = "STGappkeypair"
}


variable "key_pair_app_server" {
  type    = string
  default = "appkeypair"
}

variable "key_pair_nexus" {
  type    = string
  default = "nexuskeypair"
}

variable "key_pair_sonar" {
  type    = string
  default = "sonarkeypair"
}

variable "key_pair_redmine" {
  type    = string
  default = "redminekeypair"
}