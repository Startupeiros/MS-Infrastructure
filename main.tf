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
resource "aws_ecs_task_definition" "task_definition-1" {
  family                   = "delivery-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "arn:aws:iam::654654501042:role/LabRole"
  execution_role_arn       = "arn:aws:iam::654654501042:role/LabRole"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "delivery",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "environment": [
      {
        "name": "ASPNETCORE_HTTP_PORTS",
        "value": "80"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "/ecs/delivery-task-definition",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        },
        "secretOptions": []
    },
    "image": "654654501042.dkr.ecr.us-east-1.amazonaws.com/delivery:latest",
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

resource "aws_ecs_task_definition" "task_definition-2" {
  family                   = "customers-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "arn:aws:iam::654654501042:role/LabRole"
  execution_role_arn       = "arn:aws:iam::654654501042:role/LabRole"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "customers",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "environment": [
      {
        "name": "ASPNETCORE_HTTP_PORTS",
        "value": "80"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "/ecs/delivery-task-definition",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        },
        "secretOptions": []
    },
    "image": "654654501042.dkr.ecr.us-east-1.amazonaws.com/customers:latest",
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

resource "aws_ecs_task_definition" "task_definition-3" {
  family                   = "products-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "arn:aws:iam::654654501042:role/LabRole"
  execution_role_arn       = "arn:aws:iam::654654501042:role/LabRole"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "products",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "environment": [
      {
        "name": "ASPNETCORE_HTTP_PORTS",
        "value": "80"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "/ecs/delivery-task-definition",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        },
        "secretOptions": []
    },
    "image": "654654501042.dkr.ecr.us-east-1.amazonaws.com/products:latest",
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

resource "aws_ecs_task_definition" "task_definition-4" {
  family                   = "payments-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "arn:aws:iam::654654501042:role/LabRole"
  execution_role_arn       = "arn:aws:iam::654654501042:role/LabRole"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "payments",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "environment": [
      {
        "name": "ASPNETCORE_HTTP_PORTS",
        "value": "80"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "/ecs/delivery-task-definition",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        },
        "secretOptions": []
    },
    "image": "654654501042.dkr.ecr.us-east-1.amazonaws.com/payments:latest",
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

resource "aws_ecs_task_definition" "task_definition-5" {
  family                   = "orders-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = "arn:aws:iam::654654501042:role/LabRole"
  execution_role_arn       = "arn:aws:iam::654654501042:role/LabRole"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "orders",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-create-group": "true",
            "awslogs-group": "/ecs/delivery-task-definition",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        },
        "secretOptions": []
    },
    "image": "654654501042.dkr.ecr.us-east-1.amazonaws.com/orders:latest",
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
  name             = "delivery-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = "vpc-0ace3eaa68d9a3dde"
  health_check {
    enabled  = true
    path     = "/delivery/health"
    protocol = "HTTP"
    timeout  = 2
  }
}

resource "aws_lb_target_group" "target-group-2" {
  target_type      = "ip"
  name             = "customers-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = "vpc-0ace3eaa68d9a3dde"
  health_check {
    enabled  = true
    path     = "/customers/health"
    protocol = "HTTP"
    timeout  = 2
  }
}

resource "aws_lb_target_group" "target-group-3" {
  target_type      = "ip"
  name             = "products-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = "vpc-0ace3eaa68d9a3dde"
  health_check {
    enabled  = true
    path     = "/product/health"
    protocol = "HTTP"
    timeout  = 2
  }
}

resource "aws_lb_target_group" "target-group-4" {
  target_type      = "ip"
  name             = "payments-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = "vpc-0ace3eaa68d9a3dde"
  health_check {
    enabled  = true
    path     = "/payment/health"
    protocol = "HTTP"
    timeout  = 2
  }
}

resource "aws_lb_target_group" "target-group-5" {
  target_type      = "ip"
  name             = "orders-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = "vpc-0ace3eaa68d9a3dde"
  health_check {
    enabled  = true
    path     = "/orders/health"
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
  security_groups    = ["sg-0e04acd0f7e48929e"]
  subnets            = ["subnet-0b702b0878c2405ba", "subnet-0274b3bf39a183383"]

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
    target_group_arn = aws_lb_target_group.target-group-1.arn
  }
}

resource "aws_lb_listener_rule" "rule-delivery" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-1.arn
  }

  condition {
    path_pattern {
      values = ["/delivery/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule-customers" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-2.arn
  }

  condition {
    path_pattern {
      values = ["/customers/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule-products" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-3.arn
  }

  condition {
    path_pattern {
      values = ["/product/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule-payments" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 4
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-4.arn
  }

  condition {
    path_pattern {
      values = ["/payment/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rule-orders" {
  listener_arn = aws_lb_listener.alb-listener.arn
  priority     = 5
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-5.arn
  }

  condition {
    path_pattern {
      values = ["/orders/*"]
    }
  }
}


// Passo 05: Criar service
resource "aws_ecs_service" "delivery" {
  name        = "delivery-service"
  cluster     = aws_ecs_cluster.cluster.id
  launch_type = "FARGATE"

  task_definition            = aws_ecs_task_definition.task_definition-1.arn
  desired_count              = 2
  deployment_maximum_percent = 200

  network_configuration {
    subnets          = ["subnet-0b702b0878c2405ba", "subnet-0274b3bf39a183383"]
    security_groups  = ["sg-0e04acd0f7e48929e"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-1.arn
    container_name   = "delivery"
    container_port   = 80
  }

  enable_ecs_managed_tags = true
}

resource "aws_ecs_service" "customers" {
  name        = "customers-service"
  cluster     = aws_ecs_cluster.cluster.id
  launch_type = "FARGATE"

  task_definition            = aws_ecs_task_definition.task_definition-2.arn
  desired_count              = 2
  deployment_maximum_percent = 200

  network_configuration {
    subnets          = ["subnet-0b702b0878c2405ba", "subnet-0274b3bf39a183383"]
    security_groups  = ["sg-0e04acd0f7e48929e"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-2.arn
    container_name   = "customers"
    container_port   = 80
  }

  enable_ecs_managed_tags = true
}


resource "aws_ecs_service" "products" {
  name        = "products-service"
  cluster     = aws_ecs_cluster.cluster.id
  launch_type = "FARGATE"

  task_definition            = aws_ecs_task_definition.task_definition-3.arn
  desired_count              = 2
  deployment_maximum_percent = 200

  network_configuration {
    subnets          = ["subnet-0b702b0878c2405ba", "subnet-0274b3bf39a183383"]
    security_groups  = ["sg-0e04acd0f7e48929e"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-3.arn
    container_name   = "products"
    container_port   = 80
  }

  enable_ecs_managed_tags = true
}

resource "aws_ecs_service" "payments" {
  name        = "payments-service"
  cluster     = aws_ecs_cluster.cluster.id
  launch_type = "FARGATE"

  task_definition            = aws_ecs_task_definition.task_definition-4.arn
  desired_count              = 2
  deployment_maximum_percent = 200

  network_configuration {
    subnets          = ["subnet-0b702b0878c2405ba", "subnet-0274b3bf39a183383"]
    security_groups  = ["sg-0e04acd0f7e48929e"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-4.arn
    container_name   = "payments"
    container_port   = 80
  }

  enable_ecs_managed_tags = true
}

resource "aws_ecs_service" "orders" {
  name        = "orders-service"
  cluster     = aws_ecs_cluster.cluster.id
  launch_type = "FARGATE"

  task_definition            = aws_ecs_task_definition.task_definition-5.arn
  desired_count              = 2
  deployment_maximum_percent = 200

  network_configuration {
    subnets          = ["subnet-0b702b0878c2405ba", "subnet-0274b3bf39a183383"]
    security_groups  = ["sg-0e04acd0f7e48929e"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-5.arn
    container_name   = "orders"
    container_port   = 80
  }

  enable_ecs_managed_tags = true
}

#Subir imagem no ecr
#Validar security group e permitir acesso por qualquer ip
#Criar instância do banco de dados com banco default e acesso público
#Inserir variável de ambiente na task definition ASPNETCORE_HTTP_PORTS=80