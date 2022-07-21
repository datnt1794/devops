terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "datnt-terraform-state"
    key    = "services/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "datnt-locks"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "datnt-amz-ec2" {
  count                  = 2
  ami                    = "ami-0c802847a7dd848c0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.sg-id]
  key_name               = aws_key_pair.publickey.key_name
  user_data              = file("userdata.sh")

  tags = {
    Name = "datnt-amz-ec223"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "datnt-terraform-state"
    key    = "vpc/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
# data "aws_security_group" "sg" {
#   name = "datnt-sg"
# }

data "aws_subnet_ids" "example" {
  vpc_id = data.terraform_remote_state.networking.outputs.vpc-id
}

data "aws_subnet" "datnt-subnet" {
  for_each = data.aws_subnet_ids.example.ids
  id       = each.value
}

output "abc" {
  value = data.terraform_remote_state.networking.outputs.sg-id
}
