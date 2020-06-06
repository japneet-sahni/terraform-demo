provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

resource "aws_instance" "myec2" {
  ami           = "ami-09d95fab7fff3776c"
  instance_type = "t2.nano"
  key_name      = "abc"

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./abc.pem")
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.private_ip} >> private_ips.txt"
  }
}