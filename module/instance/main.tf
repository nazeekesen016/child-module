resource "aws_instance" "BASTION" {
  ami                    = "ami-06c39ed6b42908a36"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id[0]
  vpc_security_group_ids = [aws_security_group.only_ssh_bositon.id]
  #   key_name               = "terra"


  tags = {
    Name = "bastionhost"
  }

}



resource "aws_security_group" "only_ssh_bositon" {
  depends_on = [var.subnet_id]
  name       = "only_ssh_bositon"
  vpc_id     = var.vpc-id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "only_ssh_bositon"
  }
}
