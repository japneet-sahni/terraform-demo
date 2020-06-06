resource "aws_instance" "my_ec2" {
  ami           = "ami-09d95fab7fff3776c"
  instance_type = var.instance_type
}
