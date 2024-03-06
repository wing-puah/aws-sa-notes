// create security group for ssh access
resource "aws_security_group" "test_sg" {
  name        = "tf-security-group"
  description = "Allow ssh and internet access"

  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow internet access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-and-internet-security-group"
  }
}

// create a spread placement group
resource "aws_placement_group" "test_pg" {
  name     = "tf-placement-group"
  strategy = "spread"
}

// create a free tier ec2
resource "aws_instance" "test_ec2" {
  ami           = "ami-0f403e3180720dd7e"
  instance_type = "t3.micro"

  security_groups = [aws_security_group.test_sg.name]
  placement_group = aws_placement_group.test_pg.name

  tags = {
    Name = "tf-ec2"
  }
}


