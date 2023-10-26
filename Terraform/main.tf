provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod_vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "sub01"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "sub02"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow incoming HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server1" {
  ami           = "ami-0dd6252a626674cbe" # Ubuntu 22.04 LTS - Jammy
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id
  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install apache2 -y
              service apache2 start
              EOF

  tags = {
    Name = "web01"
  }
}

resource "aws_instance" "web_server2" {
  ami           = "ami-0dd6252a626674cbe" # Ubuntu 22.04 LTS - Jammy
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet2.id
  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install apache2 -y
              service apache2 start
              EOF

  tags = {
    Name = "web02"
  }
}

output "web_server1_public_ip" {
  value = aws_instance.web_server1.public_ip
}

output "web_server2_public_ip" {
  value = aws_instance.web_server2.public_ip
}
