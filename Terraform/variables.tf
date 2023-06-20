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
  default     = "ami-07dfed28fcf95241c"
}

variable "key_pair_jenkins" {
  type    = string
  default = "jenkinskeypair"
}


variable "key_pair_app_server" {
  type    = string
  default = "appkeypair"
}