resource "aws_key_pair" "todo_key" {
  key_name = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "security" {
  name = "automate_security_group"
  description = "generate security group"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Django app"
  }
  
   ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Nginx Server"
  }

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "All access"
  }
   
  tags = {
    Name = "automate_sg"
  }
}

resource "aws_instance" "server" {
  key_name = aws_key_pair.todo_key.key_name
  security_groups = [aws_security_group.security.name]
  instance_type =  "t2.micro"
  ami = "ami-0d1b5a8c13042c939"

  user_data = file("docker.sh") 

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "EC2-Instance"
  }
}
