resource "aws_instance" "example" {
  ami           = var.AMI_ID
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.example-instance.id]

   tags = {
      Name = "Instance_from_Packer"
    }
}

