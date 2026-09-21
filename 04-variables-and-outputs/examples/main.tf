terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket       = "devops-directive-tf-state-custom-aum-test"
    key          = "04-variables-and-outputs/examples/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Latest Ubuntu 24.04 LTS AMI, used unless var.ami is set
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

locals {
  extra_tag = "extra-tag"
}

resource "aws_instance" "instance" {
  ami           = coalesce(var.ami, data.aws_ami.ubuntu.id)
  instance_type = var.instance_type

  tags = {
    Name     = var.instance_name
    ExtraTag = local.extra_tag
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage   = 20
  storage_type        = "gp3"
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t4g.micro"
  db_name             = "mydb"
  username            = var.db_user
  password            = var.db_pass
  skip_final_snapshot = true
}

