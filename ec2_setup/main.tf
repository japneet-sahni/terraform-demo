provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "my_private_subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "my_public_subnet"
  }
}

resource "aws_eip" "my_eip" {
  vpc = true
}

resource "aws_nat_gateway" "my_natgw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.my_igw]
}

resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_routetable"
  }
}

resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_natgw.id
  }

  tags = {
    Name = "private_routetable"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_routetable.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_network_interface" "private_nic" {
  subnet_id   = aws_subnet.private_subnet.id
  private_ips = ["10.0.1.4"]

  tags = {
    Name = "my_private_nic"
  }
}

resource "aws_security_group" "my_sg_allow_ssh" {
  name   = "my_sg_allow_ssh"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_private_ec2" {
  ami                    = "ami-09d95fab7fff3776c"
  instance_type          = var.instancetype
  vpc_security_group_ids = [aws_security_group.my_sg_allow_ssh.id]

  network_interface {
    network_interface_id = aws_network_interface.private_nic.id
    device_index         = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
  }

  tags = {
    Name = "my_private_ec2"
  }
}

resource "aws_ebs_volume" "my_extra_ebs_storage" {
  availability_zone = "us-east-1a"
  size              = 10

  tags = {
    Name = "my_extra_ebs_storage"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.my_extra_ebs_storage.id
  instance_id = aws_instance.my_private_ec2.id
}

resource "aws_network_interface" "public_nic" {
  subnet_id   = aws_subnet.public_subnet.id
  private_ips = ["10.0.2.4"]

  tags = {
    Name = "my_public_nic"
  }
}

resource "aws_instance" "my_public_ec2" {
  ami                    = "ami-09d95fab7fff3776c"
  instance_type          = var.instancetype
  vpc_security_group_ids = [aws_security_group.my_sg_allow_ssh.id]

  network_interface {
    network_interface_id = aws_network_interface.public_nic.id
    device_index         = 0
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
  }

  tags = {
    Name = "my_public_ec2"
  }
}