# Latest Ubuntu 24.04 LTS AMI, used unless var.ami is set
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "instance_1" {
  ami                    = coalesce(var.ami, data.aws_ami.ubuntu.id)
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World 1" > index.html
              python3 -m http.server 8080 &
              EOF
}

resource "aws_instance" "instance_2" {
  ami                    = coalesce(var.ami, data.aws_ami.ubuntu.id)
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World 2" > index.html
              python3 -m http.server 8080 &
              EOF
}
