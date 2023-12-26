resource "aws_vpc" "jenkins_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.jenkins_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }
}

resource "aws_subnet" "jenkins_subnet" {
  vpc_id = aws_vpc.jenkins_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins-sg-"
  vpc_id = aws_vpc.jenkins_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}