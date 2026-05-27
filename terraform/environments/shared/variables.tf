variable "aws_region" {
  default = "us-east-1"
}

variable "public_key" {
  type = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "my_ip" {
  default = "52.73.17.22"
}

