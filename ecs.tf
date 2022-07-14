resource "aws_ecs_cluster" "blackbelt-capstone-cluster" {
  name = "capstone-main"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "aws_iam_policy_document" "capstone_ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "capstone_ecs_agent" {
  name               = "capstone-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.capstone_ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "capstone_ecs_agent" {
  role       = aws_iam_role.capstone_ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "capstone_ecs_agent" {
  name = "capstone-ecs-agent"
  role = aws_iam_role.capstone_ecs_agent.name
}


resource "aws_security_group" "capstone_ecs_sg" {
  vpc_id = data.aws_vpc.main-ecs-vpc.id
  name   = "capstone_ecs_sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    self      = true

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [tags]
  }

}

