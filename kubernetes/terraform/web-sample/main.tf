provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-0d3998d69ebe9b214"
  instance_type = "t2.small"
}