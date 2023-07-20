# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "django-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "django-logs"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "django-ecs-definition"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = <<DEFINITION
[
  {
    "image": "${aws_ecr_repository.ecr.repository_url}:latest",
    "cpu": ${var.fargate_cpu},
    "memory": ${var.fargate_memory},
    "name": "django-app",
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port},
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "entryPoint": [],
    "command": [],
    "environment": [],
    "mountPoints": [],
    "volumesFrom": []
  }
]
DEFINITION

}

resource "aws_ecs_service" "main" {
  name            = "django-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "django-app"
    container_port   = var.app_port
  }

  depends_on = [module.vpc, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}