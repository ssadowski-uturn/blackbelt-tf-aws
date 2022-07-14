# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs-blackbelt-capstone" {
  name        = "capstone-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_vpc.main-ecs-vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.capstone_ecs_sg.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.capstone_ecs_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# create ALB taget group
resource "aws_lb_target_group" "blackbelt-capstone" {
  name        = "blackbelt-capstone-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main-ecs-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

## Role definitions
data "aws_iam_policy_document" "capstone_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "capstone_task_execution_role" {
  name               = "capstoneEcsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.capstone_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "capstone_task_execution_role" {
  role       = aws_iam_role.capstone_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

## Task Definition

resource "aws_ecs_task_definition" "capstone-task" {
  family             = "capstone-task"
  execution_role_arn = aws_iam_role.capstone_task_execution_role.arn
  network_mode       = "bridge"
  cpu                = 256
  memory             = 512
  container_definitions = templatefile("./templates/task.json.tpl", {
    task_name        = "capstone-api"
    container_image  = "nginx:latest"
    container_cpu    = 256
    container_memory = 512
    app_port         = 80
    host_port        = 8080
    aws_region       = "us-west-2"
    env_name         = "Capstone"
    envvars          = ""
    secrets          = ""
    mountpoints      = ""
    }
  )
}


## service definition

resource "aws_ecs_service" "blackbelt-capstone" {
  name            = "blackbelt-capstone-service"
  cluster         = aws_ecs_cluster.blackbelt-capstone-cluster.id
  task_definition = aws_ecs_task_definition.capstone-task.arn
  desired_count   = 1
  launch_type     = "EXTERNAL"

#   network_configuration {
#     security_groups = [aws_security_group.ecs-blackbelt-capstone.id]
#     subnets         = [data.aws_subnet.public_usw2a.id, data.aws_subnet.public_usw2b.id, data.aws_subnet.public_usw2c.id]
#     # assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.blackbelt-capstone.arn
#     container_name   = "capstone-api"
#     container_port   = 80
#   }

  #   depends_on = [aws_alb_listener.api, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

# Redirect matching traffic from the ALB to the target group
resource "aws_lb_listener_rule" "blackbelt-capstone" {
  listener_arn = aws_lb_listener.default_443.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blackbelt-capstone.arn
  }

  condition {
    host_header {
      values = [local.host_header_fqdn]
    }
  }
}