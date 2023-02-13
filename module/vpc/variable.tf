variable "subnet-name" {
  default = ""
}

variable "private-subnet-name" {
  default = {}

}

variable "subnets-cidr-block" {
  default = [
    "10.5.1.0/24",
    "10.5.2.0/24",
    "10.5.3.0/24",
  ]
}


variable "private-subnets-cidr-block" {
  default = [
    "10.5.4.0/24",
    "10.5.5.0/24",
    "10.5.6.0/24",
  ]
}

variable "subnet-id" {
  type    = list(string)
  default = []
}

variable "subnet_id" {
  type    = list(string)
  default = []
}

variable "private-subnet-id" {}

variable "vpc-cidr-block" {
  default = "10.5.0.0/16"
}

variable "name" {
  type    = string
  default = ""
}

variable "vpc_id" {
  default = ""
}
