# restrict outgoring traffic to alb onlyy
resource "aws_security_group" "ec2" {
  name = "${var.project_name}-ec2-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_alb" {
  type = "ingress"
  security_group_id = aws_security_group.ec2.id
  source_security_group_id = aws_security_group.alb.id
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
  
}

resource "aws_security_group_rule" "allow_ec2_egress" {
  type = "egress"
  security_group_id = aws_security_group.ec2.id
  from_port         = 0
  protocol       = "-1"
  to_port           = 0
  cidr_blocks = [ "0.0.0.0/0" ]
}



# allow traffic to internet
resource "aws_security_group" "alb" {
  name = "${var.project_name}-alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-ec2-alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_alb_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id
  cidr_blocks         = ["0.0.0.0/0"]
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "allow_alb_egress" {
  type = "egress"
  security_group_id = aws_security_group.alb.id
  cidr_blocks          = ["0.0.0.0/0"]
  to_port = 0
  from_port = 0
  protocol       = "-1" # semantically equivalent to all ports
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

  instance_type = "t2.micro"


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

  user_data = filebase64("${abspath(path.root)}/scripts/ec2.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}


# session manager 
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "ec2_custom_policy" {
  name = "${var.project_name}-ec2-custom-policy"
  role = aws_iam_role.ec2_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:RegisterTargets",
          "ssm:UpdateInstanceInformation",
          "ssm:ListInstanceAssociations",
          "ssm:DescribeDocument",
          "ssm:GetDocument",
          "ssm:GetParameter"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}
