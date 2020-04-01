provider "aws" {
  version = "~> 2.9"
}

terraform {
  backend "s3" {
    bucket = "myvpn-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "wg_server" {
  ami                     = "ami-07ebfd5b3428b6f4d"
  instance_type           = "t2.nano"
  user_data               = file("wg-server.yml")
  vpc_security_group_ids  = [aws_security_group.wg_server.id]

  tags                    = {
    Name                  = "VPN"
  }
}

resource "aws_security_group" "wg_server" {
  name          = "wg-server sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5555
    to_port     = 5555
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output server_ip {
  value = aws_instance.wg_server.public_ip
}

output server_dns {
  value = aws_instance.wg_server.public_dns
}
