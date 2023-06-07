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
  default     = "ami-0ab193018f3e9351b"
}
