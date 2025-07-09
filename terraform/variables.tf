variable "aws_region" {
  default = "eu-west-1"
}

variable "ami_id" {
  default = "ami-0df368112825f8d8f" # Amazon Linux 2
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "DOCKER"
  type        = string
}

