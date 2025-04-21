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
}

// Passo 01: Criar cluster ecs com configs do tipo FARGATE 
resource "aws_ecs_cluster" "cluster" {
  name = "SixflowCluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_configs" {
  cluster_name = "SixflowCluster"
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

// Passo 02: Criar task definition
resource "aws_ecs_task_definition" "task_definition-1" {
  family                   = "facial-recognition-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "arn:aws:iam::500892577579:role/ECSRole"
  execution_role_arn       = "arn:aws:iam::500892577579:role/ECSRole"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "facial-recognition",
    "portMappings": [
      {
        "containerPort": 7008,
        "hostPort": 7008
      }
    ],
    "environment": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "/ecs/facial-recognition-task-definition",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        },
        "secretOptions": []
    },
    "image": "500892577579.dkr.ecr.us-east-1.amazonaws.com/facial-recognition:latest",
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
resource "aws_lb_target_group" "target-group-1" {
  target_type      = "ip"
  name             = "facial-recognition-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = "vpc-0efc2e33e284dc028"
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
  security_groups    = ["sg-0a117c5e1a272b8ef"]
  subnets            = ["subnet-03f8466b31e602d43", "subnet-092daac0b9e239836"]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-1.arn
  }
}

resource "aws_lb_listener_rule" "rule-facial-recognition" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-1.arn
  }

  condition {
    path_pattern {
      values = ["/facial-recognition/*"]
    }
  }
}


// Passo 05: Criar service
resource "aws_ecs_service" "facial-recognition" {
  name        = "facial-recognition-service"
  cluster     = aws_ecs_cluster.cluster.id
  launch_type = "FARGATE"

  task_definition            = aws_ecs_task_definition.task_definition-1.arn
  desired_count              = 1
  deployment_maximum_percent = 200

  network_configuration {
    subnets          = ["subnet-03f8466b31e602d43", "subnet-092daac0b9e239836"]
    security_groups  = ["sg-0a117c5e1a272b8ef"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-1.arn
    container_name   = "facial-recognition"
    container_port   = 7008
  }

  enable_ecs_managed_tags = true
}


#Subir imagem no ecr
#Validar security group e permitir acesso por qualquer ip
#Criar instância do banco de dados com banco default e acesso público
#Inserir variável de ambiente na task definition ASPNETCORE_HTTP_PORTS=80