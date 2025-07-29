provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "july29test1_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "july29test1_subnet" {
  vpc_id            = aws_vpc.july29test1_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "july29test1_sg" {
  name        = "july29test1_sg"
  description = "Security group for july29test1 project"
  vpc_id      = aws_vpc.july29test1_vpc.id

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
}

resource "aws_instance" "july29test1_instance" {
  ami                         = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.july29test1_subnet.id
  vpc_security_group_ids      = [aws_security_group.july29test1_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "july29test1_instance"
  }
}