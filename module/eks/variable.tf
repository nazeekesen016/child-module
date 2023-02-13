variable "eks-name" {
  default = ""
}


variable "template_name" {
  default = "terra"
}

variable "image-id" {
  default = "ami-0cb28ea0477916126"

}

variable "instance-type" {
  default = "t3.micro"

}

variable "sg-name" {
  default = "terra"
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
  default = ""
}

variable "private-subnet-id" {
  default = ["10.5.4.0/24", "10.5.5.0/24", "10.5.6.0/24"]
}

variable "vpc_id" {
  default = ""
}

locals {
  node_group = {

    node_group_name = "node-group4"

  }
}

variable "cluster_name" {
  default = ""

}

variable "instance_type" {
  type        = string
  description = "t2.micro"
  default     = "t2.micro"
}
