provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "july29test2_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.july29test2_ec2_profile.name

  tags = {
    Name = "july29test2-ec2"
  }
}

resource "aws_s3_bucket" "july29test2_bucket" {
  bucket = "july29test2-bucket"

  tags = {
    Name        = "july29test2-bucket"
    Environment = "Dev"
  }
}

resource "aws_iam_role" "july29test2_ec2_role" {
  name = "july29test2-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "july29test2_s3_access" {
  name        = "july29test2-s3-access"
  description = "Allow EC2 instance to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.july29test2_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "july29test2_ec2_role_attach" {
  role       = aws_iam_role.july29test2_ec2_role.name
  policy_arn = aws_iam_policy.july29test2_s3_access.arn
}

resource "aws_iam_instance_profile" "july29test2_ec2_profile" {
  name = "july29test2-ec2-profile"
  role = aws_iam_role.july29test2_ec2_role.name
}