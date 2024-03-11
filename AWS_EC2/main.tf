// create vpc
resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc"
  }
}

// create private subnet
resource "aws_subnet" "test_private_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-private-subnet"
  }
}

// create public subnet
resource "aws_subnet" "test_public_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-public-subnet"
  }
}


// create internet gateway 
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "tf-igw"
  }
}


// modify public subnet route to include internet gateway
resource "aws_route" "test_public_subnet_route" {
  route_table_id         = aws_vpc.test_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.test_igw.id
}


// create security group for ssh access
resource "aws_security_group" "test_public_sg" {
  name        = "tf-public-security-group"
  description = "Allow ssh and internet access"
  vpc_id      = aws_vpc.test_vpc.id

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
    Name = "public-security-group"
  }
}


// create a spread placement group
resource "aws_placement_group" "test_pg" {
  name     = "tf-placement-group"
  strategy = "spread"
}

// create a EBS volume 
resource "aws_ebs_volume" "test_volume" {
  availability_zone = "us-east-1a"
  size              = 8
  type              = "gp2"
  encrypted         = true

  tags = {
    Name = "tf-ebs"
  }
}

// create a EFS file system
resource "aws_efs_file_system" "test_file_system_with_lifecycle_policy" {
  encrypted = true

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }
  tags = {
    Name = "tf-efs"
  }
}


// create a free tier ec2
resource "aws_instance" "public_ec2" {
  ami           = "ami-0f403e3180720dd7e"
  instance_type = "t3.micro"

  subnet_id       = aws_subnet.test_public_subnet.id
  placement_group = aws_placement_group.test_pg.name
  # security_groups = [aws_security_group.test_public_sg.id]

  tags = {
    Name = "tf-public-ec2"
  }
}

// create a free tier private ec2
resource "aws_instance" "private_ec2" {
  ami           = "ami-0f403e3180720dd7e"
  instance_type = "t3.micro"

  subnet_id       = aws_subnet.test_private_subnet.id
  placement_group = aws_placement_group.test_pg.name

  tags = {
    Name = "tf-private-ec2"
  }
}

// attach ebs volume to public_ec2
resource "aws_volume_attachment" "test_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.test_volume.id
  instance_id = aws_instance.public_ec2.id
}

// attach efs file system to public_ec2
resource "aws_efs_mount_target" "test_mount_target" {
  file_system_id = aws_efs_file_system.test_file_system_with_lifecycle_policy.id
  subnet_id      = aws_instance.public_ec2.subnet_id
  # security_groups = [aws_security_group.test_public_sg.id]
}
