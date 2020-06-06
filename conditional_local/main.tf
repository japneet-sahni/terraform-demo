provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

#Defining a local value
locals {
    common_tags = {
        owner = "Japneet"
    }
}

resource "aws_instance" "dev" {
  ami           = "ami-09d95fab7fff3776c"
  instance_type = var.instancetype
  count = var.isDev == true ? 1 : 0
  tags = local.common_tags
}

resource "aws_instance" "prod" {
  ami           = "ami-09d95fab7fff3776c"
  instance_type = var.instancetype
  count = var.isDev == false ? 1 : 0
  tags = local.common_tags
}