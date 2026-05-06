provider "aws" {
  region  = "eu-central-1"
  profile = "personal"
}

resource "aws_instance" "test_ec2_terraform" {
  ami           = "ami-08bdb1495db49a7f9"
  instance_type = "t2.micro"
}
