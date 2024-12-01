# restrict outgoring traffic to alb onlyy
resource "aws_security_group" "ec2" {
  name_prefix = "${var.project_name}-ec2-"
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    security_groups = [ aws_security_group.alb.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# allow traffic to internet
resource "aws_security_group" "alb" {
  name_prefix = "${var.project_name}-alb-"
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [ "099720109477" ]

  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  
}

resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-"

  image_id = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"


  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.ec2.id]
  }


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-ec2"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  monitoring {
    enabled = "true"
  }

  user_data = filebase64("${path.root.scripts}/ec2.sh")
}