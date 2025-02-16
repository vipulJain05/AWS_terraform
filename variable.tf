variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "subnet_cidr" {
  type = map(string)
  default = {
    "public-sub1" = "10.0.1.0/24"
    "private-sub1" = "10.0.2.0/24"
  }
}

variable "count_sub" {
  type = number
  default = 3
}

variable "private_subnet_cidr" {
  type = map(string)
  default = {
    "us-east-1a" = "10.0.0.0/20",
    "us-east-1b" = "10.0.16.0/20"
    "us-east-1c" = "10.0.32.0/20"
  }
}

variable "public_subnet_cidr" {
  type = map(string)
  default = {
    "us-east-1a" = "10.0.80.0/20",
    "us-east-1b" = "10.0.48.0/20"
    "us-east-1c" = "10.0.64.0/20"
  }
}

variable "nat_az" {
  type = list(string)
  default = [ "us-east-1" ]
}
