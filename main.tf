terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

// Passo 01: Criar cluster ecs com configs do tipo FARGATE
resource "aws_ecs_cluster" "cluster" {
  name = "EckartCluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_configs" {
  cluster_name = "EckartCluster"

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

// Passo 02: Criar task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "httpd-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "arn:aws:iam::107579490988:role/LabRole"
  execution_role_arn       = "arn:aws:iam::107579490988:role/LabRole"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "httpd",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "image": "httpd:latest",
    "cpu": 512,
    "memory": 1024,
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


// Passo 03: Criar target group
resource "aws_lb_target_group" "target-group" {
  target_type      = "ip"
  name             = "httpd-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = "vpc-056faf1cc54475650"
  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
    timeout  = 2
  }
}

// Passo 04: Criar application load balancer
resource "aws_lb" "alb" {
  name               = "http-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = ["sg-0d67de88d682badef"]
  subnets            = ["subnet-09458228db5191041", "subnet-0035e365506b34693"]

  tags = {
    Environment = "development"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

// Passo 05: Criar service
resource "aws_ecs_service" "httpd" {
  name        = "httpd-service"
  cluster     = aws_ecs_cluster.cluster.id
  launch_type = "FARGATE"

  task_definition            = aws_ecs_task_definition.task_definition.arn
  desired_count              = 5
  deployment_maximum_percent = 200

  network_configuration {
    subnets          = ["subnet-09458228db5191041", "subnet-0035e365506b34693"]
    security_groups  = ["sg-0d67de88d682badef"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group.arn
    container_name   = "httpd"
    container_port   = 80
  }

  enable_ecs_managed_tags = true
}