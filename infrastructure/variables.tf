# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "djangoEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default = "djangoEcsAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}


variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "512"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "1024"
}

## VPC variables
variable "azs" {
  type    = list(any)
  default =  ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "private_subnets" {
  type    = list(any)
  default = [ "10.20.32.0/19", "10.20.64.0/19", "10.20.96.0/19" ]
}
variable "public_subnets" {
  type    = list(any)
  default = [ "10.20.160.0/21", "10.20.168.0/21", "10.20.176.0/21" ]
}
variable "database_subnets" {
  type    = list(any)
  default = [ "10.20.184.192/26", "10.20.184.64/26", "10.20.184.128/26" ]
}
variable "vpc_enable_nat_gateway" {
  default = true
}
variable "vpc_single_nat_gateway" {
  default = true
}
variable "enable_dns_hostnames" {
  default = true
}
variable "enable_dns_support" {
  default = true
}