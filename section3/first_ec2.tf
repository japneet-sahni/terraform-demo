provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_tf"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my_tf"
  }
}

resource "aws_network_interface" "my_nic" {
  subnet_id   = "${aws_subnet.my_subnet.id}"
  private_ips = ["10.0.1.4"]

  tags = {
    Name = "my_tf"
  }
}

resource "aws_instance" "my_ec2" {
   ami = "ami-09d95fab7fff3776c"
   instance_type = "t2.nano"

   network_interface {
       network_interface_id = "${aws_network_interface.my_nic.id}"
       device_index         = 0
    }

    root_block_device {
        delete_on_termination = false
        volume_size = 8
    }

   tags = {
           Name = "my_tf"
   }

}
