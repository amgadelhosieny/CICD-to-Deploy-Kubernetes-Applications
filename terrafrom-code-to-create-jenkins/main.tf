data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID for Ubuntu images

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "jenkins_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "jenkins-server"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id = aws_subnet.jenkins_subnet.id
  associate_public_ip_address = true

}
