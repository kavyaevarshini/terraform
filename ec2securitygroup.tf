provider "aws" {
  region = "us-west-2"
}

 data "aws_avaialability_zones" "available"{}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy ="default"

  tags{
    name = "main"
    loation = "Banglore"
  }
  }

  enable_dns_support   = true
  enable_dns_hostnames = true


resource "aws_subnet" "subnet1" {
vpc_id     = "${aws_vpc.main.id}"
 
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet1"
  }
}


resource "aws_security_group" "ec2.name" {
  name = "${local.resource_name_prefix}-ec2-sg"

  description = "EC2 security group (terraform-managed)"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
    description = "MySQL"
    cidr_blocks = local.rds_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Telnet"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "hello_terra" {
  ami                         = "ami_7b433c334"
  count                       = 2 
  instance_type               = "t2.micro"
  user_data                   = <<EOF
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    =  nn_terrform  

    #! /bin/bash
    sudo yum install httpd -y
    sudo systemctl start httpd 
    sudo systemctl enable httpd 
    echo "<h1>Sample Webserver creating using terraform<br>network nuts </h1>" >>/var/www/html/index.html
    EOF

    tags {
        name  = "webserver" 
    }
   
 
}
 vpc_security_group_ids      = var.vpc_security_group_ids


resource "tls_private_key" "hello_terra" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "hello_terra" {
  key_name   = var.key_name
  public_key = tls_private_key.hello_terra.public_key_openssh
}


